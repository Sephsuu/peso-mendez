import express from 'express';
import * as verificationQuery from '../queries/verification.query.js'
import * as tokenQuery from '../queries/token.query.js';
import * as helper from '../utils/helper.js'
import * as notificationQuery from "../queries/notifications.query.js";
import admin from '../middlewares/firebase.js'

const router = express.Router();

router.get('', async  (req, res) => {
    const { role } = req.query;
    try {
        const query = await verificationQuery.getVerifications(role);
        return res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.get('/get-by-user', async(req, res) => {
    const { id } = req.query;
    try {
        const query = await verificationQuery.getVerificationByUser(id);
        return res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.get('/get-all-users', async(req, res) => {
    const { id } = req.query;
    try {
        const query = await verificationQuery.getEmployersWithVerification();
        return res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.post('/create', async (req, res) => {
    const verification = req.body;
    try {
        const query = await verificationQuery.createOrUpdateVerification(verification);

        const userIds = await helper.getUserIdsByRole("admin");
        const tokens = await tokenQuery.getTokensByRole("admin");
        for (const id of userIds) {
            await notificationQuery.createNotification({
                recipient_id: id,
                recipient_role: "admin",
                sender_id: null,
                type: "VERIFICATION",
                content: `Employer ${query.full_name} applies for an accreditation.`,
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
                title: "Employer accreditation",
                body: `Employer ${query.full_name} applies for an accreditation.`,
            },
            data: {
                screen: "verification",
            }
        };
    
        const response = await admin.messaging().sendEachForMulticast(payload);
        console.log("FCM RESPONSE:", JSON.stringify(response, null, 2));
        console.log("FCM ERROR DETAILS:", response.responses[0].error);

        return res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

router.post("/update", async (req, res) => {
    try {
        const body = req.body || {};

        const verificationId = body.id;
        const employerId = body.employerId;

        if (!verificationId && !employerId) {
        return res.status(400).json({ error: "Missing id or employerId" });
        }

        const updatePayload = {
        ...body,
        status: "pending",
        note: "", // optional: clear old rejection note on resubmit
        };

        delete updatePayload.full_name;
        delete updatePayload.created_at;
        delete updatePayload.updated_at;

        const updated = verificationId
        ? await verificationQuery.updateVerificationById(verificationId, updatePayload)
        : await verificationQuery.updateVerificationByEmployerId(employerId, updatePayload);

        if (!updated) {
        return res.status(404).json({ error: "Verification not found" });
        }

        const userIds = await helper.getUserIdsByRole("admin");
        const tokens = await tokenQuery.getTokensByRole("admin");

        for (const id of userIds) {
        await notificationQuery.createNotification({
            recipient_id: id,
            recipient_role: "admin",
            sender_id: null,
            type: "VERIFICATION",
            content: `Employer ${updated.full_name} re-submitted accreditation documents.`,
        });
        }

        if (tokens.length > 0) {
        const payload = {
            tokens,
            notification: {
            title: "Employer accreditation",
            body: `Employer ${updated.full_name} re-submitted accreditation documents.`,
            },
            data: { screen: "verification" },
        };

        const response = await admin.messaging().sendEachForMulticast(payload);
            console.log("FCM RESPONSE:", JSON.stringify(response, null, 2));
        }

        return res.json(updated);
    } catch (err) {
        console.error("UPDATE VERIFICATION ERROR:", err);
        return res.status(500).json({ error: err.message });
    }
});


router.patch('/update-status', async (req, res) => {
    const { id, status } = req.query;
    const { note } = req.body;
    try {
        const query = await verificationQuery.updateStatus(id, status, note);

        const userIds = await helper.getUserByVerification(id);    
        const tokens = await tokenQuery.getTokensByUserIds(userIds);
        for (const id of userIds) {
            await notificationQuery.createNotification({
                recipient_id: id,
                recipient_role: "employer",
                sender_id: null,
                type: "VERIFICATION",
                content: `Your verification request has been ${status}.`,
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
                title: "Verification Request Update",
                body: `Your verification request has been ${status}.`,
            },
            data: {
                screen: "verification",
            }
        };
    
        const response = await admin.messaging().sendEachForMulticast(payload);
        console.log("FCM RESPONSE:", JSON.stringify(response, null, 2));
        console.log("FCM ERROR DETAILS:", response.responses[0].error);

        return res.json(query);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
})

export default router;