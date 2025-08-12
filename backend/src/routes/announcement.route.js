import express from 'express';
import * as announcementQuery from '../queries/announcement.query.js';

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

router.post('/create', async (req, res) => {
    const announcement = req.body;
    try {
        const query = await announcementQuery.createAnnouncement(announcement);
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