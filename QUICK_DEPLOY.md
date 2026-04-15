# Script Rápido de Deployment

## Passo 1: Verificar Git no Local

```powershell
cd c:\programaxml
git status
```

Se retornar erro, executar:
```powershell
git init
```

## Passo 2: Fazer Commit (Local)

```powershell
git add .
git commit -m "🎉 Initial commit - MeuDanfe Platform"
```

## Passo 3: Criar Repositório no GitHub

1. Acesse: **https://github.com/new**
2. Nome: `programaxml`
3. Clique "Create repository"

## Passo 4: Fazer Push para GitHub

```powershell
# Adicionar remote
git remote add origin https://github.com/SEU_USUARIO/programaxml.git

# Fazer push
git branch -M main
git push -u origin main
```

**Copie o link e substitua `SEU_USUARIO`**

## Passo 5: Deploy na Vercel

1. Acesse: **https://vercel.com**
2. Faça login com GitHub
3. Clique "Import Project"
4. Cole: `https://github.com/SEU_USUARIO/programaxml.git`
5. Configure e clique "Deploy"

---

## ✅ Pronto!

Seu app estará disponível em: `https://seu-projeto.vercel.app`

Toda vez que fizer `git push`, Vercel fará deploy automático!
