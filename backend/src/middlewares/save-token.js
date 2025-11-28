const express = require("express");
const router = express.Router();
const FcmToken = require("../models/FcmToken");

router.post("/save-token", async (req, res) => {
    const { userId, token } = req.body;

    if (!userId || !token) {
        return res.status(400).json({ message: "Missing fields" });
    }

    await FcmToken.findOneAndUpdate(
        { userId },
        { token },
        { upsert: true, new: true }
    );

    res.json({ message: "Token saved" });
});

module.exports = router;
