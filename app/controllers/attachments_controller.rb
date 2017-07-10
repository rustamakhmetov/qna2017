class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  respond_to :js

  def destroy
    if current_user.author_of?(@attachment.attachable)
      respond_with(@attachment.destroy!)
    else
      @attachment.errors.add(:base, "Вы не можете удалять чужие файлы.")
      respond_with @attachment
    end
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
