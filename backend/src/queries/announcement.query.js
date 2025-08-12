import pool from "../../db.js";

export async function getAllAnnouncements() {
    const [rows] = await pool.query(
        `SELECT * FROM announcements`
    );
    return rows;
}

export async function getAnnouncementById(id) {
    const [rows] = await pool.query(
        `SELECT * FROM announcements WHERE id = ?`,
        [id]
    );
    return rows[0];
}

export async function createAnnouncement(announcement) {
    const [rows] = await pool.query(
        `INSERT INTO announcements (title, content, target_audience)
        VALUES (?, ?, ?)`,
        [
            announcement.title,
            announcement.content,
            announcement.target_audience
        ]
    );
    const [result] = await pool.query(
        `SELECT * FROM announcements WHERE id = ?`,
        [rows.insertId]
    );
    return result[0];
}

export async function updateAnnouncement(announcement) {
    const [rows] = await pool.query(
        `UPDATE announcements SET
        title = ?,
        content = ?,
        target_audience = ?
        WHERE id = ?`,
        [
            announcement.title,
            announcement.content,
            announcement.target_audience,
            announcement.id
        ]
    );
    const [result] = await pool.query(
        `SELECT * FROM announcements WHERE id = ?`,
        [announcement.id]
    );
    return result[0];
}

export async function deleteAnnouncement(id) {
    const [rows] = await pool.query(
        `DELETE FROM announcements WHERE id = ?`,
        [id]
    );
    return rows;
}