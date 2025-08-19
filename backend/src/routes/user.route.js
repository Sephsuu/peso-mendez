
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

router.get('/get-by-id', async (req, res) => {
	const { id } = req.query;
	try {
		const user = await userQuery.getUserById(id);
		if (!user) {
			res.status(404).json({ message: `No user with id ${id}` })
		}
		res.json(user);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
});

router.get('/get-by-role', async (req, res) => {
	const { role } = req.query;
	try {
		const users = await userQuery.getUserByRole(role);
		res.json(users);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
});

router.post('/create-personal-info', async (req, res) => {
	const personalInfo = req.body;
	try {
		const query = await userQuery.createPersonalinformation(personalInfo);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
});

router.post('/create-job-ref', async (req, res) => {
	const jobRef = req.body;
	try {
		const query = await userQuery.createJobReference(jobRef);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/deactivate', async (req, res) => {
	const { id } = req.query;
	try {
		const user = await userQuery.deactivateUser(id);
		res.json(user);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

export default router;