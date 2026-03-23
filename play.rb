require './lib/chess_engine'

board = ChessEngine.new_game
turn = :white

loop do
  puts "\n#{turn.to_s.upcase} ходит"
  print "Введите ход (например, e2 e4): "
  input = gets.chomp
  break if input == 'exit'
  
  from, to = input.split
  
  if board.move_piece(from, to)
    puts "Ход принят!"
    turn = turn == :white ? :black : :white
  else
    puts "Невозможный ход!"
  end
end