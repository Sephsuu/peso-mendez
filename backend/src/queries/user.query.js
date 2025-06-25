import pool from "../../db.js";
import userRoute from '../routes/user.route.js';

export async function getUsers() {
    const [rows] = await pool.query('SELECT * FROM users');
    return rows;
}

export async function getUserById(id) {
    const [rows] = await pool.query(
        'SELECT * FROM users WHERE id = ?',
        [id]
    )
    return rows[0];
}

export async function getUserByEmailOrUsername(emailOrUsername) {
    const [rows] = await pool.query(
        'SELECT * FROM users WHERE email = ? OR username = ? LIMIT 1',
        [emailOrUsername, emailOrUsername]
    );
    return rows[0]; 
}
