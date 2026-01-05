import express from 'express';
import * as announcementQuery from '../queries/announcement.query.js';
import * as notificationQuery from "../queries/notifications.query.js";
import * as tokenQuery from '../queries/token.query.js';
import * as helper from '../utils/helper.js'
import admin from '../middlewares/firebase.js'

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const query = await announcementQuery.getAllAnnouncements();
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/get-by-id', async (req, res) => {
    const { id } = req.query;
    try {
        const query = await announcementQuery.getAnnouncementById(id);
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/get-by-audience', async (req, res) => {
    const { role } = req.query;
    try {
        const query = await announcementQuery.getAnnouncementsByRole(role);
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.post('/create', async (req, res) => {
    const announcement = req.body;
    try {
        const role = announcement.audience;
        const query = await announcementQuery.createAnnouncement(announcement);
        
        let tokens;
        let userIds;
        if (role == "all") {
            userIds = await helper.getAllUserIds();
            tokens = await tokenQuery.getAllTokens();

            for (const id of userIds) {
                await notificationQuery.createNotification({
                    recipient_id: id,
                    recipient_role: role,
                    sender_id: null,
                    type: "ANNOUNCEMENT",
                    content: "A new announcement has been posted! Go check it out.",
                })
            }

            if (tokens.length === 0) {
                return res.json({
                    success: true,
                    message: "Announcement created but no FCM tokens found.",
                    announcement: query
                });
            }

            const payload = {
                tokens: tokens,
                notification: {
                    title: "New Announcement",
                    body: announcement.title || "A new announcement was posted",
                },
                data: {
                    screen: "announcement",
                    announcementId: String(query.id),
                }
            };

            const response = await admin.messaging().sendEachForMulticast(payload);
            console.log("FCM RESPONSE:", JSON.stringify(response, null, 2));
            console.log("FCM ERROR DETAILS:", response.responses[0].error);
        }

        if (role == "job_seeker") {
            userIds = await helper.getUserIdsByRole(role);
            tokens = await tokenQuery.getTokensByRole(role);
            for (const id of userIds) {
                await notificationQuery.createNotification({
                    recipient_id: id,
                    recipient_role: role,
                    sender_id: null,
                    type: "ANNOUNCEMENT",
                    content: "A new announcement has been posted! Go check it out.",
                })
            }

            if (tokens.length === 0) {
                return res.json({
                    success: true,
                    message: "Announcement created but no FCM tokens found.",
                    announcement: query
                });
            }

            const payload = {
                tokens: tokens,
                notification: {
                    title: "New Announcement",
                    body: announcement.title || "A new announcement was posted",
                },
                data: {
                    screen: "announcement",
                    announcementId: String(query.id),
                }
            };

            const response = await admin.messaging().sendEachForMulticast(payload);
            console.log("FCM RESPONSE:", JSON.stringify(response, null, 2));
            console.log("FCM ERROR DETAILS:", response.responses[0].error);
        }

        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.patch('/update', async (req, res) => {
    const announcement = req.body;
    try {
        const query = await announcementQuery.updateAnnouncement(announcement);
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.delete('/delete', async (req, res) => {
    const { id } = req.query;
    try {
        const query = await announcementQuery.deleteAnnouncement(id);
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;