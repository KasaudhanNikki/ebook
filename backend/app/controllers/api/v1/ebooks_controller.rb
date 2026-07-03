module Api
  module V1
    class EbooksController < ApplicationController
      before_action :set_ebook, only: [:show, :update, :destroy, :download]

      def index
        @ebooks = Ebook.all
        if params[:query].present?
          query = "%#{params[:query].downcase}%"
          # Active Storage filename search requires joining with active_storage_blobs
          @ebooks = @ebooks.left_outer_joins(pdf_file_attachment: :blob)
                           .where('LOWER(ebooks.title) LIKE :query OR LOWER(ebooks.author) LIKE :query OR LOWER(active_storage_blobs.filename) LIKE :query', query: query)
                           .distinct
        end

        render json: @ebooks.map { |ebook| serialize_ebook(ebook) }
      end

      def show
        render json: serialize_ebook(@ebook)
      end

      def create
        @ebook = Ebook.new(ebook_params)

        if @ebook.save
          render json: serialize_ebook(@ebook), status: :created
        else
          render json: { errors: @ebook.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @ebook.update(ebook_params)
          render json: serialize_ebook(@ebook)
        else
          render json: { errors: @ebook.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @ebook.destroy
        head :no_content
      end

      def download
        if @ebook.pdf_file.attached?
          redirect_to rails_blob_url(@ebook.pdf_file, disposition: "attachment")
        else
          render json: { error: 'PDF not found' }, status: :not_found
        end
      end

      private

      def set_ebook
        @ebook = Ebook.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Ebook not found' }, status: :not_found
      end

      def ebook_params
        params.permit(:title, :author, :pdf_file)
      end

      def serialize_ebook(ebook)
        {
          id: ebook.id,
          title: ebook.title,
          author: ebook.author,
          filename: ebook.filename,
          pdf_url: ebook.pdf_url
        }
      end
    end
  end
end
