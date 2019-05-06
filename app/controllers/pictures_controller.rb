class PicturesController < ApplicationController

  def index
    @pictures = Picture.all
  end

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new(picture_params)
    image = params[:picture][:image]
    caption = params[:picture][:caption]

    if @picture.save
      @picture.image.attach(image) if image
      redirect_to pictures_path, notice: 'Photo was successfully uploaded.'
    else
      flash.now[:alert] = 'Photo could not be saved.'
      render :new
    end
  end

  def show
    @picture = Picture.find(params[:id])
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.image.purge
    @picture.destroy
    redirect_to pictures_path, notice: 'Photo successfully deleted'
  end

  def picture_params
    params.require(:picture).permit(:image, :caption)
  end
  
end
