import express from 'express';
import * as jobQuery from '../queries/job.query.js';

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const jobs = await jobQuery.getJobs();
        return res.json(jobs);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.get('/:id', async (req, res) => {
    try {
        const job = await jobQuery.getJobById(req.params.id);
        if (!job) {
            res.status(404).json({ message: `No job with id ${req.params.id}` })
        }
        res.json(job);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.post('/', async (req, res) => {
    try {
        const { title, company, location, salary, type, description, employerId, visibility } = req.body;

        if ( !title, !company, !location, !salary, !type, !description, !employerId, !visibility) {
            return res.status(400).json({ error: 'Missing required fields' });
        }

        const job = await jobQuery.createJob(title, company, location, salary, type, description, employerId, visibility);
        res.status(201).json({ message: 'Job created successfully', job });
    } catch (err) {
        console.log(err);
    }
})

router.get('/employer/:employerId', async (req, res) => {
    try {
        const jobs = await jobQuery.getJobsByEmployerId(req.params.employerId);
        res.json(jobs);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.get('/employer/count/:employerId', async (req, res) => {
    try {
        const rawCount = await jobQuery.getJobsByEmployerIdCount(req.params.employerId);
        const count = rawCount[0][0]['COUNT(*)'];
        res.json({ count: count });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

export default router;