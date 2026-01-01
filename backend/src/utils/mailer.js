import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
    },
});

export async function sendVerificationEmail(email, token) {
    const verificationUrl =
        `${process.env.APP_URL}/auth/verify-email?token=${token}`;

    await transporter.sendMail({
        from: `"PESO Mendez" <${process.env.EMAIL_USER}>`,
        to: email,
        subject: "Verify your email address",
        html: `
            <h3>Welcome to PESO Mendez</h3>
            <p>Please verify your email by clicking the link below:</p>
            <p>
                <a href="${verificationUrl}"
                   target="_blank"
                   style="color:#1a73e8;font-weight:bold;">
                   Verify Email
                </a>
            </p>
            <p>This link will expire in 24 hours.</p>
        `,
    });
}