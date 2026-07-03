require 'rails_helper'

RSpec.describe Ebook, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    
    it 'is valid with valid attributes and a PDF file' do
      ebook = Ebook.new(title: 'Test Book', author: 'Test Author')
      ebook.pdf_file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'test.pdf')), filename: 'test.pdf', content_type: 'application/pdf')
      expect(ebook).to be_valid
    end

    it 'is invalid without a PDF file' do
      ebook = Ebook.new(title: 'Test Book', author: 'Test Author')
      expect(ebook).to_not be_valid
      expect(ebook.errors[:pdf_file]).to include("can't be blank")
    end
  end
end
