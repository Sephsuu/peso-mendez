import nodemailer from 'nodemailer';
import * as crypto from "node:crypto";

// ${process.env.WEB_URL}/account/email-verification
const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
    },
});

export async function sendVerificationEmail(email, token) {
    const verificationUrl = `${process.env.WEB_URL}/auth/verify-email?token=${token}`

    await transporter.sendMail({
        from: `"PESO Mendez" <${process.env.EMAIL_USER}>`,
        to: email,
        subject: "Verify Your Email – PESO Mendez",
        html: `
        <div style="
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f4f6f8;
            padding: 40px 0;
        ">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="max-width: 520px; background: #ffffff; border-radius: 8px; overflow: hidden;">
                <tr>
                    <td style="background-color: #2563eb; padding: 20px; text-align: center;">
                        <h2 style="color: #ffffff; margin: 0;">
                            PESO Mendez
                        </h2>
                    </td>
                </tr>

                <tr>
                    <td style="padding: 30px; color: #333333;">
                        <h3 style="margin-top: 0;">
                            Verify Your Email Address
                        </h3>

                        <p style="font-size: 14px; line-height: 1.6;">
                            Welcome to <strong>PESO Mendez</strong>!  
                            To complete your registration, please verify your email address by clicking the button below.
                        </p>

                        <div style="text-align: center; margin: 30px 0;">
                            <a href="${verificationUrl}"
                               target="_blank"
                               style="
                                   background-color: #2563eb;
                                   color: #ffffff;
                                   text-decoration: none;
                                   padding: 12px 24px;
                                   border-radius: 6px;
                                   font-size: 14px;
                                   font-weight: bold;
                                   display: inline-block;
                               ">
                                Verify Email Address
                            </a>
                        </div>

                        <p style="font-size: 13px; color: #555555;">
                            This verification link will expire in <strong>24 hours</strong>.
                        </p>

                        <p style="font-size: 13px; color: #555555;">
                            If you did not create an account, you may safely ignore this email.
                        </p>

                        <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 30px 0;" />

                        <p style="font-size: 12px; color: #888888; text-align: center;">
                            © ${new Date().getFullYear()} PESO Mendez. All rights reserved.
                        </p>
                    </td>
                </tr>
            </table>
        </div>
        `,
    });
}

/**
 * Send Password Reset Email
 * Assumes you will build a reset page route like:
 *   ${process.env.WEB_URL}/reset-password?token=...&email=...
 *
 * Required env:
 * - WEB_URL (frontend website / flutter web url)
 * - EMAIL_USER, EMAIL_PASS
 */
export async function sendResetEmail(email, token) {
    const webUrl = process.env.WEB_URL || process.env.APP_URL;

    // Example reset page (frontend):
    // https://your-frontend.com/reset-password?token=...&email=...
    const resetUrl = `${webUrl}/reset-password?token=${encodeURIComponent(
        token
    )}&email=${encodeURIComponent(email)}`;

    await transporter.sendMail({
        from: `"PESO Mendez" <${process.env.EMAIL_USER}>`,
        to: email,
        subject: "Reset Your Password – PESO Mendez",
        html: `
        <div style="font-family: Arial, Helvetica, sans-serif; background-color: #f4f6f8; padding: 40px 0;">
            <table align="center" width="100%" cellpadding="0" cellspacing="0"
            style="max-width: 520px; background: #ffffff; border-radius: 8px; overflow: hidden;">
            <tr>
                <td style="background-color: #2563eb; padding: 20px; text-align: center;">
                <h2 style="color: #ffffff; margin: 0;">PESO Mendez</h2>
                </td>
            </tr>

            <tr>
                <td style="padding: 30px; color: #333333;">
                <h3 style="margin-top: 0;">Reset Your Password</h3>

                <p style="font-size: 14px; line-height: 1.6;">
                    We received a request to reset the password for your <strong>PESO Mendez</strong> account.
                </p>

                <div style="text-align: center; margin: 30px 0;">
                    <a href="${resetUrl}" target="_blank"
                    style="background-color: #2563eb; color: #ffffff; text-decoration: none; padding: 12px 24px; border-radius: 6px;
                    font-size: 14px; font-weight: bold; display: inline-block;">
                    Reset Password
                    </a>
                </div>

                <p style="font-size: 13px; color: #555555;">
                    This password reset link will expire in <strong>15 minutes</strong>.
                </p>

                <p style="font-size: 13px; color: #555555;">
                    If you did not request a password reset, you can safely ignore this email.
                </p>

                <p style="font-size: 12px; color: #888888;">
                    If the button doesn't work, copy and paste this link into your browser:
                    <br />
                    <span style="word-break: break-all;">${resetUrl}</span>
                </p>

                <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 30px 0;" />

                <p style="font-size: 12px; color: #888888; text-align: center;">
                    © ${new Date().getFullYear()} PESO Mendez. All rights reserved.
                </p>
                </td>
            </tr>
            </table>
        </div>
        `,
    });
}

/**
 * Optional helper: generate secure reset token (raw token you email)
 * You will store HASHED token in DB.
 */
export function generateResetToken() {
    return crypto.randomBytes(32).toString("hex");
}