class TshirtsController < ApplicationController
  # GET /tshirts
  # GET /tshirts.json
  def index
    @tshirts = Tshirt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @tshirts }
    end
  end

  # GET /tshirts/1
  # GET /tshirts/1.json
  def show
    @tshirt = Tshirt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @tshirt }
    end
  end

  # GET /tshirts/new
  # GET /tshirts/new.json
  def new
    @tshirt = Tshirt.new
    @stores = Store.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @tshirt }
    end
  end

  # GET /tshirts/1/edit
  def edit
    @tshirt = Tshirt.find(params[:id])
    @stores = Store.all
  end

  # POST /tshirts
  # POST /tshirts.json
  def create
    @tshirt = Tshirt.new(params[:tshirt])

    respond_to do |format|
      if @tshirt.save
        format.html { redirect_to @tshirt, :notice => 'Tshirt was successfully created.' }
        format.json { render :json => @tshirt, :status => :created, :location => @tshirt }
      else
        format.html { render :action => "new" }
        format.json { render :json => @tshirt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tshirts/1
  # PUT /tshirts/1.json
  def update
    @tshirt = Tshirt.find(params[:id])

    respond_to do |format|
      if @tshirt.update_attributes(params[:tshirt])
        format.html { redirect_to @tshirt, :notice => 'Tshirt was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @tshirt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tshirts/1
  # DELETE /tshirts/1.json
  def destroy
    @tshirt = Tshirt.find(params[:id])
    @tshirt.destroy

    respond_to do |format|
      format.html { redirect_to tshirts_url }
      format.json { head :no_content }
    end
  end
end
