import express from 'express';
import * as notificationQuery from '../queries/notifications.query.js';

const router = express.Router();

router.post('/get-by-role', async (req, res) => {
	const { role, userId } = req.body;
	try {
		const query = await notificationQuery.getNotificationsByRole(role, userId);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

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