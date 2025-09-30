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

router.get('/get-by-id', async (req, res) => {
	const { id } = req.query;
    try {
        const job = await jobQuery.getJobById(id);
        if (!job) {
            res.status(404).json({ message: `No job with id ${id}` })
        }
        res.json(job);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.get('/get-by-employer', async (req, res) => {
	const { id } = req.query;
    try {
			const jobs = await jobQuery.getJobsByEmployer(id);
			res.json(jobs);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
})

router.get('/get-all-saved-jobs-by-user', async (req, res) => {
    const { userId } = req.query;
    try {
        const query = await jobQuery.getAllSavedJobsByUserJob(userId);
        return res.json(query);
    } catch (err) {
        return res.status(500).json({ error: err.message });
    }
})

router.get('/get-saved-job-by-user-job', async (req, res) => {
    const { userId, jobId } = req.query;
    try {
        const job = await jobQuery.getSavedJobByUserJob(userId, jobId);
        res.json(job);
    } catch(err) {
        res.status(500).json({ error: err.message });
    }
})

router.post('/create', async (req, res) => {
    try {
        const job = req.body;
        const query = await jobQuery.createJob(job);
        return res.json(job);
    } catch(err) {
        res.status(500).json({ error: err.message });
    }
});

router.post('/save-job', async (req, res) => {
    const { userId, jobId } = req.query;
    try {
        const job = await jobQuery.saveJob(userId, jobId);
        return res.json(job);
    } catch(err) {
        res.status(500).json({ error: err.message });
    }
});

router.patch('/update', async (req, res) => {
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

router.delete('/delete', async (req, res) => {
	const { id } = req.query;
	try {
		const data = await jobQuery.deleteJob(id);
		res.json(data);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
});

export default router;