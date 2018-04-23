class BugsController < ApplicationController
  before_action :set_bug, :authenticate_user!, only: [:show, :edit, :update, :destroy]

  # GET /bugs
  # GET /bugs.json
  def index
    @bugs = Bug.all
  end

  # GET /bugs/1
  # GET /bugs/1.json
  def show
  end

  # GET /bugs/new
  def new
    @bug = Bug.new
  end

  # GET /bugs/1/edit
  def edit
  end

  # POST /bugs
  # POST /bugs.json
  def create
    @bug = Bug.new(bug_params)

    respond_to do |format|
      if @bug.save
        format.html { redirect_to @bug, notice: 'Bug was successfully created.' }
        format.json 
        link_to_bug = request.host +
          Rails.application.routes.url_helpers.bugs_path + "/#{@bug.id}"
        link_to_project = request.host + 
          Rails.application.routes.url_helpers.projects_path + 
          "/#{@bug.project_id}"
        message = "New <#{link_to_bug}|Bug> at Project " +
          "<#{link_to_project}|#{@bug.project.name}>!\n" +
          "Bug details: \n" + @bug.to_s
        SlackNotifier.ping message
      else
        format.html { render :new }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bugs/1
  # PATCH/PUT /bugs/1.json
  def update
    respond_to do |format|
      if @bug.update(bug_params)
        format.html { redirect_to @bug, notice: 'Bug was successfully updated.' }
        format.json { render :show, status: :ok, location: @bug }
        if @bug.solved
          link_to_bug = request.host +
            Rails.application.routes.url_helpers.bugs_path + "/#{@bug.id}"
          link_to_project = request.host + 
            Rails.application.routes.url_helpers.projects_path +
            "/#{@bug.project_id}"
          message = "<#{link_to_bug}|Bug> solved at Project " +
            "<#{link_to_project}|#{@bug.project.name}>!" +
            "\nBug details: \n" + @bug.to_s
          SlackNotifier.ping message
        end
      else
        format.html { render :edit }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bugs/1
  # DELETE /bugs/1.json
  def destroy
    @bug.destroy
    respond_to do |format|
      format.html { redirect_to bugs_url, notice: 'Bug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bug
      @bug = Bug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bug_params
      params.require(:bug).permit(:name, :description, :solved, :project_id)
    end
end
