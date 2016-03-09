module MagazStoreAdmin
  class ArticlesController < ApplicationController
    include MagazCore::Concerns::Authenticable

    def index
      @articles = current_shop.articles.page(params[:page])
    end

    def show
      @article = current_shop.articles.friendly.find(params[:id])
    end

    def new
      @article = MagazCore::ShopServices::AddArticle.new
    end

    def create
      service = MagazCore::ShopServices::AddArticle.run(title: params[:article][:title], content: params[:article][:content],
                                                        blog_id: params[:article][:blog_id], page_title: params[:article][:page_title],
                                                        meta_description: params[:article][:meta_description], handle: params[:article][:handle])
      if service.valid?
        @article = service.result
        @event_service = MagazCore::ShopServices::CreateEvent.call(subject: @article,
                                                                   topic: MagazCore::Webhook::Topics::CREATE_ARTICLE_EVENT,
                                                                   current_user: current_user)
        flash[:notice] = t('.notice_success')
        redirect_to article_url(@article)
      else
        @article = service
        flash[:notice] = t('.notice_fail')
        render 'new'
      end
    end

    def update
      @article = current_shop.articles.friendly.find(params[:id])
      service = MagazCore::ShopServices::ChangeArticle.run(id: @article.id, title: params[:article][:title],
                                                           blog_id: params[:article][:blog_id], page_title: params[:article][:page_title],
                                                           meta_description: params[:article][:meta_description], content: params[:article][:content],
                                                           handle: params[:article][:handle])
      if service.valid?
        @article = service.result
        @event_service = MagazCore::ShopServices::CreateEvent.call(subject: @article,
                                                                   topic: MagazCore::Webhook::Topics::UPDATE_ARTICLE_EVENT,
                                                                   current_user: current_user)
        flash[:notice] = t('.notice_success')
        redirect_to article_url(@article)
      else
        flash[:notice] = t('.notice_fail')
        render 'show'
      end
    end

    def destroy
      #delete
      @article = current_shop.articles.friendly.find(params[:id])
      @article.destroy
      @event_service = MagazCore::ShopServices::CreateEvent.call(subject: @article,
                                                                 topic: MagazCore::Webhook::Topics::DELETE_ARTICLE_EVENT,
                                                                 current_user: current_user)
      flash[:notice] = t('.notice_success')
      redirect_to articles_url
    end

    protected

    #TODO:  collection_ids are not guaranteed to belong to this shop!!!
    # https://github.com/josevalim/inherited_resources#strong-parameters
    def permitted_params
      { article:
          params.fetch(:article, {}).permit(:title, :content, :blog_id, :page_title, :meta_description, :handle) }
    end
  end
end
