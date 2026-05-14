module Api
  module V1
    class SessionsController < ApplicationController
      def create
        response = UsersApiService.login(session_params, request.headers)
        render json: response[:body], status: response[:status]
      end

      private

      def session_params
        params.permit!.to_h
      end
    end
  end
end
