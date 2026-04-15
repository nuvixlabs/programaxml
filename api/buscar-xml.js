import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
)

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).send('Method not allowed')
  }

  const { chaves, user_id } = req.body

  if (!chaves || !user_id) {
    return res.status(400).json({ erro: 'chaves e user_id são obrigatórios' })
  }

  let arquivos = []
  let custoTotal = 0

  // Pegar créditos do usuário
  const { data: user } = await supabase
    .from('usuarios')
    .select('creditos')
    .eq('id', user_id)
    .single()

  if (!user) {
    return res.status(404).json({ erro: 'Usuário não encontrado' })
  }

  let creditos = user.creditos

  for (let chave of chaves) {
    if (!chave.trim()) continue

    // 💾 CACHE: Verificar se já existe XML salvo com sucesso
    const { data: xmlCacheado } = await supabase
      .from('consultas_xml')
      .select('*')
      .eq('usuario_id', user_id)
      .eq('chave', chave)
      .eq('status', 'SUCESSO')
      .limit(1)
      .single()

    if (xmlCacheado) {
      // XML já existe em cache - NÃO COBRAR
      console.log(`[CACHE HIT] Chave: ${chave}`)
      arquivos.push({
        nome: `${chave}.xml`,
        conteudo: xmlCacheado.conteudo || 'XML em cache (dados não armazenados)',
        origem: 'cache'
      })
      continue
    }

    // Se não tem cache e não tem crédito, pular
    if (creditos < 0.15) {
      await supabase.from('consultas_xml').insert({
        usuario_id: user_id,
        chave,
        status: 'SEM_CREDITO',
        custo: 0
      })
      continue
    }

    // Buscar XML da API externa
    try {
      const response = await fetch(
        `https://api.meudanfe.com.br/v2/fd/get/xml/${chave}`,
        {
          headers: { 'Api-Key': process.env.API_KEY }
        }
      )

      if (response.status === 200) {
        const json = await response.json()

        arquivos.push({
          nome: `${chave}.xml`,
          conteudo: json.data,
          origem: 'api'
        })

        creditos -= 0.15
        custoTotal += 0.15

        await supabase.from('consultas_xml').insert({
          usuario_id: user_id,
          chave,
          status: 'SUCESSO',
          custo: 0.15,
          conteudo: json.data
        })
      } else {
        await supabase.from('consultas_xml').insert({
          usuario_id: user_id,
          chave,
          status: 'ERRO',
          custo: 0
        })
      }
    } catch (error) {
      console.error(`Erro ao buscar ${chave}:`, error)
      await supabase.from('consultas_xml').insert({
        usuario_id: user_id,
        chave,
        status: 'ERRO',
        custo: 0
      })
    }
  }

  // Atualizar créditos
  await supabase
    .from('usuarios')
    .update({ creditos })
    .eq('id', user_id)

  return res.json({
    sucesso: true,
    arquivos,
    custoTotal,
    creditosRestantes: creditos
  })
}
