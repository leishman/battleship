class PlayerBoard

  def initialize(fleet)
    @fleet = fleet
  end

  def display

  end


  def generate_board
    # board = Array.new(10,Array.new(10,"-"))
    board = []
    10.times do
      board << ["-","-","-","-","-","-","-","-","-","-"]
    end
    @fleet.ships.each do |ship|
      # p ship
      if ship.position != (nil || "")
        p ship.position
        p board[row(ship.position) - 1][column(ship.position) - 1] = "X"
        if ship.heading == "h"
          1.upto(ship.length - 1) do |i|
            p i
            board[row(ship.position) - 1][column(ship.position) - 1+ i] = "X"
          end
        elsif ship.heading == "v"
          1.upto(ship.length - 1) do |i|
            p i
            board[row(ship.position) - 1 + i][column(ship.position) - 1] = "X"
          end
        end
      end

    end
     p board
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
    p ship.combined_coords
    p @filled_coords
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

def ship_input_prompt(ship, name)
  puts "Enter the position of your #{name} (length #{ship.length})"
  ship.position = gets.chomp
  puts "Enter the heading of your #{name} (h or v)"
  ship.heading = gets.chomp
end

def get_ship(fleet, ship, name)
  ship_input_prompt(ship, name)

  # Check to see if ship is in bounds
  begin
    raise "Ship is out of bounds, choose new location" if !ship.check_position
  rescue Exception => ex
    p ex.message
    ship_input_prompt(ship, name)
  end

  ship.gen_coordinates

  # Check to see if ship is overlapping another
  begin
    raise "Ship cannot overlap with existing ship, choose new location" if !fleet.check_coords(ship)
  rescue Exception => ex
    p ex.message
    ship_input_prompt(ship, name)
  end
  fleet.add_to_fleet_coords(ship)
end




def get_user_input(fleet)
  get_ship(fleet, fleet.aircraft_carrier, "Aircraft Carrier")
  get_ship(fleet, fleet.battleship, "Battleship")
  get_ship(fleet, fleet.cruiser, "Cruiser")
  get_ship(fleet, fleet.destroyer_1, "Destroyer 1")
  get_ship(fleet, fleet.destroyer_2, "Destroyer 2")
  get_ship(fleet, fleet.submarine_1, "Submarine 1")
  get_ship(fleet, fleet.submarine_2, "Submarine 2")
end

# Check to see if ship has a valid position



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

get_user_input(human_fleet)

human_board = PlayerBoard.new(human_fleet)
human_board.generate_board
# puts "Enter the position of your Aircraft carrier (length 5)"
# human_fleet.aircraft_carrier.position = 'B2' #gets.chomp

# puts "Enter the heading of your Aircraft carrier (h or v)"
# human_fleet.aircraft_carrier.heading = 'h' #gets.chomp

# human_fleet.aircraft_carrier.check_position

# human_fleet.aircraft_carrier.gen_coordinates
# human_fleet.add_to_fleet_coords(human_fleet.aircraft_carrier)

# p human_fleet.aircraft_carrier.y_coords
# p human_fleet.aircraft_carrier.x_coords



# puts "Enter the position of your Battleship (length 4)"
# human_fleet.battleship.position = 'B2' #gets.chomp

# puts "Enter the position of your Battleship (length 4)"
# human_fleet.battleship.heading = 'v' #gets.chomp

# human_fleet.battleship.check_position
# human_fleet.battleship.gen_coordinates

# if !human_fleet.check_coords(human_fleet.battleship)
#   puts "Ship overlaps position, please enter new location"
# end


# human_fleet.add_to_fleet_coords(human_fleet.battleship)

# p human_fleet.filled_coords
# p human_fleet.aircraft_carrier

# human_fleet.add_to_fleet_coords(human_fleet.battleship)

# puts "Enter the position of your cruiser (length 3)"

# puts "Enter the position of your first Destroyer (length 2)"

# puts "Enter position of your second Destroyer (length 2)"

# puts "Enter position of your first Submarine (length 1)"

# puts "Enter position of your second Submarine (length 1)"



# a = Array.new(10,Array.new(10,"X"))

# def print_matrix(matrix)
#   matrix.each{ |x| p x }
# end

# #### TESTS ###

# p "## TESTS ##"
# p column("D2") == 4
# p row("D2") == 2
# ship = Ship.new("B2", "h")