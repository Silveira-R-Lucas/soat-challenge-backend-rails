# 🍔 Sistema de autoatendimento de fast food

> **SOAT Tech Challenge - Fase 02 | Grupo 163**

---

## 📋 Sumário

- [Objetivo](#-objetivo)
- [Funcionalidades](#-funcionalidades)
- [Documentação](#-documentação)
- [Tecnologias](#-tecnologias)
- [Arquitetura](#-arquitetura)
- [Linguagem Ubíqua](#-linguagem-ubíqua)
- [Configuração](#-configuração)
- [Equipe](#-equipe---grupo-163)

---

## 🎯 Objetivo

Desenvolver um monolito backend para gerenciamento de pedidos de uma lanchonete, implementando as melhores práticas de desenvolvimento de software com arquitetura limpa e práticas de Domain Driven Design (DDD).

---

## 🚀 Funcionalidades

### Identificação de Clientes
- ✅ Cadastro do Cliente
- ✅ Identificação do Cliente via CPF

### Gestão de Produtos
- ✅ CRUD completo de produtos
- ✅ Busca por categoria ( Bebidas, Lanches, Acompanhamentos e Sobremesa )

### Gestão de Pedidos
- ✅ CRUD completo de pedidos
- ✅ Pedidos salvos em cachê para que as informações de um carrinho de uma sessão não se percam
- ✅ Checkout de pedidos
- ✅ Listagem de pedidos em produção
- ✅ Listagem de pedidos finalizados e em produção
- ✅ Atualização de status de pedido em andamento

### Sistema de Pagamento
- ✅ Integração com API de pagamento via QrCode com PIX do Mercado Pago
- ✅ Webhook para recebimento de notificação de pagamento e atualização do pedido

---

## 📚 Documentação

| Recurso | Link |
|---------|------|
| **Swagger** | [ Swagger UI ](https://419997780cbd.ngrok-free.app/api-docs/index.html) |
| **Collection da api - Postman** | [ Payloads e Curl ](https://www.postman.com/spacecraft-engineer-11432051/teste-para-api-soat-challenge/overview) |
| **Desenho de arquitetura - Os requisitos do negócio (Aqui demonstramos o quê e para quem é destinado o projeto)** | [ Excalidraw ](https://excalidraw.com/#json=vOsZffTagoyRcKH8EYHVv,o4F3IzLk1r7_5IKyKJOy5g) |
| **Desenho de arquitetura - Os requisitos da infraestrutura(Aqui demonstramos a arquitetura desenhada para execução do projeto)** | [ Excalidraw ](https://excalidraw.com/#json=rJL77TFibyLWrqWuSkZSs,6HxeG0YGqEvn-A7UkdRVfQ) |
| **Vídeo de demonstração do Projeto** |  [ Youtube ](https://www.youtube.com/watch?v=XebfFrjbd4U) |
---

## 🛠️ Tecnologias

| Categoria | Tecnologia | Versão |
|-----------|------------|--------|
| **Linguagem** | Ruby | 3.2.2 |
| **Framework Web / UI** | Rails | 7.2.2 |
| **ORM** | Active Record | 7.2.2 |
| **Banco de Dados** | PostgreSQL | 17.5  |
| **Containerização** | Docker & Docker Compose | 28.3.2 |
| **Conteiner Registry** | Magalucloud |  |
| **Kubernets** | Magalucloud | 1.30.11 |
---

## 🏗️ Arquitetura do Projeto Rails

A arquitetura limpa deste projeto Rails é organizada em camadas concêntricas garantindo que a lógica de negócio principal em (app/domain/) seja o seu "coração" isolado, sem depender dos detalhes de como ele interage com o mundo. Essa camada central define portas (ports), que são interfaces abstratas para as operações que o negócio precisa (como salvar um cliente ou processar um pagamento), a camada de Use Cases(app/domain/use_cases) orquestra as operações do negócio, interagindo com o domínio e com interfaces (Ports). As camadas externas de infraestrutura (app/infrastructure/) e controladores (app/controllers/) atuam como adaptadores, implementando essas portas para conectar o domínio puro a tecnologias específicas, como o banco de dados (via Active Record) ou APIs externas (Mercado Pago), e também para traduzir interações do usuário (requisições HTTP), mantendo o código modular, testável e flexível a futuras mudanças tecnológicas.

-----

## Estrutura de Pastas

```
app/
├── controllers/                  # Adaptadores Primários (Interfaces de Usuário/APIs)
│   ├── carts_controller.rb
│   ├── clients_controller.rb
│   ├── mp_webhooks_controller.rb
│   └── products_controller.rb
│
├── domain/                       # Camada de Aplicação / Domínio 
│   ├── cart/                     
│   │   ├── cart.rb               # Objeto de Domínio Puro: Um Carrinho
│   │   └── cart_item.rb          # Objeto de Domínio Puro: Um Item do Carrinho
│   │
│   ├── client/                   
│   │   └── client.rb             # Objeto de Domínio Puro: Um Cliente
│   │
│   ├── payment/                  
│   │   └── payment_notification.rb # Objeto de Domínio Puro: Notificação de Pagamento
│   │
│   ├── product/                  
│   │   └── product.rb            # Objeto de Domínio Puro: Um Produto
│   │
│   ├── ports/                    # Ports (Interfaces)
│   │   ├── cart_repository.rb    # Port: Interface para Persistência de Carrinho
│   │   ├── client_repository.rb  # Port: Interface para Persistência de Cliente
│   │   └── product_repository.rb # Port: Interface para Persistência de Produto
│   │
│   └── use_cases/                # Use Cases / Service Objects (Operações de Negócio)
│       ├── add_product_to_cart.rb
│       ├── checkout_cart.rb
│       ├── create_client.rb
│       ├── create_product.rb
│       ├── delete_product.rb
│       ├── find_products_by_category.rb
│       ├── find_product_by_id.rb
│       ├── generate_cart_payment.rb
│       ├── get_or_create_client_cart.rb
│       ├── identify_client_session.rb
│       ├── list_checked_out_carts.rb
│       ├── list_in_progress_carts.rb
│       ├── process_mercadopago_notification.rb
│       ├── remove_product_from_cart.rb
│       ├── update_cart_status.rb
│       └── update_product_quantity_in_cart.rb
│
├── infrastructure/               # Camada de Infraestrutura/Adaptadore
│   ├── external_apis/            # Adaptadores para APIs Externas
│   │   └── mercadopago/          # Adaptadores Específicos do Mercado Pago
│   │       ├── mercadopago_payment_gateway_adapter.rb # Adaptador: Interage com a API de Pagamento do MP
│   │       └── mercadopago_webhook_adapter.rb         # Adaptador: Lida com Webhook do MP
│   │
│   └── persistence/              # Adaptadores de Persistência (Bancos de Dados, ORMs)
│       └── active_record/        # Adaptadores para Active Record (ORM Específico)
│           ├── cart/             # Modelos Active Record e Repositórios para Carrinho
│           │   ├── active_record_cart_repository.rb # Adaptador: Implementa CartRepository usando AR
│           │   ├── cart_item_model.rb               # Modelo Active Record: Mapeia para a tabela cart_item_models
│           │   └── cart_model.rb                    # Modelo Active Record: Mapeia para a tabela cart_models
│           │
│           ├── client/           # Modelos Active Record e Repositórios para Cliente
│           │   ├── active_record_client_repository.rb # Adaptador: Implementa ClientRepository usando AR
│           │   └── client_model.rb                    # Modelo Active Record: Mapeia para a tabela client_models
│           │
│           └── product/          # Modelos Active Record e Repositórios para Produto
│               ├── active_record_product_repository.rb # Adaptador: Implementa ProductRepository usando AR
│               └── product_model.rb                    # Modelo Active Record: Mapeia para a tabela product_models
│
└── # ... outras pastas padrão do Rails (assets, channels, jobs, mailers, etc.)
```

### Princípios Arquiteturais
- **Arquitetura Limpa** (Ports & Adapters)
- **Domain Driven Design** (DDD)
- **Princípios de Escalabilidade e Resiliência** (Cloud-Native)

---

### 📖 Linguagem Ubíqua
### Entidades Principais
| Termo | Definição |
|-------|-----------|
| **Cart** | Conjunto de itens escolhidos pelo cliente unificado em um pedido, com status rastreável |
| **CartItem** | itens escolhidos pelo cliente |
| **Client** | Cliente que realiza pedidos (identificação opcional) |
| **Product** |  Produto individual disponível no cardápio |

### Status e Categorias

#### Status do pedido
- `novo` - Pedido que ainda não realizou checkout (pedido não pago e não enviado para a cozinha)
- `recebido` - Pedido pago e recebido pela cozinha
- `em_preparação` - Cozinha preparando o pedido
- `pronto` - Pedido pronto para retirada do cliente
- `finalizado` - Pedido entregue ao cliente

#### Categorias
- `Lanches` - Sanduíches, hamburgueres etc...
- `Bebidas` - Bebidas, refrigerantes, sucos etc..
- `Acompanhamentos` - Acompanhamentos como batata frita, nuggets e afins
- `Sobremesas` - Sobremesas

#### Status do pagamento
- `aprovado` - Pagamento aprovado
- `pendente` - pedido em aguardo, pagamento ainda não iniciado
- `aguardando pagamento` - Aguardando processamento / pagamento
- `recusado` - Pagamento recusado

---

## Pré-requisitos

- **Docker** e **Docker Compose** instalados ([Guia de instalação](https://docs.docker.com/get-started/get-docker/))
- **Git** para clonar o repositório
- **Minkube para rodar localmente ou Conta em alguma cloud provider**
- **Kubectl** para gerenciamento do cluster
  
## ⚙️ Configuração
| Método | Tutorial |
|---------|------|
| **MINIKUBE - Executando o projeto localmente** | [Doc](https://github.com/Silveira-R-Lucas/soat-challenge-fase-02/blob/main/Subindo%20sua%20aplica%C3%A7%C3%A3o%20rails%20no%20kubernets%20localmente%20com%20minikube.md) |
| **MGC - Executando o projeto na magalucloud** | [Doc](https://github.com/Silveira-R-Lucas/soat-challenge-fase-02/blob/main/Salvando%20cr%20na%20mgc%20e%20subindo%20aplica%C3%A7%C3%A3o%20rails%20na%20nuvem.md) |
---

## Acesso à Aplicação
Fica disponível a url da aplicação para demonstração do projeto
- **URL:** https://da5957917817.ngrok-free.app/

---

## 👥 Equipe - Grupo 163

| Nome | RM |
|------|-----|
| **Lucas Rodrigues Silveira** | rm361245 |

---

## 📝 Licença

Este projeto foi desenvolvido como parte do desafio técnico do curso de pós graduação em arquitetura de software da FIAP.

---

<div align="center">
  <strong>🍔 Desenvolvido com dedicação pelo Grupo 163 🍔 </strong>
</div>
