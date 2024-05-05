class Blog < ApplicationRecord
  BATCH_SIZE = 200
  belongs_to :user
end
