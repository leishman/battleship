require_relative 'battleship_class_definitions.rb'
require_relative 'battleship_game_helpers.rb'

#=================START GAME================

human_fleet = Fleet.new()
computer_fleet = Fleet.new()

puts "Welcome to Battleship"
puts <<-eos
# Fleet table

| #  | Ship             | Size |
| -- | ---------------- | ---- |
| 1x | Aircraft carrier | 5    |
| 1x | Battleship       | 4    |
| 1x | Cruiser          | 3    |
| 2x | Destroyer        | 2    |
| 2x | Submarine        | 1    |
eos

# Layout ships on the boards
get_user_input(human_fleet)
random_get_user_input(computer_fleet)

# Create human board
human_board = PlayerBoard.new(human_fleet)
human_board.generate_board("Your Board")

# Create computer board
computer_board = PlayerBoard.new(computer_fleet)
computer_board.generate_board("Computer Board")

# Create human screen (view of the hits and misses)
human_screen = PlayerScreen.new(computer_board)
human_screen.generate

# Create computer screen (view of hits and misses)
computer_screen = PlayerScreen.new(human_board)

# Start battle
battle(computer_board, computer_screen, human_board, human_screen)
