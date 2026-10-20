'use client';

import AppUiManager from '../../../components/AppUiManager';
import { useAuth } from '../../../providers/auth-provider';

export default function AppUiPage() {
  const { adminToken, refreshStats } = useAuth();
  return <AppUiManager adminToken={adminToken} onRefreshStats={refreshStats} />;
}
