class WashesController < ApplicationController
  # GET /washes
  # GET /washes.json
  def index
    @washes = Wash.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @washes }
    end
  end

  # GET /washes/1
  # GET /washes/1.json
  def show
    @wash = Wash.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @wash }
    end
  end

  # GET /washes/new
  # GET /washes/new.json
  def new
    @wash = Wash.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @wash }
    end
  end

  # GET /washes/1/edit
  def edit
    @wash = Wash.find(params[:id])
  end

  # POST /washes
  # POST /washes.json
  def create
    @wash = Wash.new(params[:wash])

    respond_to do |format|
      if @wash.save
        format.html { redirect_to @wash, :notice => 'Wash was successfully created.' }
        format.json { render :json => @wash, :status => :created, :location => @wash }
      else
        format.html { render :action => "new" }
        format.json { render :json => @wash.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /washes/1
  # PUT /washes/1.json
  def update
    @wash = Wash.find(params[:id])

    respond_to do |format|
      if @wash.update_attributes(params[:wash])
        format.html { redirect_to @wash, :notice => 'Wash was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @wash.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /washes/1
  # DELETE /washes/1.json
  def destroy
    @wash = Wash.find(params[:id])
    @wash.destroy

    respond_to do |format|
      format.html { redirect_to washes_url }
      format.json { head :no_content }
    end
  end
end
