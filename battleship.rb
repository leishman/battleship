class PlayerBoard

  def initialize(fleet)
    @fleet = fleet
  end

  def display

  end

  private

  def generate_board
    board = Array.new(10,Array.new(10,"-"))
    @fleet.each do |ship|
      board[row(ship.position)][column(ship.position)] = "X"
      if ship.position.heading == "h"
        1.upto(ship.length - 1) do |i|
          board[row(ship.position)][column(ship.position) + i]
        end
      else
        1.upto(ship.length - 1) do |i|
          board[row(ship.position) + i][column(ship.position)]
        end
      end
    end
  end

end

class OpponentBoard

  def initialize
  end

  def display
  end

  def shoot
  end
end

class Ship
  attr_accessor :position, :heading, :length
  def initialize(length, position = "", heading = "")
    @position = position
    @heading = heading
    @length = length
  end

  # Generate ship coordinates
  def gen_coordinates
      @x_coords = []
      @y_coords = []
    if @heading == "h"
      1.upto(@length - 1) do
        @x_coords << column(@position)
        @y_coords << row(@position)
      end
    else
      1.upto(@length - 1) do
        @x_coords << column(@position)
        @y_coords << row(@position)
      end

    end
  end
end

class Fleet
  attr_accessor :aircraft_carrier, :battleship, :cruiser, :destroyer_1, :destroyer_2, :submarine_1, :submarine_2
  def initialize
    @aircraft_carrier = Ship.new(5)
    @battleship = Ship.new(4)
    @cruiser = Ship.new(3)
    @destroyer_1 = Ship.new(2)
    @destroyer_2 = Ship.new(2)
    @submarine_1 = Ship.new(1)
    @submarine_2 = Ship.new(1)
  end
end

def column(ln_combo)
  letter_numbers = {"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8, "i" => 9, "j" => 10}
  letter = ln_combo.split('').first.downcase
  number_of_letter = letter_numbers[letter]
end

def row(ln_combo)
  number = ln_combo.split('').last.to_i
end

# Check to see if ship has a valid position
def check_position(ship)
  boundary = 11 - ship.length
  if ship.heading == "h" && (column(ship.position) > boundary || row(ship.position) > boundary)
    puts "Not a valid position"
    false
  end
  true
end


# human_player_board = PlayerBoard.new()
# human_opponent_board = OpponentBoard.new()

# computer_player_board = PlayerBoard.new()
# computer_opponent_board = OpponentBoard.new()


# Returns the column number of a coordinate pair get_column_num("D2") #=> 4

human_fleet = Fleet.new()


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

puts "Enter the position of your Aircraft carrier (length 5)"
human_fleet.aircraft_carrier.position = gets.chomp

puts "Enter the heading of your Aircraft carrier (h or v)"
human_fleet.aircraft_carrier.heading = gets.chomp

check_position(human_fleet.aircraft_carrier)

# puts "Enter the position of your Battleship (length 4)"
# human_fleet.battleship.heading = gets

# puts "Enter the position of your Battleship (length 4)"
# human_fleet.battleship.heading = gets


# puts "Enter the position of your cruiser (length 3)"

# puts "Enter the position of your first Destroyer (length 2)"

# puts "Enter position of your second Destroyer (length 2)"

# puts "Enter position of your first Submarine (length 1)"

# puts "Enter position of your second Submarine (length 1)"



a = Array.new(10,Array.new(10,"X"))

def print_matrix(matrix)
  matrix.each{ |x| p x }
end

#### TESTS ###

p "## TESTS ##"
p column("D2") == 4
p row("D2") == 2
ship = Ship.new("B2", "h")