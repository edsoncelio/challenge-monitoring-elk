# Recursos criados pelo Packer

## Estrutura do diretório
```
.
├── README.md
├── ec2-logstash.pkr.hcl
├── playbook
│   ├── files
│   │   ├── 01-beats-input.conf
│   │   ├── 30-elasticsearch-output.conf
│   │   ├── 30-elasticsearch-output.conf.j2
│   │   └── filebeat.yml
│   ├── main.yml
│   └── requirements.yml
└── variables.pkr.hcl
```

Esse projeto usa o Packer e Ansible para provisionar e criar uma AMI na aws, seguindo o seguinte fluxo:
1. Usando as variáveis criadas em `variables.pkr.hcl` configura uma AMI;
2. Usando o *provisioner* `shell-local`instala os requisitos usados pelo Ansible;
3. Usando o *provisioner* `ansible` com o playbook `playbook/main.yml` provisiona os seguintes recursos:
    * instala e configura o docker
    * instala e configura o logstash (e dependências)
    * instala e configura o filebeat ( e dependências)
    * copia os templates do logstash e do filebeat
    * inicia um contâiner com uma aplicação de teste (nginxdemos/hello)

