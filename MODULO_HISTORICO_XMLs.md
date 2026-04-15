# 📚 MÓDULO DE HISTÓRICO DE XMLs - Documentação

## 🎯 O que é?

Um módulo que **armazena todos os XMLs que o usuário já buscou** e permite:
- ✅ Ver histórico completo
- ✅ Baixar novamente SEM cobrar
- ✅ Selecionar e baixar em lote
- ✅ Baixar unitário
- ✅ Deletar XMLs individuais
- ✅ Limpar histórico completo

---

## 📍 Localização

Dentro do app (`index.html`), após a seção de busca:

```
┌─────────────────────┐
│  Buscar XMLs        │
│  [Input] [Buscar]   │
└─────────────────────┘
         ↓
┌─────────────────────┐
│  📚 Histórico de    │
│  XMLs               │
│  [Botões de ação]   │
│  [Lista de XMLs]    │
└─────────────────────┘
```

---

## 🚀 Como Funciona

### 1. **Quando o usuário busca XMLs**
```
1. Usuário cola chaves e clica "Buscar"
2. XMLs são encontrados
3. 💾 Automaticamente salvos no localStorage
4. 📚 Aparecem na lista de histórico
```

### 2. **Histórico Mostra**
```
Para cada XML:
├─ Checkbox (selecionar)
├─ Nome do arquivo (monospace)
├─ Data e hora da busca
├─ Origem (Cache ou API)
├─ Botão: ⬇️ Download
└─ Botão: 🗑️ Deletar
```

### 3. **Operações em Lote**
```
Botões de ação:
├─ ✓  Selecionar Todos
├─ ✗  Desselecionar
├─ ⬇️ Baixar Selecionados (ZIP)
└─ 🗑️ Limpar Histórico
```

### 4. **Armazenamento**
```
localStorage.xmlHistorico = [
  {
    id: timestamp + random,
    nome: "35210516505127000148550010000001234567890123.xml",
    conteudo: "<?xml version='1.0'?>...",
    data: "15/04/2026, 10:30:45",
    origem: "api" ou "cache"
  },
  ...
]
```

---

## 🎮 Operações Disponíveis

### ✓ Selecionar Todos
```
Clica: "✓ Selecionar Todos"
└─ Marca todos os checkboxes
```

### ✗ Desselecionar
```
Clica: "✗ Desselecionar"
└─ Desmarca todos os checkboxes
```

### ⬇️ Baixar Selecionados
```
1. Seleciona 1 ou mais XMLs (checkbox)
2. Clica: "⬇️ Baixar Selecionados"
3. Gera arquivo ZIP com todos
4. Download automático
```

### ⬇️ Download Unitário
```
1. Ao lado de cada XML, clica: "⬇️ Download"
2. Baixa apenas aquele XML (não é ZIP)
```

### 🗑️ Deletar Individual
```
1. Clica: "🗑️ Deletar" ao lado do XML
2. Pede confirmação
3. Remove do histórico e da tela
```

### 🗑️ Limpar Histórico
```
1. Clica: "🗑️ Limpar Histórico"
2. Pede confirmação
3. Remove TODOS os XMLs
```

---

## 📊 Exemplos de Uso

### Exemplo 1: Baixar Todos em Lote
```
1. Clica "✓ Selecionar Todos"
2. Clica "⬇️ Baixar Selecionados"
3. Download: "XMLs_Selecionados_1713189000000.zip"
4. Abre o ZIP e vê todos os XMLs
```

### Exemplo 2: Selecionar Apenas Alguns
```
1. Marca checkbox de 3 XMLs específicos
2. Clica "⬇️ Baixar Selecionados"
3. Download: ZIP com apenas esses 3
```

### Exemplo 3: Baixar Um Só
```
1. Clica "⬇️ Download" ao lado do XML
2. Download direto: "35210516505127...xml"
```

### Exemplo 4: Limpar Histórico Antigo
```
1. Clica "🗑️ Limpar Histórico"
2. Confirmação
3. Todos os XMLs deletados
```

---

## 💾 Armazenamento

### LocalStorage
```
Chave: xmlHistorico
Tipo: JSON Array
Limite: Ultimos 100 XMLs
Persistência: Até limpar cache do navegador
```

### Estrutura de Cada XML
```javascript
{
  id: 1713189123456,            // Unique ID
  nome: "chave.xml",             // Nome do arquivo
  conteudo: "<?xml...?>",        // Conteúdo XML
  data: "15/04/2026, 10:30:45", // Data/hora da busca
  origem: "api" ou "cache"      // Onde veio
}
```

---

## 🎨 Design & UX

### Lista de XMLs
```
┌────────────────────────────────────────┐
│ ☐ 35210516... | 📅 15/04 10:30 🌐API  │
│   ⬇️ Download  🗑️ Deletar              │
├────────────────────────────────────────┤
│ ☐ 35210516... | 📅 15/04 10:29 💾Cache│
│   ⬇️ Download  🗑️ Deletar              │
├────────────────────────────────────────┤
│ ☐ 35210516... | 📅 15/04 10:28 🌐API  │
│   ⬇️ Download  🗑️ Deletar              │
└────────────────────────────────────────┘
```

### Características
```
✅ Nomes mondospace (fácil copiar)
✅ Timestamps em formato brasileiro
✅ Ícones visuais (📄, 📅, 💾, 🌐)
✅ Cores: Verde (download), Vermelho (deletar)
✅ Hover effect nas linhas
✅ Quando selecionado: background azul claro
```

---

## ⚙️ Funções Internas

### `salvarXMLsNoHistorico(arquivos)`
```
Quando: Após buscar XMLs
Faz:
├─ Pega histórico atual
├─ Adiciona novos XMLs
├─ Limite: últimos 100
└─ Chama carregarHistorico()
```

### `carregarHistorico()`
```
Quando: Page load, após salvar, após deletar
Faz:
├─ Obtém XMLs do localStorage
├─ Renderiza na tela
└─ Se vazio: mostra mensagem
```

### `selectAllXMLs()`
```
Marca todos os checkboxes
```

### `deselectAllXMLs()`
```
Desmarca todos os checkboxes
```

### `downloadSelectedXMLs()`
```
1. Pega XMLs selecionados
2. Gera ZIP com JSZip
3. Baixa arquivo
```

### `downloadXMLUnitario(xmlId)`
```
1. Procura XML por ID
2. Gera blob
3. Baixa direto
```

### `deletarXMLDoHistorico(xmlId)`
```
1. Pede confirmação
2. Remove do array
3. Salva localStorage
4. Recarrega lista
```

### `clearHistory()`
```
1. Pede confirmação
2. Limpa localStorage
3. Recarrega lista vazia
```

---

## 🔒 Limitações

```
✅ Max 100 XMLs armazenados
✅ localStorage ~5-10MB por domínio
✅ Persiste até limpar cache do navegador
✅ Backup manual: exportar historico.json
```

---

## 🆘 Troubleshooting

### XMLs não aparecem no histórico?
```
Solução:
1. Abra DevTools (F12)
2. Console
3. localStorage.getItem('xmlHistorico')
4. Se null, refresque e busque novamente
```

### Não consegue baixar em ZIP?
```
Solução:
1. Aguarde o carregamento de `JSZip`
2. Ou tente download unitário
3. Ou tente outro navegador
```

### Histórico desapareceu?
```
Causas:
• Limpou cache do navegador
• Limpou localStorage
• Clicou "Limpar Histórico"

Solução:
• Não há backup automático
• Faça as buscas novamente
```

---

## 💡 Dicas

### 1. Backup Manual
```javascript
// Cole no Console do DevTools
const backup = localStorage.getItem('xmlHistorico')
copy(backup)
// Salve em um arquivo .json
```

### 2. Restaurar
```javascript
// Cole no Console
localStorage.setItem('xmlHistorico', 'COPIE_AQUI_DEPOIS')
location.reload()
```

### 3. Estatísticas
```javascript
// Verifique quantos XMLs tem
const xmls = JSON.parse(localStorage.getItem('xmlHistorico') || '[]')
console.log(`Total de XMLs: ${xmls.length}`)
```

---

## 🎯 Casos de Uso

### 1. Auditor de NFe
```
Busca 50 notas
Histórico armazena tudo
Pode baixar novamente sem pagar
```

### 2. Contador
```
Busca X e Y NFe
Guarda no histórico
Meses depois: baixa de novo
```

### 3. Operador
```
Seleciona 10 XMLs
Baixa todos em 1 ZIP
Compartilha com gerente
```

---

## ✅ Recursos Implementados

- [x] Armazenar XMLs no localStorage
- [x] Listar histórico com detalhes
- [x] Selecionar/desselecionar
- [x] Baixar selecionados em ZIP
- [x] Baixar unitário
- [x] Deletar individual
- [x] Limpar histórico
- [x] Ícones e cores visuais
- [x] Data e hora de cada busca
- [x] Identificação de origem (API/Cache)
- [x] Limite de 100 XMLs

---

## 🚀 Próximas Melhorias

- [ ] Filtro por data
- [ ] Busca por nome de arquivo
- [ ] Ordenar por data/nome
- [ ] Exportar para CSV
- [ ] Upload de XMLs manualmente
- [ ] Cloud storage (backup automático)
- [ ] Sincronizar entre dispositivos

---

## 📝 Resumo

O **Módulo de Histórico de XMLs** oferece:
```
✅ Armazenamento persistente
✅ Acesso rápido a XMLs anteriores
✅ Download em lote ou unitário
✅ Organização visual
✅ Sem custos adicionais
```

**Usuários nunca mais precisarão buscar o mesmo XML 2x!** 🎉
