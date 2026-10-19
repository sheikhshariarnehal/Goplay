'use client';

import React, { useState } from 'react';
import { X, Upload, FileText, CheckCircle2, AlertCircle, ArrowRight, Tv, Download } from 'lucide-react';
import { CategoryData } from './CategoryEditorModal';

interface ParsedM3uChannel {
  name: string;
  logo: string;
  streamUrl: string;
  groupTitle?: string;
  tvgId?: string;
}

interface M3uImportModalProps {
  isOpen: boolean;
  onClose: () => void;
  categories: CategoryData[];
  defaultCategoryId?: string;
  onImportComplete: (
    channels: Array<{
      name: string;
      logo: string | null;
      category: string;
      stream_url: string;
    }>
  ) => Promise<void>;
}

export default function M3uImportModal({
  isOpen,
  onClose,
  categories,
  defaultCategoryId,
  onImportComplete,
}: M3uImportModalProps) {
  const [activeTab, setActiveTab] = useState<'text' | 'url'>('text');
  const [rawText, setRawText] = useState('');
  const [m3uUrl, setM3uUrl] = useState('');
  const [fetchingUrl, setFetchingUrl] = useState(false);

  const [selectedCategory, setSelectedCategory] = useState<string>(
    defaultCategoryId || (categories[0]?.id || '')
  );

  const [parsedChannels, setParsedChannels] = useState<ParsedM3uChannel[]>([]);
  const [importing, setImporting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  if (!isOpen) return null;

  const parseM3u = (content: string) => {
    const lines = content.split(/\r?\n/);
    const results: ParsedM3uChannel[] = [];

    let currentName = '';
    let currentLogo = '';
    let currentGroup = '';
    let currentId = '';

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();

      if (line.startsWith('#EXTINF:')) {
        // Extract tvg-logo
        const logoMatch = line.match(/tvg-logo="([^"]*)"/i);
        currentLogo = logoMatch ? logoMatch[1] : '';

        // Extract tvg-name
        const nameMatch = line.match(/tvg-name="([^"]*)"/i);

        // Extract group-title
        const groupMatch = line.match(/group-title="([^"]*)"/i);
        currentGroup = groupMatch ? groupMatch[1] : '';

        // Extract tvg-id
        const idMatch = line.match(/tvg-id="([^"]*)"/i);
        currentId = idMatch ? idMatch[1] : '';

        // Name after comma
        const commaIdx = line.lastIndexOf(',');
        if (commaIdx !== -1) {
          currentName = line.substring(commaIdx + 1).trim();
        } else if (nameMatch) {
          currentName = nameMatch[1].trim();
        } else {
          currentName = 'Live Stream';
        }
      } else if (line && !line.startsWith('#')) {
        // This is the stream URL
        if (currentName || line.startsWith('http')) {
          results.push({
            name: currentName || `Channel ${results.length + 1}`,
            logo: currentLogo,
            streamUrl: line,
            groupTitle: currentGroup,
            tvgId: currentId,
          });
          currentName = '';
          currentLogo = '';
          currentGroup = '';
          currentId = '';
        }
      }
    }

    return results;
  };

  const handleParseText = () => {
    setError(null);
    if (!rawText.trim()) {
      setError('Please paste M3U playlist text');
      return;
    }
    const parsed = parseM3u(rawText);
    if (parsed.length === 0) {
      setError('No valid channels found in the provided text. Ensure it contains #EXTINF lines and URLs.');
      return;
    }
    setParsedChannels(parsed);
  };

  const handleFetchUrl = async () => {
    setError(null);
    if (!m3uUrl.trim()) {
      setError('Please provide a valid M3U URL');
      return;
    }

    try {
      setFetchingUrl(true);
      const res = await fetch(m3uUrl.trim());
      if (!res.ok) throw new Error(`HTTP ${res.status}: Failed to fetch playlist from URL`);
      const text = await res.text();
      const parsed = parseM3u(text);
      if (parsed.length === 0) {
        throw new Error('No valid channels found in the remote playlist');
      }
      setParsedChannels(parsed);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch M3U playlist');
    } finally {
      setFetchingUrl(false);
    }
  };

  const handleExecuteImport = async () => {
    if (parsedChannels.length === 0) return;
    if (!selectedCategory) {
      setError('Please select a target category for imported channels');
      return;
    }

    try {
      setImporting(true);
      setError(null);

      const payload = parsedChannels.map((ch) => ({
        name: ch.name,
        logo: ch.logo || null,
        category: selectedCategory,
        stream_url: ch.streamUrl,
      }));

      await onImportComplete(payload);
      onClose();
    } catch (err: any) {
      setError(err.message || 'Import failed');
    } finally {
      setImporting(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/75 backdrop-blur-xs flex items-center justify-center p-4 overflow-y-auto">
      <div className="bg-zinc-900 border border-zinc-800 rounded-2xl w-full max-w-2xl overflow-hidden shadow-2xl flex flex-col max-h-[90vh]">
        {/* Header */}
        <div className="px-5 py-4 bg-zinc-950/80 border-b border-zinc-800 flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-purple-500/20 text-purple-400 border border-purple-500/30 flex items-center justify-center">
              <Upload className="w-4 h-4" />
            </div>
            <div>
              <h3 className="text-sm font-bold text-white leading-tight">Batch M3U Playlist Importer</h3>
              <p className="text-[11px] text-zinc-400">
                Parse M3U files into live channels and stream servers
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded-lg hover:bg-zinc-800 text-zinc-400 hover:text-white transition cursor-pointer"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Content */}
        <div className="p-5 overflow-y-auto space-y-4 flex-1">
          {error && (
            <div className="p-3 bg-rose-950/50 border border-rose-800/60 rounded-xl text-rose-300 text-xs flex items-center gap-2">
              <AlertCircle className="w-4 h-4 flex-shrink-0" />
              <span>{error}</span>
            </div>
          )}

          {parsedChannels.length === 0 ? (
            <>
              {/* Tab Selector */}
              <div className="flex rounded-xl bg-zinc-950 p-1 border border-zinc-800">
                <button
                  type="button"
                  onClick={() => setActiveTab('text')}
                  className={`flex-1 py-1.5 rounded-lg text-xs font-semibold transition cursor-pointer flex items-center justify-center gap-1.5 ${
                    activeTab === 'text'
                      ? 'bg-purple-600 text-white shadow-sm'
                      : 'text-zinc-400 hover:text-white'
                  }`}
                >
                  <FileText className="w-3.5 h-3.5" /> Paste M3U Text
                </button>
                <button
                  type="button"
                  onClick={() => setActiveTab('url')}
                  className={`flex-1 py-1.5 rounded-lg text-xs font-semibold transition cursor-pointer flex items-center justify-center gap-1.5 ${
                    activeTab === 'url'
                      ? 'bg-purple-600 text-white shadow-sm'
                      : 'text-zinc-400 hover:text-white'
                  }`}
                >
                  <Download className="w-3.5 h-3.5" /> Fetch from URL
                </button>
              </div>

              {activeTab === 'text' ? (
                <div>
                  <label className="block text-xs font-medium text-zinc-300 mb-1">
                    M3U / M3U8 Content
                  </label>
                  <textarea
                    rows={8}
                    value={rawText}
                    onChange={(e) => setRawText(e.target.value)}
                    placeholder={`#EXTM3U\n#EXTINF:-1 tvg-id="sonyten1" tvg-logo="https://..." group-title="Sports",Sony Ten 1 HD\nhttps://stream.example.com/live/sonyten1.m3u8`}
                    className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs font-mono placeholder:text-zinc-600 focus:outline-hidden focus:border-purple-500 transition"
                  />
                  <div className="mt-2 flex justify-end">
                    <button
                      type="button"
                      onClick={handleParseText}
                      className="px-4 py-2 bg-purple-600 hover:bg-purple-500 text-white text-xs font-bold rounded-xl transition cursor-pointer"
                    >
                      Parse Playlist Content
                    </button>
                  </div>
                </div>
              ) : (
                <div>
                  <label className="block text-xs font-medium text-zinc-300 mb-1">
                    Remote M3U URL
                  </label>
                  <div className="flex gap-2">
                    <input
                      type="url"
                      value={m3uUrl}
                      onChange={(e) => setM3uUrl(e.target.value)}
                      placeholder="https://example.com/playlist.m3u"
                      className="flex-1 px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs font-mono placeholder:text-zinc-600 focus:outline-hidden focus:border-purple-500 transition"
                    />
                    <button
                      type="button"
                      onClick={handleFetchUrl}
                      disabled={fetchingUrl}
                      className="px-4 py-2 bg-purple-600 hover:bg-purple-500 text-white text-xs font-bold rounded-xl transition cursor-pointer disabled:opacity-50 flex items-center gap-1.5"
                    >
                      {fetchingUrl ? (
                        <>
                          <div className="w-3.5 h-3.5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                          <span>Fetching...</span>
                        </>
                      ) : (
                        <span>Fetch & Parse</span>
                      )}
                    </button>
                  </div>
                </div>
              )}
            </>
          ) : (
            <div className="space-y-4">
              {/* Parse summary */}
              <div className="p-3.5 bg-zinc-950 border border-zinc-800 rounded-xl flex items-center justify-between">
                <div>
                  <span className="text-xs font-bold text-white block">
                    Found {parsedChannels.length} Channels in Playlist
                  </span>
                  <span className="text-[11px] text-zinc-400">
                    Ready to batch create channels and link stream servers.
                  </span>
                </div>
                <button
                  type="button"
                  onClick={() => setParsedChannels([])}
                  className="text-xs text-purple-400 hover:text-purple-300 font-semibold cursor-pointer"
                >
                  Clear & Re-parse
                </button>
              </div>

              {/* Target category picker */}
              <div>
                <label className="block text-xs font-medium text-zinc-300 mb-1">
                  Assign All Imported Channels to Category:
                </label>
                <select
                  value={selectedCategory}
                  onChange={(e) => setSelectedCategory(e.target.value)}
                  className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs focus:outline-hidden focus:border-purple-500 transition cursor-pointer"
                >
                  {categories.map((cat) => (
                    <option key={cat.id} value={cat.id}>
                      {cat.name} ({cat.id})
                    </option>
                  ))}
                </select>
              </div>

              {/* Channel preview list */}
              <div className="space-y-1.5 max-h-56 overflow-y-auto pr-1">
                <span className="text-[10px] uppercase font-bold text-zinc-400 tracking-wider">
                  Channels Preview ({Math.min(parsedChannels.length, 50)} shown)
                </span>
                {parsedChannels.slice(0, 50).map((ch, idx) => (
                  <div
                    key={idx}
                    className="p-2 bg-zinc-950/70 border border-zinc-800/80 rounded-lg flex items-center justify-between text-xs gap-2"
                  >
                    <div className="flex items-center gap-2 min-w-0">
                      {ch.logo ? (
                        // eslint-disable-next-line @next/next/no-img-element
                        <img
                          src={ch.logo}
                          alt=""
                          className="w-5 h-5 rounded-full object-cover bg-zinc-800 flex-shrink-0"
                          onError={(e) => {
                            (e.target as HTMLElement).style.display = 'none';
                          }}
                        />
                      ) : (
                        <Tv className="w-4 h-4 text-zinc-500 flex-shrink-0" />
                      )}
                      <span className="font-medium text-zinc-200 truncate">{ch.name}</span>
                    </div>
                    <span className="text-[10px] font-mono text-zinc-500 truncate max-w-[200px]">
                      {ch.streamUrl}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        {parsedChannels.length > 0 && (
          <div className="px-5 py-3.5 bg-zinc-950/80 border-t border-zinc-800 flex items-center justify-between">
            <span className="text-xs text-zinc-400">
              Target: <strong className="text-white">{selectedCategory}</strong>
            </span>
            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={() => setParsedChannels([])}
                disabled={importing}
                className="px-3 py-1.5 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-xs font-medium transition cursor-pointer"
              >
                Back
              </button>
              <button
                type="button"
                onClick={handleExecuteImport}
                disabled={importing}
                className="px-4 py-1.5 rounded-xl bg-purple-600 hover:bg-purple-500 text-white text-xs font-bold transition flex items-center gap-1.5 cursor-pointer disabled:opacity-50 shadow-md shadow-purple-600/20"
              >
                {importing ? (
                  <>
                    <div className="w-3.5 h-3.5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    <span>Importing Channels...</span>
                  </>
                ) : (
                  <>
                    <CheckCircle2 className="w-3.5 h-3.5" />
                    <span>Import {parsedChannels.length} Channels</span>
                  </>
                )}
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
