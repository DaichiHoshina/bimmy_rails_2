# frozen_string_literal: true

PER = 5

class LikesController < ApplicationController
  before_action :authenticate_user, only: %i[create destroy]

  def index
    @posts = current_user.like_posts.order(created_at: :desc)
    @like_posts = @posts.page(params[:page]).per(PER).order(created_at: :desc)
  end

  def create
    like = Like.new
    like.user_id = current_user.id
    like.post_id = params[:post_id]

    if like.save
      redirect_to posts_path, success: 'いいねしました'
    else
      redirect_to posts_path, danger: 'いいねを解除しました'
    end
  end

  def destroy
    like = Like.find_by(post_id: params[:post_id], user_id: current_user)

    if like.destroy
      redirect_to posts_path, success: 'いいねを解除しました'
    else
      redirect_to posts_path, danger: 'いいねの解除に失敗しました'
    end
  end
end
