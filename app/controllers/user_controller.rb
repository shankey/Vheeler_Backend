class UserController < ApplicationController
    
    def login
        
        user_name = params[:userName]
        password = params[:password]
        response.headers['Access-Control-Allow-Origin'] = 'true'
        user = User.where(name: user_name).where(password: password).first
        
        if(user == nil)
            render :json => JSON.pretty_generate({:json => "Invalid Username/Password"}),
             :status => 201
        else
            login = EntityLogin.new
            login.userId = user.id
            render :json => JSON.pretty_generate({:json => JSON.parse(login.to_json)}),
             :status => 200
        end
    end

    def index
        @base_api = Figaro.env.base_api
    end

    def dashboard
        @base_api = Figaro.env.base_api
        @areas = AreaInfo.all
    end
end
