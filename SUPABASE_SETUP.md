# Supabase Setup Guide

This guide will help you set up Supabase for the AI WrocDevs landing page.

## Prerequisites

- A Supabase account (sign up at https://supabase.com)
- Basic knowledge of SQL

## Step 1: Create a New Supabase Project

1. Log in to your Supabase dashboard
2. Click "New Project"
3. Fill in project details:
   - Project name: `ai-wrocdevs`
   - Database password: (choose a strong password)
   - Region: Choose closest to your users (Europe recommended for Wrocław)
4. Click "Create new project" and wait for setup to complete

## Step 2: Create the Database Table

1. Go to the **SQL Editor** in your Supabase dashboard
2. Click "New Query"
3. Copy and paste the following SQL:

```sql
-- Create the meetup_details table
CREATE TABLE meetup_details (
  id INTEGER PRIMARY KEY DEFAULT 1,
  title TEXT NOT NULL,
  date TEXT NOT NULL,
  location TEXT NOT NULL,
  description TEXT NOT NULL,
  agenda JSONB NOT NULL DEFAULT '[]'::jsonb,
  additional_info TEXT NOT NULL,
  signup_link TEXT NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT single_row_check CHECK (id = 1)
);

-- Insert default data
INSERT INTO meetup_details (
  id,
  title,
  date,
  location,
  description,
  agenda,
  additional_info,
  signup_link
) VALUES (
  1,
  'AI WrocDevs Meetup',
  '2025-11-27',
  'Wrocław, Poland',
  'Join us for an exciting meetup focused on Artificial Intelligence, Machine Learning, and the future of technology in Wrocław.',
  '[
    {
      "time": "09:00",
      "title": "Registration & Coffee",
      "description": "Welcome to AI WrocDevs! Grab a coffee and network with fellow attendees."
    },
    {
      "time": "10:00",
      "title": "Opening Keynote",
      "description": "Introduction to the latest trends in AI and what to expect from the day."
    },
    {
      "time": "11:00",
      "title": "AI in Production",
      "description": "Learn how to deploy and scale AI models in real-world applications."
    },
    {
      "time": "12:30",
      "title": "Lunch Break",
      "description": "Networking lunch with refreshments provided."
    },
    {
      "time": "14:00",
      "title": "Panel Discussion",
      "description": "Industry experts discuss the future of AI and its impact on society."
    },
    {
      "time": "15:30",
      "title": "Workshops",
      "description": "Hands-on sessions on machine learning tools and techniques."
    },
    {
      "time": "17:00",
      "title": "Closing & Networking",
      "description": "Final thoughts and open networking session."
    }
  ]'::jsonb,
  'This meetup is perfect for developers, data scientists, AI enthusiasts, and anyone interested in learning about artificial intelligence and its applications.

What to bring: Laptop for workshops (optional), enthusiasm for learning, and business cards for networking.

Free refreshments and snacks will be provided throughout the day.',
  'https://forms.google.com/your-form-link'
);
```

4. Click "Run" to execute the query

## Step 3: Set Up Row Level Security (RLS)

RLS ensures that only authenticated admins can modify data, while everyone can read it.

1. In the **SQL Editor**, create a new query with the following:

```sql
-- Enable Row Level Security
ALTER TABLE meetup_details ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can read (SELECT) the meetup details
CREATE POLICY "Public read access"
  ON meetup_details
  FOR SELECT
  USING (true);

-- Policy: Only authenticated users can update
CREATE POLICY "Authenticated users can update"
  ON meetup_details
  FOR UPDATE
  USING (auth.role() = 'authenticated');

-- Policy: Only authenticated users can insert
CREATE POLICY "Authenticated users can insert"
  ON meetup_details
  FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');
```

2. Click "Run" to execute the query

## Step 4: Create Admin User

1. Go to **Authentication** > **Users** in your Supabase dashboard
2. Click "Add user" > "Create new user"
3. Choose "Email" as the authentication method
4. Enter:
   - Email: `admin@aiwrocdevs.com` (or your preferred admin email)
   - Password: Choose a strong password
   - Auto Confirm User: **Enable** this option
5. Click "Create user"

**Important:** Save these credentials securely - you'll use them to log into the admin panel.

## Step 5: Get Your Supabase Credentials

1. Go to **Project Settings** > **API**
2. You'll find:
   - **Project URL** (starts with `https://`)
   - **anon public** key (a long string)
3. Copy these values

## Step 6: Configure Environment Variables

1. In your project root, create a `.env` file:

```bash
cp .env.example .env
```

2. Edit `.env` and add your Supabase credentials:

```env
PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```

Replace:
- `https://your-project-id.supabase.co` with your Project URL
- `your-anon-key-here` with your anon public key

## Step 7: Test the Setup

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm run dev
```

3. Visit `http://localhost:4321` - you should see the landing page with default data
4. Visit `http://localhost:4321/admin/login` and log in with your admin credentials
5. Try editing the meetup details in the dashboard

## Security Notes

- **Never commit `.env` file** - it's already in `.gitignore`
- **Keep your admin credentials secure**
- The `anon` key is safe to use in client-side code
- RLS policies ensure data security at the database level

## Troubleshooting

### "Missing Supabase environment variables" error
- Make sure you've created the `.env` file
- Verify the environment variable names match exactly
- Restart your development server after changing `.env`

### "Invalid email or password" on admin login
- Verify you created the user in Supabase Authentication
- Make sure "Auto Confirm User" was enabled
- Check that you're using the correct email and password

### Data not showing on homepage
- Check browser console for errors
- Verify your Supabase credentials are correct
- Ensure the `meetup_details` table has data (run the INSERT query again if needed)
- Check that RLS policies are set up correctly

### Can't save changes in admin panel
- Verify you're logged in
- Check that RLS policies for UPDATE are created
- Look for errors in the browser console

## Next Steps

Once everything is working:

1. Update the signup form link to your actual Google Form
2. Customize the meetup details in the admin dashboard
3. Add a custom banner image to `/public/` folder
4. Deploy to your VPS

## Support

For more information about Supabase:
- Documentation: https://supabase.com/docs
- Community: https://github.com/supabase/supabase/discussions
