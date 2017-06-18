class Attachment < ApplicationRecord
  delegate :identifier, to: :file
  delegate :filename, to: :file

  belongs_to :attachable, polymorphic: true, optional: true

  mount_uploader :file, FileUploader
end
