import pool from "../../db.js";
import bcrypt from 'bcryptjs';

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

export async function getUserByRole(role) {
    const [rows] = await pool.query(
        'SELECT * FROM users WHERE role = ?',
        [role]
    );
    return rows;
}

export async function getUsersCount(table) {
    let query = 'SELECT COUNT(*) AS count FROM users';
    let params = [];

    if (table === "employer") {
        query += ' WHERE role = ?';
        params.push('employer');
    } else if (table === "job_seeker") {
        query += ' WHERE role = ?';
        params.push('job_seeker');
    }

    const [rows] = await pool.query(query, params);
    return { count: rows[0]?.count || 0 };
}

export async function getUserByEmailOrUsername(emailOrUsername) {
    const [rows] = await pool.query(
        'SELECT * FROM users WHERE email = ? OR username = ? LIMIT 1',
        [emailOrUsername, emailOrUsername]
    );
    return rows[0]; 
}


export async function registerUser(fullName, email, contactNumber, username, password, role) {
    const checkQuery = `
        SELECT 1 FROM users WHERE email = ? OR username = ? LIMIT 1
    `;
    const [rows] = await pool.query(checkQuery, [email, username]);

    if (rows.length > 0) {
        throw new Error('Email or username already exists');
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const now = new Date();

    const insertQuery = `
        INSERT INTO users
        (full_name, email, contact, username, password, role, created_at, is_active, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const [result] = await pool.query(insertQuery, [
        fullName,
        email,
        contactNumber,
        username,
        hashedPassword,
        role,
        now,
        1,         
        'active',   
    ]);

    return { userId: result.insertId };
}