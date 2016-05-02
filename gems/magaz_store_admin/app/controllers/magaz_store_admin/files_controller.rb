module MagazStoreAdmin
  class FilesController < ApplicationController
    include MagazCore::Concerns::Authenticable
    layout 'admin_settings'

    def index
      @files = current_shop.files.page(params[:page])
    end

    def show
      @file = current_shop.files.find(params[:id])
    end

    def new
      @file = current_shop.files.new
    end

    def create
      service = MagazCore::AdminServices::File::AddFile
                  .run(shop_id: current_shop.id,
                       name: params[:file][:name],
                       file: params[:file][:file])
      if service.valid?
        @file = service.result
        flash[:notice] = t('.notice_success')
        redirect_to file_path(@file)
      else
        @file = service.datafile
        render 'new'
      end
    end

    def update
      service = MagazCore::AdminServices::File::ChangeFile
                  .run(id: params[:id],
                       name: params[:file][:name],
                       file: params[:file][:file],
                       shop_id: current_shop.id)
      if service.valid?
        @file = service.result
        flash[:notice] = t('.notice_success')
        redirect_to files_path
      else
        @file = service.datafile
        render 'show'
      end
    end

    def destroy
      MagazCore::AdminServices::File::DeleteFile
        .run(id: params[:id],
             shop_id: current_shop.id)
      flash[:notice] = t('.notice_success')
      redirect_to files_path
    end
    
  end
end
