import express from 'express';
import * as announcementQuery from '../queries/announcement.query.js';
import * as tokenQuery from '../queries/token.query.js';
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
        const query = await announcementQuery.createAnnouncement(announcement);
        console.log(query);
        
        const tokensRes = await tokenQuery.getAllTokens();
        const tokens = tokensRes.map(r => r.token);

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

        // Send to all devices
        await admin.messaging().sendEachForMulticast(payload);
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