import express from 'express';
import * as applicationQuery from '../queries/application.query.js';

const router = express.Router();

router.get('/get-application/:jobId/:userId', async (req, res) => {
  const { jobId, userId } = req.params;
    try {
      const application = await applicationQuery.getApplicationByJobAndUser(jobId, userId);
      if (!application) {
        res.status(404).json({ message: `No app with id ${req.params.userId}` })
      }
      res.json(application);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/job-seeker-applications/:userId', async (req, res) => {
  try {
    const applications = await applicationQuery.getApplicationsByUser(req.params.userId);
    
    res.json(applications);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/employer-applications/:employerId', async (req, res) => {
  try {
    const applications = await applicationQuery.getApplicationsByEmployer(req.params.employerId);
    res.json(applications);
  } catch (err) {
    console.log(err);
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

router.put('/update-status/:applicationId/:status', async (req, res) => {
  try {
    const application = await applicationQuery.updateApplicationStatus(req.params.applicationId, req.params.status);
    res.json(application)
  } catch (err) {
      console.log(err);
  }
})

export default router;