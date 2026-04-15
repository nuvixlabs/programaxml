# 🚀 Guia de Deployment - Git + Vercel

## 📋 Checklist de Deploy

### 1️⃣ **Preparar Repositório Git Local**

```bash
cd c:\programaxml

# Inicializar Git (se não estiver inicializado)
git init

# Adicionar todos os arquivos
git add .

# Fazer commit inicial
git commit -m "🎉 Initial commit - MeuDanfe XML Search Platform"
```

### 2️⃣ **Criar Repositório no GitHub**

1. Acesse: https://github.com/new
2. **Nome do repositório**: `programaxml` (ou outro nome que preferir)
3. **Descrição**: "MeuDanfe - Plataforma de busca de XMLs com créditos e PIX"
4. **Privacidade**: Público (recomendado para Vercel gratuito)
5. Clique em **"Create repository"**

### 3️⃣ **Fazer Push para GitHub**

Após criar o repositório, você receberá as instruções. Execute:

```bash
# Adicionar remote origin
git remote add origin https://github.com/SEU_USUARIO/programaxml.git

# Fazer push do branch main
git branch -M main
git push -u origin main
```

**Substitua `SEU_USUARIO` pelo seu usuário do GitHub!**

---

## 🔧 **Configurações Necessárias**

### Arquivo `.env` (Local)

Crie um arquivo `.env` na raiz do projeto:

```env
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_ANON_KEY=sua_anon_public_key
ADMIN_EMAIL=matheus.transportesirmaos@gmail.com
ADMIN_PASSWORD=123456
```

### Arquivo `.env.local` (não comitar)

Este arquivo fica local e NÃO va para Git:

```env
# Credenciais sensíveis aqui
SUPABASE_ADMIN_KEY=chave_admin_secreta
DATABASE_PASSWORD=senha_banco_dados
```

### Atualizar `.gitignore`

Certifique-se que `.gitignore` contém:

```
.env.local
node_modules/
.vercel/
.DS_Store
```

---

## 🌐 **Fazer Deploy na Vercel**

### Opção A: Via Dashboard Vercel (Recomendado)

1. Acesse: https://vercel.com/dashboard
2. Clique **"Add New"** → **"Project"**
3. Clique **"Import Git Repository"**
4. Cole a URL do seu repositório GitHub:
   ```
   https://github.com/SEU_USUARIO/programaxml.git
   ```
5. Clique **"Import"**

### Configurar Projeto na Vercel

1. **Project Name**: `programaxml`
2. **Framework**: Selecione **"Other"** (HTML + Node.js)
3. **Root Directory**: `./`
4. **Build Command**: 
   ```
   npm run build
   ```
5. **Output Directory**: `public` (se houver)

### Adicionar Variáveis de Ambiente

No dashboard da Vercel:
1. Vá para **"Settings"** → **"Environment Variables"**
2. Adicione:
   ```
   SUPABASE_URL = https://seu-projeto.supabase.co
   SUPABASE_ANON_KEY = sua_anon_public_key
   ADMIN_EMAIL = matheus.transportesirmaos@gmail.com
   ```

### Deploy

1. Clique **"Deploy"**
2. Aguarde a compilação (pode levar 2-5 minutos)
3. Receba o link da sua aplicação! 🎉

---

## 📱 **Estrutura do Projeto no Vercel**

```
https://seu-projeto.vercel.app/
  ├── landing.html          → Página de login
  ├── index.html            → Aplicação principal
  └── api/
      └── buscar-xml.js     → API endpoint
```

---

## 🔐 **Configuração de Domínio (Opcional)**

Na Vercel:
1. **Settings** → **Domains**
2. Adicione seu domínio personalizado
3. Configure DNS (instruções no dashboard)

---

## ✅ **Após o Deploy**

- ✅ Teste login em produção: https://seu-projeto.vercel.app/landing.html
- ✅ Teste busca de XMLs
- ✅ Teste recarga de créditos com PIX
- ✅ Teste histórico de XMLs
- ✅ Teste logout

---

## 🔄 **Atualizar o Deploy**

Sempre que fizer mudanças:

```bash
# Local
git add .
git commit -m "Descrição da mudança"
git push origin main

# Vercel fará deploy automaticamente em segundos!
```

---

## 🐛 **Troubleshooting**

### Erro: "Build failed"
- Verifique `package.json`
- Confira se todas as dependências estão instaladas localmente
- Teste com `npm install` → `npm run build`

### Erro: "Cannot find module"
- Adicione as dependências no `package.json`
- Exemplo: `npm install express cors dotenv`

### Erro: "API não funciona"
- Verifique se a URL do Supabase está correta
- Confira se as chaves API estão nas variáveis de ambiente

---

## 📚 **Links Úteis**

- Vercel Dashboard: https://vercel.com/dashboard
- GitHub: https://github.com
- Documentação Vercel: https://vercel.com/docs
- Supabase: https://supabase.com

---

**Pronto! Seu projeto está pronto para o mundo! 🌍**
