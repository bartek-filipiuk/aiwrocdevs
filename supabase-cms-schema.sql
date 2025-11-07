-- ============================================
-- AI WrocDevs CMS Database Schema
-- Static Pages & Menu Management System
-- ============================================

-- ============================================
-- 1. PAGES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS pages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  sections JSONB NOT NULL DEFAULT '[]'::jsonb,
  meta_description TEXT,
  is_published BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for faster slug lookups
CREATE INDEX IF NOT EXISTS idx_pages_slug ON pages(slug);
CREATE INDEX IF NOT EXISTS idx_pages_published ON pages(is_published);

-- ============================================
-- 2. MENU ITEMS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS menu_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  label TEXT NOT NULL,
  url TEXT NOT NULL,
  display_order INTEGER NOT NULL DEFAULT 0,
  is_visible BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for ordering
CREATE INDEX IF NOT EXISTS idx_menu_items_order ON menu_items(display_order);

-- ============================================
-- 3. ROW LEVEL SECURITY POLICIES
-- ============================================

-- Enable RLS on pages table
ALTER TABLE pages ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can read published pages
CREATE POLICY "Public read access to published pages"
  ON pages
  FOR SELECT
  USING (is_published = true);

-- Policy: Authenticated users can view all pages (including drafts)
CREATE POLICY "Authenticated users can view all pages"
  ON pages
  FOR SELECT
  USING (auth.role() = 'authenticated');

-- Policy: Authenticated users can insert pages
CREATE POLICY "Authenticated users can insert pages"
  ON pages
  FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- Policy: Authenticated users can update pages
CREATE POLICY "Authenticated users can update pages"
  ON pages
  FOR UPDATE
  USING (auth.role() = 'authenticated');

-- Policy: Authenticated users can delete pages
CREATE POLICY "Authenticated users can delete pages"
  ON pages
  FOR DELETE
  USING (auth.role() = 'authenticated');

-- Enable RLS on menu_items table
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can read visible menu items
CREATE POLICY "Public read access to visible menu items"
  ON menu_items
  FOR SELECT
  USING (is_visible = true);

-- Policy: Authenticated users can view all menu items
CREATE POLICY "Authenticated users can view all menu items"
  ON menu_items
  FOR SELECT
  USING (auth.role() = 'authenticated');

-- Policy: Authenticated users can insert menu items
CREATE POLICY "Authenticated users can insert menu items"
  ON menu_items
  FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- Policy: Authenticated users can update menu items
CREATE POLICY "Authenticated users can update menu items"
  ON menu_items
  FOR UPDATE
  USING (auth.role() = 'authenticated');

-- Policy: Authenticated users can delete menu items
CREATE POLICY "Authenticated users can delete menu items"
  ON menu_items
  FOR DELETE
  USING (auth.role() = 'authenticated');

-- ============================================
-- 4. TRIGGERS FOR UPDATED_AT
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for pages table
DROP TRIGGER IF EXISTS update_pages_updated_at ON pages;
CREATE TRIGGER update_pages_updated_at
  BEFORE UPDATE ON pages
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger for menu_items table
DROP TRIGGER IF EXISTS update_menu_items_updated_at ON menu_items;
CREATE TRIGGER update_menu_items_updated_at
  BEFORE UPDATE ON menu_items
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 5. SEED DATA - Migrate existing pages
-- ============================================

-- Insert About Us page
INSERT INTO pages (title, slug, sections, meta_description, is_published) VALUES (
  'About Us',
  'about',
  '[
    {
      "type": "section",
      "content": "<h2>Our Mission</h2><p>AI WrocDevs is a vibrant community of developers, data scientists, researchers, and AI enthusiasts based in Wrocław, Poland. We''re dedicated to fostering knowledge sharing, collaboration, and innovation in the field of artificial intelligence and machine learning.</p>"
    },
    {
      "type": "section",
      "content": "<h2>What We Do</h2><p>We organize regular meetups, workshops, and networking events that bring together professionals and enthusiasts from various backgrounds. Our events feature:</p><ul><li>Technical talks and presentations from industry experts</li><li>Hands-on workshops and coding sessions</li><li>Panel discussions on AI trends and ethics</li><li>Networking opportunities with like-minded individuals</li><li>Collaboration on real-world AI projects</li></ul>"
    },
    {
      "type": "section",
      "content": "<h2>Who Should Join</h2><p>Whether you''re a seasoned AI professional or just starting your journey in machine learning, you''re welcome here! Our community includes:</p><ul><li>Software developers and engineers</li><li>Data scientists and analysts</li><li>ML/AI researchers and academics</li><li>Product managers and tech leaders</li><li>Students and career changers</li><li>Anyone curious about AI and its applications</li></ul>"
    },
    {
      "type": "section",
      "content": "<h2>Get Involved</h2><p>Join our community and be part of Wrocław''s growing AI ecosystem. Whether you want to attend events, speak at a meetup, or contribute to community projects, we''d love to have you!</p><p>Stay connected with us through our meetups and follow our latest updates to never miss an event.</p>"
    }
  ]'::jsonb,
  'Building Wrocław''s AI & Technology Community',
  true
) ON CONFLICT (slug) DO NOTHING;

-- Insert Privacy Policy page
INSERT INTO pages (title, slug, sections, meta_description, is_published) VALUES (
  'Privacy Policy',
  'privacy',
  '[
    {
      "type": "section",
      "content": "<h2>Introduction</h2><p>AI WrocDevs (\"we\", \"our\", or \"us\") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your personal information when you visit our website and attend our events.</p>"
    },
    {
      "type": "section",
      "content": "<h2>Information We Collect</h2><p>When you register for our events, we may collect the following information:</p><ul><li>Name and email address</li><li>Professional information (company, job title)</li><li>Dietary preferences or accessibility requirements</li><li>Any other information you voluntarily provide</li></ul>"
    },
    {
      "type": "section",
      "content": "<h2>How We Use Your Information</h2><p>We use the collected information for the following purposes:</p><ul><li>Event registration and attendance management</li><li>Sending event updates and announcements</li><li>Improving our events and services</li><li>Communicating about future meetups and activities</li><li>Ensuring safety and security at our events</li></ul>"
    },
    {
      "type": "section",
      "content": "<h2>Data Storage and Security</h2><p>Your data is stored securely using industry-standard encryption and security practices. We use Supabase for data storage, which complies with GDPR and other data protection regulations. We do not sell, trade, or transfer your personal information to third parties without your consent.</p>"
    },
    {
      "type": "section",
      "content": "<h2>Your Rights</h2><p>You have the right to:</p><ul><li>Access your personal data</li><li>Correct inaccurate or incomplete data</li><li>Request deletion of your data</li><li>Opt-out of communications at any time</li><li>Withdraw consent for data processing</li></ul>"
    },
    {
      "type": "section",
      "content": "<h2>Cookies</h2><p>Our website uses minimal cookies to ensure proper functionality. We do not use tracking cookies or third-party analytics tools that collect personal information.</p>"
    },
    {
      "type": "section",
      "content": "<h2>Photography and Media</h2><p>During our events, we may take photographs or videos for promotional purposes. By attending our events, you consent to being photographed or recorded. If you prefer not to be included in any media, please inform our event staff.</p>"
    },
    {
      "type": "section",
      "content": "<h2>Changes to This Policy</h2><p>We may update this Privacy Policy from time to time. Any changes will be posted on this page with an updated revision date. We encourage you to review this policy periodically.</p>"
    },
    {
      "type": "section",
      "content": "<h2>Contact Us</h2><p>If you have any questions about this Privacy Policy or how we handle your data, please contact us through our meetup page or event organizers.</p>"
    }
  ]'::jsonb,
  'Privacy Policy - AI WrocDevs',
  true
) ON CONFLICT (slug) DO NOTHING;

-- ============================================
-- 6. SEED DATA - Default menu items
-- ============================================

-- Insert default menu items
INSERT INTO menu_items (label, url, display_order, is_visible) VALUES
  ('Home', '/', 0, true),
  ('About Us', '/about', 1, true),
  ('Privacy Policy', '/privacy', 2, true)
ON CONFLICT DO NOTHING;

-- ============================================
-- 7. VERIFICATION QUERIES
-- ============================================

-- Verify pages
-- SELECT id, title, slug, is_published, created_at FROM pages ORDER BY created_at;

-- Verify menu items
-- SELECT id, label, url, display_order, is_visible FROM menu_items ORDER BY display_order;

-- Verify RLS policies
-- SELECT schemaname, tablename, policyname FROM pg_policies WHERE tablename IN ('pages', 'menu_items');
