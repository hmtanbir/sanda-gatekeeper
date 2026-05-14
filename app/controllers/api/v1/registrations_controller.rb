module Api
  module V1
    class RegistrationsController < ApplicationController
      def create
        response = UsersApiService.register(registration_params, request.headers)
        render json: response[:body], status: response[:status]
      end

      private

      def registration_params
        params.permit(:name, :email, :password).to_h
      end
    end
  end
end
