'use client';

import React from 'react';
import LiveTvStudio from '../../../components/livetv/LiveTvStudio';
import { useAuth } from '../../../providers/auth-provider';

export default function LiveTvPage() {
  const { adminToken, refreshStats } = useAuth();
  return <LiveTvStudio adminToken={adminToken} onRefreshStats={refreshStats} />;
}
