class API::V1::NewsletterUsersController < APIController
  
  before_filter :build_resource, :only => :create
  
  load_and_authorize_resource :except => [:destory]
  
  # GET /api/v1/newsletter_users
  def index
    respond_with(@newsletter_users)
  end

  def create
    
    if @newsletter_user.save
      respond_with(@newsletter_user)
    else
      respond_to do |format|
        format.json { render :json => {:fields => @newsletter_user.errors}, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_with(@newsletter_user)
  end

  def update
    

    if @newsletter_user.update(resource_params)
      respond_with(@newsletter_user)
    else
      respond_to do |format|
        format.json { render :json => {:fields => @newsletter_user.errors}, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    ids = params[:id].split(",")
    @newsletter_users = ::NewsletterUser.where(:id => ids)
    authorize! :destroy, @newsletter_users
    @newsletter_users.destroy_all
  end

  def build_resource
    @newsletter_user = ::NewsletterUser.new(resource_params)
    
  end

  def resource_params
    params.require(:newsletter_user).permit(:id, :email)
  end

end
