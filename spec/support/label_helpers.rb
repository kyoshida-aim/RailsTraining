module LabelHelpers
  def register_label(name:)
    fill_in(with: name, class: /\Aform-control input-name\z/)
    click_button(I18n.t("helpers.submit.create"))
  end
end
