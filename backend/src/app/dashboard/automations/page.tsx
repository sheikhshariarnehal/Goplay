'use client';

import AutomationsStudio from '../../../components/automations/AutomationsStudio';
import { useAuth } from '../../../providers/auth-provider';

export default function AutomationsPage() {
  const { adminToken } = useAuth();
  return <AutomationsStudio adminToken={adminToken} />;
}
