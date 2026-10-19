'use client';

import React, { useEffect, useRef, useState, useCallback } from 'react';
import Hls from 'hls.js';
import {
  Play, Pause, Volume2, VolumeX, Maximize, RefreshCw, Activity,
  CheckCircle2, AlertTriangle, XCircle, ShieldCheck, ExternalLink, Copy, Check
} from 'lucide-react';
import { setupClearKeyDrm } from '../../utils/drm-helper';

export interface StreamServer {
  id?: string;
  channel_id?: string;
  name: string;
  stream_url: string;
  scheme?: number;
  drm?: {
    type: 'clearkey' | 'widevine' | 'playready';
    kid?: string;
    key?: string;
    licenseUrl?: string;
  } | null;
  headers?: Record<string, string> | null;
  has_header?: boolean;
  has_vpn_detection?: boolean;
  sort_order: number;
  active: boolean;
}

interface LivePreviewPlayerProps {
  servers: StreamServer[];
  activeServerIndex: number;
  onSelectServer: (index: number) => void;
  channelName: string;
  channelLogo?: string | null;
}

interface ProbeResult {
  ok: boolean;
  status: number;
  statusText: string;
  latencyMs: number;
  contentType: string;
  error?: string;
}

export default function LivePreviewPlayer({
  servers,
  activeServerIndex,
  onSelectServer,
  channelName,
  channelLogo,
}: LivePreviewPlayerProps) {
  const videoRef = useRef<HTMLVideoElement>(null);
  const hlsRef = useRef<Hls | null>(null);
  const drmCleanupRef = useRef<(() => void) | null>(null);

  const [isPlaying, setIsPlaying] = useState(false);
  const [isMuted, setIsMuted] = useState(true);
  const [playerError, setPlayerError] = useState<string | null>(null);
  const [playerLoading, setPlayerLoading] = useState(false);
  const [copied, setCopied] = useState(false);

  // Stream health check state
  const [probing, setProbing] = useState(false);
  const [probeResult, setProbeResult] = useState<ProbeResult | null>(null);

  const currentServer: StreamServer | undefined = servers[activeServerIndex] || servers[0];
  const streamUrl = currentServer?.stream_url?.trim() || '';
  const drm = currentServer?.drm;

  // Probe stream health via backend API
  const checkStreamHealth = useCallback(async (url: string, headers?: Record<string, string> | null) => {
    if (!url) return;
    try {
      setProbing(true);
      setProbeResult(null);
      const res = await fetch('/api/stream-check', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ url, headers: headers || {} }),
      });
      const data = await res.json();
      setProbeResult(data);
    } catch (err: any) {
      setProbeResult({
        ok: false,
        status: 0,
        statusText: 'Check Failed',
        latencyMs: 0,
        contentType: '',
        error: err.message || 'Health check error',
      });
    } finally {
      setProbing(false);
    }
  }, []);

  // Initialize playback whenever streamUrl or drm changes
  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;

    const safeTeardown = () => {
      if (drmCleanupRef.current) {
        try {
          drmCleanupRef.current();
        } catch {
          // ignore cleanup errors
        }
        drmCleanupRef.current = null;
      }
      if (hlsRef.current) {
        try {
          hlsRef.current.stopLoad();
          hlsRef.current.detachMedia();
          hlsRef.current.destroy();
        } catch {
          // ignore abort errors during teardown
        }
        hlsRef.current = null;
      }
    };

    // Reset previous stream & cleanup
    safeTeardown();

    setPlayerError(null);
    setProbeResult(null);

    if (!streamUrl) {
      try {
        video.pause();
        video.removeAttribute('src');
        video.load();
      } catch {
        // ignore video reset error
      }
      setIsPlaying(false);
      return;
    }

    setPlayerLoading(true);

    // Setup ClearKey EME if configured
    if (drm?.type === 'clearkey' && drm.kid && drm.key) {
      setupClearKeyDrm(video, drm.kid, drm.key)
        .then((cleanup) => {
          drmCleanupRef.current = cleanup;
        })
        .catch((drmErr) => {
          console.warn('[Player] DRM init warning:', drmErr);
        });
    }

    const isHls = streamUrl.includes('.m3u8') || streamUrl.includes('m3u8');

    if (isHls && Hls.isSupported()) {
      const hls = new Hls({
        enableWorker: true,
        lowLatencyMode: true,
        backBufferLength: 60,
      });

      hlsRef.current = hls;
      hls.loadSource(streamUrl);
      hls.attachMedia(video);

      hls.on(Hls.Events.MANIFEST_PARSED, () => {
        setPlayerLoading(false);
        video.play().then(() => setIsPlaying(true)).catch(() => setIsPlaying(false));
      });

      hls.on(Hls.Events.ERROR, (_event, data) => {
        if (data.fatal) {
          switch (data.type) {
            case Hls.ErrorTypes.NETWORK_ERROR:
              setPlayerError('Network connection failed or stream is offline.');
              hls.startLoad();
              break;
            case Hls.ErrorTypes.MEDIA_ERROR:
              setPlayerError('Media decoding error. Attempting recovery...');
              hls.recoverMediaError();
              break;
            default:
              setPlayerError(`HLS stream playback error: ${data.details}`);
              try {
                hls.destroy();
              } catch {
                // ignore
              }
              break;
          }
          setPlayerLoading(false);
        }
      });
    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
      // Native Safari HLS
      video.src = streamUrl;
      video.addEventListener('loadedmetadata', () => {
        setPlayerLoading(false);
        video.play().then(() => setIsPlaying(true)).catch(() => setIsPlaying(false));
      });
      video.addEventListener('error', () => {
        setPlayerLoading(false);
        setPlayerError('Native playback failed. Check stream URL or CORS policies.');
      });
    } else {
      // Direct MP4 / WebM
      video.src = streamUrl;
      video.addEventListener('loadedmetadata', () => {
        setPlayerLoading(false);
        video.play().then(() => setIsPlaying(true)).catch(() => setIsPlaying(false));
      });
      video.addEventListener('error', () => {
        setPlayerLoading(false);
        setPlayerError('Failed to play stream format in this browser.');
      });
    }

    // Auto-probe stream health
    checkStreamHealth(streamUrl, currentServer?.headers);

    return () => {
      safeTeardown();
    };
  }, [streamUrl, drm?.type, drm?.kid, drm?.key, checkStreamHealth, currentServer?.headers]);

  const togglePlay = () => {
    const video = videoRef.current;
    if (!video) return;
    if (isPlaying) {
      video.pause();
      setIsPlaying(false);
    } else {
      video.play().then(() => setIsPlaying(true)).catch((err) => {
        setPlayerError(err.message || 'Failed to start playback');
      });
    }
  };

  const toggleMute = () => {
    const video = videoRef.current;
    if (!video) return;
    video.muted = !video.muted;
    setIsMuted(video.muted);
  };

  const toggleFullscreen = () => {
    const video = videoRef.current;
    if (!video) return;
    if (!document.fullscreenElement) {
      video.requestFullscreen().catch(() => {});
    } else {
      document.exitFullscreen().catch(() => {});
    }
  };

  const copyStreamUrl = () => {
    if (!streamUrl) return;
    navigator.clipboard.writeText(streamUrl);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="bg-zinc-900 border border-zinc-800 rounded-2xl overflow-hidden shadow-xl flex flex-col">
      {/* Player Header */}
      <div className="px-4 py-3 bg-zinc-950/80 border-b border-zinc-800/80 flex items-center justify-between gap-3">
        <div className="flex items-center gap-2.5 min-w-0">
          {channelLogo ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={channelLogo}
              alt={channelName}
              className="w-6 h-6 rounded-full object-cover bg-zinc-800 border border-zinc-700/60 flex-shrink-0"
              onError={(e) => {
                (e.target as HTMLElement).style.display = 'none';
              }}
            />
          ) : (
            <div className="w-6 h-6 rounded-full bg-purple-500/20 text-purple-400 border border-purple-500/30 flex items-center justify-center text-xs font-bold flex-shrink-0">
              {channelName ? channelName[0].toUpperCase() : 'TV'}
            </div>
          )}
          <div className="min-w-0">
            <h4 className="text-xs font-bold text-white truncate leading-tight">
              {channelName || 'Stream Preview'}
            </h4>
            <p className="text-[10px] text-zinc-400 font-mono truncate">
              {currentServer?.name || 'No server selected'}
            </p>
          </div>
        </div>

        {/* Action icons */}
        <div className="flex items-center gap-1.5 flex-shrink-0">
          <button
            onClick={() => checkStreamHealth(streamUrl, currentServer?.headers)}
            disabled={probing || !streamUrl}
            title="Probe Stream Server Health"
            className="p-1.5 rounded-lg bg-zinc-800/80 hover:bg-zinc-700 text-zinc-300 hover:text-white transition cursor-pointer disabled:opacity-40"
          >
            <Activity className={`w-3.5 h-3.5 ${probing ? 'animate-pulse text-yellow-400' : ''}`} />
          </button>
          <button
            onClick={copyStreamUrl}
            disabled={!streamUrl}
            title="Copy Stream URL"
            className="p-1.5 rounded-lg bg-zinc-800/80 hover:bg-zinc-700 text-zinc-300 hover:text-white transition cursor-pointer disabled:opacity-40"
          >
            {copied ? <Check className="w-3.5 h-3.5 text-lime-400" /> : <Copy className="w-3.5 h-3.5" />}
          </button>
          {streamUrl && (
            <a
              href={streamUrl}
              target="_blank"
              rel="noreferrer"
              title="Open Raw Stream"
              className="p-1.5 rounded-lg bg-zinc-800/80 hover:bg-zinc-700 text-zinc-300 hover:text-white transition cursor-pointer"
            >
              <ExternalLink className="w-3.5 h-3.5" />
            </a>
          )}
        </div>
      </div>

      {/* Video Viewport */}
      <div className="relative aspect-video w-full bg-black flex items-center justify-center overflow-hidden group">
        <video
          ref={videoRef}
          muted={isMuted}
          playsInline
          className="w-full h-full object-contain"
          onPlay={() => setIsPlaying(true)}
          onPause={() => setIsPlaying(false)}
        />

        {/* Loading Spinner */}
        {playerLoading && (
          <div className="absolute inset-0 bg-black/60 backdrop-blur-xs flex flex-col items-center justify-center gap-2 pointer-events-none">
            <div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin" />
            <span className="text-[11px] font-medium text-zinc-300">Connecting stream...</span>
          </div>
        )}

        {/* Error / Offline Overlay */}
        {playerError && !playerLoading && (
          <div className="absolute inset-0 bg-black/85 p-4 flex flex-col items-center justify-center text-center gap-2.5 z-10">
            <AlertTriangle className="w-7 h-7 text-amber-400 animate-bounce" />
            <p className="text-xs font-semibold text-zinc-200 max-w-xs">{playerError}</p>
            <p className="text-[10px] text-zinc-400 max-w-xs">
              Check stream reachability, CORS headers, or click Health Probe below.
            </p>
            <button
              onClick={() => {
                setPlayerError(null);
                checkStreamHealth(streamUrl, currentServer?.headers);
              }}
              className="mt-1 px-3 py-1 bg-zinc-800 hover:bg-zinc-700 text-zinc-200 text-[11px] font-medium rounded-lg border border-zinc-700 transition cursor-pointer flex items-center gap-1.5"
            >
              <RefreshCw className="w-3 h-3" /> Retry Stream
            </button>
          </div>
        )}

        {/* Empty State */}
        {!streamUrl && (
          <div className="flex flex-col items-center justify-center gap-2 text-zinc-500">
            <Play className="w-10 h-10 opacity-30" />
            <p className="text-xs font-medium">No stream URL entered for this server</p>
          </div>
        )}

        {/* Hover Controls Bar */}
        {streamUrl && (
          <div className="absolute bottom-0 inset-x-0 bg-gradient-to-t from-black/90 via-black/40 to-transparent p-3 flex items-center justify-between opacity-0 group-hover:opacity-100 transition-opacity duration-200">
            <div className="flex items-center gap-2">
              <button
                onClick={togglePlay}
                className="p-1.5 rounded-lg bg-white/10 hover:bg-white/20 text-white transition cursor-pointer"
              >
                {isPlaying ? <Pause className="w-4 h-4" /> : <Play className="w-4 h-4 fill-white" />}
              </button>
              <button
                onClick={toggleMute}
                className="p-1.5 rounded-lg bg-white/10 hover:bg-white/20 text-white transition cursor-pointer"
              >
                {isMuted ? <VolumeX className="w-4 h-4" /> : <Volume2 className="w-4 h-4" />}
              </button>
              <span className="text-[10px] text-zinc-300 font-mono uppercase bg-black/50 px-2 py-0.5 rounded border border-white/10">
                {isPlaying ? 'LIVE' : 'PAUSED'}
              </span>
              {drm?.type && (
                <span className="text-[10px] text-purple-300 font-mono uppercase bg-purple-950/70 border border-purple-500/40 px-1.5 py-0.5 rounded flex items-center gap-1">
                  <ShieldCheck className="w-3 h-3 text-purple-400" /> {drm.type}
                </span>
              )}
            </div>

            <button
              onClick={toggleFullscreen}
              className="p-1.5 rounded-lg bg-white/10 hover:bg-white/20 text-white transition cursor-pointer"
            >
              <Maximize className="w-4 h-4" />
            </button>
          </div>
        )}
      </div>

      {/* Stream Health Diagnostic Banner */}
      {probeResult && (
        <div
          className={`px-3.5 py-2 text-[11px] flex items-center justify-between border-t ${
            probeResult.ok
              ? 'bg-emerald-950/40 border-emerald-800/40 text-emerald-300'
              : 'bg-rose-950/40 border-rose-800/40 text-rose-300'
          }`}
        >
          <div className="flex items-center gap-2 min-w-0">
            {probeResult.ok ? (
              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400 flex-shrink-0" />
            ) : (
              <XCircle className="w-3.5 h-3.5 text-rose-400 flex-shrink-0" />
            )}
            <span className="font-semibold truncate">
              {probeResult.ok
                ? `HTTP ${probeResult.status} ${probeResult.statusText || 'OK'} (${probeResult.latencyMs}ms)`
                : `Error: ${probeResult.error || `HTTP ${probeResult.status}`}`}
            </span>
          </div>
          {probeResult.contentType && (
            <span className="text-[10px] font-mono text-zinc-400 px-1.5 py-0.5 rounded bg-black/40 border border-white/5 truncate max-w-[140px]">
              {probeResult.contentType.split(';')[0]}
            </span>
          )}
        </div>
      )}

      {/* Server Switcher Tabs */}
      {servers.length > 0 && (
        <div className="p-2.5 bg-zinc-950/90 border-t border-zinc-800/60">
          <div className="flex items-center justify-between mb-1.5">
            <span className="text-[10px] font-bold text-zinc-400 uppercase tracking-wider">
              Preview Server ({servers.length})
            </span>
            <span className="text-[10px] text-zinc-500 font-mono">Click to preview server feed</span>
          </div>
          <div className="flex flex-wrap gap-1.5 max-h-24 overflow-y-auto">
            {servers.map((srv, idx) => {
              const isActive = idx === activeServerIndex;
              return (
                <button
                  key={srv.id || idx}
                  onClick={() => onSelectServer(idx)}
                  className={`px-2.5 py-1 rounded-lg text-xs font-medium transition cursor-pointer flex items-center gap-1.5 border ${
                    isActive
                      ? 'bg-purple-600 text-white border-purple-400 shadow-sm shadow-purple-500/20'
                      : 'bg-zinc-900 hover:bg-zinc-800 text-zinc-400 hover:text-zinc-200 border-zinc-800'
                  }`}
                >
                  <span
                    className={`w-1.5 h-1.5 rounded-full ${
                      srv.active ? 'bg-emerald-400' : 'bg-zinc-600'
                    }`}
                  />
                  <span className="truncate max-w-[120px]">{srv.name || `Server ${idx + 1}`}</span>
                  {idx === 0 && (
                    <span className="text-[9px] px-1 py-0.2 bg-black/40 rounded text-zinc-300 font-mono">
                      Primary
                    </span>
                  )}
                </button>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}
