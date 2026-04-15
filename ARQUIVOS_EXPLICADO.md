# 📚 ARQUIVOS DO PROJETO - Explicação Rápida

## Estrutura Criada
```
programaxml/
├── api/
│   └── buscar-xml.js          ← API backend (Vercel)
├── index.html                  ← Frontend (interface do usuário)
├── package.json                ← Dependências do Node
├── vercel.json                 ← Config do Vercel
├── SETUP_BANCO.sql            ← SQL para criar banco Supabase
├── SQL_COMMANDS.sql           ← Comandos úteis para gerenciar créditos
├── .env.example               ← Variáveis de ambiente (template)
├── .gitignore                 ← Arquivos a ignorar no Git
├── README.md                  ← Documentação completa
├── DEPLOYMENT_CHECKLIST.md    ← Checklist step-by-step
└── EXEMPLOS_INTEGRACAO.md     ← Exemplos e integrações
```

---

## 🎯 O QUE CADA ARQUIVO FAZ

### 🗄️ Banco de Dados

**SETUP_BANCO.sql**
- Cria tabela `usuarios` (id, créditos)
- Cria tabela `consultas_xml` (histórico de buscas)
- Cria índices para performance
- ❤️ Executar uma única vez no Supabase

**SQL_COMMANDS.sql**
- Adicionar créditos: `UPDATE usuarios SET creditos = ...`
- Ver histórico de buscas
- Estatísticas de receita
- Top usuários por consumo

---

### 🔧 Backend (Vercel)

**api/buscar-xml.js**
```
POST /api/buscar-xml
├── Recebe: { chaves: [], user_id }
├── Verifica: Tem crédito?
├── 💾 Cache: Já existe XML? Retorna sem cobrar
├── Chama: API MeuDanfe
├── Desconta: R$ 0.15 de crédito
└── Retorna: XML ou erro
```

**package.json**
- Dependência: `@supabase/supabase-js`
- Usado no Vercel para fazer deploy

**vercel.json**
- Configura ambiente Vercel
- Define env variables
- Tempo de execução (30s max)

**.env.example**
- Template das variáveis necessárias
- Você copia, renomeia para `.env` e preenche

**.gitignore**
- Impede fazer push de `.env` (com credenciais)
- Ignora `node_modules/`

---

### 💻 Frontend

**index.html**
```
┌─────────────────────┐
│   HTML Completo     │
├─────────────────────┤
│ ✅ Sistema de Login │
│ ✅ Buscar XMLs      │
│ ✅ Ver Créditos     │
│ ✅ Histórico        │
└─────────────────────┘
```
- Interface bonita e funcional
- Integrado com Supabase Auth
- Chama backend `/api/buscar-xml`

---

### 📖 Documentação

**README.md**
- Guia de setup passo a passo
- Como obter as chaves
- Troubleshooting

**DEPLOYMENT_CHECKLIST.md**
- ✅ Checklist visual
- 5 minutos por fase
- Links diretos

**EXEMPLOS_INTEGRACAO.md**
- Bot Slack
- App Mobile (React Native)
- Plugin WordPress
- Ideias de monetização

---

## 🚀 PASSO 1: SUPABASE

1. Copiar `SETUP_BANCO.sql` inteiro
2. Colar no **SQL Editor** do Supabase
3. Executar (Ctrl+Enter)
4. Ir em **Settings → API** e copiar as 3 chaves

---

## 🚀 PASSO 2: VERCEL

1. Fazer push para GitHub
2. Importar repo no Vercel
3. Adicionar 3 variáveis de ambiente:
   - `SUPABASE_URL` (do passo 1)
   - `SUPABASE_SERVICE_ROLE_KEY` (do passo 1)
   - `API_KEY` (do MeuDanfe)
4. Deploy automático!

---

## 🚀 PASSO 3: FRONTEND

1. Editar `index.html`
2. Alterar 3 variáveis JavaScript:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `BACKEND_URL` (URL do Vercel)
3. Fazer push para GitHub
4. Vercel faz deploy automaticamente

---

## 💰 APÓS SETUP

1. **Adicionar créditos:**
   ```sql
   UPDATE usuarios SET creditos = 100 WHERE id = 'USER_UUID';
   ```

2. **Testar:**
   - Abrir frontend
   - Fazer login
   - Colar chave NFe
   - Clicar "Buscar"

3. **Monitorar:**
   - Ver logs em Vercel
   - Queries em Supabase
   - Receita em banco

---

## 🔑 RESUMO DAS CREDENCIAIS

| Credencial | Onde obter | Onde usar |
|-----------|-----------|----------|
| `SUPABASE_URL` | Settings → API | Vercel + index.html |
| `SUPABASE_ANON_KEY` | Settings → API (anon) | index.html (frontend) |
| `SUPABASE_SERVICE_ROLE_KEY` | Settings → API (secret) | Vercel (backend) |
| `API_KEY` | MeuDanfe dashboard | Vercel |

---

## ✅ TUDO PRONTO!

Seu sistema está 100% completo:
- ✅ Backend com cache
- ✅ Frontend com autenticação
- ✅ Banco de dados com histórico
- ✅ Sistema de créditos
- ✅ Pronto para monetizar

**Próximas ações:**
1. Seguir o `DEPLOYMENT_CHECKLIST.md`
2. Testar tudo funcionando
3. Adicionar usuários de verdade
4. Começar a lucrar! 💰

Dúvidas? Verificar `EXEMPLOS_INTEGRACAO.md` ou `README.md`
