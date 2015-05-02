class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  request = Vacuum.new

  request.configure(
    aws_access_key_id: ENV["S3_KEY_ID"],
    aws_secret_access_key: ENV["S3_SECRET"],
    associate_tag: 'tag'
   )

end
