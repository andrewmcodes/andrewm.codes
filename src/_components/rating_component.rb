class RatingComponent < ApplicationComponent
  required :rating

  def render_in(view_context)
    <<~HTML
      <div class="flex">
        #{yellow_stars}
        #{gray_stars}
      </div>
    HTML
  end

  private

  def yellow_stars
    return if rating.zero?
    stars(rating, color: "yellow")
  end

  def gray_stars
    return if gray_star_count.zero?
    stars(gray_star_count)
  end

  def stars(count, color: "gray")
    count == 1 ? star(color) : Array.new(count) { |_v| star(color) }.join
  end

  def gray_star_count
    @gray_star_count ||= 5 - rating
  end

  def star(color)
    <<~HTML
      <svg class="w-4 h-4 text-#{color}-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
      </svg>
    HTML
  end
end
