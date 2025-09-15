#!/bin/bash

# Enterprise Docker Environment Monitor
# This script provides comprehensive monitoring for the enterprise Linux setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
LOG_DIR="../logs"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo -e "${BLUE}=== Enterprise Docker Environment Monitor ===${NC}"
echo -e "${BLUE}Timestamp: ${TIMESTAMP}${NC}"
echo ""

# Function to check container health
check_container_health() {
    local container_name=$1
    local status=$(docker inspect --format='{{.State.Health.Status}}' "$container_name" 2>/dev/null || echo "unknown")
    
    case $status in
        "healthy")
            echo -e "${GREEN}✓ $container_name: HEALTHY${NC}"
            ;;
        "unhealthy")
            echo -e "${RED}✗ $container_name: UNHEALTHY${NC}"
            ;;
        "starting")
            echo -e "${YELLOW}⚡ $container_name: STARTING${NC}"
            ;;
        *)
            echo -e "${YELLOW}? $container_name: $status${NC}"
            ;;
    esac
}

# Function to check container status
check_container_status() {
    local container_name=$1
    local status=$(docker inspect --format='{{.State.Status}}' "$container_name" 2>/dev/null || echo "not found")
    
    case $status in
        "running")
            echo -e "${GREEN}✓ $container_name: RUNNING${NC}"
            ;;
        "exited")
            echo -e "${RED}✗ $container_name: STOPPED${NC}"
            ;;
        "restarting")
            echo -e "${YELLOW}⚡ $container_name: RESTARTING${NC}"
            ;;
        *)
            echo -e "${RED}✗ $container_name: $status${NC}"
            ;;
    esac
}

# Function to show resource usage
show_resource_usage() {
    echo -e "\n${BLUE}=== Resource Usage ===${NC}"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}" | head -5
}

# Function to show network information
show_network_info() {
    echo -e "\n${BLUE}=== Network Information ===${NC}"
    echo "Enterprise Network Details:"
    docker network inspect enterprise-net --format='{{.IPAM.Config}}' 2>/dev/null || echo "Network not found"
    
    echo -e "\nContainer IP Addresses:"
    docker inspect rhel-prod-server ubuntu-prod-server centos-legacy-server portainer-management \
        --format='{{.Name}}: {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 2>/dev/null || echo "Some containers not found"
}

# Function to show volume information
show_volume_info() {
    echo -e "\n${BLUE}=== Volume Information ===${NC}"
    docker volume ls --filter label=com.company.volume --format "table {{.Driver}}\t{{.Name}}"
}

# Main monitoring checks
echo -e "${BLUE}=== Container Status Check ===${NC}"
check_container_status "rhel-prod-server"
check_container_status "ubuntu-prod-server"  
check_container_status "centos-legacy-server"
check_container_status "portainer-management"

echo -e "\n${BLUE}=== Container Health Check ===${NC}"
check_container_health "rhel-prod-server"
check_container_health "ubuntu-prod-server"

# Show additional information
show_resource_usage
show_network_info
show_volume_info

# Log summary
echo -e "\n${BLUE}=== Log Summary ===${NC}"
echo "Access Portainer: http://localhost:9000"
echo "Enterprise Network: enterprise-net (172.20.0.0/16)"
echo "Total Containers: $(docker ps -q | wc -l)"
echo "Total Volumes: $(docker volume ls -q --filter label=com.company.volume | wc -l)"

# Check for any issues
echo -e "\n${BLUE}=== Health Summary ===${NC}"
UNHEALTHY=$(docker ps --filter health=unhealthy --format '{{.Names}}' | wc -l)
STOPPED=$(docker ps -a --filter status=exited --format '{{.Names}}' | wc -l)

if [ "$UNHEALTHY" -eq 0 ] && [ "$STOPPED" -eq 0 ]; then
    echo -e "${GREEN}✓ All systems operational${NC}"
else
    echo -e "${YELLOW}⚠ Issues detected: $UNHEALTHY unhealthy, $STOPPED stopped${NC}"
fi

echo -e "\n${BLUE}Monitor completed at: $(date '+%Y-%m-%d %H:%M:%S')${NC}"