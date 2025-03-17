class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_one :student, dependent: :destroy
  has_one :faculty, dependent: :destroy
  has_one :admin, dependent: :destroy

  # Add validations, even though we use OAuth.
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  # validates :name, presence: true
  validates :uid, presence: true
  validates :provider, presence: true

  def self.from_google(email:, name:, uid:, provider:)
    user = find_or_initialize_by(email: email) # Use initialize

    if user.new_record?  # Only set attributes if it's a new record
        user.uid = uid
        user.provider = provider
        user.name = name
        # user.password = Devise.friendly_token[0,20] # Set a random password
        user.save! # Explicit save, so we can call .create_admin! and others

        # Role Assignment Logic (Example based on email - CUSTOMIZE THIS)
        if User.is_admin_email?(user.email)
          user.create_admin! unless user.admin? # Create Admin role if email matches admin domain
        elsif User.is_faculty_email?(user.email)
          user.create_faculty!(department: "To be determined") unless user.faculty? # Create Faculty role if email matches faculty domain
        elsif User.is_student_email?(user.email)
          user.create_student!(major: "Undecided", year: 0) unless user.student? # Create Student role if email matches student domain
        end
    else
        user.update(uid: uid, provider: provider) if user.uid.blank? || user.provider.blank?
    end
    user
  end

   # Example Role Checking Methods (Customize these based on your actual criteria)
   def self.is_admin_email?(email)
    admin_emails = [
      "davidvanderklay@tamu.edu",
      "paulinewade@tamu.edu",
      "sudhanvarajesh@tamu.edu",
      "samraatg@tamu.edu",
      "stephanie.vilas@exchange.tamu.edu",
      "stephanie.vilas@tamu.edu",
      "maung@tamu.edu"

    ]
    admin_emails.include?(email.downcase) # Case-insensitive email check
  end

  def self.is_faculty_email?(email)
    email == "davidvanderklay@gmail.com" # Example: faculty email - CUSTOMIZE
  end

  def self.is_student_email?(email)
    email == "georgelantin@gmail.com" # Example: student email - CUSTOMIZE
  end
  # Helper methods to check the user's role.
  def admin?
    admin.present?
  end

  def faculty?
    faculty.present?
  end

  def student?
    student.present?
  end
end
