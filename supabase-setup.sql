-- 小可爱面包房：在 Supabase 的 SQL Editor 里整段粘贴，点 Run 一次即可

-- 1. 照片表
create table if not exists public.photos (
  id uuid primary key default gen_random_uuid(),
  src text not null,
  w int, h int,
  caption text default '' check (char_length(caption) <= 40),
  place   text default '' check (char_length(place)   <= 30),
  "when"  text default '' check (char_length("when")  <= 30),
  story   text default '' check (char_length(story)   <= 500),
  "by"    text default '' check (char_length("by")    <= 20),
  tags text[] default '{}',
  created_at timestamptz not null default now()
);

-- 2. 留言小票表
create table if not exists public.notes (
  id uuid primary key default gen_random_uuid(),
  name text default '' check (char_length(name) <= 20),
  text text not null check (char_length(text) between 1 and 200),
  created_at timestamptz not null default now()
);

-- 3. 权限：所有人能看、能新增；不能改、不能删（删除只有你在后台能做）
alter table public.photos enable row level security;
alter table public.notes  enable row level security;
drop policy if exists "anyone can read photos" on public.photos;
drop policy if exists "anyone can add photos"  on public.photos;
drop policy if exists "anyone can read notes"  on public.notes;
drop policy if exists "anyone can add notes"   on public.notes;
create policy "anyone can read photos" on public.photos for select using (true);
create policy "anyone can add photos"  on public.photos for insert with check (true);
create policy "anyone can read notes"  on public.notes  for select using (true);
create policy "anyone can add notes"   on public.notes  for insert with check (true);

-- 4. 实时刷新：别人上传后，打开着的页面会自动更新
alter publication supabase_realtime add table public.photos;
alter publication supabase_realtime add table public.notes;

-- 5. 存照片的公开文件夹（单张最大 5MB，只收图片）
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('photos', 'photos', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;
drop policy if exists "anyone can upload photos" on storage.objects;
create policy "anyone can upload photos" on storage.objects
  for insert with check (bucket_id = 'photos');

-- 6. 首批 16 张照片（图片文件本身放在网站的 photos 文件夹里）
insert into public.photos (src, w, h, caption, tags, "by", created_at) values
('photos/p01.jpg',1600,1200,'凑近检查：你今天带吃的了吗',array['开门营业']::text[],'店主',now() - interval '0 minutes'),
('photos/p02.jpg',1600,1200,'纸板上揣成一只吐司',array['揣成吐司']::text[],'店主',now() - interval '1 minutes'),
('photos/p03.jpg',1205,1600,'晒太阳，白手套摆得整整齐齐',array['醒面中']::text[],'店主',now() - interval '2 minutes'),
('photos/p04.jpg',1600,1200,'仰头看你，绿眼睛亮晶晶',array['开门营业']::text[],'店主',now() - interval '3 minutes'),
('photos/p05.jpg',1200,1600,'夜巡归来，圆滚滚地坐好',array['巡店']::text[],'店主',now() - interval '4 minutes'),
('photos/p06.jpg',1200,1600,'窗边的黄椅子，是本宫的御座',array['开门营业']::text[],'店主',now() - interval '5 minutes'),
('photos/p07.jpg',1200,1600,'御座上侧目，尾巴顺便搭在你鞋上',array['热乎乎']::text[],'店主',now() - interval '6 minutes'),
('photos/p08.jpg',1200,1600,'天冷了，钻进小毯子里',array['热乎乎']::text[],'店主',now() - interval '7 minutes'),
('photos/p09.jpg',1200,1600,'瞳孔放大：是罐罐吗？',array['试吃']::text[],'店主',now() - interval '8 minutes'),
('photos/p10.jpg',1200,1600,'再确认一遍：真的是罐罐吧',array['试吃']::text[],'店主',now() - interval '9 minutes'),
('photos/p11.jpg',1600,1200,'绿眼睛特写，爪爪并拢',array['开门营业']::text[],'店主',now() - interval '10 minutes'),
('photos/p12.jpg',1600,1200,'仰拍太后，睥睨众生',array['限定款']::text[],'店主',now() - interval '11 minutes'),
('photos/p13.jpg',1200,1600,'小小一只，尾巴乖乖绕着脚',array['限定款']::text[],'店主',now() - interval '12 minutes'),
('photos/p14.jpg',1200,1600,'盘成一个圆面包，背上还驮着小玩偶',array['揣成吐司','醒面中']::text[],'店主',now() - interval '13 minutes'),
('photos/p15.jpg',1600,1200,'搭着爪爪，半眯眼审视众人',array['醒面中']::text[],'店主',now() - interval '14 minutes'),
('photos/p16.jpg',1600,1521,'白手套特写，肉垫请排队参观',array['醒面中']::text[],'店主',now() - interval '15 minutes');
