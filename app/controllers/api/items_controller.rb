class Api::ItemsController < ApplicationController

  def index
    @items = Item.joins("LEFT OUTER JOIN orders ON orders.item_id = items.id WHERE orders.item_id IS NULL AND items.hidden = false").includes(:user)

    # @items.each do |item|
    #   item.photo_file_name = item.photo.url(:medium)
    #   item.photo_content_type = item.user.avatar.url(:thumb)
    # end
    render "items/index"
    #render :json => @items
  end

  def sale
    @items = Item.joins("LEFT OUTER JOIN orders ON orders.item_id = items.id WHERE
 orders.item_id IS NULL AND items.sale_price IS NOT NULL AND items.hidden = false").includes(:user)

    render :json => @items
  end

  def trade
    @items = Item.joins("LEFT OUTER JOIN orders ON orders.item_id = items.id WHERE
 orders.item_id IS NULL AND items.trade_price IS NOT NULL AND items.hidden = false").includes(:user)
    render :json => @items
  end

  def show
    @item = Item.find(params[:id])
    render "items/show"
    #render :json => @item
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      render :json => @item
    else
      render :json => @item.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    @item = Item.find(params[:id])
    if @item.destroy
      render :json => @item
    else
      raise "Error in Item Destroy Action"
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :brand, :category, :photo, :condition, :original_price, :description,
                                 :sale_price, :trade_price, :allow_pickup, :weight, :size)
  end

end