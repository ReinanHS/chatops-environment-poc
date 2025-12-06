<div align="center">

 # ChatOps Environment POC
 
</div>

Os arquivos neste repositório constituem o esqueleto (modelo) para iniciar experimentos para a criação de um ambiente de ChatOps, aproveitando os provedores do GCP e Helm.

## Requisitos

Antes de começar, certifique-se de que você tenha os seguintes requisitos instalados:

- Terraform
- Google Cloud SDK
- Helm  

## Etapas

Aqui estão as principais etapas para iniciar e realizar experimentos com as configurações no GCP usando Terraform e Helm:

### Passo 1: Iniciar a autenticação no GCP

Use o seguinte comando para iniciar a autenticação no GCP:

```shell
gcloud auth login
gcloud auth application-default login
```

### Etapa 2: Código no Terraform

O código Terraform usado nesta demonstração está organizado em vários arquivos para seguir as melhores práticas:

- `providers.tf`: Este arquivo contém detalhes sobre os módulos do provedor HashiCorp Terraform que usaremos. Você pode personalizar os provedores necessários aqui.
- `versions.tf`: Este arquivo controla as versões específicas do Terraform e de outros módulos que estamos utilizando.
- `variables.tf`: Aqui, estão definidas as variáveis necessárias para configurar e personalizar o ambiente de infraestrutura.
- `modules.tf`: Aqui, estão definidas as variáveis necessárias para configurar e personalizar o ambiente de infraestrutura.

### Etapa 3: Configurar o Terraform 

Crie um arquivo terraform.tfvars para definir o project_id:

```shell
project_id = "your-project-id"
```

### Etapa 4: Executar o código do Terraform para criar recursos

Nesta etapa, estaremos executando os seguintes comandos Terraform para criar os recursos no GCP:

```shell
terraform init
terraform validate
terraform plan
terraform apply
```

> Atenção: lembre-se de definir a variável `manifest_run` na primeira execução com o valor de `false`. Após a segunda execução você deve definir o valor dessa variável para `true`.

### Etapa 5: Verificar os recursos no GCP

Após a execução bem-sucedida do código Terraform, você pode verificar os recursos criados no GCP.

Para obter o token do Headlamp, execute o seguinte comando:

```shell
kubectl get secret headlamp-admin-token -n default -o go-template='{{.data.token | base64decode}}'
```

Para obter a senha do usuário root do GitLab, execute o seguinte comando:

```shell
kubectl get secret gitlab-gitlab-initial-root-password -o go-template='{{.data.password | base64decode}}'
```

### Etapa 6: Limpar recursos de demonstração

Quando você terminar seus experimentos e quiser limpar os recursos implantados, você pode executar o seguinte comando Terraform:

```shell
terraform destroy
```

Isso removerá todos os recursos criados na etapa 3. Lembre-se de personalizar e adaptar os arquivos Terraform de acordo com seus requisitos específicos antes de executar as etapas acima.

## Changelog

Por favor, veja [CHANGELOG](CHANGELOG.md) para obter mais informações sobre o que mudou recentemente.

## Seja um dos contribuidores

Sinta-se à vontade para contribuir com melhorias, correções de bugs ou adicionar recursos a este repositório. Basta criar um fork do projeto, fazer as alterações e enviar um pull request. Suas contribuições serão bem-vindas!

Quer fazer parte desse projeto? leia [como contribuir](CONTRIBUTING.md).

## Licença

Este projeto é licenciado sob a Licença MIT. Veja o arquivo [LICENÇA](LICENSE) para mais detalhes.