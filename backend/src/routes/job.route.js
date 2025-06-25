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

export default router;