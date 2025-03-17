require 'rails_helper'

RSpec.describe Faculty, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      association = Faculty.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has and belongs to many projects' do
      association = Faculty.reflect_on_association(:projects)
      expect(association.macro).to eq(:has_and_belongs_to_many)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      faculty = build(:faculty) # Using FactoryBot to create a valid faculty (define factories later)
      expect(faculty).to be_valid
    end

    it 'is not valid without an email' do
      faculty = build(:faculty, user: build(:user, email: nil))
      expect(faculty).to_not be_valid
      expect(faculty.user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid if email is too long' do
      faculty = build(:faculty, user: build(:user, email: 'a' * 256))
      expect(faculty).to_not be_valid
      expect(faculty.user.errors[:email]).to include("is too long (maximum is 255 characters)") # Adjust message if needed
    end
  end
end
