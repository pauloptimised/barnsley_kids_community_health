class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  mount_uploader :image, ArticleUploader

  scope :published, -> { where("display = ? and date <= ?", true, Date.today) }

  validates :title, :content, :date, presence: true
  validates :suggested_url, allow_blank: true, uniqueness: { message: 'is not unique, leave this blank to generate automatically' }

  def slug_candidates
    [
      :suggested_url,
      :title,
      [:suggested_url, :title]
    ]
  end

  def should_generate_new_friendly_id?
    suggested_url_changed? || title_changed?
  end

end
