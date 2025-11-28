import express from 'express';
import * as applicationQuery from '../queries/application.query.js';
import * as tokenQuery from '../queries/token.query.js';
import * as helper from '../utils/helper.js'
import * as notificationQuery from "../queries/notifications.query.js";
import admin from '../middlewares/firebase.js'

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
    const query = await applicationQuery.createApplication(jobId, userId);

    const userIds = await helper.getUserByJob(jobId);    
    const tokens = await tokenQuery.getTokensByUserIds(userIds);
    for (const id of userIds) {
        await notificationQuery.createNotification({
            recipient_id: id,
            recipient_role: "employer",
            sender_id: null,
            type: "APPLICATION",
            content: `Job seeker ${query.full_name} applied to job ${query.title}.`,
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
            title: "A New Job Applicant.",
            body: `Job seeker ${query.full_name} applied to job ${query.title}.`,
        },
        data: {
            screen: "application",
        }
    };

    const response = await admin.messaging().sendEachForMulticast(payload);
    console.log("FCM RESPONSE:", JSON.stringify(response, null, 2));
    console.log("FCM ERROR DETAILS:", response.responses[0].error);

    res.status(201).json(query);
  } catch (err) {
    console.log(err);
  }
});

router.patch('/update-status', async (req, res) => {
  const { id, status } = req.query;
  try {
    const query = await applicationQuery.updateApplicationStatus(id, status);

    if (status == "Hired") {
      const userIds = await helper.getUserIdsByRole("admin");
      const tokens = await tokenQuery.getTokensByRole("admin");
      for (const id of userIds) {
          await notificationQuery.createNotification({
              recipient_id: id,
              recipient_role: "admin",
              sender_id: null,
              type: "APPLICATION",
              content: status ==`Job listing for ${application.title} is now closed.`,
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
              title: "A job listing has closed.",
              body: `Job listing for ${application.title} is now closed.`,
          },
          data: {
              screen: "application",
          }
      };

      const response = await admin.messaging().sendEachForMulticast(payload);
      console.log("FCM RESPONSE:", JSON.stringify(response, null, 2));
      console.log("FCM ERROR DETAILS:", response.responses[0].error);
    }

    const userIds = await helper.getUserByApplication(id);    
    const tokens = await tokenQuery.getTokensByUserIds(userIds);
    for (const id of userIds) {
        await notificationQuery.createNotification({
            recipient_id: id,
            recipient_role: "job_seeker",
            sender_id: null,
            type: "APPLICATION",
            content: `Your job application status has been updated to ${status}.`,
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
            title: "Application status updated.",
            body: `Your job application status has been updated to ${status}.`,
        },
        data: {
            screen: "application",
        }
    };

    const response = await admin.messaging().sendEachForMulticast(payload);
    console.log("FCM RESPONSE:", JSON.stringify(response, null, 2));
    console.log("FCM ERROR DETAILS:", response.responses[0].error);

    res.json(query)
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