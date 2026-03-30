---
name: hetzner-setup
description: "Provision and harden a Hetzner Cloud server. WHEN: 'Hetzner', 'VPS setup', 'dedicated server', 'cloud server provision'. NOT WHEN: managed platforms (Railway, Netlify), Docker-only tasks, Kubernetes clusters."
---

# Hetzner Setup — VPS Provisioning & Configuration

## Activation

| Context | Status |
|---------|--------|
| User says "Hetzner", "VPS", "cloud server", "provision server" | ACTIVE |
| User wants managed platform deploy | DORMANT — use railway-deploy or netlify-deploy |
| User wants Docker containers only (no server provisioning) | DORMANT — use docker-setup |
| User wants Kubernetes on Hetzner | ESCALATE |

Output on activation: `Hetzner Setup — Provisioning and configuring your server...`

## Instructions

### Step 1: Server Selection

**Type decision tree:**

| Need | Type | Why |
|------|------|-----|
| Budget dev/staging | CX (shared Intel) | Cheapest, burstable |
| Budget production | CAX (shared ARM) | Best price-to-performance if app supports ARM |
| Consistent CPU workloads | CPX (shared AMD) | Better single-thread than CX at similar cost |
| DB-heavy, latency-sensitive | CCX (dedicated vCPU) | No noisy neighbors, guaranteed CPU |

**Location rules:**
- EU users: `nbg1` (Nuremberg) or `fsn1` (Falkenstein) — lowest latency to DACH region
- US users: `ash` (Ashburn) — only US location
- Asia-Pacific users: `sin1` (Singapore) — only APAC location
- Compliance constraint overrides proximity

**Gate:** Server type and location confirmed before proceeding.

### Step 2: Security Hardening

Checklist — all items mandatory:

- [ ] Non-root deploy user with sudo
- [ ] SSH key-only auth (`PasswordAuthentication no`, `PermitRootLogin no`, `MaxAuthTries 3`)
- [ ] UFW: deny incoming default, allow 22/80/443 only
- [ ] fail2ban installed and enabled
- [ ] Unattended security upgrades enabled (`unattended-upgrades` package)
- [ ] SSH restarted and verified from a second terminal before closing root session

**Gate:** Verify SSH login as deploy user from a separate session. Do not proceed until confirmed — locking yourself out requires console access.

### Step 3: Reverse Proxy Selection

| Condition | Choice |
|-----------|--------|
| Single app, minimal config, auto-SSL desired | **Caddy** — zero-config HTTPS, lowest maintenance |
| Multiple apps, need fine-grained control, existing nginx experience | **nginx** + certbot |
| Docker-native routing, dynamic service discovery needed | **Traefik** — integrates with Docker labels |

Configure chosen proxy to terminate SSL and forward to app port. Verify HTTPS works before proceeding.

**Gate:** `curl -I https://yourdomain.com` returns 200 or valid redirect.

### Step 4: Application Deployment

Deploy via Docker Compose (preferred) or systemd service. Set env vars from `.env` file, not hardcoded. Confirm app responds behind reverse proxy.

**Gate:** Application health endpoint returns expected response through the public URL.

### Step 5: Backup Strategy

| Layer | Method | Retention |
|-------|--------|-----------|
| Database | Cron dump + gzip, daily | 7 days local |
| Filesystem | Hetzner automated backups (paid) or snapshot before major changes | Per policy |
| Off-site | Sync backup dir to Hetzner Object Storage or external S3 | 30 days |

**Gate:** Run backup script manually once and verify restore works.

### Step 6: Monitoring

- **Minimum:** Disk usage alert (cron check > 85%), container health via `docker ps`
- **Recommended:** Uptime probe (UptimeRobot, Hetrixtools free tier), log aggregation
- **Production:** Prometheus + Grafana stack, or Hetzner Cloud metrics API

### Step 7: Hetzner-Specific Features

Apply only when needed — do not over-provision:

| Feature | When to use |
|---------|-------------|
| **Floating IPs** | Zero-downtime server migration, failover between servers |
| **Volumes** | Data persistence independent of server lifecycle, or storage beyond server disk |
| **Load Balancers** | Multiple app servers, SSL termination at LB level |
| **Hetzner Firewall** | Network-level rules before traffic hits server (complement to UFW, not replacement) |

## Examples

**1. Budget SaaS API (Node.js, Postgres, < 1k users):**
CAX21 (ARM) in `nbg1`, Caddy reverse proxy, Docker Compose with app + postgres containers, daily DB dump to Hetzner Volume, UptimeRobot ping. Total: ~EUR 7/mo.

**2. Multi-service production (3 services, dedicated CPU needed):**
CCX23 in `ash`, Traefik reverse proxy with Docker labels, Hetzner Firewall + UFW, automated backups to Object Storage, Prometheus + Grafana monitoring. Floating IP reserved for future migration.

## Common Issues

- **Locked out after SSH hardening:** Always test new SSH config from a second terminal before closing root session. Recovery requires Hetzner console access.
- **ARM compatibility:** Some Docker images lack ARM builds. Check before choosing CAX. Use `docker manifest inspect` to verify multi-arch support.
- **Disk fills silently:** Docker logs and unused images accumulate. Add `docker system prune` to weekly cron and monitor disk usage.

## Anti-Patterns

- Running production as root
- Password-based SSH on public servers
- No firewall on a public-facing VPS
- No backups — Hetzner does not back up by default
- Hardcoding server IPs in deploy scripts — use DNS or env vars
- Over-provisioning Hetzner features (floating IPs, LBs) before traffic justifies them

## Escalation

Hand off when:
- Multi-server HA with automated failover required
- Kubernetes cluster provisioning on Hetzner
- Custom networking (VPN mesh, private subnets across locations)
- Hetzner dedicated (bare metal) servers with RAID configuration

## Inputs

- Application type, runtime, and resource requirements
- Expected traffic and growth trajectory
- Domain name (if ready)
- Budget constraint
- Compliance or data residency requirements

## Outputs

- Server type and location recommendation with rationale
- Security hardening verification report
- Reverse proxy selection and SSL confirmation
- Deployment method and health check results
- Backup schedule and restore verification
- Monitoring approach summary

## Level History

- **Lv.1** — Base: Server selection, hardening, Docker, Caddy, deploy workflow, backup cron, basic monitoring. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Decision-tree format, validation gates, server type taxonomy (CX/CPX/CAX/CCX), reverse proxy decision matrix, Hetzner-specific features table, unattended upgrades added to hardening checklist. Removed raw commands per creator-density rules. (Origin: MemStack v3.4, Mar 2026)
