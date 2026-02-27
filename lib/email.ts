import nodemailer from 'nodemailer'

const smtpHost = process.env.SMTP_HOST
const smtpPort = Number(process.env.SMTP_PORT || 587)
const smtpUser = process.env.SMTP_USER
const smtpPass = process.env.SMTP_PASS

const smtpEnabled = Boolean(smtpHost && smtpUser && smtpPass)

const transporter = smtpEnabled
  ? nodemailer.createTransport({
      host: smtpHost,
      port: smtpPort,
      secure: smtpPort === 465,
      auth: {
        user: smtpUser,
        pass: smtpPass,
      },
    })
  : null

export interface InviteEmailPayload {
  to: string
  inviteUrl: string
  siteName?: string
  roleLabel: string
  invitedByEmail: string
}

export async function sendInviteEmail(payload: InviteEmailPayload): Promise<void> {
  if (!transporter) {
    // eslint-disable-next-line no-console
    console.warn('[email] SMTP is not configured. Skipping invite email for', payload.to)
    return
  }

  const { to, inviteUrl, siteName, roleLabel, invitedByEmail } = payload

  const subject = siteName
    ? `Lời mời quản lý site "${siteName}"`
    : 'Lời mời tham gia Web Manager'

  const html = `
    <div style="font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; line-height: 1.6; color: #020617;">
      <h2>Chào bạn,</h2>
      <p>
        Bạn được mời tham gia ${siteName ? `quản lý website <strong>${siteName}</strong>` : 'Web Manager'} 
        với vai trò <strong>${roleLabel}</strong>.
      </p>
      <p>Người mời: <strong>${invitedByEmail}</strong></p>
      <p>Để chấp nhận lời mời, hãy bấm vào nút bên dưới:</p>
      <p style="margin: 24px 0;">
        <a href="${inviteUrl}" 
           style="
             display: inline-block;
             padding: 10px 18px;
             border-radius: 999px;
             background-image: linear-gradient(135deg, #8b5cf6, #3b82f6);
             color: #f9fafb;
             font-weight: 600;
             text-decoration: none;
           ">
          Chấp nhận lời mời
        </a>
      </p>
      <p>Nếu nút trên không bấm được, bạn có thể copy link sau và dán vào trình duyệt:</p>
      <p style="font-size: 13px; color: #64748b; word-break: break-all;">${inviteUrl}</p>
      <p style="margin-top: 32px; font-size: 12px; color: #94a3b8;">
        Email này được gửi tự động từ hệ thống Web Manager.
      </p>
    </div>
  `

  await transporter.sendMail({
    from: process.env.EMAIL_FROM || smtpUser || 'Web Manager <no-reply@example.com>',
    to,
    subject,
    html,
  })
}

