import express from 'express';
import * as jobQuery from '../queries/job.query.js';
import * as tokenQuery from '../queries/token.query.js';
import * as helper from '../utils/helper.js'
import * as notificationQuery from "../queries/notifications.query.js";
import admin from '../middlewares/firebase.js'

const router = express.Router();

router.get('/', async (req, res) => {
	try {
		const jobs = await jobQuery.getJobs();
		return res.json(jobs);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.get('/get-recommended', async (req, res) => {
    const { id } = req.query;
    try {
        const query = await jobQuery.getRecommendedJobs(id);
        return res.json(query);
    } catch (err) {
        return res.status(500).json({ error: err.message });
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

router.get('/get-job-skills', async (req, res) => {
	const { id } = req.query;
    try {
        const job = await jobQuery.getJobSkills(id);
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
    const { id } = req.query;
    try {
        const query = await jobQuery.getAllSavedJobsByUser(id);
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
        return res.json(query);
    } catch(err) {
        res.status(500).json({ error: err.message });
    }
});

router.post('/create-job-skills', async (req, res) => {
    try {
        const { id } = req.query;
        const { skills } = req.body;
        const query = await jobQuery.createJobSkills(id, skills);

        const userIds = await helper.getMatchedUsersAndSkill(skills);
        const tokens = await tokenQuery.getTokensByUserIds(userIds);
        for (const id of userIds) {
            await notificationQuery.createNotification({
                recipient_id: id,
                recipient_role: "job_seeker",
                sender_id: null,
                type: "JOB",
                content: `Job ${query.title} has required skills that matches yours.`,
            })
        }
    
        if (tokens.length === 0) {
            return res.json({
                success: true,
                message: "No FCM tokens found.",
                announcement: query
            });
        }
    
        const payload = {
            tokens: tokens,
            notification: {
                title: "New Job Recommendation",
                body: `Job ${query.title} has required skills that matches yours.`,
            },
            data: {
                screen: "job",
            }
        };
    
        const response = await admin.messaging().sendEachForMulticast(payload);
        console.log("FCM RESPONSE:", JSON.stringify(response, null, 2));
        console.log("FCM ERROR DETAILS:", response.responses[0].error);

        return res.json(query);
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

router.post('/unsave-job', async (req, res) => {
    const { userId, jobId } = req.query;
    try {
        const job = await jobQuery.unsaveJob(userId, jobId);

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