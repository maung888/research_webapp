# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  before_action :set_project, only: [ :show, :edit, :update, :destroy ] # Find project for show, edit, update, and destroy
  before_action :authorize_faculty_admin, only: [ :new, :create ]
  before_action :authorize_project_owner, only: [ :edit, :update, :destroy ] # Authorization!

  def index
    @projects = Project.all

    if params[:search].present?
      # Make a wildcard query for partial matches
      search_term = "%#{params[:search]}%"

      # We can search across multiple columns, including faculty’s user name.
      # Using ILIKE for case-insensitive search in PostgreSQL
      @projects = @projects.joins(faculties: :user)
                           .where("projects.title ILIKE :term
                                   OR projects.areas_of_research ILIKE :term
                                   OR projects.start_semester ILIKE :term
                                   OR projects.prefered_class ILIKE :term
                                   OR users.name ILIKE :term",
                                  term: search_term)
      flash.now[:info] = "Showing search results for: '#{params[:search]}'"
    else
      @projects = Project.all
      flash.now[:info] = "Showing all research projects" if request.format.html?

    end
  end

  def new
    @project = Project.new
  end


 # app/controllers/projects_controller.rb
 def create
     Rails.logger.debug "project_params: #{project_params.inspect}"
     @project = Project.new(project_params)

     if current_user.admin?
       Rails.logger.debug "Associating Admin creator: #{current_user.admin.inspect}"
       @project.admin_id = current_user.admin.id # <==== SET admin_id BEFORE save! - MOVED THIS LINE UP
       Rails.logger.debug "Set project.admin_id to: #{@project.admin_id}"
     end
     @project.faculties << current_user.faculty if current_user.faculty

     if @project.save! # <==== Now save! after admin_id is set
       Rails.logger.debug "--- Project Created ---"
       Rails.logger.debug "Current User is Admin? #{current_user.admin?}"
       Rails.logger.debug "Current User: #{current_user.inspect}"
       Rails.logger.debug "Project after save! - Admin: #{@project.admin.inspect}, Admin ID: #{@project.admin_id}"
      # --- Send email notifications to STUDENTS only ---
      User.joins(:student).each do |user|  # Efficiently get only users with a student record
        ProjectNotificationMailer.new_project_email(user, @project).deliver_now
      end
       # --- End email notifications ---

       redirect_to @project, notice: "Project was successfully created." # Redirect to show action
     else
       render :new, status: :unprocessable_entity
     end
   end

  def show
    # @project is already loaded by set_project
  end

  def edit
    # @project is already loaded by set_project
  end

  def update
    # @project is already loaded by set_project
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # @project is already loaded by set_project
    @project.destroy
    redirect_to projects_path, notice: "Project was successfully deleted.", status: :see_other # Use :see_other for redirect after delete
  end

  private

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Project not found."
  end

  def project_params
    params.require(:project).permit(
      :title, :description, :num_positions, :areas_of_research,
      :start_semester, :prefered_class, :other_comments, :admin_id
    )
  end

  def authorize_faculty_admin
    unless current_user_is_faculty_or_admin?
      redirect_to root_path, alert: "You are not authorized to create projects."
    end
  end

  def authorize_project_owner # <---  THIS METHOD WAS MISSING
    unless current_user.admin? || (@project.faculties.include?(current_user.faculty))
      redirect_to root_path, alert: "You are not authorized to edit this project."
    end
  end

  def current_user_is_faculty_or_admin?
    current_user.admin? || current_user.faculty?
  end
end
