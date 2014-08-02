class ListController < ApplicationController
  def index
    @list = List.create
    redirect_to "/#{@list.id}"
  end

  def view
    if List.find_by_id(params[:id])
      @list = List.find(params[:id])
    else
      List.all.each do |list|
        if ListItem.where(:list_id => list.id).to_a.length == 0
          list.destroy
        end
      end
      @list = List.create
      redirect_to "/#{@list.id}"
    end
    if params[:new_item]
      @list_item = ListItem.new
      @list_item.list_id = @list.id
      @list_item.item = params[:new_item].to_s
      @list_item.save
      redirect_to "/#{@list.id}"
    end
    if params[:new_name]
      @list.name = params[:new_name]
      @list.save
      redirect_to "/#{@list.id}"
    end
    @list_items = ListItem.where(:list_id => @list.id).to_a
  end

  def delete_item
    @list_item = ListItem.find(params[:id])
    @list = List.find(@list_item.list_id)
    @list_item.destroy
    redirect_to "/#{@list.id}"
  end

  def delete_list
    @list_id = params[:id]
    @list = List.find(@list_id)
    @list.destroy
    redirect_to "/"
  end
end
