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

  // Agenda section titles
  agenda_title_part1: string;
  agenda_title_part2: string;

  // Event Location section (3 detail cards)
  location_detail_1_title: string;
  location_detail_1_description: string;
  location_detail_2_title: string;
  location_detail_2_description: string;
  location_detail_3_title: string;
  location_detail_3_description: string;
  map_embed_code: string;

  // What to Expect section titles
  expect_title_part1: string;
  expect_title_part2: string;

  // What to Expect section (3 feature cards)
  expect_feature_1_title: string;
  expect_feature_1_description: string;
  expect_feature_2_title: string;
  expect_feature_2_description: string;
  expect_feature_3_title: string;
  expect_feature_3_description: string;

  // Ready to Join section
  join_heading: string;
  join_subtitle: string;
  join_button_text: string;
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
