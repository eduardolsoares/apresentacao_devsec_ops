# Implementando DevSecOps com Terraform

Para a apresentaçao, utilizamos o [Localstack](https://www.localstack.cloud/) para imitar o comportamento da AWS, facilitando os testes.

#### Deploy com Terraform

```bash
git clone REPONAME
cd REPONAME
cd terraform/main
terraform init
terraform plan
terraform apply
```

### Conferindo vulnerabilidades com tfsec

```bash

#Instalar o tfsec em https://github.com/aquasecurity/tfsec
# rodando o tfsec no repositorio:
cd terraform-101/terraform/main
tfsec

### Configuraçoes terraform

https://www.youtube.com/watch?v=0nU9yvqg2Rw
