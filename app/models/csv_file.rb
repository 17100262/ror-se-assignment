class CsvFile < ApplicationRecord
    belongs_to :user

    has_one_attached :attachment
    after_create :start_csv_import_job

    private

    def start_csv_import_job
        blob = self.attachment.blob
        file_path = ActiveStorage::Blob.service.path_for(blob.key)
        user_id = self.user.id
    
        CsvImportWorker.perform_async(user_id, file_path)
    end
end
