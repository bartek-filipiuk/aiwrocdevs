# AI WrocDevs Landing Page

A modern, elegant dark-themed landing page for AI WrocDevs meetup community in Wrocław, built with Astro and Supabase.

## Features

- **Modern Dark Theme** - Sleek, tech-focused design with gradient accents
- **Server-Side Rendering (SSR)** - Fast, dynamic content rendering
- **CMS-like Admin Panel** - Easy content management without rebuilding
- **Supabase Backend** - Secure database with authentication and RLS
- **Fully Responsive** - Beautiful on all devices
- **Static Pages** - About Us and Privacy Policy
- **Dynamic Sections**:
  - Hero banner with event details
  - Agenda timeline
  - Location information
  - Additional event info
  - Sign-up integration

## Tech Stack

- **Framework:** [Astro](https://astro.build) v4+ with SSR
- **Database:** [Supabase](https://supabase.com)
- **Styling:** Vanilla CSS with custom dark theme
- **Deployment:** Node.js (VPS ready)

## Quick Start

### Prerequisites

- Node.js 18+ and npm
- A Supabase account

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd aiwrocdevs
```

2. Install dependencies:
```bash
npm install
```

3. Set up Supabase:
   - Follow the detailed guide in [SUPABASE_SETUP.md](./SUPABASE_SETUP.md)
   - Create a Supabase project
   - Run the SQL scripts to create tables and policies
   - Create an admin user

4. Configure environment variables:
```bash
cp .env.example .env
```

Edit `.env` with your Supabase credentials:
```env
PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

5. Start the development server:
```bash
npm run dev
```

Visit `http://localhost:4321` to see the site!

## Admin Panel

Access the admin panel at `/admin/login` to manage event content:

- **Login:** `/admin/login`
- **Dashboard:** `/admin/dashboard` (requires authentication)

Default admin credentials are created during Supabase setup.

### What You Can Edit:

- Event title, date, and location
- Event description
- Agenda items (add, edit, remove)
- Additional information
- Sign-up form link

Changes are saved to Supabase and appear immediately on the site!

## Project Structure

```
/
├── public/                # Static assets
├── src/
│   ├── components/        # Reusable Astro components
│   │   ├── Header.astro
│   │   ├── Banner.astro
│   │   ├── Agenda.astro
│   │   ├── LocationInfo.astro
│   │   └── AdditionalInfo.astro
│   ├── layouts/
│   │   └── Layout.astro   # Main layout with dark theme
│   ├── lib/
│   │   └── supabase.ts    # Supabase client
│   └── pages/
│       ├── index.astro    # Homepage
│       ├── about.astro    # About Us page
│       ├── privacy.astro  # Privacy Policy page
│       └── admin/
│           ├── login.astro      # Admin login
│           └── dashboard.astro  # Admin dashboard
├── .env.example           # Environment variables template
├── astro.config.mjs       # Astro configuration (SSR)
├── package.json
├── SUPABASE_SETUP.md      # Supabase setup guide
└── README.md
```

## Deployment

### VPS Deployment (Digital Ocean, etc.)

1. **Build the application:**
```bash
npm run build
```

2. **Transfer files to your VPS:**
```bash
rsync -avz --exclude 'node_modules' ./ user@your-vps:/path/to/app
```

3. **On your VPS:**
```bash
cd /path/to/app
npm install --production
```

4. **Set up environment variables:**
```bash
nano .env
# Add your production Supabase credentials
```

5. **Run with PM2 (recommended):**
```bash
npm install -g pm2
pm2 start dist/server/entry.mjs --name "ai-wrocdevs"
pm2 save
pm2 startup
```

6. **Set up Nginx reverse proxy:**
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:4321;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

7. **Set up SSL with Certbot:**
```bash
sudo certbot --nginx -d your-domain.com
```

### Alternative: Vercel/Netlify

While designed for VPS, the app can also be deployed to:
- **Vercel:** Add `@astrojs/vercel` adapter
- **Netlify:** Add `@astrojs/netlify` adapter

See [Astro deployment docs](https://docs.astro.build/en/guides/deploy/) for details.

## Customization

### Update Banner Image

1. Add your image to `/public/` (e.g., `banner.jpg`)
2. Edit `src/components/Banner.astro`
3. Update the background style to use your image

### Change Colors

Edit CSS variables in `src/layouts/Layout.astro`:

```css
:root {
  --accent-primary: #3b82f6;    /* Blue */
  --accent-secondary: #8b5cf6;  /* Purple */
  /* ... more colors */
}
```

### Modify Sections

Components are modular and easy to customize:
- Edit existing components in `src/components/`
- Create new sections as needed
- Update `src/pages/index.astro` to include them

## Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build locally

## Security

- Environment variables are never committed (`.gitignore`)
- Supabase RLS policies protect data
- Admin authentication required for content editing
- HTTPS recommended for production

## Support

For issues or questions:
- Check [SUPABASE_SETUP.md](./SUPABASE_SETUP.md) for database setup
- Review [Astro docs](https://docs.astro.build)
- Open an issue on GitHub

## License

MIT License - feel free to use for your own meetup!

---

Built with ❤️ for the AI WrocDevs community
