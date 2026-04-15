# 🎯 COMECE AQUI!

## Bem-vindo! Aqui está seu sistema 100% funcional 🚀

```
📊 O QUE É ISSO?
████████████████████████████████████
Um sistema COMPLETO para:
✅ Fazer login de usuários
✅ Buscar XMLs (NFe/NFC-e)
✅ Cobrar por busca (R$ 0,15 cada)
✅ Adicionar créditos
✅ Ver histórico e lucro

ARQUITETURA:
┌─────────────┐
│  Frontend   │ (index.html)
│  HTML+JS    │
└──────┬──────┘
       │
       ▼
┌──────────────────┐
│  Backend/API     │ (Vercel)
│  Node.js         │
└──────┬────────┬──┘
       │        │
       ▼        ▼
   ┌────────┐ ┌───────────┐
   │Supabase│ │ MeuDanfe  │
   │(DB)    │ │ (XML API) │
   └────────┘ └───────────┘
```

---

## 📋 SETUP - 3 PASSOS (30 minutos total)

### PASSO 1️⃣: SUPABASE BANCO (5 min)
```bash
1. Ir em supabase.com
2. Criar novo projeto
3. Ir em SQL Editor
4. Abrir arquivo: SETUP_BANCO.sql
5. Copiar TUDO (Ctrl+A)
6. Colar no SQL Editor (Ctrl+V)
7. Executar (Ctrl+Enter)
✅ PRONTO
```

**O que acontece:** Cria 2 tabelas (usuarios e consultas_xml)

---

### PASSO 2️⃣: BACKEND VERCEL (10 min)

#### Step 1: GitHub
```bash
cd c:\programaxml
git init
git add .
git commit -m "setup"
git remote add origin https://github.com/SEU-USER/programaxml.git
git push -u origin main
```

#### Step 2: Vercel Deploy
```
1. Abrir vercel.com
2. Clicar "Add New" → "Project"
3. Selecionar repo "programaxml"
4. Clicar "Import"
5. Aguardar 2 minutos deploy
```

#### Step 3: Environment Variables
```
1. No Vercel → Settings → Environment Variables
2. Adicionar 3 variáveis:

SUPABASE_URL = https://xxxxxx.supabase.co
[Copiar de: Supabase → Settings → API → URL]

SUPABASE_SERVICE_ROLE_KEY = eyJhbGc...
[Copiar de: Supabase → Settings → API → Service Role secret]

API_KEY = [sua chave do MeuDanfe]
```

✅ Vercel faz redeploy automaticamente

---

### PASSO 3️⃣: FRONTEND (5 min)

Editar arquivo `index.html`:

**Procurar por (linha ~65):**
```javascript
const SUPABASE_URL = 'https://seu-projeto.supabase.co'
const SUPABASE_ANON_KEY = 'sua_anon_public_key'
const BACKEND_URL = 'https://seu-projeto.vercel.app'
```

**Substituir por seus valores:**
```javascript
const SUPABASE_URL = 'https://xxxxxx.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1N...'
const BACKEND_URL = 'https://programaxml-abc123.vercel.app'
```

**Como obter:**
- `SUPABASE_URL`: Supabase → Settings → API → URL
- `SUPABASE_ANON_KEY`: Supabase → Settings → API → Anon public
- `BACKEND_URL`: Vercel → Project → Domains (está lá!)

**Depois fazer push:**
```bash
git add index.html
git commit -m "update config"
git push
```

Vercel faz deploy automaticamente!

---

## 🧪 TESTAR TUDO

### Criar usuário teste
1. Supabase → Authentication → Users
2. Add User: `teste@email.com` / `senha123`
3. Copiar o UUID gerado

### Adicionar créditos
1. Supabase → SQL Editor
2. Colar:
```sql
INSERT INTO usuarios (id, creditos) 
VALUES ('COLE-O-UUID-AQUI', 100);
```
3. Executar!

### Testar frontend
1. Abrir: https://programaxml-xyz.vercel.app
2. Fazer login: `teste@email.com` / `senha123`
3. Deve aparecer: ✅ Email e R$ 100.00
4. Cole uma chave NFe válida
5. Clique "Buscar XMLs"
6. ✅ Créditos devem descer para R$ 99.85

---

## 📁 ARQUIVOS E O QUE FAZER COM CADA UM

| Arquivo | Quando | O quê |
|---------|--------|-------|
| SETUP_BANCO.sql | Primeira vez | Colar no SQL Editor Supabase |
| SQL_COMMANDS.sql | Sempre | Copiar queries úteis (adicionar créditos, ver lucro, etc) |
| DEPLOYMENT_CHECKLIST.md | Setup | Seguir passo a passo |
| README.md | Dúvidas | Documentação completa |
| ARQUIVOS_EXPLICADO.md | Entender | O que cada arquivo faz |
| EXEMPLOS_INTEGRACAO.md | Depois | Integrar com Slack, Mobile, etc |

---

## 🛠️ TROUBLESHOOTING RÁPIDO

❌ **"Cannot find api"**
- Verificar se arquivo `api/buscar-xml.js` existe
- Verificar URLs em `index.html`

❌ **"Unauthorized Supabase"**
- Copiar `SUPABASE_SERVICE_ROLE_KEY` errado
- Verificar se está em Vercel

❌ **"Chave inválida" sempre**
- Testar chave NFe (é válida?)
- `API_KEY` do MeuDanfe está certo?

❌ **Login não funciona**
- Usuário existe em `usuarios` table?
- Execute: `INSERT INTO usuarios...`

---

## ✅ PRÓXIMOS PASSOS

Após tudo funcionando:

1. **Adicionar mais usuários**
   - Supabase Auth → Add User
   - Executar SQL para criar no banco

2. **Monitorar receita**
   ```sql
   SELECT SUM(custo) FROM consultas_xml WHERE status = 'SUCESSO';
   ```

3. **Mudar o preço**
   - Editar `api/buscar-xml.js`
   - Trocar `0.15` pelo novo valor

4. **Adicionar pagamentos**
   - Integrar Stripe/PagSeguro
   - Webhook para comprar créditos

---

## 🎓 REFERÊNCIA RÁPIDA

### Arquivos principais:
- **Backend**: `api/buscar-xml.js`
- **Frontend**: `index.html`
- **Banco**: `SETUP_BANCO.sql`

### Hosts:
- **Frontend**: Vercel (automático)
- **Backend**: Vercel (automático)
- **Banco**: Supabase (na nuvem)

### Custos:
- **Vercel**: Grátis até 100k requisições
- **Supabase**: Grátis até 500MB
- **MeuDanfe**: R$ 0,15 por busca

---

## 📞 PRECISA DE AJUDA?

1. Verificar `DEPLOYMENT_CHECKLIST.md` → mais detalhado
2. Verificar `README.md` → documentação completa
3. Checkup: Ver Vercel logs (Real-time logs)
4. Checkup: Ver Supabase queries (SQL Editor)

---

## 🎉 ESTÁ TUDO PRONTO!

Seu sistema:
✅ Backend funcionando
✅ Frontend bonito
✅ Banco de dados setup
✅ Sistema de créditos
✅ Cache implementado
✅ Documentação completa

**Agora é só fazer o setup dos 3 passos e começar a lucrar!** 💰

---

## 🚀 QUER COMEÇAR?

1. Abra: `DEPLOYMENT_CHECKLIST.md` (segue passo a passo)
2. Ou avance direto: `SETUP_BANCO.sql` (passo 1)

**Tempo total: ~30 minutos** ⏱️

Boa sorte! 🎯
