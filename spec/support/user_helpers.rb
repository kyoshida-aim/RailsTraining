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
end
