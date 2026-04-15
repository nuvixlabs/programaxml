-- 💰 GERENCIAR CRÉDITOS - SQL Commands para Supabase

-- ✅ ADICIONAR CRÉDITOS (50 reais = 50 ÷ 0.15 = 333 buscas)
UPDATE usuarios SET creditos = creditos + 50 WHERE id = 'USER_ID';

-- 💳 VER CRÉDITOS DE UM USUÁRIO
SELECT id, creditos FROM usuarios WHERE id = 'USER_ID';

-- 📋 LISTAR TODOS OS USUÁRIOS E CRÉDITOS
SELECT id, creditos FROM usuarios ORDER BY creditos DESC;

-- 🔍 VER HISTÓRICO DE CONSULTAS
SELECT 
    usuario_id,
    chave,
    status,
    custo,
    data
FROM consultas_xml 
WHERE usuario_id = 'USER_ID' 
ORDER BY data DESC;

-- 💵 RECEITA TOTAL (só sucessos)
SELECT SUM(custo) as receita_total FROM consultas_xml WHERE status = 'SUCESSO';

-- 📊 ESTATÍSTICAS
SELECT 
    COUNT(*) as total_consultas,
    COUNT(CASE WHEN status = 'SUCESSO' THEN 1 END) as sucessos,
    COUNT(CASE WHEN status = 'ERRO' THEN 1 END) as erros,
    COUNT(CASE WHEN status = 'SEM_CREDITO' THEN 1 END) as sem_credito,
    ROUND(SUM(custo)::numeric, 2) as receita_total
FROM consultas_xml;

-- 🎯 TOP 10 USUÁRIOS POR CONSUMO
SELECT 
    usuario_id,
    COUNT(*) as consultas,
    ROUND(SUM(custo)::numeric, 2) as gasto_total
FROM consultas_xml
WHERE status = 'SUCESSO'
GROUP BY usuario_id
ORDER BY gasto_total DESC
LIMIT 10;

-- 🔄 RESETAR CRÉDITOS (usar com cuidado!)
UPDATE usuarios SET creditos = 0 WHERE id = 'USER_ID';

-- 🗑️ DELETAR HISTÓRICO DE UM USUÁRIO
DELETE FROM consultas_xml WHERE usuario_id = 'USER_ID';

-- 🔐 CRIAR NOVO USUÁRIO "MANUAL"
-- (Depois de criar no Authentication)
INSERT INTO usuarios (id, creditos) 
VALUES ('copy-uuid-from-auth', 500);

-- 📈 CHAVES MAIS BUSCADAS
SELECT 
    chave,
    COUNT(*) as vezes_buscada,
    COUNT(CASE WHEN status = 'SUCESSO' THEN 1 END) as sucessos
FROM consultas_xml
GROUP BY chave
ORDER BY COUNT(*) DESC
LIMIT 20;

-- ❌ ENCONTRAR USUÁRIOS SEM CRÉDITO
SELECT 
    id,
    creditos
FROM usuarios 
WHERE creditos < 0.15
ORDER BY creditos DESC;

-- 💤 USUÁRIOS INATIVOS (sem buscas nos últimos 7 dias)
SELECT 
    u.id,
    u.creditos,
    COALESCE(MAX(c.data), 'nunca') as ultima_busca
FROM usuarios u
LEFT JOIN consultas_xml c ON u.id = c.usuario_id
GROUP BY u.id, u.creditos
HAVING MAX(c.data) IS NULL OR MAX(c.data) < NOW() - INTERVAL '7 days'
ORDER BY u.creditos DESC;

-- 🛠️ USAR TRIGGERS PARA AUTO-CRIAR USUÁRIO AO REGISTRAR
-- (Executar só uma vez)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger as $$
begin
  insert into public.usuarios (id, creditos)
  values (new.id, 0);
  return new;
end;
$$ language plpgsql security definer;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 📅 FATURAMENTO DIÁRIO
SELECT 
    DATE(data) as data,
    COUNT(*) as consultas,
    COUNT(CASE WHEN status = 'SUCESSO' THEN 1 END) as sucessos,
    ROUND(SUM(custo)::numeric, 2) as receita
FROM consultas_xml
GROUP BY DATE(data)
ORDER BY data DESC;
