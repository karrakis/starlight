require 'colorize'
require 'terminfo'


class Tile
	attr_accessor :type
	def initialize(type)
		@type = decide_type(type)
	end

	def decide_type(type)
		case type
		when 'ocean'
			return "\u2713".colorize(background: :blue)
		end
	end
end

class Player
	attr_accessor :health, :graphic
	def initialize(status)
		case status
		when 'start'
			@health = 100
			@graphic = "$"
		end
	end
end

class Field

	def initialize
		@terrain = Array.new(TermInfo.screen_size[0]) { Array.new(TermInfo.screen_size[1]){ Tile.new('ocean').type} }
		@terrain[TermInfo.screen_size[0]/2][TermInfo.screen_size[1]/2] = Player.new('start').graphic
	end

	def display
		@terrain.each{|col| col.each{|square| print square}; print "\n"}
	end

end