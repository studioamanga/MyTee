class WearsController < ApplicationController
  # GET /wears
  # GET /wears.json
  def index
    @wears = Wear.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @wears }
    end
  end

  # GET /wears/1
  # GET /wears/1.json
  def show
    @wear = Wear.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @wear }
    end
  end

  # GET /wears/new
  # GET /wears/new.json
  def new
    @wear = Wear.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @wear }
    end
  end

  # GET /wears/1/edit
  def edit
    @wear = Wear.find(params[:id])
  end

  # POST /wears
  # POST /wears.json
  def create
    @wear = Wear.new(params[:wear])

    respond_to do |format|
      if @wear.save
        format.html { redirect_to @wear, :notice => 'Wear was successfully created.' }
        format.json { render :json => @wear, :status => :created, :location => @wear }
      else
        format.html { render :action => "new" }
        format.json { render :json => @wear.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wears/1
  # PUT /wears/1.json
  def update
    @wear = Wear.find(params[:id])

    respond_to do |format|
      if @wear.update_attributes(params[:wear])
        format.html { redirect_to @wear, :notice => 'Wear was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @wear.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wears/1
  # DELETE /wears/1.json
  def destroy
    @wear = Wear.find(params[:id])
    @wear.destroy

    respond_to do |format|
      format.html { redirect_to wears_url }
      format.json { head :no_content }
    end
  end
end
