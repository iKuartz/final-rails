class V1::LoginController < ApplicationController
    def index
        name = params[:name]
        users = User.all
        userPresent = false
        users.each do |user|
            if user.name == name
                render json: {
                    message: "Login successful."
                }
                userPresent = true
                break
            end
        end
        unless userPresent
            render json: {
                message: "User not present"
            }
        end
    end
end