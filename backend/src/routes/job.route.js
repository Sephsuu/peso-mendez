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

router.get('/employer-jobs/:employerId', async (req, res) => {
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
});

router.get('/employer/title/:employerId', async (req, res) => {
    try {
        const jobs = await jobQuery.getJobTitleByEmployer(req.params.employerId);
        const titles = jobs.map(job => job.title);
        res.json(titles);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/employer/location/:employerId', async (req, res) => {
    try {
        const jobs = await jobQuery.getJobLocationByEmployer(req.params.employerId);
        const locations = jobs.map(job => job.location);
        res.json(locations);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.put('/update-job', async (req, res) => {
    try {
        const {
            title,
            company,
            location,
            type,
            salary,
            visibility,
            description,
            id,
        } = req.body;
        const job = await jobQuery.updateJob(id, title, company, location, type, salary, visibility, description);
        return res.json(job);
    } catch(err) {
        res.status(500).json({ error: err.message });
    }
});

router.delete('/delete-job/:id', async (req, res) => {
    try {
        const data = await jobQuery.deleteJob(req.params.id);
        res.json(data);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;