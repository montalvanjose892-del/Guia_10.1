class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :image, presence: { message: "no puede estar vacía" }
  validates :description, presence: { message: "no puede estar vacía" },
                          length: { minimum: 10, message: "es muy corta (mínimo 10 caracteres)" }
  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?

    unless image.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
      errors.add(:image, "debe ser JPG, PNG, GIF o WEBP")
    end

    if image.blob.byte_size > 5.megabytes
      errors.add(:image, "no puede pesar más de 5 MB")
    end
  end
end
