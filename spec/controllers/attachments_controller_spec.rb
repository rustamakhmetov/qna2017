require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    sign_in_user

    let!(:question) { create(:question, user: @user) }
    let!(:attachment) { create(:attachment, attachable: question) }

    it 'assigns the requested attachment to @attachment' do
      delete :destroy, params: {id: attachment, format: :js}
      expect(assigns(:attachment)).to eq attachment
    end

    it 'delete attachment of question' do
      expect {delete :destroy, params: {id: attachment, format: :js}}.to change(Attachment, :count).by(-1)
    end

    it 'user can not delete attachament of other author' do
      attachment = create(:attachment, attachable: create(:question, user: create(:user)))
      expect {delete :destroy, params: {id: attachment, format: :js}}.to_not change(Attachment, :count)
    end

    it 'render destroy template' do
      delete :destroy, params: {id: attachment, format: :js}
      expect(response).to render_template :destroy
    end
  end
end