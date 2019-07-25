module UserHelpers
  def login(login_id:, password:)
    visit(login_path)
    fill_in(with: login_id, id: "session_login_id")
    fill_in(with: password, id: "session_password")
    click_button(I18n.t("helpers.submit.login"))
  end

  def login_by(user)
    login(login_id: user.login_id, password: user.password)
  end

  def register_user(login_id:, password:, password_confirmation:)
    fill_id_pass(login_id: login_id, password: password, password_confirmation: password_confirmation)
    click_button(I18n.t("helpers.submit.create"))
  end

  def update_user(login_id:, password:, password_confirmation:)
    fill_id_pass(login_id: login_id, password: password, password_confirmation: password_confirmation)
    click_button(I18n.t("helpers.submit.update"))
  end

  private

    def fill_id_pass(login_id:, password:, password_confirmation:)
      fill_in(with: login_id, class: /\Aform-control input-login_id\z/)
      fill_in(with: password, class: /\Aform-control input-password\z/)
      fill_in(with: password_confirmation, class: /\Aform-control input-password_confirmation\z/)
    end
end

RSpec.configure do |config|
  config.include UserHelpers, type: :system
end
