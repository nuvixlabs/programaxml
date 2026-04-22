const express = require('express');
const bodyParser = require('body-parser');
const router = express.Router();

router.use(bodyParser.json());

router.post('/webhook-pagamento', (req, res) => { 
    const event = req.body;
    console.log('Received webhook event:', event);
    
    if (event.type === 'payment') {
        const paymentId = event.data.id;
        const status = event.data.status;
        console.log(`Payment ${paymentId} status: ${status}`);
        
        if (status === 'approved') {
            console.log('Payment approved! Credit user.');
        }
    }
    
    res.status(200).json({ok: true});
});

module.exports = router;