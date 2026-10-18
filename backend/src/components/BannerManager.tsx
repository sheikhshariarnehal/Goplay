'use client';

import React, { useState, useEffect, useMemo, useRef } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import {
  Plus, Edit2, Trash2, Save, X, ExternalLink, Tv, Image as ImageIcon,
  CheckCircle, AlertTriangle, ArrowUpDown, UploadCloud, Search, Eye,
  Sparkles, Layers, RefreshCw, Check, Tag, Type
} from 'lucide-react';

export interface HeroBanner {
  id: string;
  title: string | null;
  image_url: string;
  badge_text: string | null;
  show_title: boolean;
  show_badge: boolean;
  action_type: 'none' | 'url' | 'channel';
  action_value: string | null;
  active: boolean;
  sort_order: number;
  created_at: string;
  updated_at: string;
}

interface ChannelOption {
  id: string;
  name: string;
  logo: string | null;
  category: string | null;
}

interface BannerManagerProps {
  adminToken: string;
  onRefreshStats?: () => void;
}

export default function BannerManager({ adminToken, onRefreshStats }: BannerManagerProps) {
  const [banners, setBanners] = useState<HeroBanner[]>([]);
  const [channels, setChannels] = useState<ChannelOption[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  // Modal / Form state
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingBanner, setEditingBanner] = useState<HeroBanner | null>(null);
  const [isUploading, setIsUploading] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // Channel dropdown search state
  const [channelSearch, setChannelSearch] = useState('');
  const [isChannelDropdownOpen, setIsChannelDropdownOpen] = useState(false);

  // Form Fields
  const [formData, setFormData] = useState({
    title: '',
    image_url: '',
    badge_text: '',
    show_title: true,
    show_badge: true,
    action_type: 'none' as 'none' | 'url' | 'channel',
    action_value: '',
    active: true,
    sort_order: 0,
  });

  const supabaseAdmin = useMemo(() => createAdminSupabaseClient(adminToken), [adminToken]);

  const showNotification = (type: 'success' | 'error', msg: string) => {
    if (type === 'success') {
      setSuccess(msg);
      setTimeout(() => setSuccess(null), 3500);
    } else {
      setError(msg);
      setTimeout(() => setError(null), 4500);
    }
  };

  // Fetch Banners
  const fetchBanners = async () => {
    try {
      setLoading(true);
      const { data, error: fetchErr } = await supabaseAdmin
        .from('hero_banners')
        .select('*')
        .order('sort_order', { ascending: true })
        .order('created_at', { ascending: false });

      if (fetchErr) throw fetchErr;
      setBanners(data || []);
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to fetch hero banners');
    } finally {
      setLoading(false);
    }
  };

  // Fetch Channels for channel action picker
  const fetchChannels = async () => {
    try {
      const { data } = await supabaseAdmin
        .from('channels')
        .select('id, name, logo, category')
        .order('name', { ascending: true })
        .limit(1000);

      setChannels(data || []);
    } catch (err) {
      console.error('Failed to fetch channels for picker:', err);
    }
  };

  useEffect(() => {
    fetchBanners();
    fetchChannels();
  }, [supabaseAdmin]);

  // Handle open add modal
  const handleOpenAddModal = () => {
    setEditingBanner(null);
    const nextOrder = banners.length > 0 ? Math.max(...banners.map((b) => b.sort_order)) + 1 : 1;
    setFormData({
      title: '',
      image_url: '',
      badge_text: '',
      show_title: true,
      show_badge: true,
      action_type: 'none',
      action_value: '',
      active: true,
      sort_order: nextOrder,
    });
    setChannelSearch('');
    setIsChannelDropdownOpen(false);
    setIsModalOpen(true);
  };

  // Handle open edit modal
  const handleOpenEditModal = (banner: HeroBanner) => {
    setEditingBanner(banner);
    setFormData({
      title: banner.title || '',
      image_url: banner.image_url,
      badge_text: banner.badge_text || '',
      show_title: banner.show_title ?? true,
      show_badge: banner.show_badge ?? true,
      action_type: banner.action_type,
      action_value: banner.action_value || '',
      active: banner.active,
      sort_order: banner.sort_order,
    });
    setChannelSearch('');
    setIsChannelDropdownOpen(false);
    setIsModalOpen(true);
  };

  // Handle direct file upload to Supabase Storage
  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (!file.type.startsWith('image/')) {
      showNotification('error', 'Please choose a valid image file (PNG, JPG, WebP, etc.)');
      return;
    }

    try {
      setIsUploading(true);
      const fileExt = file.name.split('.').pop();
      const sanitizedName = file.name.replace(/[^a-zA-Z0-9.-]/g, '_');
      const fileName = `${Date.now()}_${sanitizedName}`;

      const { data, error: uploadErr } = await supabaseAdmin.storage
        .from('hero-banners')
        .upload(fileName, file, {
          cacheControl: '3600',
          upsert: true,
        });

      if (uploadErr) throw uploadErr;

      const { data: publicUrlData } = supabaseAdmin.storage
        .from('hero-banners')
        .getPublicUrl(fileName);

      if (publicUrlData?.publicUrl) {
        setFormData((prev) => ({ ...prev, image_url: publicUrlData.publicUrl }));
        showNotification('success', 'Image uploaded successfully!');
      }
    } catch (err: any) {
      showNotification('error', err.message || 'Image upload failed. You can also paste a direct image URL.');
    } finally {
      setIsUploading(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  // Handle Save (Create or Update)
  const handleSaveBanner = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.image_url.trim()) {
      showNotification('error', 'Banner image URL or file upload is required');
      return;
    }

    if (formData.action_type === 'url' && !formData.action_value.trim()) {
      showNotification('error', 'Please enter a target URL for the web link action');
      return;
    }

    if (formData.action_type === 'channel' && !formData.action_value.trim()) {
      showNotification('error', 'Please select a live channel for the channel action');
      return;
    }

    try {
      setIsSaving(true);
      const payload = {
        title: formData.title.trim() || null,
        image_url: formData.image_url.trim(),
        badge_text: formData.badge_text.trim() || null,
        show_title: formData.show_title,
        show_badge: formData.show_badge,
        action_type: formData.action_type,
        action_value: formData.action_type === 'none' ? null : formData.action_value.trim() || null,
        active: formData.active,
        sort_order: Number(formData.sort_order) || 0,
        updated_at: new Date().toISOString(),
      };

      if (editingBanner) {
        const { error: updateErr } = await supabaseAdmin
          .from('hero_banners')
          .update(payload)
          .eq('id', editingBanner.id);

        if (updateErr) throw updateErr;
        showNotification('success', 'Banner updated successfully!');
      } else {
        const { error: insertErr } = await supabaseAdmin
          .from('hero_banners')
          .insert([payload]);

        if (insertErr) throw insertErr;
        showNotification('success', 'Banner created successfully!');
      }

      setIsModalOpen(false);
      await fetchBanners();
      if (onRefreshStats) onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to save banner');
    } finally {
      setIsSaving(false);
    }
  };

  // Quick toggle active
  const handleToggleActive = async (banner: HeroBanner) => {
    const newActive = !banner.active;
    setBanners((prev) =>
      prev.map((b) => (b.id === banner.id ? { ...b, active: newActive } : b))
    );

    try {
      const { error: updateErr } = await supabaseAdmin
        .from('hero_banners')
        .update({ active: newActive, updated_at: new Date().toISOString() })
        .eq('id', banner.id);

      if (updateErr) throw updateErr;
      showNotification('success', `Banner marked as ${newActive ? 'Active' : 'Inactive'}`);
      if (onRefreshStats) onRefreshStats();
    } catch (err: any) {
      setBanners((prev) =>
        prev.map((b) => (b.id === banner.id ? { ...b, active: banner.active } : b))
      );
      showNotification('error', err.message || 'Failed to update status');
    }
  };

  // Quick toggle show badge
  const handleToggleShowBadge = async (banner: HeroBanner) => {
    const newShowBadge = !(banner.show_badge ?? true);
    setBanners((prev) =>
      prev.map((b) => (b.id === banner.id ? { ...b, show_badge: newShowBadge } : b))
    );

    try {
      const { error: updateErr } = await supabaseAdmin
        .from('hero_banners')
        .update({ show_badge: newShowBadge, updated_at: new Date().toISOString() })
        .eq('id', banner.id);

      if (updateErr) throw updateErr;
      showNotification('success', `Badge tag ${newShowBadge ? 'visible' : 'hidden'}`);
    } catch (err: any) {
      setBanners((prev) =>
        prev.map((b) => (b.id === banner.id ? { ...b, show_badge: banner.show_badge } : b))
      );
      showNotification('error', err.message || 'Failed to update badge tag visibility');
    }
  };

  // Quick toggle show title
  const handleToggleShowTitle = async (banner: HeroBanner) => {
    const newShowTitle = !(banner.show_title ?? true);
    setBanners((prev) =>
      prev.map((b) => (b.id === banner.id ? { ...b, show_title: newShowTitle } : b))
    );

    try {
      const { error: updateErr } = await supabaseAdmin
        .from('hero_banners')
        .update({ show_title: newShowTitle, updated_at: new Date().toISOString() })
        .eq('id', banner.id);

      if (updateErr) throw updateErr;
      showNotification('success', `Title text ${newShowTitle ? 'visible' : 'hidden'}`);
    } catch (err: any) {
      setBanners((prev) =>
        prev.map((b) => (b.id === banner.id ? { ...b, show_title: banner.show_title } : b))
      );
      showNotification('error', err.message || 'Failed to update title visibility');
    }
  };

  // Delete banner
  const handleDeleteBanner = async (id: string) => {
    if (!window.confirm('Are you sure you want to delete this hero banner?')) return;

    try {
      const { error: deleteErr } = await supabaseAdmin
        .from('hero_banners')
        .delete()
        .eq('id', id);

      if (deleteErr) throw deleteErr;
      setBanners((prev) => prev.filter((b) => b.id !== id));
      showNotification('success', 'Banner deleted successfully!');
      if (onRefreshStats) onRefreshStats();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to delete banner');
    }
  };

  // Quick reorder
  const handleUpdateOrder = async (banner: HeroBanner, delta: number) => {
    const newOrder = Math.max(0, banner.sort_order + delta);
    if (newOrder === banner.sort_order) return;

    setBanners((prev) =>
      prev.map((b) => (b.id === banner.id ? { ...b, sort_order: newOrder } : b))
    );

    try {
      const { error: updateErr } = await supabaseAdmin
        .from('hero_banners')
        .update({ sort_order: newOrder, updated_at: new Date().toISOString() })
        .eq('id', banner.id);

      if (updateErr) throw updateErr;
      await fetchBanners();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to reorder banner');
    }
  };

  // Filtered channels for picker
  const filteredChannels = useMemo(() => {
    if (!channelSearch.trim()) return channels.slice(0, 50);
    const q = channelSearch.toLowerCase();
    return channels
      .filter((c) => c.name.toLowerCase().includes(q) || (c.category && c.category.toLowerCase().includes(q)))
      .slice(0, 50);
  }, [channels, channelSearch]);

  const selectedChannel = useMemo(() => {
    if (formData.action_type !== 'channel' || !formData.action_value) return null;
    return channels.find((c) => c.id === formData.action_value);
  }, [channels, formData.action_type, formData.action_value]);

  // Statistics
  const activeCount = useMemo(() => banners.filter((b) => b.active).length, [banners]);
  const urlActionsCount = useMemo(() => banners.filter((b) => b.action_type === 'url').length, [banners]);
  const channelActionsCount = useMemo(() => banners.filter((b) => b.action_type === 'channel').length, [banners]);

  return (
    <div className="flex-1 p-6 lg:p-8 max-w-7xl mx-auto space-y-8 animate-fadeIn overflow-y-auto">
      {/* Toast Notifications */}
      {success && (
        <div className="fixed top-6 right-6 z-50 flex items-center gap-2 bg-emerald-500/90 text-white px-4 py-3 rounded-xl shadow-xl backdrop-blur-md border border-emerald-400/30 text-sm font-medium animate-fadeIn">
          <CheckCircle className="w-5 h-5 flex-shrink-0" />
          <span>{success}</span>
        </div>
      )}
      {error && (
        <div className="fixed top-6 right-6 z-50 flex items-center gap-2 bg-rose-500/90 text-white px-4 py-3 rounded-xl shadow-xl backdrop-blur-md border border-rose-400/30 text-sm font-medium animate-fadeIn">
          <AlertTriangle className="w-5 h-5 flex-shrink-0" />
          <span>{error}</span>
        </div>
      )}

      {/* Header Section */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-6 border-b border-zinc-800/80">
        <div>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400">
              <ImageIcon className="w-5 h-5" />
            </div>
            <div>
              <h1 className="text-2xl font-bold text-white tracking-tight">Hero Banners & Ads</h1>
              <p className="text-sm text-zinc-400">
                Manage promotional banners, ads, and spotlight graphics displayed in the Android app header carousel.
              </p>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={fetchBanners}
            className="p-2.5 rounded-xl bg-zinc-900 border border-zinc-800 text-zinc-400 hover:text-white hover:bg-zinc-800 transition-all cursor-pointer"
            title="Refresh banners"
          >
            <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
          </button>
          <button
            onClick={handleOpenAddModal}
            className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-500 hover:to-pink-500 text-white text-sm font-semibold shadow-lg shadow-purple-500/20 transition-all cursor-pointer"
          >
            <Plus className="w-4 h-4" />
            <span>Create Banner</span>
          </button>
        </div>
      </div>

      {/* Metric Cards */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <div className="bg-zinc-900/60 border border-zinc-800/80 rounded-2xl p-4">
          <div className="flex items-center justify-between text-zinc-400 mb-2">
            <span className="text-xs font-medium uppercase tracking-wider">Total Banners</span>
            <Layers className="w-4 h-4 text-purple-400" />
          </div>
          <div className="text-2xl font-extrabold text-white">{banners.length}</div>
        </div>

        <div className="bg-zinc-900/60 border border-zinc-800/80 rounded-2xl p-4">
          <div className="flex items-center justify-between text-zinc-400 mb-2">
            <span className="text-xs font-medium uppercase tracking-wider">Active in App</span>
            <Sparkles className="w-4 h-4 text-emerald-400" />
          </div>
          <div className="text-2xl font-extrabold text-emerald-400">{activeCount}</div>
        </div>

        <div className="bg-zinc-900/60 border border-zinc-800/80 rounded-2xl p-4">
          <div className="flex items-center justify-between text-zinc-400 mb-2">
            <span className="text-xs font-medium uppercase tracking-wider">Web Links</span>
            <ExternalLink className="w-4 h-4 text-blue-400" />
          </div>
          <div className="text-2xl font-extrabold text-white">{urlActionsCount}</div>
        </div>

        <div className="bg-zinc-900/60 border border-zinc-800/80 rounded-2xl p-4">
          <div className="flex items-center justify-between text-zinc-400 mb-2">
            <span className="text-xs font-medium uppercase tracking-wider">Channel Triggers</span>
            <Tv className="w-4 h-4 text-amber-400" />
          </div>
          <div className="text-2xl font-extrabold text-white">{channelActionsCount}</div>
        </div>
      </div>

      {/* Banners Grid */}
      {loading && banners.length === 0 ? (
        <div className="py-20 flex flex-col items-center justify-center text-zinc-500">
          <div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin mb-3"></div>
          <p className="text-sm">Loading hero banners...</p>
        </div>
      ) : banners.length === 0 ? (
        <div className="py-16 px-4 text-center bg-zinc-900/40 border border-zinc-800/60 rounded-2xl">
          <ImageIcon className="w-12 h-12 text-zinc-600 mx-auto mb-3" />
          <h3 className="text-base font-semibold text-zinc-300 mb-1">No Hero Banners Found</h3>
          <p className="text-sm text-zinc-500 max-w-sm mx-auto mb-5">
            Create promotional banners or ads to display at the top of the GoPlay mobile app home screen.
          </p>
          <button
            onClick={handleOpenAddModal}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-purple-600 hover:bg-purple-500 text-white text-sm font-semibold transition-all cursor-pointer"
          >
            <Plus className="w-4 h-4" />
            <span>Add First Banner</span>
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {banners.map((banner) => {
            const linkedChannel = banner.action_type === 'channel' && banner.action_value
              ? channels.find((c) => c.id === banner.action_value)
              : null;

            const hasOverlay = (banner.show_badge ?? true) || (banner.show_title ?? true);

            return (
              <div
                key={banner.id}
                className={`group relative flex flex-col rounded-2xl border transition-all duration-200 overflow-hidden bg-zinc-900/70 ${
                  banner.active
                    ? 'border-zinc-800 hover:border-purple-500/50 shadow-md hover:shadow-purple-500/10'
                    : 'border-zinc-800/40 opacity-60 hover:opacity-100'
                }`}
              >
                {/* Visual Card Preview (matches mobile app aspect ratio) */}
                <div className="relative aspect-[16/8] w-full bg-zinc-950 overflow-hidden flex items-center justify-center">
                  {banner.image_url ? (
                    <img
                      src={banner.image_url}
                      alt={banner.title || 'Banner'}
                      className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
                      onError={(e) => {
                        (e.target as HTMLImageElement).src = 'https://placehold.co/600x300/18181b/71717a?text=Broken+Image+URL';
                      }}
                    />
                  ) : (
                    <div className="flex flex-col items-center justify-center text-zinc-600">
                      <ImageIcon className="w-8 h-8 mb-1" />
                      <span className="text-xs">No image</span>
                    </div>
                  )}

                  {/* Gradient overlay only if badge or title is enabled */}
                  {hasOverlay && (
                    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-black/40 pointer-events-none" />
                  )}

                  {/* Top Bar inside preview */}
                  <div className="absolute top-3 left-3 right-3 flex items-center justify-between pointer-events-none">
                    {(banner.show_badge ?? true) && banner.badge_text ? (
                      <span className="px-2.5 py-1 rounded-md bg-black/60 backdrop-blur-md border border-white/20 text-[10px] font-bold uppercase tracking-wider text-white">
                        {banner.badge_text}
                      </span>
                    ) : (
                      <span />
                    )}

                    <div className="flex items-center gap-1.5 px-2 py-0.5 rounded-full bg-black/70 backdrop-blur-md border border-white/10 text-[10px] font-semibold text-zinc-300">
                      <span>#{banner.sort_order}</span>
                    </div>
                  </div>

                  {/* Bottom title in preview */}
                  {(banner.show_title ?? true) && banner.title && (
                    <div className="absolute bottom-3 left-3 right-3 pointer-events-none">
                      <h4 className="text-white text-sm font-bold truncate drop-shadow-md">
                        {banner.title}
                      </h4>
                    </div>
                  )}
                </div>

                {/* Card Info & Details */}
                <div className="p-4 flex-1 flex flex-col justify-between gap-3">
                  <div className="space-y-2.5">
                    {/* Action Type & Active Status */}
                    <div className="flex items-center justify-between gap-2">
                      <div className="flex items-center gap-1.5 text-xs font-medium">
                        {banner.action_type === 'url' ? (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-blue-500/10 text-blue-400 border border-blue-500/20">
                            <ExternalLink className="w-3 h-3" /> External Link
                          </span>
                        ) : banner.action_type === 'channel' ? (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-amber-500/10 text-amber-400 border border-amber-500/20">
                            <Tv className="w-3 h-3" /> Live Channel
                          </span>
                        ) : (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-zinc-800 text-zinc-400 border border-zinc-700/50">
                            <Eye className="w-3 h-3" /> Display Only
                          </span>
                        )}
                      </div>

                      <button
                        onClick={() => handleToggleActive(banner)}
                        className={`text-xs font-semibold px-2.5 py-1 rounded-full transition-all cursor-pointer flex items-center gap-1.5 ${
                          banner.active
                            ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/30 hover:bg-emerald-500/20'
                            : 'bg-zinc-800 text-zinc-400 border border-zinc-700 hover:bg-zinc-700 hover:text-white'
                        }`}
                      >
                        <span className={`w-1.5 h-1.5 rounded-full ${banner.active ? 'bg-emerald-400 animate-pulse' : 'bg-zinc-500'}`} />
                        {banner.active ? 'Active' : 'Hidden'}
                      </button>
                    </div>

                    {/* Quick Visibility Controls for Tag & Title */}
                    <div className="flex items-center gap-2 pt-1 pb-1 px-2.5 rounded-xl bg-zinc-950/40 border border-zinc-800/60">
                      <span className="text-[10px] font-bold text-zinc-500 uppercase tracking-wider">Overlays:</span>
                      
                      <button
                        type="button"
                        onClick={() => handleToggleShowBadge(banner)}
                        className={`px-2 py-0.5 rounded-md text-[10px] font-semibold transition-all cursor-pointer flex items-center gap-1 ${
                          (banner.show_badge ?? true)
                            ? 'bg-purple-500/20 text-purple-300 border border-purple-500/40'
                            : 'bg-zinc-900 text-zinc-500 border border-zinc-800 hover:text-zinc-400'
                        }`}
                        title="Click to toggle Tag visibility"
                      >
                        <Tag className="w-2.5 h-2.5" />
                        <span>Tag: {(banner.show_badge ?? true) ? 'Visible' : 'Hidden'}</span>
                      </button>

                      <button
                        type="button"
                        onClick={() => handleToggleShowTitle(banner)}
                        className={`px-2 py-0.5 rounded-md text-[10px] font-semibold transition-all cursor-pointer flex items-center gap-1 ${
                          (banner.show_title ?? true)
                            ? 'bg-purple-500/20 text-purple-300 border border-purple-500/40'
                            : 'bg-zinc-900 text-zinc-500 border border-zinc-800 hover:text-zinc-400'
                        }`}
                        title="Click to toggle Title text visibility"
                      >
                        <Type className="w-2.5 h-2.5" />
                        <span>Title: {(banner.show_title ?? true) ? 'Visible' : 'Hidden'}</span>
                      </button>
                    </div>

                    {/* Action Target Details */}
                    {banner.action_type === 'url' && banner.action_value && (
                      <p className="text-xs text-zinc-400 truncate flex items-center gap-1 font-mono">
                        <span className="text-zinc-600">Target:</span>
                        <a
                          href={banner.action_value}
                          target="_blank"
                          rel="noreferrer"
                          className="hover:text-blue-400 underline truncate"
                        >
                          {banner.action_value}
                        </a>
                      </p>
                    )}

                    {banner.action_type === 'channel' && (
                      <div className="flex items-center gap-2 p-1.5 rounded-lg bg-zinc-950/60 border border-zinc-800 text-xs">
                        {linkedChannel?.logo ? (
                          <img
                            src={linkedChannel.logo}
                            alt=""
                            className="w-5 h-5 object-contain rounded bg-black/40"
                          />
                        ) : (
                          <Tv className="w-4 h-4 text-zinc-500" />
                        )}
                        <span className="text-zinc-300 font-medium truncate">
                          {linkedChannel ? linkedChannel.name : `Channel ID: ${banner.action_value}`}
                        </span>
                      </div>
                    )}
                  </div>

                  {/* Actions footer */}
                  <div className="pt-3 border-t border-zinc-800/80 flex items-center justify-between gap-2">
                    {/* Reorder Buttons */}
                    <div className="flex items-center gap-1">
                      <button
                        onClick={() => handleUpdateOrder(banner, -1)}
                        className="p-1 rounded-lg bg-zinc-800/60 hover:bg-zinc-800 text-zinc-400 hover:text-white transition-all text-xs cursor-pointer"
                        title="Move Up in priority"
                      >
                        ▲
                      </button>
                      <button
                        onClick={() => handleUpdateOrder(banner, 1)}
                        className="p-1 rounded-lg bg-zinc-800/60 hover:bg-zinc-800 text-zinc-400 hover:text-white transition-all text-xs cursor-pointer"
                        title="Move Down in priority"
                      >
                        ▼
                      </button>
                    </div>

                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => handleOpenEditModal(banner)}
                        className="flex items-center gap-1 px-2.5 py-1.5 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-200 text-xs font-medium transition-all cursor-pointer"
                      >
                        <Edit2 className="w-3.5 h-3.5" />
                        <span>Edit</span>
                      </button>
                      <button
                        onClick={() => handleDeleteBanner(banner.id)}
                        className="p-1.5 rounded-lg hover:bg-rose-950/30 text-zinc-500 hover:text-rose-400 transition-all cursor-pointer"
                        title="Delete banner"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* ── CREATE / EDIT MODAL ────────────────────────────────────── */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm animate-fadeIn">
          <div className="w-full max-w-2xl bg-zinc-900 border border-zinc-800 rounded-3xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
            {/* Modal Header */}
            <div className="p-6 border-b border-zinc-800 flex items-center justify-between">
              <div>
                <h2 className="text-xl font-bold text-white">
                  {editingBanner ? 'Edit Hero Banner' : 'Create New Hero Banner'}
                </h2>
                <p className="text-xs text-zinc-400 mt-0.5">
                  Set banner graphics, promotional copy, overlay toggles, and tap destination actions.
                </p>
              </div>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-2 rounded-xl text-zinc-400 hover:text-white hover:bg-zinc-800 transition-all cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Modal Body */}
            <form onSubmit={handleSaveBanner} className="p-6 overflow-y-auto space-y-6">
              {/* Image Input & Upload */}
              <div className="space-y-3">
                <label className="block text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Banner Artwork Image <span className="text-rose-400">*</span>
                </label>

                {/* Upload or URL tabs */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  {/* File Upload Box */}
                  <div
                    onClick={() => fileInputRef.current?.click()}
                    className={`border-2 border-dashed rounded-2xl p-4 flex flex-col items-center justify-center gap-2 cursor-pointer transition-all ${
                      isUploading
                        ? 'border-purple-500 bg-purple-500/10'
                        : 'border-zinc-700 hover:border-purple-500/60 bg-zinc-950/40 hover:bg-zinc-950'
                    }`}
                  >
                    <input
                      ref={fileInputRef}
                      type="file"
                      accept="image/*"
                      onChange={handleFileUpload}
                      className="hidden"
                    />
                    <UploadCloud className={`w-6 h-6 ${isUploading ? 'animate-bounce text-purple-400' : 'text-zinc-400'}`} />
                    <div className="text-center">
                      <span className="text-xs font-semibold text-zinc-200 block">
                        {isUploading ? 'Uploading to Supabase...' : 'Upload Image File'}
                      </span>
                      <span className="text-[10px] text-zinc-500">PNG, JPG, WEBP (Max 5MB)</span>
                    </div>
                  </div>

                  {/* Direct URL input */}
                  <div className="flex flex-col justify-center gap-1.5">
                    <span className="text-xs text-zinc-400 font-medium">Or paste image URL:</span>
                    <input
                      type="url"
                      placeholder="https://example.com/banner.png"
                      value={formData.image_url}
                      onChange={(e) => setFormData({ ...formData, image_url: e.target.value })}
                      className="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3 py-2 text-xs text-white placeholder-zinc-600 focus:outline-none focus:border-purple-500"
                    />
                    <span className="text-[10px] text-zinc-500">
                      Recommendation: 16:9 widescreen or 800x400 landscape banner.
                    </span>
                  </div>
                </div>

                {/* Live Card Preview Box */}
                {formData.image_url && (
                  <div className="mt-3">
                    <span className="text-[11px] font-semibold text-zinc-400 block mb-1.5">
                      Preview in Mobile App Frame:
                    </span>
                    <div className="relative aspect-[16/8] w-full max-w-md mx-auto rounded-2xl overflow-hidden border border-zinc-700 bg-zinc-950 shadow-lg">
                      <img
                        src={formData.image_url}
                        alt="Preview"
                        className="w-full h-full object-cover"
                        onError={(e) => {
                          (e.target as HTMLImageElement).src = 'https://placehold.co/600x300/18181b/71717a?text=Invalid+Image+URL';
                        }}
                      />
                      {/* Gradient overlay only if badge or title is enabled */}
                      {(formData.show_badge || formData.show_title) && (
                        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-black/30 pointer-events-none" />
                      )}

                      {/* Preview Top Badge */}
                      {formData.show_badge && formData.badge_text && (
                        <div className="absolute top-3 left-3">
                          <span className="px-2.5 py-1 rounded-md bg-black/60 backdrop-blur-md border border-white/20 text-[10px] font-bold uppercase tracking-wider text-white">
                            {formData.badge_text}
                          </span>
                        </div>
                      )}

                      {/* Preview Bottom Title */}
                      {formData.show_title && formData.title && (
                        <div className="absolute bottom-3 left-3 right-3">
                          <h4 className="text-white text-sm font-bold truncate drop-shadow-md">
                            {formData.title}
                          </h4>
                        </div>
                      )}
                    </div>
                  </div>
                )}
              </div>

              {/* Title & Badge Text Inputs */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <div className="flex items-center justify-between mb-1.5">
                    <label className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Banner Title (Optional)
                    </label>
                    <label className="flex items-center gap-1.5 text-xs text-zinc-400 cursor-pointer">
                      <input
                        type="checkbox"
                        checked={formData.show_title}
                        onChange={(e) => setFormData({ ...formData, show_title: e.target.checked })}
                        className="w-3.5 h-3.5 accent-purple-600 rounded cursor-pointer"
                      />
                      <span>Show Title</span>
                    </label>
                  </div>
                  <input
                    type="text"
                    placeholder="e.g. ICC T20 World Cup Live"
                    value={formData.title}
                    onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                    className="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3.5 py-2.5 text-sm text-white placeholder-zinc-600 focus:outline-none focus:border-purple-500"
                  />
                </div>

                <div>
                  <div className="flex items-center justify-between mb-1.5">
                    <label className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Badge Tag (Optional)
                    </label>
                    <label className="flex items-center gap-1.5 text-xs text-zinc-400 cursor-pointer">
                      <input
                        type="checkbox"
                        checked={formData.show_badge}
                        onChange={(e) => setFormData({ ...formData, show_badge: e.target.checked })}
                        className="w-3.5 h-3.5 accent-purple-600 rounded cursor-pointer"
                      />
                      <span>Show Badge</span>
                    </label>
                  </div>
                  <input
                    type="text"
                    placeholder="e.g. Featured, Ad, Sponsor, Live"
                    value={formData.badge_text}
                    onChange={(e) => setFormData({ ...formData, badge_text: e.target.value })}
                    className="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3.5 py-2.5 text-sm text-white placeholder-zinc-600 focus:outline-none focus:border-purple-500"
                  />
                </div>
              </div>

              {/* Action Destination */}
              <div className="space-y-3 p-4 rounded-2xl bg-zinc-950/60 border border-zinc-800/80">
                <label className="block text-xs font-bold uppercase tracking-wider text-zinc-300">
                  Tap / Click Action Destination
                </label>

                {/* Action Type Radio Tabs */}
                <div className="grid grid-cols-3 gap-2">
                  <button
                    type="button"
                    onClick={() => setFormData({ ...formData, action_type: 'none', action_value: '' })}
                    className={`py-2 px-3 rounded-xl text-xs font-semibold flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                      formData.action_type === 'none'
                        ? 'bg-purple-600 text-white shadow-md shadow-purple-500/20'
                        : 'bg-zinc-900 text-zinc-400 hover:text-zinc-200 border border-zinc-800'
                    }`}
                  >
                    <Eye className="w-3.5 h-3.5" />
                    <span>Display Only</span>
                  </button>

                  <button
                    type="button"
                    onClick={() => setFormData({ ...formData, action_type: 'url' })}
                    className={`py-2 px-3 rounded-xl text-xs font-semibold flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                      formData.action_type === 'url'
                        ? 'bg-blue-600 text-white shadow-md shadow-blue-500/20'
                        : 'bg-zinc-900 text-zinc-400 hover:text-zinc-200 border border-zinc-800'
                    }`}
                  >
                    <ExternalLink className="w-3.5 h-3.5" />
                    <span>External URL</span>
                  </button>

                  <button
                    type="button"
                    onClick={() => setFormData({ ...formData, action_type: 'channel' })}
                    className={`py-2 px-3 rounded-xl text-xs font-semibold flex items-center justify-center gap-1.5 transition-all cursor-pointer ${
                      formData.action_type === 'channel'
                        ? 'bg-amber-600 text-white shadow-md shadow-amber-500/20'
                        : 'bg-zinc-900 text-zinc-400 hover:text-zinc-200 border border-zinc-800'
                    }`}
                  >
                    <Tv className="w-3.5 h-3.5" />
                    <span>Live Channel</span>
                  </button>
                </div>

                {/* Action Value based on selection */}
                {formData.action_type === 'url' && (
                  <div className="space-y-1 animate-fadeIn">
                    <label className="text-[11px] font-semibold text-zinc-400">Target Web Link:</label>
                    <input
                      type="url"
                      placeholder="https://example.com/promo"
                      value={formData.action_value}
                      onChange={(e) => setFormData({ ...formData, action_value: e.target.value })}
                      className="w-full bg-zinc-900 border border-zinc-800 rounded-xl px-3.5 py-2.5 text-xs text-white placeholder-zinc-600 focus:outline-none focus:border-blue-500"
                    />
                    <span className="text-[10px] text-zinc-500">Opens in the user's default browser or app.</span>
                  </div>
                )}

                {formData.action_type === 'channel' && (
                  <div className="space-y-2 animate-fadeIn relative">
                    <label className="text-[11px] font-semibold text-zinc-400">Select Live Channel:</label>

                    {/* Selected channel display */}
                    {selectedChannel ? (
                      <div className="flex items-center justify-between p-2.5 rounded-xl bg-zinc-900 border border-amber-500/40">
                        <div className="flex items-center gap-2.5">
                          {selectedChannel.logo ? (
                            <img src={selectedChannel.logo} alt="" className="w-6 h-6 object-contain rounded" />
                          ) : (
                            <Tv className="w-5 h-5 text-zinc-500" />
                          )}
                          <div>
                            <span className="text-xs font-semibold text-white block">{selectedChannel.name}</span>
                            <span className="text-[10px] text-zinc-400">{selectedChannel.category || 'Channel'}</span>
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() => setFormData({ ...formData, action_value: '' })}
                          className="text-xs text-zinc-400 hover:text-white px-2 py-1 rounded bg-zinc-800 cursor-pointer"
                        >
                          Change
                        </button>
                      </div>
                    ) : (
                      <div>
                        <div className="relative">
                          <Search className="w-4 h-4 text-zinc-500 absolute left-3 top-3" />
                          <input
                            type="text"
                            placeholder="Search channel by name..."
                            value={channelSearch}
                            onChange={(e) => {
                              setChannelSearch(e.target.value);
                              setIsChannelDropdownOpen(true);
                            }}
                            onFocus={() => setIsChannelDropdownOpen(true)}
                            className="w-full bg-zinc-900 border border-zinc-800 rounded-xl pl-9 pr-3.5 py-2.5 text-xs text-white placeholder-zinc-600 focus:outline-none focus:border-amber-500"
                          />
                        </div>

                        {/* Search results dropdown */}
                        {isChannelDropdownOpen && (
                          <div className="mt-1 max-h-48 overflow-y-auto bg-zinc-900 border border-zinc-800 rounded-xl shadow-xl divide-y divide-zinc-800/60 z-20">
                            {filteredChannels.length === 0 ? (
                              <div className="p-3 text-center text-xs text-zinc-500">No channels found</div>
                            ) : (
                              filteredChannels.map((c) => (
                                <div
                                  key={c.id}
                                  onClick={() => {
                                    setFormData({ ...formData, action_value: c.id });
                                    setIsChannelDropdownOpen(false);
                                  }}
                                  className="p-2.5 flex items-center gap-2.5 hover:bg-zinc-800/80 cursor-pointer transition-all"
                                >
                                  {c.logo ? (
                                    <img src={c.logo} alt="" className="w-5 h-5 object-contain rounded" />
                                  ) : (
                                    <Tv className="w-4 h-4 text-zinc-500" />
                                  )}
                                  <div className="truncate">
                                    <span className="text-xs font-medium text-zinc-200 block truncate">{c.name}</span>
                                    <span className="text-[10px] text-zinc-500">{c.category || 'General'}</span>
                                  </div>
                                </div>
                              ))
                            )}
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                )}
              </div>

              {/* Status & Priority Order */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-zinc-400 mb-1.5">
                    Sort Order Priority
                  </label>
                  <input
                    type="number"
                    value={formData.sort_order}
                    onChange={(e) => setFormData({ ...formData, sort_order: parseInt(e.target.value) || 0 })}
                    className="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3.5 py-2 text-sm text-white focus:outline-none focus:border-purple-500"
                  />
                  <span className="text-[10px] text-zinc-500 mt-1 block">Lower numbers appear first.</span>
                </div>

                <div className="flex flex-col justify-center">
                  <label className="block text-xs font-bold uppercase tracking-wider text-zinc-400 mb-1.5">
                    Visibility in App
                  </label>
                  <label className="flex items-center gap-3 p-2 rounded-xl bg-zinc-950 border border-zinc-800 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={formData.active}
                      onChange={(e) => setFormData({ ...formData, active: e.target.checked })}
                      className="w-4 h-4 accent-purple-600 rounded cursor-pointer"
                    />
                    <span className="text-xs font-semibold text-zinc-200">
                      {formData.active ? 'Active (Visible)' : 'Draft (Hidden)'}
                    </span>
                  </label>
                </div>
              </div>

              {/* Modal Footer Buttons */}
              <div className="pt-4 border-t border-zinc-800 flex items-center justify-end gap-3">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2.5 rounded-xl border border-zinc-800 hover:bg-zinc-800 text-zinc-400 hover:text-white text-xs font-semibold transition-all cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={isSaving}
                  className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-500 hover:to-pink-500 text-white text-xs font-semibold shadow-lg shadow-purple-500/20 transition-all cursor-pointer disabled:opacity-50"
                >
                  <Save className="w-4 h-4" />
                  <span>{isSaving ? 'Saving...' : editingBanner ? 'Update Banner' : 'Create Banner'}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
