require 'bcrypt'
require 'pry'

class User
  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation
  # :password_token

  property :id, Serial
  property :email, String, unique: true, message: 'This email is already taken'
  # this will store both the password and the salt
  # It's Text and not String because String holds
  # 50 characters by default
  # and it's not enough for the hash and salt

  property :password_digest, Text
  property :password_token, Text

  # when assigned the password, we don't store it directly
  # instead, we generate a password digest, that looks like this:
  # "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"
  # and save it in the database. This digest, provided by bcrypt,
  # has both the password hash and the salt. We save it to the
  # database instead of the plain password for security reasons.
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  validates_confirmation_of :password

  def self.authenticate(email:, password:)
    user = first(email: email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end

  def self.token_generator(email:)
    user = first(email: email)
    user.password_token = ([*('a'..'z'),*('0'..'9')].shuffle[0,15].join)
    user.save
  end

  # def token_generator=(create)
  #   @token = create
  #   self.password_token =
  # [*('a'..'z'),*('0'..'9')].shuffle[0,15].join
  # end
  # # def token_generator=(token)
  #   # @token =
  # # def token=(token)
  # #   @token = token
  # #   self.password_token =
  #   [*('a'..'z'),*('0'..'9')].shuffle[0,15].join
  # # user.save
  # end

end
