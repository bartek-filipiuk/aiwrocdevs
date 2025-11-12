module.exports = {
  apps: [{
    name: 'wrocdevs-pl',
    script: './dist/server/entry.mjs',
    cwd: '/var/www/wrocdevs.pl/app',
    instances: 2,
    exec_mode: 'cluster',

    // Environment variables
    env_production: {
      NODE_ENV: 'production',
      HOST: '127.0.0.1',
      PORT: 3000,
    },

    // Restart behavior
    max_memory_restart: '500M',
    watch: false,
    autorestart: true,

    // Logging
    error_file: '/var/www/wrocdevs.pl/logs/pm2-error.log',
    out_file: '/var/www/wrocdevs.pl/logs/pm2-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,

    // Graceful shutdown
    kill_timeout: 5000,
    wait_ready: true,
    listen_timeout: 10000
  }]
};
