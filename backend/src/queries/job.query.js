import pool from "../../db.js";

export async function getJobs() {
    const [rows] = await pool.query('SELECT * FROM jobs');
    return rows;
}

export async function getJobById(id) {
    const [rows] = await pool.query(
        'SELECT * FROM jobs WHERE id = ?',
        [id]
    )
    return rows[0];
}