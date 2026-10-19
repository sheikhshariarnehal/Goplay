'use client';

import React, { useState, useEffect } from 'react';
import { X, Save, Layers, Lock, Unlock, Image as ImageIcon } from 'lucide-react';

export interface CategoryData {
  id: string;
  name: string;
  icon_url: string | null;
  type?: 'custom' | 'm3u';
  playz_endpoint?: string | null;
  m3u_url?: string | null;
  sort_order: number;
  active: boolean;
  channel_count?: number;
}

interface CategoryEditorModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (cat: CategoryData) => Promise<void>;
  initialData?: CategoryData | null;
  existingIds: string[];
}

export default function CategoryEditorModal({
  isOpen,
  onClose,
  onSave,
  initialData,
  existingIds,
}: CategoryEditorModalProps) {
  const isEditing = Boolean(initialData);

  const [formData, setFormData] = useState<CategoryData>({
    id: '',
    name: '',
    icon_url: '',
    type: 'custom',
    playz_endpoint: '',
    m3u_url: '',
    sort_order: 0,
    active: true,
  });

  const [idLocked, setIdLocked] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (initialData) {
      setFormData({
        ...initialData,
        type: initialData.type || 'custom',
        icon_url: initialData.icon_url || '',
        playz_endpoint: initialData.playz_endpoint || '',
        m3u_url: initialData.m3u_url || '',
      });
      setIdLocked(true);
    } else {
      setFormData({
        id: '',
        name: '',
        icon_url: '',
        type: 'custom',
        playz_endpoint: '',
        m3u_url: '',
        sort_order: 0,
        active: true,
      });
      setIdLocked(false);
    }
    setError(null);
  }, [initialData, isOpen]);

  if (!isOpen) return null;

  const handleNameChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const name = e.target.value;
    if (!isEditing && !idLocked) {
      const generatedId = name
        .toLowerCase()
        .trim()
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/^-+|-+$/g, '');
      setFormData((prev) => ({ ...prev, name, id: generatedId }));
    } else {
      setFormData((prev) => ({ ...prev, name }));
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    const cleanId = formData.id.trim().toLowerCase();
    const cleanName = formData.name.trim();

    if (!cleanName) {
      setError('Category display name is required.');
      return;
    }
    if (!cleanId) {
      setError('Unique category ID slug is required.');
      return;
    }

    if (!isEditing && existingIds.includes(cleanId)) {
      setError(`Category ID "${cleanId}" already exists. Please choose a unique ID.`);
      return;
    }

    try {
      setSaving(true);
      await onSave({
        ...formData,
        id: cleanId,
        name: cleanName,
        icon_url: formData.icon_url?.trim() || null,
        playz_endpoint: formData.type === 'custom' ? (formData.playz_endpoint?.trim() || null) : null,
        m3u_url: formData.type === 'm3u' ? (formData.m3u_url?.trim() || null) : null,
      });
      onClose();
    } catch (err: any) {
      setError(err.message || 'Failed to save category');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-xs flex items-center justify-center p-4 overflow-y-auto">
      <div className="bg-zinc-900 border border-zinc-800 rounded-2xl w-full max-w-lg overflow-hidden shadow-2xl animate-in fade-in zoom-in-95 duration-200">
        {/* Header */}
        <div className="px-5 py-4 bg-zinc-950/80 border-b border-zinc-800 flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-purple-500/20 text-purple-400 border border-purple-500/30 flex items-center justify-center">
              <Layers className="w-4 h-4" />
            </div>
            <div>
              <h3 className="text-sm font-bold text-white leading-tight">
                {isEditing ? 'Edit Category' : 'Create New Category'}
              </h3>
              <p className="text-[11px] text-zinc-400">
                {isEditing ? `Configure "${formData.name}" settings` : 'Add a new group for live channels'}
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

        {/* Form Body */}
        <form onSubmit={handleSubmit} className="p-5 space-y-4">
          {error && (
            <div className="p-3 bg-rose-950/50 border border-rose-800/60 rounded-xl text-rose-300 text-xs">
              {error}
            </div>
          )}

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
            {/* Name */}
            <div>
              <label className="block text-xs font-medium text-zinc-300 mb-1">
                Display Name <span className="text-purple-400">*</span>
              </label>
              <input
                type="text"
                value={formData.name}
                onChange={handleNameChange}
                placeholder="e.g. Sports, Kolkata, Bangla"
                required
                className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs placeholder:text-zinc-600 focus:outline-hidden focus:border-purple-500 transition"
              />
            </div>

            {/* ID / Slug */}
            <div>
              <div className="flex items-center justify-between mb-1">
                <label className="block text-xs font-medium text-zinc-300">
                  Unique ID / Slug <span className="text-purple-400">*</span>
                </label>
                {isEditing && (
                  <button
                    type="button"
                    onClick={() => setIdLocked(!idLocked)}
                    className="text-[10px] text-zinc-400 hover:text-purple-400 flex items-center gap-1 cursor-pointer"
                  >
                    {idLocked ? <Lock className="w-2.5 h-2.5" /> : <Unlock className="w-2.5 h-2.5" />}
                    {idLocked ? 'Unlock' : 'Lock'}
                  </button>
                )}
              </div>
              <input
                type="text"
                value={formData.id}
                onChange={(e) => setFormData({ ...formData, id: e.target.value })}
                disabled={isEditing && idLocked}
                placeholder="e.g. kolkata, sports, news"
                required
                className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs font-mono placeholder:text-zinc-600 focus:outline-hidden focus:border-purple-500 transition disabled:opacity-50"
              />
            </div>
          </div>

          {/* Icon URL & Live Preview */}
          <div>
            <label className="block text-xs font-medium text-zinc-300 mb-1">
              Category Icon / Badge URL
            </label>
            <div className="flex gap-2">
              <input
                type="url"
                value={formData.icon_url || ''}
                onChange={(e) => setFormData({ ...formData, icon_url: e.target.value })}
                placeholder="https://assets-playztv.pages.dev/category/kolkata.jpg"
                className="flex-1 px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs font-mono placeholder:text-zinc-600 focus:outline-hidden focus:border-purple-500 transition"
              />
              <div className="w-9 h-9 rounded-xl bg-zinc-950 border border-zinc-800 flex items-center justify-center overflow-hidden flex-shrink-0">
                {formData.icon_url ? (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img
                    src={formData.icon_url}
                    alt="Preview"
                    className="w-full h-full object-cover"
                    onError={(e) => {
                      (e.target as HTMLElement).style.display = 'none';
                    }}
                  />
                ) : (
                  <ImageIcon className="w-4 h-4 text-zinc-600" />
                )}
              </div>
            </div>
          </div>

          {/* Category Type Tabs */}
          <div>
            <label className="block text-xs font-medium text-zinc-300 mb-1.5">
              Category Architecture Type
            </label>
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => setFormData({ ...formData, type: 'custom' })}
                className={`py-2 px-3 rounded-xl border text-xs font-medium transition cursor-pointer flex flex-col items-center gap-0.5 ${
                  formData.type === 'custom'
                    ? 'bg-purple-600/20 border-purple-500 text-white'
                    : 'bg-zinc-950 border-zinc-800 text-zinc-400 hover:text-zinc-200'
                }`}
              >
                <span className="font-bold">Custom Database</span>
                <span className="text-[10px] text-zinc-400">PlayZ channels & stream servers</span>
              </button>

              <button
                type="button"
                onClick={() => setFormData({ ...formData, type: 'm3u' })}
                className={`py-2 px-3 rounded-xl border text-xs font-medium transition cursor-pointer flex flex-col items-center gap-0.5 ${
                  formData.type === 'm3u'
                    ? 'bg-purple-600/20 border-purple-500 text-white'
                    : 'bg-zinc-950 border-zinc-800 text-zinc-400 hover:text-zinc-200'
                }`}
              >
                <span className="font-bold">External M3U Stream</span>
                <span className="text-[10px] text-zinc-400">Remote dynamic M3U playlist</span>
              </button>
            </div>
          </div>

          {/* Conditional Endpoint Input */}
          {formData.type === 'custom' ? (
            <div>
              <label className="block text-xs font-medium text-zinc-300 mb-1">
                PlayZ Endpoint Path (Optional)
              </label>
              <input
                type="text"
                value={formData.playz_endpoint || ''}
                onChange={(e) => setFormData({ ...formData, playz_endpoint: e.target.value })}
                placeholder="channels/S29sa2F0YTE3NjcwMDgwNjY5MDg.txt"
                className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs font-mono placeholder:text-zinc-600 focus:outline-hidden focus:border-purple-500 transition"
              />
            </div>
          ) : (
            <div>
              <label className="block text-xs font-medium text-zinc-300 mb-1">
                M3U Stream URL <span className="text-purple-400">*</span>
              </label>
              <input
                type="url"
                value={formData.m3u_url || ''}
                onChange={(e) => setFormData({ ...formData, m3u_url: e.target.value })}
                placeholder="https://m3u-tvb.pages.dev/pk.m3ux"
                required={formData.type === 'm3u'}
                className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs font-mono placeholder:text-zinc-600 focus:outline-hidden focus:border-purple-500 transition"
              />
            </div>
          )}

          {/* Sort order & Active toggle */}
          <div className="grid grid-cols-2 gap-3 pt-1">
            <div>
              <label className="block text-xs font-medium text-zinc-300 mb-1">
                Sort Order Weight
              </label>
              <input
                type="number"
                value={formData.sort_order}
                onChange={(e) => setFormData({ ...formData, sort_order: parseInt(e.target.value) || 0 })}
                className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs font-mono focus:outline-hidden focus:border-purple-500 transition"
              />
              <span className="text-[10px] text-zinc-500">Lower numbers appear first</span>
            </div>

            <div className="flex flex-col justify-center">
              <label className="block text-xs font-medium text-zinc-300 mb-2">
                Visibility Status
              </label>
              <label className="inline-flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.active}
                  onChange={(e) => setFormData({ ...formData, active: e.target.checked })}
                  className="sr-only peer"
                />
                <div className="w-10 h-5 bg-zinc-800 peer-focus:outline-hidden rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-purple-600 relative"></div>
                <span className="text-xs text-zinc-300 font-medium">
                  {formData.active ? 'Active (Visible)' : 'Disabled'}
                </span>
              </label>
            </div>
          </div>

          {/* Footer Actions */}
          <div className="pt-4 border-t border-zinc-800 flex items-center justify-end gap-2">
            <button
              type="button"
              onClick={onClose}
              disabled={saving}
              className="px-4 py-2 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-xs font-medium transition cursor-pointer"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={saving}
              className="px-4 py-2 rounded-xl bg-purple-600 hover:bg-purple-500 text-white text-xs font-bold transition flex items-center gap-1.5 cursor-pointer disabled:opacity-50 shadow-md shadow-purple-600/20"
            >
              {saving ? (
                <>
                  <div className="w-3.5 h-3.5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                  <span>Saving...</span>
                </>
              ) : (
                <>
                  <Save className="w-3.5 h-3.5" />
                  <span>{isEditing ? 'Save Changes' : 'Create Category'}</span>
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
