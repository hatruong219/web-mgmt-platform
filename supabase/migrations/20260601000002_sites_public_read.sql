-- Allow anon to read sites — required for public APIs that resolve site_id by slug
CREATE POLICY "sites_anon_select" ON sites
  FOR SELECT
  TO anon
  USING (true);
