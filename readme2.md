# Flyton Architecture & Development Guide

**Flyton** is a lightweight, convention-over-configuration web methodology combining standard cloud infrastructure with a minimalist, Python-driven server-side rendering (SSR) and API pipeline.

---

## 1. Cloud Infrastructure & Hosting

- **Compute & OS:** Ubuntu Linux running Apache2 on AWS EC2.
- **SSL & CDN:** AWS CloudFront maps domain names with managed SSL (e.g., `https://www.myproject.com`) to port `80` (HTTP) on the EC2 origin. DNS is handled via AWS Route 53.
- **Database:** MySQL on Linux. All administration is performed via the native MySQL Linux Shell (no web panels).
- **Development Environment:** AWS Cloud9 on a dedicated development server. Production is accessed and deployed exclusively from the dev environment.
- **Dependencies:** Strictly zero or minimal external packages. Do not install third-party packages unless absolutely unavoidable.

---

## 2. Directory Structure

```text
/
├── client/
│   ├── admin/
│   ├── weba/
│   ├── pages/
│   │   ├── lib/          # Static libs, CSS, client-side JS (e.g., bootstrap, kicdev.server.js)
│   │   ├── files/
│   │   └── im/           # Image assets
├── server/
│   ├── cgi-bin/
│   │   ├── p             # 2-line bash entry script calling p4web
│   │   └── p4web.py      # Core execution and page routing engine
│   └── apis/
│       ├── api/          # Individual API endpoints (api_*.py)
│       └── tools/        # Shared core modules & utilities
│           ├── cron/
│           ├── sql.py    # Database abstraction layer
│           ├── kiclang.py# Multilingual text support
│           └── db_*.py   # Entity-specific database managers (e.g., db_prod.py, db_part.py)