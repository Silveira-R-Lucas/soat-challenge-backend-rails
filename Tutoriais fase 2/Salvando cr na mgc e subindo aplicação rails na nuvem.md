# 1. Clonar o repositório
````bash
git clone https://github.com/Silveira-R-Lucas/soat-challenge-fase-02.git
cd soat-challenge-fase-02
````

# 2. Criar imagem a partir do projeto
````bash
docker build -t soat_tech_challenge:1.2.0 .
````

# 3. Fazer download da CLI da mgc
https://docs.magalu.cloud/docs/devops-tools/cli-mgc/how-to/download-and-install

# 4. Autenticar com sua conta
````bash
mgc auth login
````

# 5. Criar um novo registro
````bash
mgc container-registry registries create --name=soat-challenge-2 --region="<região_desejada>"
````

# 6. Faça login no Docker para o registry na região desejada, ex:
````bash
docker login https://container-registry.br-se1.magalu.cloud
````

# 7. Marque a imagem local do projeto para o registry:
````bash
docker tag soat_tech_challenge:1.2.0 container-registry.br-se1.magalu.cloud/soat-challenge-2/soat_tech_challenge:1.2.0
````

# 8. Envie (push) a imagem para o registry:
````bash
docker push container-registry.br-se1.magalu.cloud/soat-challenge-2/soat_tech_challenge:1.2.0

# Você pode validar o envio da imagem com:
mgc cr registries list --region="br-se1"
mgc cr repositories list --registry-id='<resultado_campo_id_comando_anterior>' --region="<região_desejada>"
mgc cr images get --registry-id='<resultado_campo_id_comando_anterior>' --repository-name='<nome_do_repositório_criado>' --digest-or-tag='<versao_da_imagem>'
````

# 9. Vamos criar uma secret para podermos acessar essa imagem
````bash
# primeiro vamos pegar as crendenciais de acesso pela CLI da MGC
mgc container-registry credentials list --region="<região_desejada>"

# Criando a secret:
kubectl create secret docker-registry magalu-registry-secret \
    --docker-server=container-registry.<região_desejada>.magalu.cloud \
    --docker-username='<resultado_campo_username_comando_anterior>' \
    --docker-password='<resultado_campo_password_comando_anterior>' \
    --docker-email='<resultado_campo_email_comando_anterior>'
````

# 10. Agora precisamos referenciar esta imagem no deployment:
````yaml
spec:
      containers:
        - name: rails
          # --- Atualize a tag da imagem aqui ---
          image: container-registry.br-se1.magalu.cloud/soat-challenge-2/soat_tech_challenge:1.2.0
          # ------------------------------------
# E no final do arquivo referenciamos as secrets:
      imagePullSecrets:
        - name: magalu-registry-secret
````

# 11. Com a imagem criada e referenciada agora podemos criar um cluster na mgc pelo portal ou pela CLI
<img width="1921" height="887" alt="2025-08-01_21-45" src="https://github.com/user-attachments/assets/60ca8e2a-a34b-44eb-a4c1-df9634436adf" />

````bash
 mgc kubernetes cluster create
````

# 12. Baixar o kubeconfig
````bash
mgc kubernetes cluster kubeconfig --cluster-id="uuid"
````

# 13. Referenciar este kubeconfig no nosso kubectl:
````bash
# 1. Defina a variável de ambiente para incluir o arquivo padrão e o novo
export KUBECONFIG=~/.kube/config:/caminho/para/novo-kubeconfig.yaml

# 2. Mescle tudo e sobrescreva o arquivo padrão (fazendo um backup antes!)
kubectl config view --flatten > ~/.kube/config_temp && mv ~/.kube/config_temp ~/.kube/config
````

# 14. Gerar as secrets para o projeto
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

# Desta forma a configuração se torna permanente e está sempre estará disponível para a aplicação.
````

# 15. Realizar o deploy do banco de dados
````bash
kubectl apply -f db-deployment.yaml
kubectl apply -f db-pvc.yaml
kubectl apply -f db-service.yaml
````

# 16. Realizar o deploy do ngrok(conteiner com aplicação que gera certificados https para comunicação do webhook do Mercado pago)
````bash
kubectl apply -f ngrok-deployment.yaml
kubectl apply -f ngrok-service.yaml
````

# 17. Gerar os configmaps para o projeto
````bash
# verificar url gerada pelo ngrok em https://dashboard.ngrok.com/agents
kubectl create configmap mp-rails-config --from-literal=mercadopago_notification_url='<url_da_aplicação>'\
  --from-literal=user_id='<user_id_integração_mp>' \
  --from-literal=external_pos_id='<id_do_caixa_de_integração_MP>'
````

# 18. Realizar o deploy da aplicação
````bash
kubectl apply -f rails-deployment.yaml
kubectl apply -f rails-service.yaml
kubectl apply -f rails-hpa.yaml
````
