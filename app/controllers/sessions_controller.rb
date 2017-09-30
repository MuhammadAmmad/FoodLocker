class SessionsController < ApplicationController
    
    def new
    end
    
    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            if user.activated?
                if user.google_auth
                    redirect_to new_verification_path(:id => user.id, :rem => params[:session][:remember_me])
                else
                    log_in user
                    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
                    redirect_back_or user
                end
            else
                message  = "Account not activated. "
                message += "Check your email for the activation link."
                flash[:warning] = message
                redirect_to root_url
            end
        else
            flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
            render 'new'
        end
    end
    
    def destroy
        log_out if logged_in?
        redirect_to root_url
    end
    
    # Facebook Login
    
    def create_fb
        user = User.from_omniauth(request.env["omniauth.auth"])
        if user.email.blank?
            redirect_to insert_email_path
        else
            user.update_attribute(:activated, true)
            user.save!
            if user.google_auth
                redirect_to new_verification_path(:id => user.id)
            else
                log_in user
                redirect_back_or user
            end
        end
    end

    def destroy_fb
        log_out if logged_in?
        redirect_to root_url
    end
    
end
