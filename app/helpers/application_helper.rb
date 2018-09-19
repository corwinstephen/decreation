module ApplicationHelper
	def render_project_images
		cms_fragment_content(:images).map do |i|
			"<div>#{image_tag(i)}</div>"
		end.join.html_safe
	end

	def homepage_image
		images = Comfy::Cms::File.for_category('homepage').with_attached_attachment.with_images
		offset = rand(images.count)
		image_tag(rails_blob_path(images.offset(offset).first.attachment, disposition: 'attachment'))
	end

	def sidenav_pages
		@cms_site.pages.for_category('sidenav').published
	end

	def yearlist
		fragment_content = @cms_site.pages.find_by(label: 'projects').children.published.map do |p|
			cms_fragment_content(:date, p)
		end

		fragment_content.uniq.reject(&:blank?).sort
	end

	def project_pages(category = nil)
		# Hack while waiting for partial locals fix
		category = params[:cms_path]

		pages = @cms_site.pages.find_by(label: 'projects').children.published
		pages = pages.for_category(category) if category
		pages = pages.select{|p| cms_fragment_content(:date, p).downcase.strip == params[:year].downcase.strip } if params[:year].present?
		pages
	end

	def project_image_urls
		output = project_pages.map do |p|
			attachments = cms_fragment_content(:featured_image, p).try(:attachments)
			image_url = attachments ? rails_blob_path(attachments.first) : nil
			{ id: p.id, image_url: image_url }
		end
	end
end
