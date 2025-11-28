import pool from "../../db.js";

export async function getHighestEducationCounts() {
    const [rows] = await pool.query(`
        SELECT eb.highest_education, COUNT(*) AS total
        FROM educational_backgrounds eb
        JOIN users u ON eb.user_id = u.id
        WHERE u.status = 'active'
          AND u.role = 'job_seeker'
        GROUP BY eb.highest_education
    `);

    return rows;
}

export async function getGenderCounts() {
	const [rows] = await pool.query(`
		SELECT pi.sex AS sex, COUNT(*) AS total
		FROM personal_informations pi
		JOIN users u ON pi.user_id = u.id
		WHERE u.role = 'job_seeker'
		AND u.status = 'active'
		GROUP BY LOWER(pi.sex);
	`)

	return rows;
}

export async function getPlacementCounts() {
	const [rows] = await pool.query(`
		SELECT placement, COUNT(*) AS total
		FROM applications 
		WHERE placement IS NOT NULL
		GROUP BY placement;
	`)

	return rows;
}

export async function getEmployerTypeCounts() {
	const [rows] = await pool.query(`
		SELECT ei.employer_type, COUNT(*) AS total
		FROM employer_information ei
		JOIN users u ON u.id = ei.employer_id
		WHERE u.status = 'active'
		GROUP BY ei.employer_type;
	`)

	return rows;
}

export async function getClienteleCounts() {
	const [rows] = await pool.query(`
		SELECT pi.clientele, COUNT(*) AS total
		FROM personal_informations pi
		JOIN users u ON u.id = pi.user_id
		WHERE u.role = 'job_seeker'
		AND u.status = 'active'
		GROUP BY pi.clientele
		ORDER BY total DESC;
	`)

	return rows;
}

export async function getCitmunCounts() {
	const [rows] = await pool.query(`
		SELECT pi.citmun, COUNT(*) AS total
		FROM personal_informations pi
		JOIN users u ON u.id = pi.user_id
		WHERE u.role = 'job_seeker'
		AND u.status = 'active'
		GROUP BY pi.citmun
		ORDER BY total DESC;
	`)

	return rows;
}



