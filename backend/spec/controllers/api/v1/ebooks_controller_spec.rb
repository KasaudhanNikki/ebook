require 'rails_helper'

RSpec.describe Api::V1::EbooksController, type: :controller do
  let(:valid_attributes) { { title: 'Test Book', author: 'Test Author' } }
  let(:valid_pdf) { fixture_file_upload('test.pdf', 'application/pdf') }
  let(:ebook) do
    ebook = Ebook.new(valid_attributes)
    ebook.pdf_file.attach(valid_pdf)
    ebook.save!
    ebook
  end

  describe 'GET #index' do
    it 'returns a success response' do
      ebook
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Ebook' do
        expect {
          post :create, params: { title: 'New', author: 'Author', pdf_file: valid_pdf }
        }.to change(Ebook, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'GET #download' do
    it 'downloads the attached pdf' do
      get :download, params: { id: ebook.id }
      expect(response).to have_http_status(:redirect) # redirects to blob url
    end
  end
end
