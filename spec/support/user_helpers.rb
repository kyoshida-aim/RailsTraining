module UserHelpers
  def login_by(user)
    visit(login_path)
    fill_in(with: user.login_id, id: "session_login_id")
    fill_in(with: user.password, id: "session_password")
    click_button(I18n.t("helpers.submit.login"))
  end

  def try_login(login_id:, password:)
    visit(login_path)
    fill_in(with: login_id, id: "session_login_id")
    fill_in(with: password, id: "session_password")
    click_button(I18n.t("helpers.submit.login"))
  end
end
