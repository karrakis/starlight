#!/usr/bin/env ruby

require 'rubygems'
require 'gosu'
require 'ashton'

$sand1 = Gosu::Image.new("tiles/sand1.jpg", :tileable => true)
$sand2 = Gosu::Image.new("tiles/sand2.jpg", :tileable => true)
$sand3 = Gosu::Image.new("tiles/sand3.jpg", :tileable => true)
$rock1 = Gosu::Image.new("tiles/rock1.jpg", :tileable => true)
$star3 = Gosu::Image.new("tiles/star3.jpg", :tileable => true)

#this is probably handled improperly.  It works, but would be better as a feature of each item
#featurization would permit impassability to be removed from individual instances
#it would, however, make it harder to implement, say, a drill item that renders all rocks passable
#which currently involves "$impassables.delete($rock1) if $drill"
#or something.  I dunno.  Too tired.
$impassables = [$rock1]

class Player
	attr_accessor :x, :y, :last_x, :last_y
	def initialize(background, field_permeability)
		@background = background
		@field_permeability = field_permeability
		@player_image = {:object => Gosu::Image.new("tiles/star1.jpg", :tileable => true), :altitude => 10}
		@x = 50
		@y = 50
		@background[@x][@y] << @player_image
		store_last_location
	end

	def store_last_location
		@last_x = @x
		@last_y = @y
	end

	def move
		@background[@last_x][@last_y].delete(@player_image)
		@background[@last_x][@last_y] = [{:object => $rock1, :altitude => 0}]
		@background[@x][@y] << @player_image
		store_last_location
		return @background	
	end
end

class StarlightWindow < Gosu::Window
	WIDTH = 1000
	HEIGHT = 1000
	TILE_SIZE = 10
	def initialize
		super WIDTH, HEIGHT
		self.caption = "Ant Simulator"
		@background_images = [$sand1, $sand2, $sand3, $rock1, $star3]
		@background = Array.new(100){ Array.new(100){ [{:object => @background_images[(rand(5).to_f / 2 * rand(5).to_f / 2).ceil], :altitude => 0}]}}
		@player = Player.new(@background, @field_permeability)
		@redraw = true
	end

	def impermeable(x,y)
		return true if @background[x][y].select{|m| $impassables.include?(m[:object])} != []
		return false
	end

	def update
		if button_down?(Gosu::KbLeft)
			@player.x -= 1 unless impermeable(@player.x - 1, @player.y)
		end
		if button_down?(Gosu::KbRight)
			@player.x += 1 unless impermeable(@player.x + 1, @player.y)
		end
		if button_down?(Gosu::KbUp)
			@player.y -= 1 unless impermeable(@player.x, @player.y - 1)
		end
		if button_down?(Gosu::KbDown)
			@player.y += 1 unless impermeable(@player.x, @player.y + 1)
		end
		if @background[@player.x][@player.y].select{|m| m[:object] == $star3} != []
			(@player.x - 3..@player.x + 3).each do |x|
				(@player.y - 3..@player.y + 3).each do |y|
					@background[x][y] = [{:object => $sand1, :altitude => 0}]
				end
			end
		end
		@background = @player.move if @player.last_x != @player.x or @player.last_y != @player.y
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
				@background[x][y].each{|m| m[:object].draw(x * TILE_SIZE,y * TILE_SIZE, m[:altitude])}
			end
		end
		@redraw = false
	end


end

window = StarlightWindow.new
window.show