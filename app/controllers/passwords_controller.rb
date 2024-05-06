class PasswordsController < ApplicationController
    before_action :redirect_if_authenticated

    def create
        @user = User.find_by(email: params[:user][:email].downcase)
        if @user.present?
          if @user.confirmed?
            @user.send_password_reset_email!
            redirect_to root_path, notice: "Se o usuário existir, nós iremos enviar as instruções para seu e-mail."
          else
            redirect_to new_confirmation_path, alert: "Por favor, confirme seu email primeiro."
          end
        else
          redirect_to root_path, notice: "Se o usuário existir, nós iremos enviar as instruções para seu e-mail."
        end
      end

      def edit
        @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
        if @user.present? && @user.unconfirmed?
            redirect_to new_confirmation_path, alert: "Você deve confirmar seu e-mail antes de logar"
        elsif @user.nil?
          redirect_to new_password_path, alert: "Token inválido ou expirado."
        end
      end

      def new
      end

      def update
        @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
        if @user
          if @user.unconfirmed?
            redirect_to new_confirmation_path, alert: "Você deve confirmar seu e-mail antes de logar"
          elsif @user.update(password_params)
            redirect_to login_path, notice: "Logue-se"
          else
            flash.now[:alert] = @user.errors.full_messages.to_sentence
            render :edit, status: :unprocessable_entity
          end
        else
          flash.now[:alert] = "Token inválido ou expirado."
          render :new, status: :unprocessable_entity
        end
      end

      private

      def password_params
        params.require(:user).permit(:password, :password_confirmation)
      end
end
