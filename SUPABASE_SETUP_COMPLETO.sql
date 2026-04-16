-- 🔐 MeuDanfe - SQL Setup Completo para Supabase
-- Execute este script NO SQL EDITOR do Supabase
-- ============================================

-- ============================================
-- 1️⃣ TABELA DE USUÁRIOS
-- ============================================
CREATE TABLE IF NOT EXISTS usuarios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  nome TEXT,
  creditos DECIMAL(10, 2) DEFAULT 0,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 2️⃣ TABELA DE HISTÓRICO DE XMLs (COM EXPIRAÇÃO 24H)
-- ============================================
DROP TABLE IF EXISTS consultas_xml CASCADE;

CREATE TABLE IF NOT EXISTS consultas_xml (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  chave_acesso TEXT NOT NULL,
  xml_conteudo TEXT,
  data_consulta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP DEFAULT (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
  custou_credito DECIMAL(10, 2) DEFAULT 0.15,
  origem TEXT DEFAULT 'api'
);

-- ============================================
-- 3️⃣ TABELA DE TRANSAÇÕES DE CRÉDITOS
-- ============================================
CREATE TABLE IF NOT EXISTS transacoes_creditos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  tipo TEXT NOT NULL,
  valor DECIMAL(10, 2) NOT NULL,
  saldo_anterior DECIMAL(10, 2),
  saldo_novo DECIMAL(10, 2),
  descricao TEXT,
  data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 4️⃣ ÍNDICES PARA PERFORMANCE
-- ============================================
CREATE INDEX IF NOT EXISTS idx_consultas_xml_user_id ON consultas_xml(user_id);
CREATE INDEX IF NOT EXISTS idx_consultas_xml_expires_at ON consultas_xml(expires_at);
CREATE INDEX IF NOT EXISTS idx_consultas_xml_data ON consultas_xml(data_consulta DESC);
CREATE INDEX IF NOT EXISTS idx_transacoes_user_id ON transacoes_creditos(user_id);
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);

-- ============================================
-- 5️⃣ FUNÇÃO PARA DELETAR XMLs EXPIRADOS
-- ============================================
CREATE OR REPLACE FUNCTION deletar_xmls_expirados()
RETURNS INTEGER AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  DELETE FROM consultas_xml WHERE expires_at < CURRENT_TIMESTAMP;
  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 6️⃣ ATIVAR RLS (Row Level Security)
-- ============================================
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE consultas_xml ENABLE ROW LEVEL SECURITY;
ALTER TABLE transacoes_creditos ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 7️⃣ POLICIES DE SEGURANÇA
-- ============================================

-- Policies para usuarios
CREATE POLICY "Usuários podem ler seus próprios dados"
  ON usuarios FOR SELECT
  USING (auth.uid() = id OR is_admin = TRUE);

CREATE POLICY "Usuários podem atualizar seus próprios dados"
  ON usuarios FOR UPDATE
  USING (auth.uid() = id);

-- Policies para consultas_xml
CREATE POLICY "Usuários podem ler suas próprias consultas"
  ON consultas_xml FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem inserir suas próprias consultas"
  ON consultas_xml FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem deletar suas próprias consultas"
  ON consultas_xml FOR DELETE
  USING (auth.uid() = user_id);

-- Policies para transacoes_creditos
CREATE POLICY "Usuários podem ler suas próprias transações"
  ON transacoes_creditos FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem inserir suas próprias transações"
  ON transacoes_creditos FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- 8️⃣ INSERIR USUÁRIO ADMIN
-- ============================================
INSERT INTO usuarios (email, nome, creditos, is_admin)
VALUES ('matheus.transportesirmaos@gmail.com', 'Admin MeuDanfe', 500.00, TRUE)
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- ✅ SETUP COMPLETO!
-- ============================================
-- ✓ Tabela usuarios - Gerencia usuários e créditos
-- ✓ Tabela consultas_xml - Histórico com expiração 24h
-- ✓ Tabela transacoes_creditos - Log de transações
-- ✓ Índices criados para performance
-- ✓ Função para limpeza de XMLs expirados
-- ✓ RLS (Row Level Security) ativado
-- ✓ Policies de segurança configuradas
-- ✓ Usuário admin criado com 500 créditos
-- 
-- 🎉 Pronto para usar!
-- ============================================
