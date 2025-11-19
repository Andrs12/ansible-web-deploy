# ansible-web-deploy
Ansible playbook for automated web server provisioning. Handles Apache/Nginx installation and configuration across multiple hosts, including firewall management, user creation, and static website deployment. Role-based architecture for maximum reusability and maintainability.

## Structure
```
ansible-webserver-config/
├── ansible.cfg
├── inventory/
│   ├── hosts
│   └── group_vars/
│       └── webservers.yml
├── playbooks/
│   └── site.yml
├── roles/
│   ├── common/
│   ├── webserver/
│   ├── firewall/
│   └── deploy_static_site/
├── docker
│   ├── docker-compose.test.yml
│   └── test.sh
└── README.md
```

## Requirements

- Ansible 2.9+
- Python 3.6+
- Docker & Docker Compose (for testing)
- Target servers: Debian 11+, Ubuntu 20.04+, or RHEL-based systems

## Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/Andrs12/ansible-web-deploy.git
   cd ansible-web-deploy
   ```

2. **Configure your inventory**
   ```bash
   # Edit inventory/hosts with your server IPs
   nano inventory/hosts
   
   # Customize variables
   nano inventory/group_vars/webservers.yml
   ```

3. **Run the playbook**
   ```bash
   ansible-playbook -i inventory/hosts playbooks/site.yml
   ```

## Testing with Docker

### Deployment Script
```bash
./docker/test.sh
```

### Start test environment
```bash
docker-compose -f docker/docker-compose.test.yml up -d
```

### Execute playbook
```bash
ansible-playbook -i inventory/hosts.docker playbooks/site.yml
```

### Access test websites
- Debian: http://localhost:8080
- Ubuntu: http://localhost:8081

### Verify services
```bash
# Check containers are running
docker ps --filter "name=web-test"

# Check connectivity
ansible all -i inventory/hosts.docker -m ping

# Access to container
docker exec -it debian-web-test bash

# Access web page
docker exec debian-web-test curl http://localhost
```

### Clean environment
```bash
# Stop containers
docker-compose -f docker/docker-compose.test.yml down

# Stop and delete volumes
docker-compose -f docker/docker-compose.test.yml down -v
```

## Roles

### common
- System updates
- Common package installation
- User creation
- SSH configuration

### firewall
- UFW configuration (Debian/Ubuntu)
- Firewalld configuration (RedHat/CentOS)
- Service and port management

### webserver
- Nginx or Apache installation
- Virtual host configuration
- Service management

### deploy_static_site
- Static website deployment
- File permissions management
- Web server reload

## Configuration

### Inventory Variables

Edit `inventory/group_vars/webservers.yml`:

```yaml
# Webserver type
webserver_type: nginx  # or apache

# Firewall settings
firewall_allowed_services:
  - ssh
  - http
  - https

firewall_default_policy: deny

# Admin user
admin_user: webadmin
```

### Custom Variables

Check each role's `defaults/main.yml` for available variables:
- `roles/common/defaults/main.yml`
- `roles/firewall/defaults/main.yml`
- `roles/webserver/defaults/main.yml`
- `roles/deploy_static_site/defaults/main.yml`

## Troubleshooting

**Permission denied with Docker:**
```bash
sudo usermod -aG docker $USER
newgrp docker
```

**Nginx fails to restart in Docker:**
This is expected in containers without systemd. The playbook handles this gracefully with `ignore_errors`.

**Firewalld not working in containers:**
Firewalld requires systemd. Use VMs or real servers for full testing.

## Production Deployment

For production servers:

1. Update `inventory/hosts` with your server IPs:
   ```ini
   [webservers]
   web1 ansible_host=192.168.1.10
   web2 ansible_host=192.168.1.11
   ```

2. Configure SSH keys for passwordless authentication

3. Test connectivity:
   ```bash
   ansible all -i inventory/hosts -m ping
   ```

4. Run the playbook:
   ```bash
   ansible-playbook -i inventory/hosts playbooks/site.yml
   ```

## License

MIT

## Author

Andres (@Andrs12)

