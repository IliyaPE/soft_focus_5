# How to Launch Soft Focus to the Web

To turn this into a live website, you'll need three things: a place to host the code, a database, and an image storage service.

## Option 1: Render (Easiest Cloud Choice)

[Render](https://render.com) is very friendly for Ruby on Rails apps.

### 1. Create a Production Database (MongoDB Atlas)
Since your app uses MongoDB, you need a live database.
1. Sign up for a free account at [MongoDB Atlas](https://www.mongodb.com/cloud/atlas).
2. Create a "Shared" (free) cluster.
3. In "Network Access", allow access from `0.0.0.0/0` (or just your server IP later).
4. In "Database Access", create a user and password.
5. Get your **Connection String** (`mongodb+srv://...`).

### 2. Put your code on GitHub
1. Create a new repository on GitHub.
2. In your terminal:
   ```bash
   git init
   git add .
   git commit -m "Internal release"
   git remote add origin YOUR_GITHUB_URL
   git push -u origin main
   ```

### 3. Deploy on Render
1. Create a "Web Service" on Render and connect your GitHub repo.
2. **Environment**: Select `Ruby`.
3. **Build Command**: `bundle install; bundle exec rake assets:precompile; bundle exec rake assets:clean`
4. **Start Command**: `bundle exec puma -C config/puma.rb` (or matching your config).
5. **Environment Variables**: Add these in the Render dashboard:
   - `RAILS_ENV`: `production`
   - `MONGO_URL`: *Your MongoDB Atlas connection string*
   - `RAILS_MASTER_KEY`: *The content of your config/master.key (if it exists)*

## ⚠️ Important: Image Storage
In production, your server's disk is often "ephemeral" (it wipes itself when you redeploy).
- **Current Setup**: Saves images to `public/system`.
- **Recommendation**: To keep images permanently, you should configure the `Paperclip` gem in `app/models/image.rb` to use **Amazon S3** or **Google Cloud Storage**.

Let me know if you want me to help you configure S3 for permanent storage!

## Option 2: Easypanel & Hostinger VPS (Full Control)

Since you have **Easypanel** on your Hostinger VPS, you can host everything yourself for free!

### 1. Create a MongoDB Service in Easypanel
1. Go to your Easypanel dashboard.
2. Click **Add Service** -> **Database** -> **MongoDB**.
3. Once created, copy the **Internal Connection String** (e.g., `mongodb://mongodb:27017/softfocus`).

### 2. Create the App Service
1. Click **Add Service** -> **App**.
2. Connect your GitHub repository.
3. In the **General** tab:
   - **Port**: `3000`
   - **Environment Variables**:
     - `RAILS_ENV`: `production`
     - `MONGO_URL`: *Your Internal MongoDB String*
     - `RAILS_SERVE_STATIC_FILES`: `true`

### 3. Setup Persistent Storage (CRITICAL)
Since Docker containers are temporary, you must tell Easypanel to save your images on the VPS disk:
1. Go to the **Volumes** tab in your app service.
2. Add a new volume mapping:
   - **Host Path**: `/mnt/softfocus_images` (or any path on your VPS)
   - **Mount Path**: `/app/public/system`

This ensures your users' photos aren't deleted when you update the code!
