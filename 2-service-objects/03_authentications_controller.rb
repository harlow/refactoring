class AuthenticationsController < AuthenticatedController
  def create
    if authenticate
      enroll_promotions
      redirect_to return_path
    else
      redirect_to back_path, error: authentication_error_message
    end
  end

  private

  def authenticate
    if user_authentication.authenticate!(sso_session).success?
      self.current_token = user_authentication.authenticated_user_token
    end
  end

  def enroll_promotions
    if user_authentication.promo_applicable?
      user_authentication.enroll! promo_id
      flash[:success] = I18n.t("promotions.confirmation_message")
    end
  end

  def authentication_error_message
    I18n.t("user_authentication.not_allowed") if user_authentication.not_allowed?
  end

  def user_authentication
    @user_authentication ||= UserAuthentication.new
  end
end
