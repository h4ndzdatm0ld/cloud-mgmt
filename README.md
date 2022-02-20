# Personal Project: `Cloud Mgmt`

AWS & Digital Ocean Management via Terraform & Ansible

## Requirements

- Docker
- Docker-Compose

# Terraform & Ansible in Docker

Terraform & Ansible are using a volume mount and are executed all inside of a docker container.

---
# Env Variables

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=
REMOTE_USER=
DO_TOKEN=
TF_DO_TOKEN=
TF_VAR_AWS_ACCESS_KEY_ID=
TF_VAR_AWS_SECRET_ACCESS_KEY=
NTC_USER_PASSWORD=

## Examples

### Running Terraform

Initialize

```bash
docker-compose run terraform -chdir=terraform-plans/do-droplet/ init
```

Plan

```bash
docker-compose run terraform -chdir=terraform-plans/do-droplet/ validate
```
