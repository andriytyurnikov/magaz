class Admin::PagesController < Admin::ApplicationController
  include Authenticable
  inherit_resources
  actions :all, :except => [:edit]

  def update
    update! do |success, failure|
      failure.html { render :show }
    end
  end

  def show
    @page = Page.friendly.find(params[:id])
  end

  protected

  def begin_of_association_chain
    current_shop
  end

  def collection
    @pages ||= end_of_association_chain.page(params[:page])
  end

  #TODO collection_ids are not guaranteed to belong to this shop!!!
  # https://github.com/josevalim/inherited_resources#strong-parameters
  def permitted_params
    { page: params.fetch(:page, {}).permit(:title, :content, :page_title, :meta_description, :handle) }
  end
end
