# 1. Clonar o repositório
````bash
git clone https://github.com/Silveira-R-Lucas/soat-challenge-fase-02.git
cd soat-challenge-fase-02
````
# 2. Criar imagem a partir do projeto
````bash
docker build -t soat_tech_challenge:1.2.0 .
````

# 3. Alterar os arquivos de deployment referenciando a imagem gerada 
````yaml
spec:
      containers:
        - name: rails
          # --- Atualize a tag da imagem aqui ---
          image: soat_tech_challenge:1.0.1
          # ------------------------------------
          ports:
````        
          
# 4. Criar um cluster localmente
````bash
minikube start # Isso geralmente configura o contexto 'minikube' automaticamente
````
          
# 5. Carregue a imagem no cluster Minikube:
````bash
minikube image load silveira.codes/soat_tech_challenge:1.2.0
````

# 6. Gerar as secrets para o projeto
````bash
kubectl create secret generic db-credentials \
  --from-literal=database_name=soat_challenge_fase_01_development \
  --from-literal=username='<user>' \
  --from-literal=password=s'<password>' \
  --from-literal=database_url=postgresql://<user>:<password>@db:5432/soat_challenge_fase_01_development

cat config/master.key  # Buscar o valor da master.key rails do projeto
kubectl create secret generic rails-secrets   --from-literal=master_key='<resultado_do_comando_anterior>'

#pegar credenciais ngrok em https://dashboard.ngrok.com/get-started/your-authtoken
kubectl create secret generic ngrok-authtoken-secret --from-literal=authtoken='<ngrok_token>'

kubectl create secret mp-secret --from-literal=secret='<secret_webhook_mp>'\
  --from-literal=token='<token_de_produção_da _sua integração_MP> '
````

# 7. Realizar o deploy do banco de dados
````bash
kubectl apply -f db-deployment.yaml
kubectl apply -f db-pvc.yaml
kubectl apply -f db-service.yaml
````

# 8. Realizar o deploy do ngrok(conteiner com aplicação que gera certificados https para comunicação do webhook do Mercado pago)
````bash
kubectl apply -f ngrok-deployment.yaml
kubectl apply -f ngrok-service.yaml
````

# 9. Gerar os configmaps para o projeto
````bash
# verificar url gerada pelo ngrok em https://dashboard.ngrok.com/agents
kubectl create configmap mp-rails-config --from-literal=mercadopago_notification_url='<url_da_aplicação>'\
  --from-literal=user_id='<user_id_integração_mp>' \
  --from-literal=external_pos_id='<id_do_caixa_de_integração_MP>'
````

# 8. Realizar o deploy da aplicação
````bash
kubectl apply -f rails-deployment.yaml
kubectl apply -f rails-service.yaml
kubectl apply -f rails-hpa.yaml
````
