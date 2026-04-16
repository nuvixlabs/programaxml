-- 🔐 MeuDanfe - SQL Setup para Supabase
-- Execute este script no SQL Editor do Supabase

-- Tabela de Usuários
CREATE TABLE IF NOT EXISTS usuarios (
  id UUID PRIMARY KEY DEFAULT auth.uid(),
  email TEXT UNIQUE NOT NULL,
  nome TEXT,
  creditos DECIMAL(10, 2) DEFAULT 0,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Histórico de XMLs
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

-- Index para deletar automaticamente XMLs expirados
CREATE INDEX IF NOT EXISTS idx_consultas_xml_expires_at ON consultas_xml(expires_at);

-- Função para deletar XMLs expirados (executar periodicamente)
CREATE OR REPLACE FUNCTION deletar_xmls_expirados()
RETURNS void AS $$
BEGIN
  DELETE FROM consultas_xml WHERE expires_at < CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- Tabela de Transações de Créditos
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

-- Ativar RLS (Row Level Security)
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE consultas_xml ENABLE ROW LEVEL SECURITY;
ALTER TABLE transacoes_creditos ENABLE ROW LEVEL SECURITY;

-- Policies para usuarios
CREATE POLICY "Usuários podem ler seus próprios dados"
  ON usuarios FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Admin pode ler todos os usuários"
  ON usuarios FOR SELECT
  USING (auth.uid() IN (SELECT id FROM usuarios WHERE is_admin = TRUE));

-- Policies para consultas_xml
CREATE POLICY "Usuários podem ler suas próprias consultas"
  ON consultas_xml FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem inserir suas próprias consultas"
  ON consultas_xml FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policies para transacoes_creditos
CREATE POLICY "Usuários podem ler suas próprias transações"
  ON transacoes_creditos FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem inserir suas próprias transações"
  ON transacoes_creditos FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- 👤 Inserir usuário admin
INSERT INTO usuarios (id, email, nome, creditos, is_admin)
VALUES (
  'admin-meudanfe-001', 
  'matheus.transportesirmaos@gmail.com', 
  'Admin MeuDanfe', 
  500.00, 
  TRUE
)
ON CONFLICT (email) DO UPDATE SET
  creditos = 500.00,
  is_admin = TRUE;

-- ✅ Tudo pronto!
COMMIT;
