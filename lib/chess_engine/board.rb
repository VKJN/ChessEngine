module ChessEngine
  class Board
    def initialize
      # Создаем пустую доску 8x8
      # grid[0] - это 8-я горизонталь (a8, b8, ...)
      # grid[7] - это 1-я горизонталь (a1, b1, ...)
      @grid = Array.new(8) { Array.new(8) }
    end

    # Ставит фигуру на клетку
    def place_piece(position, piece)
      row, col = position_to_coordinates(position)
      @grid[row][col] = piece
    end

    # Возвращает фигуру на клетке (или nil, если пусто)
    def piece_at(position)
      row, col = position_to_coordinates(position)
      @grid[row][col]
    end

    def move_piece(from, to)
      piece = piece_at(from)
      return false if piece.nil?
      
      target = piece_at(to)
      return false if target && target.color == piece.color

      return false unless piece.valid_move?(from, to, self)
      
      place_piece(to, piece)
      place_piece(from, nil)
      true
    end

    def empty?(position)
      piece_at(position).nil?
    end

    def piece_color_at(position)
      piece = piece_at(position)
      piece&.color
    end

    def setup_initial_position
      ('a'..'h').each do |letter|
        place_piece("#{letter}2", Piece.new(:white, :pawn))
        place_piece("#{letter}7", Piece.new(:black, :pawn))
      end
      
      place_piece('a1', Piece.new(:white, :rook))
      place_piece('h1', Piece.new(:white, :rook))
      place_piece('a8', Piece.new(:black, :rook))
      place_piece('h8', Piece.new(:black, :rook))
      
      place_piece('b1', Piece.new(:white, :knight))
      place_piece('g1', Piece.new(:white, :knight))
      place_piece('b8', Piece.new(:black, :knight))
      place_piece('g8', Piece.new(:black, :knight))
      
      place_piece('c1', Piece.new(:white, :bishop))
      place_piece('f1', Piece.new(:white, :bishop))
      place_piece('c8', Piece.new(:black, :bishop))
      place_piece('f8', Piece.new(:black, :bishop))
      
      place_piece('d1', Piece.new(:white, :queen))
      place_piece('d8', Piece.new(:black, :queen))
      

      place_piece('e1', Piece.new(:white, :king))
      place_piece('e8', Piece.new(:black, :king))
    end
    
    private
    # Переводит 'e2' в индексы массива [row, col]
    def position_to_coordinates(position)
      col = position[0].ord - 'a'.ord
      row = 8 - position[1].to_i
      [row, col]
    end

    def coordinates_to_position(row, col)
      file = (col + 'a'.ord).chr
      rank = (8 - row).to_s
      "#{file}#{rank}"
    end
  end
end