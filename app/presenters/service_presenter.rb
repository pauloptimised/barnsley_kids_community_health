class ServicePresenter < BasePresenter
  presents :service
  delegate :name, :subdomain, to: :service

  def linked_name
    h.link_to name, subdomain_link
  end

  def icon
    h.image_tag service.icon.url, class: 'service-icon-image'
  end

  def homepage_image
    h.image_tag service.image.homepage, class: 'service-image', alt: name
  end

  def banner_image
    h.image_tag service.image.banner, width: 424, height: 188
  end

  def colour
    service.colour.tr("_", "-")
  end

  def overview
    h.raw service.overview
  end

  def heading_classes
    ["service-header", colour].join(" ")
  end

  def subdomain_link
    h.request.protocol + subdomain + "." + [h.request.domain, h.request.port].compact.join(":")
  end

end
