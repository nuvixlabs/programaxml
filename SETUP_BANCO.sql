-- 🔒 SUPABASE SQL - Executar no SQL Editor

CREATE TABLE usuarios (
    id uuid PRIMARY KEY,
    creditos numeric DEFAULT 0
);

CREATE TABLE consultas_xml (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id uuid,
    chave text,
    status text,
    custo numeric,
    data timestamp DEFAULT now()
);

-- Índices para melhor performance
CREATE INDEX idx_consultas_usuario ON consultas_xml(usuario_id);
CREATE INDEX idx_consultas_chave ON consultas_xml(chave);
CREATE INDEX idx_consultas_status ON consultas_xml(status);

-- IMPORTANTE: O id da tabela usuarios será preenchido com auth.uid()
-- Quando criar um usuário no Supabase Auth, execute:
-- INSERT INTO usuarios (id, creditos) VALUES (auth.uid(), 0);
