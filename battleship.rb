# Pass in 10x10 matrix of inputs and display symbols in sweet grid
def display_board(matrix, message)

  puts message

  puts <<-eos
         A   B   C   D   E   F   G   H   I   J
      +---------------------------------------+
    eos
  matrix.each_with_index do |x, i|
    puts <<-eos
   #{i+1} #{" " if i != 9}| #{x[0]} | #{x[1]} | #{x[2]} | #{x[3]} | #{x[4]} | #{x[5]} | #{x[6]} | #{x[7]} | #{x[8]} | #{x[9]} |
      |---|---|---|---|---|---|---|---|---|---|
    eos
  end

puts <<-eos
      +---------------------------------------+
      eos
end





class PlayerBoard

  def initialize(fleet)
    @fleet = fleet
  end

  def display

  end


  def generate_board(message)
    # board = Array.new(10,Array.new(10,"-"))
    board = []
    10.times do
      board << ["-","-","-","-","-","-","-","-","-","-"]
    end
    name_key = {5 => "A", 4=> "B", 3=> "C", 2=> "D", 1=> "S"}
    @fleet.ships.each do |ship|
      letter = name_key[ship.length].split[0]
      if ship.position != (nil || "")
        board[row(ship.position) - 1][column(ship.position) - 1] = letter
        if ship.heading == "h"
          1.upto(ship.length - 1) do |i|
            board[row(ship.position) - 1][column(ship.position) - 1+ i] = letter
          end
        elsif ship.heading == "v"
          1.upto(ship.length - 1) do |i|
            board[row(ship.position) - 1 + i][column(ship.position) - 1] = letter
          end
        end
      end

    end
    display_board(board, message)
  end

end



class OpponentBoard

  def initialize
  end

  def display
  end

  def shoot
  end

  def generate_board
    # board = Array.new(10,Array.new(10,"-"))
    board = []
    10.times do
      board << ["-","-","-","-","-","-","-","-","-","-"]
    end
    @fleet.ships.each do |ship|
      if ship.position != (nil || "")
        board[row(ship.position) - 1][column(ship.position) - 1] = "X"
        if ship.heading == "h"
          1.upto(ship.length - 1) do |i|
            board[row(ship.position) - 1][column(ship.position) - 1+ i] = "X"
          end
        elsif ship.heading == "v"
          1.upto(ship.length - 1) do |i|
            board[row(ship.position) - 1 + i][column(ship.position) - 1] = "X"
          end
        end
      end

    end
     p board
  end
end

class Ship
  attr_accessor :position, :heading, :length
  attr_reader :x_coords, :y_coords, :combined_coords
  def initialize(length, position = "", heading = "")
    @length = length
    @position = position
    @heading = heading
    @combined_coords = []
  end

  # Generate ship coordinates
  def gen_coordinates
      @x_coords = []
      @y_coords = []
      @combined_coords = []
    if @heading == "h"
      0.upto(@length - 1) do |i|
        @x_coords << column(@position) + i
        @y_coords << row(@position)
      end
    else
      0.upto(@length - 1) do |i|
        @x_coords << column(@position)
        @y_coords << row(@position) + i
      end
    end
    @x_coords.each_with_index do |x, i|
      @combined_coords[i] = "#{x}#{@y_coords[i]}"
    end
  end

  # Check to see if ship is in valid board position
  def check_position
    boundary = 11 - @length
    if ((@heading == "h" && column(@position) > boundary) || (@heading == "v" && row(@position) > boundary)) || (column(@position) > 10 || row(@position) > 10)
      false
    else
      true
    end
  end
end

class Fleet
  attr_accessor :aircraft_carrier, :battleship, :cruiser, :destroyer_1, :destroyer_2, :submarine_1, :submarine_2
  attr_reader :filled_coords, :ships
  def initialize
    @aircraft_carrier = Ship.new(5)
    @battleship = Ship.new(4)
    @cruiser = Ship.new(3)
    @destroyer_1 = Ship.new(2)
    @destroyer_2 = Ship.new(2)
    @submarine_1 = Ship.new(1)
    @submarine_2 = Ship.new(1)
    @ships = [@aircraft_carrier, @battleship, @cruiser, @destroyer_1, @destroyer_2, @submarine_1, @submarine_2]
    @filled_coords = []
  end

  def add_to_fleet_coords(ship)
    ship.gen_coordinates
    @filled_coords.concat(ship.combined_coords)
  end

  # Returns false if there is collision detected
  def check_coords(ship)
    if !(ship.combined_coords & @filled_coords).empty?
      false
    else
      true
    end
  end
end


# Extra methods

def column(ln_combo)
  letter_numbers = {"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8, "i" => 9, "j" => 10}
  letter = ln_combo.split('').first.to_s.downcase
  number_of_letter = letter_numbers[letter]
end

def row(ln_combo)
  number = ln_combo.split('').last.to_i
end

#=======================GET USER INPUT=============================

def ship_input_prompt(ship, name)
  puts "Enter the position of your #{name} (length #{ship.length})"
  ship.position = gets.chomp
  puts "Enter the heading of your #{name} (h or v)"
  ship.heading = gets.chomp
end

def get_ship(fleet, ship, name)
  ship_input_prompt(ship, name)
  ship.gen_coordinates
  while !(ship.check_position && fleet.check_coords(ship))
    p "Ship is out of bounds or collides with another ship, choose new location"
    ship_input_prompt(ship, name)
    ship.gen_coordinates
  end
    fleet.add_to_fleet_coords(ship)
end


def get_user_input(fleet)
  get_ship(fleet, fleet.aircraft_carrier, "Aircraft Carrier")
  get_ship(fleet, fleet.battleship, "Battleship")
  # get_ship(fleet, fleet.cruiser, "Cruiser")
  # get_ship(fleet, fleet.destroyer_1, "Destroyer 1")
  # get_ship(fleet, fleet.destroyer_2, "Destroyer 2")
  # get_ship(fleet, fleet.submarine_1, "Submarine 1")
  # get_ship(fleet, fleet.submarine_2, "Submarine 2")
end

#============GENERATE COMPUTER INPUT==============

def random_ship_input_prompt(ship)
  y = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
  heading = ["h", "v"]
  ship.position = "#{y.sample}#{rand(9)+1}"
  ship.heading = heading.sample
end

def random_get_ship(ship, fleet)
  random_ship_input_prompt(ship)
  ship.gen_coordinates
  while !(ship.check_position && fleet.check_coords(ship))
    random_ship_input_prompt(ship)
    ship.gen_coordinates
  end
    fleet.add_to_fleet_coords(ship)
end

def random_get_user_input(fleet)
  fleet.ships.each do |ship|
    random_get_ship(ship, fleet)
  end
end

#=================START GAME================

def shoot(coordinate)

end



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

get_user_input(human_fleet)
random_get_user_input(computer_fleet)

human_board = PlayerBoard.new(human_fleet)
human_board.generate_board("Your Board")
computer_board = PlayerBoard.new(computer_fleet)
computer_board.generate_board("Computer Board")

