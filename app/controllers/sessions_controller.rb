class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    resp = Faraday.post 'https://github.com/login/oauth/access_token' do |req|
      client_id = ENV['GITHUB_CLIENT_ID']
      client_secret = ENV['GITHUB_CLIENT_SECRET']
      code = params[:code]
      req.body = { 'client_id': client_id, 'client_secret': client_secret, 'code': code }
      req.headers['Accept'] = 'application/json'
    end
    body = JSON.parse(resp.body)
    if resp.success?
      session[:token] = body['access_token']
    else
      session[:errors] = body
      render 'index'
    end
    redirect_to root_path
  end

    
end
