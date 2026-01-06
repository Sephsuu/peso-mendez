
import express from 'express';
import * as userQuery from '../queries/user.query.js';
import { generateResumePDF } from '../utils/genereateResume.js';
import fs from "fs";
import path from "path";

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

router.get('/get-profile-strength', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserProfileStrength(id);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

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

router.get('/get-prof-license', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getUserProfessionalLicense(id);
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

router.get('/get-employer-information', async (req, res) => {
	const { id } = req.query;
	try {
		const query = await userQuery.getEmployerInformation(id);
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

router.get('/generate-resume', async (req, res) => {
	const { id } = req.query;
	try {
		const resumePath = path.join(
            process.cwd(),
            "uploads",
            "job-seeker-resume",
            `${id}_resume.pdf`
        );

        if (fs.existsSync(resumePath)) {
            fs.unlinkSync(resumePath);
        }

		const credentials = await userQuery.getUserCredentials(id);
		const personal_information = await userQuery.getUserPersonalInformation(id);
		const job_reference = await userQuery.getUserJobReference(id);
		const language_proficiency = await userQuery.getUserLanguageProcefiency(id);
		const educational_background = await userQuery.getUserEducationalBackground(id);
		const tech_voc = await userQuery.getUserTechVocTrainings(id);
		const eligibility = await userQuery.getUserEligibility(id);
		const professional_license = await userQuery.getUserProfessionalLicense(id);
		const work_experience = await userQuery.getUserWorkExperience(id);
		const other_skills = await userQuery.getUserOtherSkills(id);

		const resume = {
			credentials,
			personal_information,
			job_reference,
			language_proficiency,
			educational_background,
			tech_voc,
			eligibility,
			professional_license,
			work_experience,
			other_skills,
		};

		console.log(resume);

		generateResumePDF(resume, id, res);

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

router.post('/create-employer-information', async (req, res) => {
	const employerInfo = req.body;
	try {
		const query = await userQuery.createEmployerInformation(employerInfo);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-credential', async (req, res) => {
	const user = req.body;
	console.log('ROUTE', user);
	try {
		const query = await userQuery.updateUserCredential(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-personal-info', async (req, res) => {
	const user = req.body;
	try {
		const query = await userQuery.updatePersonalInformation(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-job-ref', async (req, res) => {
	const user = req.body;
	try {
		const query = await userQuery.updateJobReference(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-language', async (req, res) => {
	const user = req.body;
	try {
		const query = await userQuery.updateLanguageProfeciency(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-educ-bg', async (req, res) => {
	const user = req.body;
	try {
		const query = await userQuery.updateEducationalBackground(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-techvoc-training', async (req, res) => {
	const user = req.body;
	try {
		const query = await userQuery.updateTechVocTraining(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-eligibility', async (req, res) => {
	const user = req.body;
	try {
		const query = await userQuery.updateEligibility(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-prof-license', async (req, res) => {
	const user = req.body;
	try {
		const query = await userQuery.updateProfessionalLicense(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-work-exp', async (req, res) => {
	const user = req.body;
	try {
		const query = await userQuery.updateWorkExperience(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

router.patch('/update-other-skills', async (req, res) => {
	const user = req.body;
	console.log(user);

	try {
		await userQuery.deleteOtherSkills(user.userId);

		for (const item of user.skills) {  
		await userQuery.createOtherSkill({
			userId: user.userId,
			skill: item.skill   // now correct!
		});
		}

		res.json({ message: "Skills updated" });
		
	} catch (err) {
		res.status(500).json({ error: err.message });
  }
});

router.post('/update-employer-information', async (req, res) => {
	const user = req.body;
	try {
		const query = await userQuery.updateEmployerInformation(user);
		res.json(query);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
});

router.patch('/deactivate', async (req, res) => {
	const { id } = req.query;
	const { note } = req.body
	try {
		const user = await userQuery.deactivateUser(id, note);
		res.json(user);
	} catch (err) {
		res.status(500).json({ error: err.message });
	}
})

export default router;