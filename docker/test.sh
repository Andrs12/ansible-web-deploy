#!/bin/bash

# Script to test the playbook in Docker containers

set -e

cd "$(dirname "$0")/.."

echo "Starting test environment..."

docker-compose -f docker/docker-compose.test.yml up -d

sleep 10

echo ""
echo "Execute playbook..."
ansible-playbook -i inventory/hosts.docker playbooks/site.yml

# Verify services
echo ""
echo "✅ Verifying web services..."
echo "Debian (nginx):"
docker exec debian-web-test curl -s http://localhost || echo "Nginx not responding"

echo "Ubuntu (nginx):"
docker exec ubuntu-web-test curl -s http://localhost || echo "Nginx not responding"

echo ""
echo "✨ Tests completed!"
echo ""
echo "Useful commands:"
echo "  - Container logs: docker logs debian-web-test"
echo "  - Enter a container: docker exec -it debian-web-test bash"
echo "  - Stop all: docker-compose -f docker/docker-compose.test.yml down"