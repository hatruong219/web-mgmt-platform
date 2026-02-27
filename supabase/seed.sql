-- ═══════════════════════════════════════════════════════════════════════════
-- SEED DATA - Dữ liệu khởi tạo ban đầu
-- ═══════════════════════════════════════════════════════════════════════════
-- File này chứa các câu lệnh SQL để khởi tạo dữ liệu cần thiết.
-- KHÔNG chạy tự động - chỉ chạy thủ công khi cần.
--
-- Cách dùng:
-- 1. Đăng nhập Supabase Dashboard → SQL Editor
-- 2. Copy các câu lệnh cần thiết và chạy
-- 3. Thay đổi giá trị phù hợp với môi trường của bạn
-- ═══════════════════════════════════════════════════════════════════════════


-- ═══════════════════════════════════════════════════════════════════════════
-- 1. SET SUPER ADMIN
-- ═══════════════════════════════════════════════════════════════════════════
-- Chạy sau khi đã đăng ký tài khoản đầu tiên.
-- Thay 'YOUR_EMAIL_HERE' bằng email của bạn.

-- Option A: Nếu profile đã tồn tại (user đã đăng ký)
UPDATE profiles 
SET role = 'super_admin' 
WHERE email = 'YOUR_EMAIL_HERE';

-- Option B: Nếu profile chưa tồn tại (insert từ auth.users)
-- INSERT INTO profiles (id, email, role)
-- SELECT id, email, 'super_admin'
-- FROM auth.users
-- WHERE email = 'YOUR_EMAIL_HERE'
-- ON CONFLICT (id) DO UPDATE SET role = 'super_admin';


-- ═══════════════════════════════════════════════════════════════════════════
-- 2. TẠO SITE MẪU (Optional)
-- ═══════════════════════════════════════════════════════════════════════════
-- INSERT INTO sites (name, slug, domain, description, status)
-- VALUES (
--   'My Blog',
--   'my-blog',
--   'https://myblog.com',
--   'Personal blog về tech',
--   'active'
-- );


-- ═══════════════════════════════════════════════════════════════════════════
-- 3. GÁN USER VÀO SITE (Optional)
-- ═══════════════════════════════════════════════════════════════════════════
-- Sau khi tạo site, gán Super Admin làm admin của site đó.
-- Thay 'YOUR_EMAIL' và 'SITE_SLUG' phù hợp.

-- INSERT INTO site_members (site_id, user_id, role, accepted_at)
-- SELECT 
--   s.id,
--   p.id,
--   'admin',
--   NOW()
-- FROM sites s, profiles p
-- WHERE s.slug = 'SITE_SLUG' AND p.email = 'YOUR_EMAIL';


-- ═══════════════════════════════════════════════════════════════════════════
-- 4. KIỂM TRA DỮ LIỆU
-- ═══════════════════════════════════════════════════════════════════════════
-- Các câu query hữu ích để kiểm tra

-- Xem tất cả users và role
-- SELECT id, email, role, is_active, created_at FROM profiles ORDER BY created_at;

-- Xem tất cả sites
-- SELECT id, name, slug, status, created_at FROM sites ORDER BY created_at;

-- Xem site members
-- SELECT 
--   sm.role as site_role,
--   p.email,
--   p.role as platform_role,
--   s.name as site_name
-- FROM site_members sm
-- JOIN profiles p ON p.id = sm.user_id
-- JOIN sites s ON s.id = sm.site_id;

-- Xem pending invitations
-- SELECT email, role, expires_at, created_at FROM invitations WHERE accepted_at IS NULL;
