# Enterprise Linux Docker Environment

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![RHEL](https://img.shields.io/badge/Red%20Hat-EE0000?style=for-the-badge&logo=redhat&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![CentOS](https://img.shields.io/badge/cent%20os-002260?style=for-the-badge&logo=centos&logoColor=F0F0F0)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)

> **Built by [Thinh Le](https://github.com/mamamia0729)** - Highly Certified IT Professional  
> **Certifications**: AWS | Azure AZ-104 | CCNA | CompTIA Security+ | Network+ | A+

A production-ready, multi-distribution Linux environment built with Docker, featuring enterprise-grade security, monitoring, and infrastructure-as-code practices. This project demonstrates advanced containerization skills suitable for enterprise DevOps and Cloud Infrastructure roles.

## 🏢 Enterprise Features

- **Multi-Distribution Support**: RHEL UBI 9, Ubuntu 22.04 LTS, CentOS 7
- **Security Hardened**: Non-root users, minimal attack surface, secure networking
- **Production Ready**: Health checks, logging, monitoring, restart policies
- **Infrastructure as Code**: Reproducible deployments via Docker Compose
- **Container Orchestration**: Centralized management with Portainer
- **Network Isolation**: Custom bridge network with defined IP ranges
- **Persistent Storage**: Named volumes with proper labeling

## 🔧 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   Enterprise Network                        │
│                  (172.20.0.0/16)                          │
├─────────────────┬─────────────────┬─────────────────────────┤
│  RHEL UBI 9     │  Ubuntu 22.04   │  CentOS 7              │
│  (Production)   │  (Production)   │  (Legacy Support)      │
│  172.20.0.4     │  172.20.0.5     │  172.20.0.2            │
├─────────────────┼─────────────────┼─────────────────────────┤
│                 │  Portainer CE   │                        │
│                 │  (Management)   │                        │
│                 │  172.20.0.3     │                        │
│                 │  Port: 9000     │                        │
└─────────────────┴─────────────────┴─────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker Desktop installed and running
- macOS/Linux/Windows with Docker support
- 8GB+ RAM recommended

### Deployment
```bash
# Clone or download the project
git clone <repository-url>
cd enterprise-linux-docker

# Deploy the entire environment
docker-compose up -d

# Verify deployment
./scripts/monitor.sh

# Access container management
open http://localhost:9000
```

## 📋 Container Details

### RHEL UBI 9 Enterprise (`rhel-prod-server`)
- **Base Image**: `registry.access.redhat.com/ubi9/ubi:latest`
- **Security**: Non-root user (`appuser`)
- **Packages**: Essential tools (wget, vim, git, procps-ng, etc.)
- **Health Check**: Built-in monitoring
- **Use Case**: Production RHEL workloads

### Ubuntu LTS Enterprise (`ubuntu-prod-server`)
- **Base Image**: `ubuntu:22.04`
- **Security**: Non-root user (`appuser`)
- **Packages**: Development tools (curl, git, jq, htop, etc.)
- **Health Check**: Built-in monitoring
- **Use Case**: Development and CI/CD pipelines

### CentOS Legacy (`centos-legacy-server`)
- **Base Image**: `centos:7`
- **Purpose**: Legacy application support
- **Use Case**: Migration and compatibility testing

### Portainer Management (`portainer-management`)
- **Base Image**: `portainer/portainer-ce:latest`
- **Access**: http://localhost:9000
- **Purpose**: Container management and monitoring

## 🔒 Security Implementation

### Container Security
- ✅ Non-root user execution
- ✅ Minimal base images
- ✅ Limited sudo privileges
- ✅ Secure file permissions (750)
- ✅ Package updates and cleanup

### Network Security
- ✅ Custom bridge network isolation
- ✅ Defined IP subnet (172.20.0.0/16)
- ✅ No unnecessary port exposure
- ✅ Container-to-container communication

### Volume Security
- ✅ Named volumes with labels
- ✅ Proper ownership and permissions
- ✅ Separate volumes per service
- ✅ Shared data volume for inter-container communication

## 📊 Monitoring & Maintenance

### Health Checks
All containers include comprehensive health monitoring:
```bash
# Check overall status
docker ps

# Detailed health information
docker inspect <container-name> --format='{{.State.Health.Status}}'

# Run monitoring script
./scripts/monitor.sh
```

### Logging
Centralized logging configuration:
- JSON file driver
- 10MB max size per log file
- Maximum 3 log files per container
- Automatic log rotation

### Resource Monitoring
```bash
# Real-time resource usage
docker stats

# Container resource limits
docker inspect <container-name> --format='{{.HostConfig.Memory}}'
```

## 🛠️ Management Commands

### Container Operations
```bash
# Start environment
docker-compose up -d

# Stop environment
docker-compose down

# Restart specific service
docker-compose restart <service-name>

# View logs
docker-compose logs <service-name>

# Execute commands in container
docker exec -it <container-name> bash
```

### Maintenance Tasks
```bash
# Update images
docker-compose pull
docker-compose up -d

# Clean unused resources
docker system prune -f

# Backup volumes
docker run --rm -v <volume-name>:/backup alpine tar czf - /backup

# Monitor script with cron (optional)
# Add to crontab: */5 * * * * /path/to/monitor.sh >> /var/log/docker-monitor.log
```

## 📈 Enterprise Benefits

### Development Teams
- **Consistent Environments**: Identical setup across dev/staging/prod
- **Multi-OS Testing**: Test applications across different Linux distributions
- **Rapid Deployment**: Infrastructure as code for quick provisioning

### DevOps Teams
- **Monitoring Integration**: Built-in health checks and logging
- **Security Compliance**: Hardened containers following best practices
- **Scalability**: Easy to replicate and scale horizontally

### Operations Teams
- **Centralized Management**: Portainer for GUI-based container management
- **Automated Monitoring**: Custom scripts for environment health checks
- **Volume Management**: Persistent data with proper backup strategies

## 🔧 Customization

### Adding New Services
1. Create new Dockerfile in project root
2. Add service definition to `docker-compose.yml`
3. Include in monitoring script
4. Update documentation

### Environment Variables
Key environment variables for customization:
- `ENVIRONMENT`: production/staging/development
- `LOG_LEVEL`: info/debug/warn/error
- `SERVICE_NAME`: Custom service identification

### Network Configuration
To modify network settings, update `docker-compose.yml`:
```yaml
networks:
  enterprise-network:
    ipam:
      config:
        - subnet: 172.20.0.0/16  # Change subnet as needed
          gateway: 172.20.0.1
```

## 📚 Best Practices Implemented

### Docker Best Practices
- ✅ Multi-stage builds where applicable
- ✅ Minimal base images
- ✅ Non-root user execution
- ✅ Proper layer caching
- ✅ Health check implementation

### Enterprise Standards
- ✅ Consistent labeling strategy
- ✅ Environment variable management
- ✅ Logging standardization
- ✅ Security hardening
- ✅ Documentation completeness

### DevOps Practices
- ✅ Infrastructure as Code
- ✅ Container orchestration
- ✅ Monitoring and alerting
- ✅ Backup and recovery procedures
- ✅ Version control integration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the DevOps team
- Check the troubleshooting section

---

## 👨‍💻 About the Author

**Thinh Le** - Highly Certified IT Professional  
📧 [GitHub Profile](https://github.com/mamamia0729)

### 🏆 Certifications & Expertise
- ☁️ **Cloud**: AWS Cloud Practitioner, Azure Administrator (AZ-104)
- 🔒 **Security**: CompTIA Security+ 
- 🌐 **Networking**: Cisco CCNA, CompTIA Network+
- 💻 **Hardware/OS**: CompTIA A+
- 🐧 **Linux**: Multi-distribution administration (RHEL, Ubuntu, CentOS)
- 🐳 **Containerization**: Docker, Docker Compose, Enterprise Orchestration

### 💼 Professional Background
- **Current**: Desktop Support Specialist with enterprise infrastructure focus
- **Previous**: System Administrator, Network Administrator, Endpoint Management
- **Achievements**: Developed PowerShell solutions that freed 50+ TB across 1800+ machines
- **Goal**: Pursuing AWS Solutions Architect certification and advanced cloud roles

---

**Built with ❤️ for Enterprise Linux Environments**

*This setup demonstrates production-ready Docker practices suitable for enterprise environments, combining security, monitoring, and operational excellence.*
