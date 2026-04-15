## 📋 SETUP - Sistema de Busca de XML com Créditos

### 1️⃣ SUPABASE (Banco de Dados)

#### Passo 1: Criar tabelas
Vá em **Supabase Console** → **SQL Editor** → Execute o código em `SETUP_BANCO.sql`

```sql
CREATE TABLE usuarios (
    id uuid PRIMARY KEY,
    creditos numeric DEFAULT 0
);

CREATE TABLE consultas_xml (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id uuid,
    chave text,
    status text,
    conteudo text,
    custo numeric,
    data timestamp DEFAULT now()
);
```

#### Passo 2: Criar usuários
Vá em **Authentication** → **Users** → **Add User**
- Preencha email e senha
- Copie o UUID gerado
- Execute no SQL Editor:
```sql
INSERT INTO usuarios (id, creditos) VALUES ('UUID-DO-USUARIO', 0);
```

---

### 2️⃣ BACKEND (Vercel API)

#### Passo 1: Deploy no Vercel
```bash
# 1. Clone seu repositório ou crie novo projeto
cd programaxml
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/SEU-USER/programaxml.git
git push -u origin main

# 2. No Vercel Dashboard: Import GitHub Project
```

#### Passo 2: Environment Variables
No **Vercel Dashboard** → **Settings** → **Environment Variables**, adicione:

```
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_SERVICE_ROLE_KEY=seu_service_role_key_super_secreto
API_KEY=sua_chave_api_meudanfe
```

**Como obter as chaves:**
- `SUPABASE_URL`: Supabase → Project Settings → API → URL
- `SUPABASE_SERVICE_ROLE_KEY`: Supabase → Project Settings → API → Service Role secret
- `API_KEY`: Sua chave de API do meudanfe.com.br

---

### 3️⃣ FRONTEND (HTML)

#### Passo 1: Editar o arquivo `index.html`
Abra e procure por:
```javascript
const SUPABASE_URL = 'https://seu-projeto.supabase.co'
const SUPABASE_ANON_KEY = 'sua_anon_public_key'
const BACKEND_URL = 'https://seu-projeto.vercel.app'
```

**Substituir por:**
- `SUPABASE_URL`: Seu projeto Supabase
- `SUPABASE_ANON_KEY`: Supabase → Project Settings → API → Anon public
- `BACKEND_URL`: URL do seu projeto no Vercel (ex: https://meu-projeto-xyz123.vercel.app)

#### Passo 2: Hospedar o frontend
Opção A: **Vercel**
```bash
vercel deploy
```

Opção B: **Colocar em um pasta `public/` no mesmo Vercel**
Opção C: **GitHub Pages**

---

### 💰 GERENCIAR CRÉDITOS

#### Adicionar créditos para usuário:
```sql
UPDATE usuarios SET creditos = creditos + 50 WHERE id = 'USER_ID';
```

#### Consultar créditos:
```sql
SELECT id, creditos FROM usuarios;
```

#### Ver histórico de consultas:
```sql
SELECT * FROM consultas_xml WHERE usuario_id = 'USER_ID' ORDER BY data DESC;
```

#### Lucro (consultas bem-sucedidas):
```sql
SELECT SUM(custo) as receita FROM consultas_xml WHERE status = 'SUCESSO';
```

---

### 🚀 ARQUITETURA

```
┌────────────────┐
│   Frontend     │ (index.html)
│  (HTML + JS)   │
└────────┬────────┘
         │
         ▼
┌────────────────┐
│  Vercel API    │ (/api/buscar-xml.js)
│ (Node.js)      │
└────────┬────────┘
         │
         ├──────────────────┐
         ▼                  ▼
    ┌─────────────┐  ┌──────────────┐
    │ Supabase DB │  │ MeuDanfe API │
    │ (cache)     │  │ (XML busca)  │
    └─────────────┘  └──────────────┘
```

---

### 💾 CACHE (NÃO COBRAR 2x)

**Fluxo:**
1. Chave chega no backend
2. Backend verifica: "Já existe essa chave com status SUCESSO?"
3. ✅ Sim: Retorna XML salvo → **NÃO COBRAR**
4. ❌ Não: Busca na API → Cobra R$ 0,15

---

### 🔐 SEGURANÇA

- ⚠️ **SERVICE_ROLE_KEY** no backend (side secret)
- ⚠️ **ANON_KEY** no frontend (segura, sem write)
- ⚠️ **API_KEY** nunca no frontend
- ✅ Validação de créditos no backend

---

### 🆘 TROUBLESHOOTING

**"Invalid request"** na busca?
- Verificar se `BACKEND_URL` está correto
- Verificar se variáveis de ambiente estão no Vercel

**"Unauthorized" no Supabase?**
- Verificar se `SUPABASE_SERVICE_ROLE_KEY` está correto
- Verificar se `SUPABASE_URL` está correto

**Créditos não atualizando?**
- Verificar se usuário existe em `usuarios` table
- Verificar se tem crédito disponível

---

### 📞 SUPORTE

Dúvidas? Verifique:
- Status: https://status.vercel.com
- Logs: Vercel Dashboard → Deployments → Real-time logs
- Console: `F12` → Console tab no browser
