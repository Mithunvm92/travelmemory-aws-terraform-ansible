
# TravelMemory AWS Deployment using Terraform and Ansible

## Project Overview

This project deploys the TravelMemory MERN application on AWS using:

- Terraform for AWS infrastructure provisioning
- Ansible for server configuration and application deployment
- React for the frontend
- Node.js/Express for the backend
- MongoDB for the database
- Nginx as the frontend web server and reverse proxy

The deployment uses separate public and private subnets.

---

## Architecture

```text
                         Internet
                            |
                            | HTTP :80
                            v
                  +--------------------+
                  |     Web EC2        |
                  |    Public Subnet   |
                  |                    |
                  | Nginx :80          |
                  |   |                |
                  |   +--> React       |
                  |   |                |
                  |   +--> /trip       |
                  |          |         |
                  |      Node.js :3001 |
                  +----------+---------+
                             |
                             | Private network
                             | TCP 27017
                             v
                  +--------------------+
                  |    Database EC2    |
                  |   Private Subnet   |
                  |                    |
                  | MongoDB :27017     |
                  | Authentication     |
                  +--------------------+

```text
/mnt/c/Users/mithu/travelmemory-aws-terraform-ansible
```

And your `find` command returned **no `.pem` or `.key` files**, so the private key is not in the project.

Your current files are exactly what we want:

```text
.gitignore
.terraform.lock.hcl
README.md
ansible/
repository-link.txt
screenshots/
terraform/
```

Let's finish quickly.

# Step 28 — Replace README with the final project README

From the project root:

```bash
cd /mnt/c/Users/mithu/travelmemory-aws-terraform-ansible
```

Run:

````bash
cat > README.md <<'EOF'
# TravelMemory AWS Deployment using Terraform and Ansible

## Project Overview

This project deploys the TravelMemory MERN application on AWS using:

- Terraform for AWS infrastructure provisioning
- Ansible for server configuration and application deployment
- React for the frontend
- Node.js/Express for the backend
- MongoDB for the database
- Nginx as the frontend web server and reverse proxy

The deployment uses separate public and private subnets.

---

## Architecture

```text
                         Internet
                            |
                            | HTTP :80
                            v
                  +--------------------+
                  |     Web EC2        |
                  |    Public Subnet   |
                  |                    |
                  | Nginx :80          |
                  |   |                |
                  |   +--> React       |
                  |   |                |
                  |   +--> /trip       |
                  |          |         |
                  |      Node.js :3001 |
                  +----------+---------+
                             |
                             | Private network
                             | TCP 27017
                             v
                  +--------------------+
                  |    Database EC2    |
                  |   Private Subnet   |
                  |                    |
                  | MongoDB :27017     |
                  | Authentication     |
                  +--------------------+
````

---

# AWS Infrastructure

Region:

```text
ap-south-1 (Mumbai)
```

Resources provisioned using Terraform include:

* VPC
* Public subnet
* Private subnet
* Internet Gateway
* NAT Gateway
* Public route table
* Private route table
* Web security group
* Database security group
* IAM roles and instance profiles
* Public Web EC2 instance
* Private Database EC2 instance

---

# Network Design

## Public Subnet

The Web EC2 instance is deployed in the public subnet.

It provides:

* Nginx
* React frontend
* Node.js backend

Internet access is provided through the Internet Gateway.

## Private Subnet

The MongoDB EC2 instance is deployed in the private subnet.

MongoDB is not directly exposed to the Internet.

The database security group allows MongoDB traffic only from the Web EC2 security group.

---

# Application Stack

## Frontend

* React
* React Router
* Axios
* Production build generated using `npm run build`

## Backend

* Node.js
* Express
* Mongoose
* Port `3001`

## Database

* MongoDB 8
* Authentication enabled
* Application database: `travelmemory`
* Application collection: `tripdetails`

## Web Server

* Nginx
* Port `80`
* Serves the React production build
* Reverse proxies `/trip` requests to Node.js

---

# Terraform Deployment

Navigate to:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Validate:

```bash
terraform validate
```

Review:

```bash
terraform plan
```

Apply:

```bash
terraform apply
```

View outputs:

```bash
terraform output
```

Important outputs include:

* Web instance ID
* Web private IP
* Web public IP
* Web public DNS
* Database instance ID
* Database private IP

---

# Ansible Configuration

Navigate to:

```bash
cd ansible
```

Ansible is configured using:

```text
ansible.cfg
inventory.ini
```

Because the project is located under `/mnt/c`, use:

```bash
ANSIBLE_CONFIG=$PWD/ansible.cfg
```

for Ansible commands.

Test connectivity:

```bash
ANSIBLE_CONFIG=$PWD/ansible.cfg ansible all -m ping
```

Expected:

```text
web-server       | SUCCESS
database-server  | SUCCESS
```

---

# Web Server Deployment

The web server playbook installs:

* Required system packages
* Node.js
* npm
* TravelMemory application

Playbook:

```text
ansible/web-server.yml
```

The application is deployed under:

```text
/opt/TravelMemory
```

---

# MongoDB Deployment

MongoDB is configured using:

```text
ansible/mongodb-server.yml
```

MongoDB runs on the private database EC2 instance.

Authentication is enabled.

The application uses a dedicated MongoDB user with `readWrite` access to the `travelmemory` database.

Credentials are stored outside Git-tracked files.

---

# Backend Service

The Node.js backend runs as a systemd service:

```text
travelmemory-backend.service
```

Service configuration:

```text
ansible/backend-service.yml
```

The service:

* Runs as the `ubuntu` user
* Uses the backend `.env`
* Starts automatically after reboot
* Restarts automatically if the process fails

Verify:

```bash
systemctl status travelmemory-backend
```

Backend test:

```bash
curl http://127.0.0.1:3001/hello
```

Expected:

```text
Hello World!
```

---

# Nginx Configuration

Nginx configuration:

```text
ansible/nginx-travelmemory.conf
```

Nginx:

* Serves the React production build
* Listens on port 80
* Proxies `/trip` requests to Node.js on port 3001

Validate:

```bash
nginx -t
```

Verify:

```bash
systemctl status nginx
```

---

# Application Verification

The deployed application is accessible through the Web EC2 public IP.

Example:

```text
http://<WEB_PUBLIC_IP>
```

The following functionality was tested:

1. React frontend loads successfully.
2. Nginx serves the frontend.
3. Nginx proxies `/hello` to Node.js.
4. `/trip` API returns MongoDB records.
5. Add Experience creates a database record.
6. MongoDB persistence was verified directly on the private database server.
7. The record was subsequently removed after testing.

---

# Security

Security controls implemented include:

* MongoDB deployed in a private subnet
* MongoDB authentication enabled
* Dedicated application database user
* Database access restricted to the Web security group
* SSH restricted to the configured administrator source IP
* Node.js port 3001 is not required to be publicly accessible
* Nginx exposes HTTP port 80
* Private SSH key excluded using `.gitignore`
* Environment files excluded from Git
* Terraform state files excluded from Git

---

# Important Security Note

Never commit:

```text
*.pem
*.key
*.env
*.tfstate
*.tfvars
```

The MongoDB credentials used during deployment must not be stored in the Git repository.

For production deployments, Ansible Vault or AWS Secrets Manager should be used for application credentials.

---

# Project Structure

```text
travelmemory-aws-terraform-ansible/
|
+-- terraform/
|   +-- provider.tf
|   +-- variables.tf
|   +-- vpc.tf
|   +-- subnet.tf
|   +-- route_tables.tf
|   +-- nat.tf
|   +-- security_groups.tf
|   +-- iam.tf
|   +-- ec2.tf
|   +-- outputs.tf
|
+-- ansible/
|   +-- ansible.cfg
|   +-- inventory.ini
|   +-- web-server.yml
|   +-- mongodb-server.yml
|   +-- backend-service.yml
|   +-- nginx-travelmemory.conf
|
+-- screenshots/
|
+-- .gitignore
+-- .terraform.lock.hcl
+-- README.md
```

---

# Validation Evidence

Important deployment evidence includes:

* Terraform infrastructure provisioning
* Terraform validation
* Ansible connectivity
* MongoDB installation and authentication
* Backend MongoDB connectivity
* Node.js backend service
* React production build
* Nginx configuration
* Public HTTP access
* Nginx reverse proxy
* TravelMemory API
* React frontend
* Application database write
* MongoDB persistence verification

Screenshots are stored under:

```text
screenshots/
```

---

# Final Result

The TravelMemory MERN application was successfully deployed on AWS using Infrastructure as Code and configuration management.

The final application flow is:

```text
Browser
   |
   v
Nginx
   |
   +---- React Frontend
   |
   +---- /trip
          |
          v
       Node.js
          |
          v
       MongoDB
          |
          v
   Private Database EC2
```

---

# Technologies Used

| Technology      | Purpose                        |
| --------------- | ------------------------------ |
| AWS EC2         | Compute                        |
| AWS VPC         | Network isolation              |
| AWS NAT Gateway | Private subnet outbound access |
| AWS IAM         | Instance permissions           |
| Terraform       | Infrastructure as Code         |
| Ansible         | Configuration management       |
| Ubuntu          | Operating system               |
| Nginx           | Web server / reverse proxy     |
| Node.js         | Backend runtime                |
| Express         | Backend framework              |
| React           | Frontend                       |
| MongoDB         | Database                       |
| Mongoose        | MongoDB integration            |
| Git             | Version control                |

EOF

````

---

# Step 29 — Final Git safety check

Run:

```bash
git status --short
````

Then:

```bash
git ls-files | grep -E '(\.pem$|\.key$|\.env$|\.tfstate$)'
```

The second command should produce **no output**.

Also:

```bash
find . -type f \( -name "*.pem" -o -name "*.key" \)
```

should produce no output.

---

# Step 30 — Stage the project

If the secret checks are clean:

```bash
git add .gitignore README.md terraform ansible screenshots .terraform.lock.hcl repository-link.txt
```

Then:

```bash
git status --short
```

You should see your assignment files staged.

📸 **SCREENSHOT NEEDED**

Save:

```text
142-final-git-staged.png
```

---

# Step 31 — Commit

```bash
git commit -m "Deploy TravelMemory on AWS with Terraform and Ansible"
```

Then:

```bash
git status
```

Expected:

```text
nothing to commit, working tree clean
```

📸 **SCREENSHOT NEEDED**

Save:

```text
143-git-commit-clean.png
```

---

## One thing before pushing

**Do not push yet.**

Your project is now ready for GitHub, but we need to check the existing `repository-link.txt` and determine whether you already have a GitHub repository URL configured.

Run:

```bash
cat repository-link.txt
```

and:

```bash
git remote -v
```

Send me those two outputs. Then I'll give you the **final 2–3 commands to push the assignment to GitHub**.
