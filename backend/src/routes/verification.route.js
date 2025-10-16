import express from 'express';
import * as verificationQuery from '../queries/verification.query.js'

const router = express.Router();

router.get('', async  (req, res) => {
    const { role } = req.query;
    try {
        const query = await verificationQuery.getVerifications(role);
        return res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.get('/get-by-user', async(req, res) => {
    const { id } = req.query;
    try {
        const query = await verificationQuery.getVerificationByUser(id);
        return res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.post('/create', async (req, res) => {
    const verification = req.body;
    console.log(verification);
    
    try {
        const query = await verificationQuery.createVerification(verification);
        return res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.patch('/update-status', async (req, res) => {
    const { id, status } = req.query;
    console.log(id, status);
    
    try {
        const query = await verificationQuery.updateStatus(id, status);
        return res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

export default router;