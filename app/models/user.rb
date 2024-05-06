class User < ApplicationRecord
    CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
    PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes
    MAILER_FROM_EMAIL = "no-reply@example.com"

    has_secure_password

    before_save :downcase_email

    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    def confirm!
        update_columns(confirmed_at: Time.current)
    end

    def confirmed?
        confirmed_at.present?
    end

    def generate_confirmation_token
        signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
    end

    def generated_password_reset_token
        signed_id expires_in: PASSWORD_RESET_TOKEN_EXPIRATION, purpose: :reset_password
    end

    def unconfirmed?
        !confirmed?
    end

    def send_confirmation_email!
        confirmation_token = generate_confirmation_token
        UserMailer.confirmation(self, confirmation_token).deliver_now
    end

    def send_password_reset_email!
      password_reset_token = generated_password_reset_token
      UserMailer.password_reset(self, password_reset_token).deliver_now
    end

    private

    def downcase_email
        self.email = email.downcase
    end


end