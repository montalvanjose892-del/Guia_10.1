class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_owner!, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:user, image_attachment: :blob).order(created_at: :desc)
  end

  def show; end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "Publicación creada correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    attrs = post_params
    attrs.delete(:image) if attrs[:image].blank?

    if @post.update(attrs)
      redirect_to @post, notice: "Publicación actualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, notice: "Publicación eliminada.", status: :see_other
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_owner!
    return if @post.user == current_user
    redirect_to root_path, alert: "No tienes permiso para hacer eso."
  end

  def post_params
    params.require(:post).permit(:image, :description)
  end
end
