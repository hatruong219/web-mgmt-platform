-- ════════════════════════════════════════════════════════════════════════════
-- Migration: Invitations delete policy for site admins
-- Date: 2026-02-27
-- Description: Allow site admins to delete pending invitations for their sites
-- ════════════════════════════════════════════════════════════════════════════

CREATE POLICY "invitations_admin_delete" ON invitations
  FOR DELETE USING (is_site_admin(site_id));

