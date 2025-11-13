import { defineMiddleware } from 'astro:middleware';

export const onRequest = defineMiddleware(async (context, next) => {
  const response = await next();

  // Get Supabase URL from environment
  const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL || '';

  // Set Content Security Policy headers to allow Google Maps iframes and Supabase API
  response.headers.set(
    'Content-Security-Policy',
    [
      "default-src 'self'",
      "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://maps.googleapis.com https://maps.gstatic.com",
      "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
      "img-src 'self' data: https: blob:",
      "font-src 'self' https://fonts.gstatic.com",
      "frame-src 'self' https://www.google.com https://maps.google.com",
      `connect-src 'self' https://maps.googleapis.com ${supabaseUrl}`
    ].join('; ')
  );

  return response;
});