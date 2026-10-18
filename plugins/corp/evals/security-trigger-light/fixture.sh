#!/usr/bin/env bash
set -e
mkdir -p "$(dirname 'auth.js')"
cat > 'auth.js' <<'FIXTURE'
const session = require('express-session');
module.exports = session({
  secret: process.env.SESSION_SECRET,
  cookie: { httpOnly: true, secure: true, sameSite: 'lax', maxAge: 7 * 24 * 60 * 60 * 1000 },
});
FIXTURE
