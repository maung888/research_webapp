class FacultiesController < ApplicationController
  before_action :set_faculty, only: [ :show, :edit, :update, :destroy ]

  def index
    @faculties = Faculty.all
  end

  def show
  end

  def new
    @faculty = Faculty.new
  end

  def create
    dept  = faculty_params[:department]
    name  = faculty_params[:name]
    email = faculty_params[:email].downcase

    user = User.find_by(email: email)
    if user
      # If user already has faculty, block
      if user.faculty
        # The user is *already a faculty* => error out
        flash[:alert] = "A faculty with that email already exists."
        redirect_to new_faculty_path and return
      else
        # user has no faculty, so you can still make a new one
        # Possibly update name if you want to sync
        user.name = name if name.present?
      end
    else
      # No user => create new
      user = User.new(
        name:     name,
        email:    email,
        provider: "manual",
        uid:      SecureRandom.uuid
      )
    end

    ActiveRecord::Base.transaction do
      user.save!
      @faculty = Faculty.create!(user: user, department: dept)
    end

    redirect_to faculties_path, notice: "Faculty was successfully created."
  rescue ActiveRecord::RecordInvalid => e
    @faculty = Faculty.new(department: dept)
    @faculty.errors.add(:base, e.message) if @faculty.errors.empty?
    render :new, status: :unprocessable_entity
  end


  def edit
    # If you want to pre-fill name, do so from @faculty.user
  end

  def update
    dept  = faculty_params[:department]
    name  = faculty_params[:name]
    email = faculty_params[:email]

    user = @faculty.user
    # If you want to let them edit the user’s email, you can do this:
    user.email = email if email.present?
    user.name  = name if name.present?

    @faculty.department = dept

    ActiveRecord::Base.transaction do
      user.save!
      @faculty.save!
    end

    redirect_to faculties_path, notice: "Faculty was successfully updated."
  rescue ActiveRecord::RecordInvalid => e
    @faculty.errors.add(:base, e.message) if @faculty.errors.empty?
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @faculty.destroy
    redirect_to faculties_path, notice: "Faculty was successfully destroyed."
  end

  private

  def set_faculty
    @faculty = Faculty.find(params[:id])
  end

  def faculty_params
    # name and department are optional, but we'll permit them
    # email is required from the form's standpoint
    params.require(:faculty).permit(:email, :name, :department)
  end
end
