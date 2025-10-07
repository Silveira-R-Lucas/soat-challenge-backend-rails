# SOAT - Aplicação Backend em Ruby on Rails (backend-rails)

Este repositório contém o código-fonte da aplicação monolítica de backend para o sistema de autoatendimento da lanchonete, desenvolvida em Ruby on Rails.

---

### Função no Projeto

Esta é a camada de aplicação. Sua responsabilidade é conter toda a lógica de negócio, APIs para os clientes e painéis administrativos. Além do código, este repositório também é responsável por "empacotar" a si mesmo em uma imagem Docker pronta para ser executada em qualquer ambiente.

### Artefatos Gerados

* **Imagem Docker:** O principal artefato gerado por este repositório é uma imagem Docker, que é enviada para o Amazon ECR. A imagem é versionada com a tag `latest` e também com o hash do commit do Git para rastreabilidade.

### Pré-requisitos

1.  **Ambiente de Desenvolvimento Local:**
    * Ruby (versão definida em `.ruby-version`)
    * Bundler
    * Docker e Docker Compose
2.  **GitHub Secrets:** Para o pipeline de CI/CD funcionar, as seguintes secrets são necessárias:
    * `AWS_ACCESS_KEY_ID`
    * `AWS_SECRET_ACCESS_KEY`
    * `AWS_ACCOUNT_ID`: O ID da conta AWS, para construir a URL do ECR.
    * `RAILS_MASTER_KEY`: Para os testes automatizados que precisam decriptar as credenciais.
3.  **ECR Repository:** O pipeline espera que o repositório ECR (`soat-challenge/rails-app`) já exista na AWS (ele é criado pelo projeto `infra-k8s`).

### Como Utilizar

#### Desenvolvimento Local

1.  Clone o repositório.
2.  Instale as dependências com `bundle install`.
3.  Configure seu arquivo `.env` para as variáveis de ambiente locais (banco de dados, etc.).
4.  Use o Docker Compose para subir o ambiente localmente: `docker-compose up`.

#### Fluxo de CI/CD

O pipeline `rails-ci-cd.yml` automatiza todo o processo de integração e entrega contínua.

1.  **Pull Request:** Ao abrir um PR, o job `test-and-lint` é acionado para rodar RuboCop, Brakeman e os testes RSpec, garantindo a qualidade e segurança do código.
2.  **Merge na `main`:** Após a aprovação e o merge, o job `build-and-deploy-to-ecr` é executado, seguindo estes passos:
    a.  Faz login no Amazon ECR.
    b.  Executa `docker build` usando o `Dockerfile` para criar a imagem da aplicação.
    c.  Envia (`push`) a nova imagem para o ECR.

Uma vez que a nova imagem está no ECR, o deploy final é feito acionando o pipeline do repositório `soat-challenge-infra-k8s`.
