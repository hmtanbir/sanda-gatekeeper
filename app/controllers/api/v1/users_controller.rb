module Api
  module V1
    class UsersController < ApplicationController
      def index
        response = UsersApiService.list_users(params.permit!.to_h, request.headers)
        render json: response[:body], status: response[:status]
      end

      def me
        response = UsersApiService.get_me(request.headers)
        render json: response[:body], status: response[:status]
      end

      def show
        response = UsersApiService.get_user(params[:id], request.headers)
        render json: response[:body], status: response[:status]
      end

      def update
        response = UsersApiService.update_user(params[:id], user_params, request.headers)
        render json: response[:body], status: response[:status]
      end

      def update_me
        response = UsersApiService.update_me(user_params, request.headers)
        render json: response[:body], status: response[:status]
      end

      def destroy
        response = UsersApiService.delete_user(params[:id], request.headers)
        render json: response[:body], status: response[:status]
      end

      private

      def user_params
        params.permit!.to_h
      end
    end
  end
end
