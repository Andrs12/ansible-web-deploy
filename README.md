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
└── README.md
```


