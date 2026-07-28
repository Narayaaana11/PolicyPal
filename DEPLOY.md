# PolicyPal Deployment Guide

This guide details step-by-step instructions for deploying all four PolicyPal subprojects to production.

---

## 1. 🗄️ Database: MongoDB Atlas (Already Configured)
- **Host**: Cloud MongoDB Atlas Cluster
- **Connection URI**: Stored in `.env` under `MONGODB_URI`
- **Setup**:
  - Whitelist `0.0.0.0/0` in Network Access on MongoDB Atlas dashboard to allow backend connections from Render / Vercel.

---

## 2. ⚡ Backend API: Render / Railway

### Deploying on Render (Recommended Free Tier)
1. Go to [Render Dashboard](https://dashboard.render.com/) and click **New > Web Service**.
2. Connect your GitHub repository: `https://github.com/Narayaaana11/PolicyPal`.
3. Configure the following options:
   - **Name**: `policypal-api`
   - **Root Directory**: `.` (leave empty for root)
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `node server.js`
4. Add **Environment Variables**:
   - `PORT` = `5000`
   - `MONGODB_URI` = `mongodb+srv://narayaaana11_db_user:fHYb7HItQdjp7YHo@cluster0.6isddxr.mongodb.net/`
   - `JWT_SECRET` = `policypal_access_secret_key_change_in_production_12345`
   - `JWT_REFRESH_SECRET` = `policypal_refresh_secret_key_change_in_production_67890`
   - `OPENROUTER_API_KEY` = `your_openrouter_api_key_here`
   - `OPENROUTER_MODEL` = `google/gemini-2.0-flash-exp:free`
5. Click **Create Web Service**. Your live backend API URL will be: `https://policypal-api.onrender.com`.

---

## 3. 🌐 Next.js Web App: Vercel

1. Go to [Vercel Dashboard](https://vercel.com/new) and import `https://github.com/Narayaaana11/PolicyPal`.
2. Select the `web` folder as the **Root Directory**.
3. Framework Preset: **Next.js** (Auto-detected).
4. Add **Environment Variables**:
   - `NEXT_PUBLIC_API_URL` = `https://policypal-api.onrender.com/api`
5. Click **Deploy**. Vercel will host your app at `https://policypal-web.vercel.app`.

---

## 4. 🎨 Landing Page: Netlify or Vercel

1. Go to [Netlify Dashboard](https://app.netlify.com/) > **Add new site > Import an existing project**.
2. Select GitHub repo `PolicyPal`.
3. Set configuration:
   - **Base directory**: `landing-page`
   - **Build command**: `npm run build`
   - **Publish directory**: `landing-page/dist`
4. Click **Deploy Site**. Live URL will be generated (e.g. `https://policypal.netlify.app`).

---

## 5. 📱 Flutter Android App: Play Store / Direct APK Distribution

- **APK File Ready**: Located at `app/build/app/outputs/flutter-apk/app-release.apk`
- **Distribution Options**:
  1. **Direct Download**: Upload `app-release.apk` to Firebase App Distribution or GitHub Releases.
  2. **Google Play Console**: Build Android App Bundle (`flutter build appbundle`) and upload to Play Store.
