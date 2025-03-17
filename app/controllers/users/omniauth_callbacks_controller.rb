class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    if auth.nil?
      Rails.logger.error "OmniAuth auth hash is nil! Possible misconfiguration or test mode issue."
      flash[:alert] = "Authentication failed. Please try again."
      redirect_to new_user_session_path and return
    end

    Rails.logger.debug "--- Google OAuth Callback ---" # Add log at the beginning
    Rails.logger.debug "Full auth hash: #{auth.inspect}" # Log the entire auth hash
    Rails.logger.debug "auth.info: #{auth.info.inspect}" # Log auth.info specifically
    Rails.logger.debug "auth.info.name: #{auth.info.name.inspect}" # Log auth.info.name specifically
    Rails.logger.debug "auth.info.full_name: #{auth.info.full_name.inspect}" # Log auth.info.full_name specifically (if you're trying this)
    user = User.from_google(**from_google_params)

    if user.present?
      sign_out_all_scopes
      flash[:success] = t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = t "devise.omniauth_callbacks.failure", kind: "Google", reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_session_path # Redirect to user sign-in
    end
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path # Redirect to user sign-in
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  def from_google_params
    @from_google_params ||= {
      uid: auth.uid,
      email: auth.info.email,
      name: auth.info.name,
      provider: "google_oauth2" # Add provider
    }
  end

  def auth
    @auth ||= request.env["omniauth.auth"]
  end
end
