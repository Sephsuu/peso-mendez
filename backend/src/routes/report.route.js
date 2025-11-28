import express from 'express';
import * as reportQuery from '../queries/report.query.js';

const router = express.Router();

router.get('/highest-education', async (req, res) => {
    try {
        const query = await reportQuery.getHighestEducationCounts();
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/genders', async (req, res) => {
    try {
        const query = await reportQuery.getGenderCounts();
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/placements', async (req, res) => {
    try {
        const query = await reportQuery.getPlacementCounts();
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/employer-types', async (req, res) => {
    try {
        const query = await reportQuery.getEmployerTypeCounts();
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/clientele', async (req, res) => {
    try {
        const query = await reportQuery.getClienteleCounts();
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/citmun', async (req, res) => {
    try {
        const query = await reportQuery.getCitmunCounts();
        res.json(query)
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;