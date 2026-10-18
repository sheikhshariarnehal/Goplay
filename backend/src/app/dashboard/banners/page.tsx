'use client';

import BannerManager from '../../../components/BannerManager';
import { useAuth } from '../../../providers/auth-provider';

export default function HeroBannersPage() {
  const { adminToken, refreshStats } = useAuth();
  return <BannerManager adminToken={adminToken} onRefreshStats={refreshStats} />;
}
