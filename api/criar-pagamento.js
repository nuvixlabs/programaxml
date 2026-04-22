const axios = require('axios');
const MERCADO_PAGO_API = 'https://api.mercadopago.com/v1';

module.exports = async (req, res) => {
    const { valor, usuario_id } = req.body;
    try {
        const response = await axios.post(`${MERCADO_PAGO_API}/payments`, {
            transaction_amount: valor,
            description: `Recarga de créditos MeuDanfe`,
            payment_method_id: 'pix',
            payer: {
                email: 'usuario@meudanfe.com.br'
            },
            external_reference: usuario_id
        }, {
            headers: {
                'Authorization': `Bearer ${process.env.MERCADO_PAGO_TOKEN}`,
                'Content-Type': 'application/json'
            }
        });
        return res.status(200).json({
            qr_code: response.data.point_of_interaction.transaction_data.qr_code,
            payment_id: response.data.id,
            status: response.data.status
        });
    } catch (error) {
        console.error('Error creating payment:', error.message);
        return res.status(400).json({ erro: error.message });
    }
};