# 🏥 Secure DevOps (DevSecOps) Implementation in a Healthcare System

A comprehensive DevSecOps implementation for a HIPAA-compliant Healthcare Patient Management System, demonstrating security-first practices throughout the entire software development lifecycle.

## 📋 Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    DevSecOps Pipeline                         │
├──────────┬──────────┬──────────┬──────────┬─────────────────┤
│  CODE    │  BUILD   │  TEST    │  DEPLOY  │  MONITOR        │
│          │          │          │          │                  │
│ ESLint   │ Docker   │ Unit     │ Blue-    │ Health Checks   │
│ Security │ Multi-   │ Tests    │ Green    │ Audit Logs      │
│ Plugin   │ Stage    │ SAST     │ K8s      │ Prometheus      │
│ Input    │ Hadolint │ Trivy    │ Network  │ Grafana         │
│ Valid.   │ npm audit│ CodeQL   │ Policy   │                 │
└──────────┴──────────┴──────────┴──────────┴─────────────────┘
```

## 🔐 Security Features (DevSecOps)

### Application Security
- **JWT Authentication** with role-based access control (RBAC)
- **Input Validation** & sanitization (express-validator)
- **Rate Limiting** to prevent brute-force attacks
- **Security Headers** via Helmet.js (HSTS, CSP, X-Frame-Options, etc.)
- **Password Policy** enforcement (complexity requirements)
- **PHI Encryption** at rest using AES-256-CBC
- **SSN Masking** in API responses

### Container Security
- **Multi-stage Docker builds** (minimal attack surface)
- **Non-root user** execution (UID 1001)
- **Read-only filesystem** with tmpfs for writable paths
- **No new privileges** security option
- **Resource limits** (CPU/Memory)
- **Health checks** for liveness and readiness
- **Signal handling** with dumb-init

### CI/CD Pipeline Security
- **SAST** - Static Application Security Testing (CodeQL)
- **Dependency Scanning** - npm audit
- **Container Scanning** - Trivy vulnerability scanner
- **Dockerfile Linting** - Hadolint
- **Blue-Green Deployment** - Zero-downtime releases
- **Automated Rollback** on failure

### Network Security
- **Kubernetes Network Policies** - Pod-level traffic control
- **CORS** restriction
- **Inter-container communication** disabled
- **TLS enforcement** via ingress

### HIPAA Compliance
- **Audit Logging** - All PHI access logged
- **Data Encryption** - At rest and in transit
- **Access Controls** - Role-based (Admin, Doctor, Nurse, Viewer)
- **Data Minimization** - Only necessary data exposed
- **Incident Response** - Automated health monitoring

## 🚀 Quick Start

### Prerequisites
- Docker Desktop (with Kubernetes enabled)
- Node.js 20+ (for local development)

### Option 1: Docker Compose (Recommended)
```bash
# Build and run
docker-compose up --build -d

# Check health
curl http://localhost:3000/api/health

# View logs
docker-compose logs -f healthcare-api
```

### Option 2: Kubernetes (Blue-Green Deployment)
```powershell
# Run the deployment script
.\scripts\deploy.ps1
```

### Option 3: Local Development
```bash
# Install dependencies
npm install

# Run with hot-reload
npm run dev

# Run tests
npm test
```

## 📁 Project Structure

```
healthcare-devsecops/
├── src/
│   ├── server.js              # Entry point with graceful shutdown
│   ├── app.js                 # Express app with security middleware
│   ├── routes/
│   │   ├── auth.js            # Authentication (register/login)
│   │   ├── patients.js        # Patient CRUD (PHI protected)
│   │   └── health.js          # Health check endpoints
│   ├── middleware/
│   │   ├── auth.js            # JWT authentication & RBAC
│   │   ├── audit.js           # HIPAA audit logging
│   │   └── errorHandler.js    # Secure error handling
│   ├── models/
│   │   ├── Patient.js         # Patient model with PHI encryption
│   │   └── User.js            # User model with bcrypt hashing
│   └── utils/
│       └── logger.js          # Winston structured logging
├── tests/
│   └── health.test.js         # Security & API tests
├── security/
│   ├── security-policy.yaml   # HIPAA security policy
│   └── container-security-checklist.md
├── k8s/
│   ├── base/                  # Base Kubernetes manifests
│   │   ├── namespace.yaml
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── secrets.yaml
│   │   └── network-policy.yaml
│   └── blue-green/            # Blue-Green deployment
│       ├── blue-deployment.yaml
│       ├── green-deployment.yaml
│       └── service.yaml
├── monitoring/                # Prometheus + Grafana
├── scripts/                   # Deployment scripts
├── .github/workflows/         # CI/CD pipeline
├── Dockerfile                 # Multi-stage secure build
├── docker-compose.yml         # Production stack
├── docker-compose.security-scan.yml  # Security scanning
└── .dockerignore
```

## 🔄 Blue-Green Deployment Flow

```
1. Build new image (v2)
2. Deploy Green (v2) alongside Blue (v1)
3. Run health checks on Green
4. Switch Service selector: blue → green
5. Verify traffic on Green
6. Scale down Blue (keep for rollback)
```

## 🧪 API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | /api/health | No | Health check |
| GET | /api/health/ready | No | Readiness probe |
| POST | /api/auth/register | No | Register user |
| POST | /api/auth/login | No | Login (get JWT) |
| GET | /api/patients | JWT (Admin/Doctor) | List patients |
| GET | /api/patients/:id | JWT (Admin/Doctor/Nurse) | Get patient |
| POST | /api/patients | JWT (Admin/Doctor) | Create patient |
| PUT | /api/patients/:id | JWT (Admin/Doctor) | Update patient |
| DELETE | /api/patients/:id | JWT (Admin) | Delete patient |

## 📊 Security Scanning Commands

```bash
# Trivy - Container vulnerability scan
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image healthcare-devsecops:latest

# Hadolint - Dockerfile linting
docker run --rm -i hadolint/hadolint < Dockerfile

# npm audit - Dependency vulnerabilities
npm audit --audit-level=high
```

## 👥 Team
- **DevSecOps Engineer** - Security pipeline & container hardening
- Built with ❤️ for Healthcare Security
