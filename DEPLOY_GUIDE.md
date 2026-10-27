# Echo deployment — retain original frontend and C backend

## What's unchanged
- C files `backend/music.c`, `backend/music.h`, and `backend/json.c` remain unchanged.
- The original HTML/CSS design remains unchanged; JavaScript has a new optional Discover view.
- Queue, stack, linked lists, hash table, merge sort and binary search remain in native C.

## 1. Push to GitHub
Create an empty *public or private* GitHub repository (for example `echo-dsa-music`). In the project directory:

```bash
git init
git add .
git commit -m "Deploy Echo C DSA music player"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/echo-dsa-music.git
git push -u origin main
```

GitHub authentication is needed to push; sharing a ZIP does not grant access to your GitHub account.

## 2. Render C backend
- Go to Render > New > Blueprint, connect GitHub repo, and select the repo containing `render.yaml`; or New > Web Service, select Docker runtime and this repository.
- The Dockerfile **compiles and runs the real C backend**; Node/Python are not involved in serving API requests.
- After deployment, verify `https://YOUR-SERVICE.onrender.com/api/health` returns `backend: C`.
- Copy your actual Render URL. On free services the filesystem is ephemeral: your playlists and uploads **may disappear** after restart or redeploy. For persistence, use a Render paid service with disk mounted at `/var/echo` and set environment variable `ECHO_STORAGE=/var/echo`. The container starts with `data` and `media` symlinked to that folder.

## 3. Vercel frontend
- In `vercel.json`, replace `https://REPLACE-WITH-YOUR-RENDER-SERVICE.onrender.com` in **both destinations** with your *actual Render URL* (no trailing slash), commit and push.
- Vercel > Add New Project > Import the same GitHub repository.
- Set **Root Directory** to `static`; BUT Vercel cannot read `vercel.json` if it is above that directory. Instead, leave Root Directory at the **repository root**, set Framework Preset to **Other**, Build Command empty, and Output Directory **`static`**.
- Deploy. The Vercel origin serves original HTML/CSS/JS, while `/api/*` and `/media/*` are rewritten to Render, avoiding browser CORS issues.
- Check `/api/health` on your Vercel URL, then create a playlist and refresh.

## 4. Dynamic catalogue
- Open `Find new music` to search Apple's public iTunes Search API for songs/artists.
- Play available **short previews** without manually creating a library entry.
- Click `+` to import a preview URL and metadata into the **C backend** library; then it is usable in playlists, queue, favorites and sorting.
- This is **not** access to complete commercial songs. Preview availability depends on Apple's API and region, and usage must comply with Apple's terms. If preview access fails, use your own/licensed audio URLs instead.

## Important public hosting notes
- Original C app has **no user authentication** or rate limiting. Anyone who opens a public deployment can change shared playlists, delete songs or upload files. Treat this as a class demo, not a multi-user production app. Do not put private music or information in it.
- On Render's free tier data and uploads will not survive every restart/redeploy. Paid persistent disk or a redesigned external database/object store is required for reliable persistence.
- No developer can push to your GitHub or deploy to your Render/Vercel accounts without your authorization.
