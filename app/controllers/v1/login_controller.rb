class V1::LoginController < ApplicationController
    def index
        render json: {
            error: "Testing an error message"
        }
    end
end