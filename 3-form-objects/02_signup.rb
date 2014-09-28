class Signup
  include ActiveModel::Model
  
  # we can override the route and params name
  def self.model_name
    ActiveModel::Name.new(self, nil, "User")
  end

  attr_reader :user
  attr_reader :company

  attr_accessor :name, :email, :company_name

  validates :email, presence: true
  # … more validations …

  def save
    if valid?
      create_company! && create_user!
    else
      false
    end
  end

  private

  def create_company!
    @company = Company.create!(
      name: company_name
    )
  end
  
  def create_user!
    @user = @company.users.create!(
      name: name, 
      email: email
    )
  end
end
