import express from 'express';
import * as applicationQuery from '../queries/application.query.js';

const router = express.Router();

router.get('/get-by-job-user', async (req, res) => {
  const { jobId, userId } = req.query;
  try {
    const application = await applicationQuery.getApplicationByJobAndUser(jobId, userId);
    if (!application) {
      res.status(404).json({ message: `No app with id ${userId}` })
    }
    res.json(application);
  } catch (err) {
      res.status(500).json({ error: err.message });
  }
});

router.get('/get-by-employer', async (req, res) => {
  const { id } = req.query;
  try {
    const applications = await applicationQuery.getApplicationsByEmployer(id);
    res.json(applications);
  } catch (err) {
    console.log(err);
  }
});

router.get('/get-by-user', async (req, res) => {
  const { id } = req.query;
  try {
    const applications = await applicationQuery.getApplicationsByUser(id);
    res.json(applications);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/create', async (req, res) => {
  const { jobId, userId } = req.query;
  
  try {
    if ( !jobId && !userId) {
        return res.status(400).json({ error: 'Missing required fields' });
    }
    const application = await applicationQuery.createApplication(jobId, userId);
    res.status(201).json(application);
  } catch (err) {
    console.log(err);
  }
});

router.patch('/update-status', async (req, res) => {
  const { id, status } = req.query;
  try {
    const application = await applicationQuery.updateApplicationStatus(id, status);
    res.json(application)
  } catch (err) {
      console.log(err);
  }
})

router.patch('/update-placement', async (req, res) => {
  const { id, placement } = req.query;
  try {
    const application = await applicationQuery.updateApplicationPlacement(id, placement);
    res.json(application)
  } catch (err) {
      console.log(err);
  }
})

router.delete('/delete-by-job-user', async (req, res) => {
  const { jobId, userId } = req.query;
  try {
    const application = await applicationQuery.deleteApplicationByJobAndUser(jobId, userId);
    if (!application) {
      res.status(404).json({ message: `No app with id ${userId}` })
    }
    res.json(application);
  } catch (err) {
      res.status(500).json({ error: err.message });
  }
});

export default router;