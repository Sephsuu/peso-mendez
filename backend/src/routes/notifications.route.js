import express from 'express';
import * as notificationQuery from '../queries/notifications.query.js';

const router = express.Router();

router.post('/create', async (req, res) => {
	const notification = req.body;
	try {
		const query = await notificationQuery.createNotification(notification);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

export default router;