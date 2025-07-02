import express from 'express';
import * as userQuery from '../queries/user.query.js';

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const users = await userQuery.getUsers();
        res.json(users);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/:id', async (req, res) => {
    try {
        const user = await userQuery.getUserById(req.params.id);
        if (!user) {
            res.status(404).json({ message: `No user with id ${req.params.id}` })
        }
        res.json(user);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/role/:role', async (req, res) => {
    try {
        const users = await userQuery.getUserByRole(req.params.role);
        res.json(users);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/count/:table', async (req, res) => {
    try {
        const count = await userQuery.getUsersCount(req.params.table);
        res.json(count);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;