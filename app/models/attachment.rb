class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true
end
