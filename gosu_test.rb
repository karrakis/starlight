require 'gosu'
require 'terminfo'

=begin
notes:
google terms for future:
gosu impassable objects

if that fails, figure out how to "lock off" locations in the array so that players cannot be in them.
try also to arrange for array draw to happen in such a way that "stacks of objects" are at array entry locations
including players, trees, etc. - movement should be in increments of 10 and redraws should only happen
whenever movement does.  Non-player movement should be minimized by consequence.
=end

class Star
  attr_reader :x, :y

  def initialize
  	@background_images = [Gosu::Image.new("tiles/star1.jpg", :tileable => true), Gosu::Image.new("tiles/star2.jpg", :tileable => true),Gosu::Image.new("tiles/star3.jpg", :tileable => true)]
    @color = Gosu::Color.new(0xff_000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = (rand * 1000).ceil
    @y = (rand * 1000).ceil
    @migrate = rand(2) == 1 ? 1 : -1
    @migratex = rand(2) == 1 ? 1 : -1
    @migratey = rand(2) == 1 ? 1 : -1
  end

  def move(player)
  	@x += @migratex
 	@y += @migratey
 	@migratex += rand * 0.01 * @migrate
 	@migratey += rand * 0.01 * @migrate
  	if @x == 1000
		@x = 0
	elsif @x == 0
		@x == 1000
	end
	if @y == 1000
		@y = 0
	elsif @y == 0
		@y == 1000
	end
	if player.x < @x
		@x -= 2
	end
	if player.y < @y
		@y -= 2
	end
	if player.x > @x
		@x += 2
	end
	if player.y > @y
		@y += 2
	end
  end

  def draw
  	img = @background_images[rand(3)];
    img.draw(@x - img.width, @y - img.height, 0)
  end
end

class Player
	attr_accessor :x, :y
	def initialize
		@player_images = [Gosu::Image.new("tiles/star1.jpg", :tileable => true), Gosu::Image.new("tiles/star2.jpg", :tileable => true),Gosu::Image.new("tiles/star3.jpg", :tileable => true)]
		@x = 500
		@y = 500
	end

	def move
	  	if @x >= 1000
			@x = 0
		elsif @x <= 0
			@x = 1000
		end
		if @y >= 1000
			@y = 0
		elsif @y <= 0
			@y = 1000
		end 
	end

	def draw
		img = @player_images[rand(3)]
		img.draw(@x - img.width, @y - img.height, 0)
	end
end

class StarlightWindow < Gosu::Window
	WIDTH = 1000
	HEIGHT = 1000
	TILE_SIZE = 10
	def initialize
		super WIDTH, HEIGHT
		self.caption = "Gosu Tutorial Game"
		@background_images = [Gosu::Image.new("tiles/grass1.jpg", :tileable => true), Gosu::Image.new("tiles/grass2.jpg", :tileable => true),Gosu::Image.new("tiles/grass3.jpg", :tileable => true), Gosu::Image.new("tiles/grass4.jpg", :tileable => true)]
		@background = Array.new(100){ Array.new(100){ @background_images[rand(4)]}}
		@stars = Array.new
		@redraw = true
		@player = Player.new
	end

	def update
		@stars << Star.new
		@stars.each{|star| star.move(@player)}
		button_down?(Gosu::KbLeft) ? @player.x -= 10 : nil
		button_down?(Gosu::KbRight) ? @player.x += 10 : nil
		button_down?(Gosu::KbUp) ? @player.y -= 10 : nil
		button_down?(Gosu::KbDown) ? @player.y += 10 : nil
		@player.move
		if button_down?(Gosu::KbLeft) || button_down?(Gosu::KbRight) || button_down?(Gosu::KbUp) || button_down?(Gosu::KbDown)
			@redraw = true
		end
	end

	def needs_redraw?
		@redraw
	end

	def draw
		(0..99).each do |x|
			(0..99).each do |y|
				@background[x][y].draw(x * TILE_SIZE,y * TILE_SIZE,0)
			end
		end
		@stars.each{|star| star.draw}
		@player.draw
		@redraw = false
	end


end

window = StarlightWindow.new
window.show
