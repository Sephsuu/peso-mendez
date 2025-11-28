import { getUserById } from "../queries/user.query.js";

export async function loadUser(req, res, next) {
    console.log('Session in loadUser', req.session.userId);
    
    if (!req.session.userId) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    try {
        const user = await getUserById(req.session.userId);
        if (!user) {
        return res.status(401).json({ message: 'User not found' });
        }
        req.user = user;
        next();
    } catch (err) {
        next(err);
    }
}