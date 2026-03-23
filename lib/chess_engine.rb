require_relative "chess_engine/piece"
require_relative "chess_engine/board"

module ChessEngine
  VERSION = "0.1.0"
  
  def self.new_game
    board = Board.new
    board.setup_initial_position
    board
  end
end