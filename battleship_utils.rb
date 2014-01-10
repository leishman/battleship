# Clear the screen
def clear_screen!
  print "\e[2J"
end

def display_board(matrix, message = "")
  # clear_screen!
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

# Extra methods

def column(ln_combo)
  letter_numbers = {"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8, "i" => 9, "j" => 10}
  letter = ln_combo.split('').first.to_s.downcase
  number_of_letter = letter_numbers[letter]
end

def row(ln_combo)
  number = ln_combo.split('').last.to_i
end
