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
def random_coords
  letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
  "#{letters.sample}#{rand(9)+1}"
end

def random_ship_input_prompt(ship)
  heading = ["h", "v"]
  ship.position = random_coords()
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

#================BATTLE LOGIC======================

def human_shoot(human_screen)
  puts "Enter coordinates of shot:"
  coords = gets.chomp
  human_screen.shoot(coords)
end

def computer_shoot(computer_screen)
  # Remove the randomness later
  computer_screen.shoot(random_coords)
end

def battle(computer_board, computer_screen, human_board, human_screen)
  winner = false
  while !winner
    human_shoot(human_screen)
    human_screen.display
    human_board.display
    puts "Press Enter to have the computer fire"
    junk = gets
    computer_shoot(computer_screen)
    puts "Computer has fired"
    human_screen.display
    human_board.display
  end
end
