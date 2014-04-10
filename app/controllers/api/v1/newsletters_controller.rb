class API::V1::NewslettersController < APIController

  before_filter :build_resource, :only => :create

  load_and_authorize_resource :except => [:destory]

  # GET /api/v1/newsletters
  def index
    respond_with(@newsletters)
  end

  def create

    if @newsletter.save
      respond_with(@newsletter)
    else
      respond_to do |format|
        format.json { render :json => {:fields => @newsletter.errors}, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_with(@newsletter)
  end

  def update


    if @newsletter.update(resource_params)
      respond_with(@newsletter)
    else
      respond_to do |format|
        format.json { render :json => {:fields => @newsletter.errors}, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    ids = params[:id].split(",")
    @newsletters = ::Newsletter.where(:id => ids)
    authorize! :destroy, @newsletters
    @newsletters.destroy_all
  end

  def build_resource
    @newsletter = ::Newsletter.new(resource_params)

  end

  def resource_params
    params.require(:newsletter).permit(:id, :title, :content)
  end

end
