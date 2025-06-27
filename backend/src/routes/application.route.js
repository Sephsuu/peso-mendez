import express from 'express';
import * as applicationQuery from '../queries/application.query.js';

const router = express.Router();

router.get('/:jobId/:userId', async (req, res) => {
  const { jobId, userId } = req.params;
    try {
      const application = await applicationQuery.getApplicationByJobAndUser(jobId, userId);
      if (!application) {
        res.status(404).json({ message: `No job with id ${req.params.userId}` })
      }
      res.json(application);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.post('/', async (req, res) => {
    try {
        const { jobId, userId } = req.body;

        if ( !jobId, !userId) {
            return res.status(400).json({ error: 'Missing required fields' });
        }

        const application = await applicationQuery.addApplication(jobId, userId);
        res.status(201).json({ message: 'Application created successfully', application });
    } catch (err) {
        console.log(err);
    }
});

export default router;