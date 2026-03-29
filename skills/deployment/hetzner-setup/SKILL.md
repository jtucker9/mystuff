---
name: hetzner-setup
description: "Use when the user says 'Hetzner', 'VPS', 'server setup', 'cloud server', 'dedicated server', or needs to provision and configure a Hetzner Cloud server with SSH hardening, reverse proxy, SSL, and monitoring. Do NOT use for managed platforms like Railway or Netlify."
---

# 🖥️ Hetzner Setup — VPS Provisioning & Configuration
*Provision a Hetzner Cloud server with security hardening, reverse proxy, SSL, Docker, databases, monitoring, and automated backups.*

## Activation

When this skill activates, output:

`🖥️ Hetzner Setup — Provisioning and configuring your server...`

| Context | Status |
|---------|--------|
| **User says "Hetzner", "VPS", "cloud server"** | ACTIVE |
| **User wants to deploy to a VPS** | ACTIVE |
| **User wants managed platform deploy** | DORMANT — see railway-deploy or netlify-deploy |
| **User wants Docker containers specifically** | DORMANT — see docker-setup |

## Protocol

### Step 1: Choose Server

| Type | vCPU | RAM | Storage | Cost/mo | Use Case |
|------|------|-----|---------|---------|----------|
| CX22 | 2 | 4GB | 40GB | ~€4 | Small apps, staging |
| CX32 | 4 | 8GB | 80GB | ~€7 | Production API, small SaaS |
| CX42 | 8 | 16GB | 160GB | ~€15 | Medium traffic, DB + app |
| CAX21 (ARM) | 4 | 8GB | 80GB | ~€5 | Budget production (ARM native) |
| CAX31 (ARM) | 8 | 16GB | 160GB | ~€9 | Best value for compute |

```bash
# Create via CLI
hcloud server create \
  --name myapp-prod \
  --type cx32 \
  --image ubuntu-24.04 \
  --location nbg1 \
  --ssh-key my-key
```

### Step 2: Initial Server Hardening

```bash
# Connect
ssh root@<server-ip>

# Update system
apt update && apt upgrade -y

# Create deploy user (no root SSH)
adduser deploy
usermod -aG sudo deploy

# Copy SSH key to deploy user
mkdir -p /home/deploy/.ssh
cp ~/.ssh/authorized_keys /home/deploy/.ssh/
chown -R deploy:deploy /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys

# Harden SSH
cat >> /etc/ssh/sshd_config << 'EOF'
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3
AllowUsers deploy
EOF
systemctl restart sshd

# Firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw enable

# Fail2ban for brute force protection
apt install -y fail2ban
systemctl enable fail2ban
```

### Step 3: Install Docker

```bash
# Official Docker install
curl -fsSL https://get.docker.com | sh
usermod -aG docker deploy

# Install Docker Compose plugin
apt install -y docker-compose-plugin

# Verify
docker --version
docker compose version
```

### Step 4: Reverse Proxy (Caddy — recommended)

```bash
# Install Caddy
apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudflare.com/apt/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudflare.com/apt/sources.list.d/caddy-stable.list' | tee /etc/apt/sources.list.d/caddy-stable.list
apt update && apt install -y caddy
```

```
# /etc/caddy/Caddyfile
example.com {
    reverse_proxy localhost:3000
    encode gzip
    log {
        output file /var/log/caddy/access.log
    }
}

api.example.com {
    reverse_proxy localhost:8000
}
```

```bash
sudo systemctl reload caddy
# Caddy automatically gets and renews SSL certificates
```

### Step 5: Deploy Application

```bash
# As deploy user
su - deploy
mkdir -p /opt/app && cd /opt/app

# Clone your repo
git clone https://github.com/user/repo.git .

# Create .env
cp .env.example .env
nano .env  # Set production values

# Start with Docker Compose
docker compose -f docker-compose.prod.yml up -d

# View logs
docker compose logs -f app
```

**Systemd service (for non-Docker apps):**
```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/opt/app
ExecStart=/usr/bin/node dist/index.js
Restart=on-failure
RestartSec=5
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable myapp
sudo systemctl start myapp
```

### Step 6: Automated Backups

```bash
# Database backup script
cat > /opt/scripts/backup.sh << 'SCRIPT'
#!/bin/bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=/opt/backups

mkdir -p $BACKUP_DIR
docker exec postgres pg_dump -U postgres myapp | gzip > "$BACKUP_DIR/db_$TIMESTAMP.sql.gz"

# Keep last 7 days
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete

echo "Backup complete: db_$TIMESTAMP.sql.gz"
SCRIPT
chmod +x /opt/scripts/backup.sh

# Cron: daily at 2 AM
echo "0 2 * * * /opt/scripts/backup.sh" | crontab -
```

### Step 7: Monitoring

```bash
# Simple monitoring with htop and logging
apt install -y htop

# Docker container health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Disk usage alert (add to cron)
USAGE=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
if [ "$USAGE" -gt 85 ]; then echo "⚠️ Disk usage at ${USAGE}%"; fi
```

### Step 8: Output

```
━━━ HETZNER SERVER SETUP ━━━━━━━━━━━━━━━━

── SERVER ────────────────────────────────
Type: [CX32]
IP: [x.x.x.x]
Location: [nbg1]
OS: Ubuntu 24.04

── SECURITY ──────────────────────────────
SSH: Key-only, root disabled, fail2ban active
Firewall: UFW (22, 80, 443 only)

── SERVICES ──────────────────────────────
Reverse Proxy: Caddy (auto-SSL)
Application: Docker Compose
Database: [if applicable]

── ACCESS ────────────────────────────────
SSH: ssh deploy@<ip>
App: https://example.com
```

## Anti-Patterns

- **Running as root**: Always create a deploy user with sudo.
- **Password SSH**: Disable immediately. Key-only authentication.
- **No firewall**: UFW takes 30 seconds and prevents most drive-by attacks.
- **No backups**: Hetzner snapshots cost extra but manual DB dumps are free. Do both.
- **Hardcoding server IP in deploy scripts**: Use DNS or environment variables.

## Escalation

Hand off when:
- High-availability setup needed (load balancer, multiple servers)
- Hetzner dedicated servers with custom networking
- Kubernetes cluster setup on Hetzner
- Complex firewall rules beyond UFW

## Inputs
- Application type and requirements
- Expected traffic/resource needs
- Domain (if ready)
- Budget constraints

## Outputs
- Server provisioning commands
- Security hardening scripts
- Reverse proxy configuration
- Docker/systemd deployment setup
- Backup and monitoring scripts

## Level History

- **Lv.1** — Base: Server selection guide, hardening script (SSH, UFW, fail2ban), Docker install, Caddy reverse proxy with auto-SSL, deploy workflow, backup cron, basic monitoring. (Origin: MemStack v3.3, Mar 2026)
