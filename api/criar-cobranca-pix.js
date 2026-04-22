// api/criar-cobranca-pix.js

const mercadopago = require('mercadopago');

// Configure the SDK with your credentials
mercadopago.configure({
  access_token: 'YOUR_ACCESS_TOKEN'
});

const createPixPayment = async (paymentData) => {
  try {
    const preference = await mercadopago.preferences.create({
      items: [{
        title: paymentData.title,
        unit_price: paymentData.amount,
        quantity: 1,
      }],
      payment_methods: {
        excluded_payment_types: [{
          id: 'ticket' // Exclude other payment types if necessary
        }],
      },
      back_urls: {
        success: paymentData.success_url,
        failure: paymentData.failure_url,
        pending: paymentData.pending_url,
      },
      auto_return: 'approved',
    });

    console.log('Payment Preference ID:', preference.body.id);

    return preference.body;
  } catch (error) {
    console.error('Error creating payment:', error);
    throw error;
  }
};

module.exports = { createPixPayment };