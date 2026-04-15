# 🚀 QUICK START - Deployment Checklist

## ✅ Antes de começar
- [ ] Conta no Supabase (supabase.com)
- [ ] Conta no Vercel (vercel.com)
- [ ] Conta no GitHub
- [ ] Chave de API do MeuDanfe

---

## 1️⃣ SUPABASE SETUP (5 minutos)

### Step 1: Criar Projeto
- Vá em supabase.com → New Project
- Escolha região (me recomendo US East)
- Aguarde criação

### Step 2: Criar Tabelas
- Vá em **SQL Editor**
- Copie todo o conteúdo de `SETUP_BANCO.sql`
- Execute (Ctrl + Enter)

### Step 3: Obter Chaves
- **SQL Editor** → **Project Settings** → **API**
- Copie:
  - `URL` → será `SUPABASE_URL`
  - `anon public` → será `SUPABASE_ANON_KEY` (frontend)
  - `service_role secret` → será `SUPABASE_SERVICE_ROLE_KEY` (backend)

### Step 4: Criar Primeiro Usuário
- Vá em **Authentication** → **Users** → **Add User**
- Email: `seu@email.com`
- Password: `senhaforte123`
- Clique em **Create User**
- **Copie o UUID** que aparece

### Step 5: Adicionar Créditos
- Vá em **SQL Editor**
- Execute:
```sql
INSERT INTO usuarios (id, creditos) VALUES ('COLE-O-UUID-AQUI', 100);
```

---

## 2️⃣ BACKEND SETUP (10 minutos)

### Step 1: Git Repository
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/SEU-USUARIO/programaxml.git
git push -u origin main
```

### Step 2: Vercel Deploy
- Vá em vercel.com → **Add New** → **Project**
- Selecione seu repositório GitHub `programaxml`
- Clique em **Import**

### Step 3: Environment Variables
- Na página do projeto → **Settings** → **Environment Variables**
- Adicione 3 variáveis:

| Key | Value | Origem |
|-----|-------|--------|
| `SUPABASE_URL` | `https://xxxx.supabase.co` | Supabase API |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJhbGci...` | Supabase API (secret) |
| `API_KEY` | Sua chave MeuDanfe | MeuDanfe dashboard |

### Step 4: Deploy
- Clique em **Deployments** → Aguarde terminar
- **Copie a URL** (ex: https://programaxml-xyz.vercel.app)

---

## 3️⃣ FRONTEND SETUP (5 minutos)

### Step 1: Editar `index.html`
Abra o arquivo e procure por:
```javascript
const SUPABASE_URL = 'https://seu-projeto.supabase.co'
const SUPABASE_ANON_KEY = 'sua_anon_public_key'
const BACKEND_URL = 'https://seu-projeto.vercel.app'
```

Substitua com suas chaves:
```javascript
const SUPABASE_URL = 'https://xxxxx.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
const BACKEND_URL = 'https://programaxml-xyz.vercel.app'
```

### Step 2: Fazer Deploy
```bash
git add index.html
git commit -m "Update config"
git push
```

Vercel vai fazer deploy automaticamente!

### Step 3: Testar
- Abra: https://programaxml-xyz.vercel.app
- Faça login com `seu@email.com` / `senhaforte123`
- Teste uma busca

---

## 🧪 TESTE COMPLETO

### ✅ Tudo funcionando?

1. **Login**: Deve aparecer seu email e R$ 100.00
2. **Buscar**: Cole uma chave válida e clique em Buscar
3. **Resultado**: Deve aparecer XML ou erro "Chave inválida"
4. **Créditos**: Devem descer para R$ 99.85 (se sucesso)

---

## 📊 MONITORAR DEPOIS

### Links úteis:
- **Vercel Logs**: https://vercel.com → Project → Real-time logs
- **Supabase Queries**: Project → SQL Editor → View results
- **Database Stats**: 
  ```sql
  SELECT COUNT(*) as total_buscas, SUM(custo) as receita 
  FROM consultas_xml WHERE status = 'SUCESSO';
  ```

---

## ❌ PROBLEMAS COMUNS

### "CORS Error"?
- Ajuste `BACKEND_URL` em `index.html`

### "Unauthorized" em Supabase?
- Verificar `SUPABASE_SERVICE_ROLE_KEY` no Vercel

### "Chave inválida" sempre?
- Testar chave com MeuDanfe API diretamente
- Verificar se `API_KEY` está certo

### "Crédito não atualizou"?
- Verificar se usuário existe em tabela `usuarios`
- Verificar SQL error logs no Vercel

---

## 🎉 PRONTO!

Seu sistema está 100% funcional! 

**Próximos passos:**
- Adicionar mais usuários (Supabase Auth)
- Monitorar receita (SQL)
- Ajustar preço (alterar 0.15 em `api/buscar-xml.js`)
- Adicionar webhook para pagamentos

Sucesso! 🚀
