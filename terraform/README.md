# Recursos criados pelo Terraform

## Estrutura do diretório

```
.
├── README.md
├── main.tf
├── outputs.tf
├── terraform.tfvars
├── variables.tf
└── versions.tf
```

Esse projeto provisiona um AWS ES e uma instância EC2, seguindo o seguinte fluxo:   
1. Cria o recurso ES 
2. Ao final da criação do ES, é usado um provisioner local para executar as seguintes tarefas:
    * adição do *endpoint* do elasticsearch no arquivo de configuração do logstash
    * chamada a execução do packer para construir uma AMI 
3. Criação de uma EC2 usando a versão mais recente da AMI criada pelo usuário atual

## Entradas
As variáveis de entradas são carregadas a partir do arquivo `terraform.tfvars`

## Saídas
O *output* gerado pelo Terraform expõe as seguintes variáveis:   
* `kibana_endpoint`: URL para acessar o kibana (informações mais abaixo sobre como acessar)
* `public_ip`: endereço IP público da instância EC2 (vai ter uma aplicação executando na porta 80)
