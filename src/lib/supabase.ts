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
