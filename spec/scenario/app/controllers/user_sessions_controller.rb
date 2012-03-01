class UserSessionsController < ApplicationController

  def new
    puts "Trying new user session"
    redirect_to(cas_login_url) unless returning_from_cas?
  end


  # POST /user_sessions
  # POST /user_sessions.json
  def create
    @user_session = UserSession.new(params[:user_session])

    respond_to do |format|
      if @user_session.save
        format.html { redirect_to root_path, notice: 'User session was successfully created.' }
        format.json { render json: @user_session, status: :created, location: @user_session }
      else
        format.html { render action: "new" }
        format.json { render json: @user_session.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :ok }
    end
  end


  protected
  def returning_from_cas?
    params[:ticket] || request.referer =~ /^#{::Authlogic::Cas.cas_client.cas_base_url}/
  end


  def cas_login_url
    login_url = ::Authlogic::Cas.cas_client.add_service_to_login_url(users_service_url)
    redirect_url = ""# "&redirect=#{cas_return_to_url}"
    return "#{login_url}#{redirect_url}"
  end
  helper_method :cas_login_url
  
end
