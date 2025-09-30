
import express from 'express';
import * as userQuery from '../queries/user.query.js';

const router = express.Router();

router.get('/', async (req, res) => {
	try {
		const users = await userQuery.getUsers();
		res.json(users);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
});

router.get('/get-by-id', async (req, res) => {
	const { id } = req.query;
	try {
		const user = await userQuery.getUserById(id);
		if (!user) {
			res.status(404).json({ message: `No user with id ${id}` })
		}
		res.json(user);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
});

router.get('/get-by-role', async (req, res) => {
	const { role } = req.query;
	try {
		const users = await userQuery.getUserByRole(role);
		res.json(users);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
});

router.get('/get-credentials', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserCredentials(id);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})


router.get('/get-personal-information', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserPersonalInformation(id);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.get('/get-job-reference', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserJobReference(id);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.get('/get-language-profeciency', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserLanguageProcefiency(id);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.get('/get-educational-background', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserEducationalBackground(id);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.get('/get-tech-voc-trainings', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserTechVocTrainings(id);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.get('/get-eligibility', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserEligibility(id);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.get('/get-work-experience', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserWorkExperience(id);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.get('/get-other-skills', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserOtherSkills(id);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.post('/create-personal-info', async (req, res) => {
	const personalInfo = req.body;
	try {
		const query = await userQuery.createPersonalinformation(personalInfo);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
});

router.post('/create-job-ref', async (req, res) => {
	const jobRef = req.body;
	try {
		const query = await userQuery.createJobReference(jobRef);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.post('/create-language-prof', async (req, res) => {
	const languageProf = req.body;
	try {
		const query = await userQuery.createLanguageProfeciency(languageProf);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.post('/create-educ-bg', async (req, res) => {
	const educBg = req.body;
	try {
		const query = await userQuery.createEducationalBackground(educBg);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.post('/create-techvoc-training', async (req, res) => {
	const techVoc = req.body;
	try {
		const query = await userQuery.createTechVocTraining(techVoc);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.post('/create-eligibility', async (req, res) => {
	const eligibility = req.body;
	try {
		const query = await userQuery.createEligibility(eligibility);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.post('/create-prof-license', async (req, res) => {
	const prc = req.body;
	try {
		const query = await userQuery.createProfessionalLicense(prc);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.post('/create-work-exp', async (req, res) => {
	const workExp = req.body;
	try {
		const query = await userQuery.createWorkExperience(workExp);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.post('/create-other-skill', async (req, res) => {
	const otherSkill = req.body;
	try {
		const query = await userQuery.createOtherSkill(otherSkill);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-credential', async (req, res) => {
	const user = req.body;
	try {
		const query = await userQuery.updateUserCredential(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/deactivate', async (req, res) => {
	const { id } = req.query;
	try {
		const user = await userQuery.deactivateUser(id);
		res.json(user);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

export default router;