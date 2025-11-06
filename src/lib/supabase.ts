import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export interface MeetupDetails {
  id: number;
  title: string;
  date: string;
  location: string;
  description: string;
  agenda: AgendaItem[];
  additional_info: string;
  signup_link: string;
  updated_at: string;
}

export interface AgendaItem {
  time: string;
  title: string;
  description: string;
}

export interface PageSection {
  type: string;
  content: string;
}

export interface Page {
  id: string;
  title: string;
  slug: string;
  sections: PageSection[];
  meta_description: string | null;
  is_published: boolean;
  created_at: string;
  updated_at: string;
}

export interface MenuItem {
  id: string;
  label: string;
  url: string;
  display_order: number;
  is_visible: boolean;
  created_at: string;
  updated_at: string;
}
