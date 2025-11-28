import express from 'express';
import * as messageQuery from '../queries/message.query.js';

const router = express.Router();

router.get('/get-conversations', async (req, res) => {
    const { userId } = req.query;
    try {
        const query = await messageQuery.getConversationsByUser(userId);
        res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.get('/get-messages', async (req, res) => {
    const { userId, otherId } = req.query;
    try {
        const query = await messageQuery.getMessages(userId, otherId);
        res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.post('/create', async (req, res) => {
    const { userId, otherId, message } = req.body;
    try {
        const query = await messageQuery.createMessage(userId, otherId, message);
        res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

export default router;