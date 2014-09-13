class UsersController < ApplicationController
    def new
        @user = User.new
    end

    # POST /users
    # POST /users.json
    def create

    end
end
