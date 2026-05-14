module Api
  module V1
    class RegistrationsController < ApplicationController
      def create
        response = UsersApiService.register(registration_params, request.headers)
        render json: response[:body], status: response[:status]
      end

      private

      def registration_params
        params.permit!.to_h # Forward all params to the downstream service
      end
    end
  end
end
