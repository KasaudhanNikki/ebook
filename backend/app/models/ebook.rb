class Ebook < ApplicationRecord
  has_one_attached :pdf_file

  validates :title, presence: true
  validates :author, presence: true
  validates :pdf_file, attached: true, content_type: ['application/pdf']
  
  def filename
    pdf_file.attached? ? pdf_file.filename.to_s : nil
  end

  def pdf_url
    if pdf_file.attached?
      Rails.application.routes.url_helpers.rails_blob_url(pdf_file, only_path: true)
    end
  end
end
