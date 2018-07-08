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
end
