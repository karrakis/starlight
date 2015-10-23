require "tco"
require "rmagick"

img = Magick::Image::read(ARGV[0]).first
img = img.adaptive_resize(0.2)
img.each_pixel do |pixel, col, row|
  c = [pixel.red, pixel.green, pixel.blue].map { |v| 256 * (v / 65535.0) }
  pixel.opacity == 65535 ? print("  ") : print("  ".bg c)
  puts if col >= img.columns - 1
end