# 🔐 Configurar Supabase para MeuDanfe

## 📋 **Passo 1: Criar Conta no Supabase**

1. Acesse: **https://app.supabase.com**
2. Clique **"Sign Up"**
3. Faça login com **GitHub** (use `nuvixlabs`)
4. Autorize a conexão

---

## 🗄️ **Passo 2: Criar Projeto**

1. Na dashboard, clique **"New Project"**
2. Configure:
   - **Name**: `meudanfe` (ou `programaxml`)
   - **Database Password**: Crie uma senha forte (ex: `Senha123!@#`)
   - **Region**: `South America (São Paulo)` ou outra próxima
   - **Pricing**: Deixe **Free** (grátis)
3. Clique **"Create new project"**

⏳ **Aguarde 2-3 minutos** para criar o banco...

---

## 📊 **Passo 3: Criar Tabelas**

Após o projeto criado, acesse a **SQL Editor** e execute:

```sql
-- Tabela de Usuários
CREATE TABLE usuarios (
  id UUID PRIMARY KEY DEFAULT auth.uid(),
  email TEXT UNIQUE NOT NULL,
  nome TEXT,
  creditos DECIMAL(10, 2) DEFAULT 0,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Histórico de XMLs
CREATE TABLE consultas_xml (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  chave_acesso TEXT NOT NULL,
  xml_conteudo TEXT,
  data_consulta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  custou_credito DECIMAL(10, 2) DEFAULT 0.15,
  origem TEXT DEFAULT 'api'
);

-- Tabela de Transações de Créditos
CREATE TABLE transacoes_creditos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  tipo TEXT NOT NULL, -- 'compra' ou 'gasto'
  valor DECIMAL(10, 2) NOT NULL,
  saldo_anterior DECIMAL(10, 2),
  saldo_novo DECIMAL(10, 2),
  descricao TEXT,
  data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert do usuário admin
INSERT INTO usuarios (email, nome, creditos, is_admin)
VALUES ('matheus.transportesirmaos@gmail.com', 'Admin', 500.00, TRUE);
```

---

## 🔑 **Passo 4: Pegar as Chaves API**

1. Na dashboard, vá para **Settings** (ícone de engrenagem)
2. Clique **"API"**
3. Copie:
   - **Project URL** → `SUPABASE_URL`
   - **anon public** (em API KEYS) → `SUPABASE_ANON_KEY`

---

## 📝 **Passo 5: Configurar Variáveis no Vercel**

1. Acesse seu projeto no Vercel: **https://vercel.com/dashboard**
2. Clique no projeto **`programaxml`**
3. Vá para **Settings** → **Environment Variables**
4. Adicione:

```
SUPABASE_URL = https://seu-projeto.supabase.co
SUPABASE_ANON_KEY = eyJhbGc...
```

5. Clique **"Save"**
6. Na página inicial do projeto, clique **"Redeploy"** para aplicar as mudanças

---

## ✅ **Pronto!**

Seu projeto agora está conectado ao Supabase! 🎉

**URLs de Acesso:**
- Landing Page: `https://seu-projeto.vercel.app/landing.html`
- App: `https://seu-projeto.vercel.app/index.html`

---

## 🚀 **Próximos Passos**

1. Teste login com: `matheus.transportesirmaos@gmail.com` / `123456`
2. Teste buscar XMLs
3. Teste recarregar créditos
4. Teste histórico de XMLs

**Tudo funcionando? Parabéns! 🎊**
