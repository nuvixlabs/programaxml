<!-- 🧠 FRONTEND ALTERNATIVO - Sem dependências externas -->
<!-- Use isso se tiver problema com CDN do Supabase -->

<!DOCTYPE html>
<html>
<head>
    <title>XML Busca - Versão Offline</title>
    <style>
        body { font-family: Arial; padding: 20px; max-width: 600px; margin: 0 auto; }
        input, textarea, button { width: 100%; padding: 10px; margin: 5px 0; font-size: 14px; }
        button { background: #667eea; color: white; border: none; cursor: pointer; border-radius: 5px; }
        button:hover { background: #5568d3; }
        .info { background: #f0f0f0; padding: 10px; margin: 10px 0; border-radius: 5px; }
    </style>
</head>
<body>

<h1>🔍 Buscar XML</h1>

<div class="info">
    <strong>📌 IMPORTANTE:</strong><br>
    Esta é uma versão simplificada. Para produção, use o arquivo index.html completo.
</div>

<h2>Login</h2>
<input type="email" id="email" placeholder="email@exemplo.com">
<input type="password" id="senha" placeholder="senha">
<button onclick="fazerLogin()">Login</button>

<h2>Buscar XMLs</h2>
<textarea id="chaves" placeholder="Cole chaves aqui (uma por linha)"></textarea>
<button onclick="buscarXMLs()">Buscar</button>

<div id="resultado"></div>

<script>
// ⚠️ CONFIGURE ESSAS VARIÁVEIS
const API_URL = 'https://seu-projeto.vercel.app/api/buscar-xml'
const SUPABASE_URL = 'https://seu-projeto.supabase.co'
const ANON_KEY = 'sua_chave_publica'

let usuarioLogado = null

async function fazerLogin() {
    const email = document.getElementById('email').value
    const senha = document.getElementById('senha').value
    
    if (!email || !senha) {
        alert('Preencha email e senha')
        return
    }
    
    try {
        // NOTA: Isso é uma simulação. Para autenticação real, use Supabase Auth
        usuarioLogado = { email, id: 'temp-user-id' }
        alert(`Login bem-sucedido para ${email}`)
    } catch (e) {
        alert('Erro no login: ' + e.message)
    }
}

async function buscarXMLs() {
    if (!usuarioLogado) {
        alert('Faça login primeiro')
        return
    }
    
    const chaves = document.getElementById('chaves').value
        .split('\n')
        .filter(c => c.trim())
    
    if (chaves.length === 0) {
        alert('Cole as chaves first')
        return
    }
    
    try {
        const res = await fetch(API_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                chaves,
                user_id: usuarioLogado.id
            })
        })
        
        const data = await res.json()
        
        let html = `<h3>✅ Resultado:</h3>`
        html += `<p>Encontrados: ${data.arquivos.length} XML(s)</p>`
        html += `<p>Custo: R$ ${data.custoTotal.toFixed(2)}</p>`
        html += `<p>Créditos restantes: R$ ${data.creditosRestantes.toFixed(2)}</p>`
        
        document.getElementById('resultado').innerHTML = html
    } catch (e) {
        document.getElementById('resultado').innerHTML = `<p style="color: red;">❌ Erro: ${e.message}</p>`
    }
}
</script>

</body>
</html>

---

## 🔗 INTEGRATION EXAMPLES

### 1. SLACK BOT
```javascript
// Notificar quando alguém compra XML
const slack_webhook = 'https://hooks.slack.com/services/...'

await fetch(slack_webhook, {
    method: 'POST',
    body: JSON.stringify({
        text: `✅ Nova compra: ${chaves.length} XMLs por R$ ${custoTotal}`
    })
})
```

### 2. WEBHOOK PARA PAGAMENTO
```javascript
// Quando crédito acabar, poderia disparar pagamento automático
if (creditos < 1) {
    await fetch('/webhook/pagamento-necessario', {
        method: 'POST',
        body: JSON.stringify({ user_id, creditos_necessarios: 50 })
    })
}
```

### 3. BUSCADOR AUTOMATIZADO (CRON)
```javascript
// Em background job, buscar XMLs automaticamente
const usuarios = await supabase.from('usuarios').select('*')
for (let user of usuarios.data) {
    const chaves = await minhaFuncaoBuscaChaves()
    await fetch('/api/buscar-xml', {
        method: 'POST',
        body: JSON.stringify({ chaves, user_id: user.id })
    })
}
```

### 4. DASHBOARD DE ANALYTICS
```sql
-- Quanto cada usuário gastou
SELECT 
    u.id,
    COUNT(*) as consultas,
    SUM(c.custo) as total_gasto,
    MAX(c.data) as ultima_consulta
FROM usuarios u
LEFT JOIN consultas_xml c ON u.id = c.usuario_id
GROUP BY u.id
ORDER BY total_gasto DESC
```

### 5. SISTEMA DE REFERRAL
```sql
-- Dar bônus se trouxer novo cliente
ALTER TABLE usuarios ADD COLUMN referrer_id uuid;
UPDATE usuarios SET creditos = creditos + 10 WHERE id IN (
    SELECT referrer_id FROM usuarios WHERE referrer_id IS NOT NULL
)
```

---

## 📱 MOBILE APP (React Native)
```javascript
import { supabase } from './supabaseClient'

export function BuscarXML() {
    const [chaves, setChaves] = useState('')
    const [loading, setLoading] = useState(false)
    
    const buscar = async () => {
        setLoading(true)
        const { data: { user } } = await supabase.auth.getUser()
        
        const res = await fetch('https://seu-backend/api/buscar-xml', {
            method: 'POST',
            body: JSON.stringify({
                chaves: chaves.split('\n'),
                user_id: user.id
            })
        })
        
        const result = await res.json()
        setLoading(false)
        Alert.alert('Sucesso', `Custo: R$ ${result.custoTotal}`)
    }
    
    return (
        <View>
            <TextInput onChange={(e) => setChaves(e.text)} />
            <Button onPress={buscar} disabled={loading} title="Buscar" />
        </View>
    )
}
```

---

## 🛒 WORDPRESS PLUGIN
```php
<?php
// plugin.php
// Adicionar botão em WooCommerce para buscar XML de pedidos automaticamente

add_action('woocommerce_order_status_completed', function($order_id) {
    $order = wc_get_order($order_id);
    $nfe_chave = $order->get_meta('chave_nfe'); // Meta do pedido
    
    wp_remote_post('https://seu-backend/api/buscar-xml', array(
        'body' => json_encode([
            'chaves' => [$nfe_chave],
            'user_id' => $order->get_user_id()
        ])
    ));
});
?>
```

---

## 🤖 AUTOMAÇÃO COM ZAPIER
1. Trigger: Form de contato preenchido
2. Action: POST para `/api/buscar-xml`
3. Action: Email com XML para cliente

---

## 💡 IDEIAS PARA MONETIZAR
- Adicionar `free_credits` por mês
- Plano PREMIUM com desconto (0,10 em vez de 0,15)
- Reseller - deixar outras pessoas venderem seus créditos
- API pública para terceiros
