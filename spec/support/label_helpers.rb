module LabelHelpers
  def register_label(name:)
    fill_name(name: name)
    click_button(I18n.t("helpers.submit.create"))
  end

  def update_label(name:)
    fill_name(name: name)
    click_button(I18n.t("helpers.submit.update"))
  end

  private

    def fill_name(name:)
      fill_in(with: name, class: /\Aform-control input-name\z/)
    end
end
