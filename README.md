# 小可爱面包房

学校元老猫小可爱（可猪 · 太后）的纪念照片墙。

- 网页放在 **GitHub Pages** 上，免费。
- 照片和留言存在 **Supabase** 里，免费额度够用：数据库 500MB，文件 1GB。
- 所有人都能打开、上传照片、留言，不用注册。

整个流程大约 20 分钟。只需要浏览器，不用装任何软件。

---

## 第 1 步：建数据库（Supabase）（✅ 已完成）

1. 打开 https://supabase.com，点 **Start your project**，用 GitHub 账号登录最方便。
2. 点 **New project**：
   - Name 填 `kezhu-bakery`。
   - Database Password 随便设一个，记下来。
   - Region 选离你们学校近的，比如 Tokyo 或 Singapore。
3. 等 1～2 分钟项目建好后，点左侧 **SQL Editor** → **New query**。
4. 把本文件夹里 `supabase-setup.sql` 的全部内容粘贴进去，点 **Run**，看到 `Success` 就可以了。

## 第 2 步：拿到两个值，填进 config.js（✅ 已填好）

1. 左侧点 **Project Settings**（齿轮图标）→ **API**。
2. 复制这两个值：
   - **Project URL**，形如 `https://abcdxyz.supabase.co`
   - **anon public** key，一长串字符
3. 用记事本打开 `config.js`，替换掉 `YOUR-PROJECT...` 和 `YOUR-ANON-KEY` 那两处。引号要保留。

> anon key 本来就是给网页公开用的，放进公开仓库没问题。
> 页面上方 Settings → API 里还有一个 **service_role** key，那个千万不要放进来。

## 第 3 步：放到 GitHub 上

1. 登录 https://github.com，右上角 **+** → **New repository**：
   - 名字填 `kezhu-bakery`，选 **Public**，点 **Create repository**。
2. 在新仓库页面点 **uploading an existing file**。
3. 把本文件夹里的**所有内容**拖进去，包括 `photos`、`anim` 两个文件夹和 `.nojekyll`。
   - Mac 上 `.nojekyll` 默认看不见，在访达里按 `Cmd + Shift + .` 就能显示。
4. 点 **Commit changes**。
5. 进入仓库的 **Settings** → **Pages**：
   - Source 选 **Deploy from a branch**。
   - Branch 选 **main**，文件夹选 **/(root)**，点 **Save**。
6. 等 1～2 分钟，刷新这个页面，顶部会出现网址，形如 `https://你的用户名.github.io/kezhu-bakery/`。

把这个网址发到群里，或者做成二维码贴在她常待的地方就行。

---

## 日常管理

所有操作都在 Supabase 后台里做。网页上没有管理按钮，也就没人能乱删。

- **删掉不合适的照片或留言**：在 **Table Editor** → `photos` 或 `notes` 里找到那一行，右键 **Delete row**。
- **连照片文件一起删**：在 **Storage** → `photos` 里删掉对应的文件。
- **改配文或分类**：在 Table Editor 里直接双击格子修改。
- **换橱窗照片**：改 `config.js` 里的 `heroPhoto`。
  - 可以填 `photos/p01.jpg` 到 `photos/p16.jpg`，也可以填任意一张照片的完整网址。

## 提醒

- 网站完全公开，任何拿到网址的人都能上传，建议隔几天去后台看一眼。
- 如果以后想改成“先审核再展示”，可以回来找 Claude 加。
- Supabase 免费项目如果连续 7 天没人访问会被暂停，到后台点一下 **Restore** 就能恢复，数据不会丢。
- Supabase 和 GitHub Pages 的服务器都在海外，在中国大陆打开可能偏慢，个别网络下可能打不开。
- 还没连上数据库时，网站也能打开，只会显示首批 16 张照片，上传和留言功能暂时关闭。
- 想先看看效果：网址后面加 `#peek`，就能提前预览解锁动画。
