module AdvertHelper
  def state_link_or_span state
    if @advert.send("#{state}?")
      content_tag :span, t("adverts.state.#{state}")
    else
      "LINK"
      case state
        when "for_sale"
          path = set_for_sale_advert_path(@advert)
        when "reserved"
          path = reserve_advert_path(@advert)
        when "sold"
          path = sell_advert_path(@advert)
      end
      link_to t("adverts.state.#{state}"), path, method: :put
    end
  end
end
