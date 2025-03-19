class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @tweets = Tweet.includes(:user).order("created_at DESC")
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.find(params[:id])
    #バリデーションに引っかからず更新されれば、トップページにリダイレクトする
    if @tweet.update(tweet_params)
      redirect_to root_path
    else
      #バリデーションに引っかかり保存されなければ、「編集」の画面が呼び出される
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to root_path
  end

  def edit
  end

  def update
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
    redirect_to root_path
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
  end

  def search
    @tweets = SearchTweetsService.search(params[:keyword])
  end

  private
  def tweet_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end