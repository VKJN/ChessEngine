module ChessEngine
  class Piece
    TYPES = {
      pawn: 'пешка',
      knight: 'конь',
      bishop: 'слон',
      rook: 'ладья',
      queen: 'ферзь',
      king: 'король'
    }

      def color
        @color
      end
      
      def type
        @type
      end

    def initialize(color, type)
      @color = color
      @type = type
    end

    def symbol
      case @type
      when :pawn then @color == :black ? '♙' : '♟'
      when :knight then @color == :black ? '♘' : '♞'
      when :bishop then @color == :black ? '♗' : '♝'
      when :rook then @color == :black ? '♖' : '♜'
      when :queen then @color == :black ? '♕' : '♛'
      when :king then @color == :black ? '♔' : '♚'
      end
    end

    def valid_move?(from, to, board)
      if @type == :pawn
        valid_pawn_move?(from, to, board)
      elsif @type == :knight
        valid_knight_move?(from, to, board)
      elsif @type == :rook
        valid_rook_move?(from, to, board)
      elsif @type == :bishop
        valid_bishop_move?(from, to, board)
      elsif @type == :queen
        valid_queen_move?(from, to, board)
      elsif @type == :king
        valid_king_move?(from, to, board)
      else
        false
      end
    end

private
    def valid_pawn_move?(from, to, board)
      from_row, from_col = board.send(:position_to_coordinates, from)
      to_row, to_col = board.send(:position_to_coordinates, to)
      
      delta_row = (to_row - from_row).abs
      delta_col = (to_col - from_col).abs
      
      # Направление: белые вверх (row уменьшается), черные вниз (row увеличивается)
      direction = @color == :white ? -1 : 1
      
      # Ход на 1 клетку вперед
      if delta_col == 0 && to_row - from_row == direction
        return board.piece_at(to).nil?
      end
      
      # Ход на 2 клетки с начальной позиции
      start_row = @color == :white ? 6 : 1  # Белые: ряд 6 (e2), Черные: ряд 1 (e7)
      if from_row == start_row && delta_col == 0 && to_row - from_row == 2 * direction
        mid_row = from_row + direction
        mid_pos = board.send(:coordinates_to_position, mid_row, from_col)
        return board.piece_at(mid_pos).nil? && board.piece_at(to).nil?
      end
      
      # Взятие фигуры по диагонали
      if delta_col == 1 && to_row - from_row == direction
        target = board.piece_at(to)
        return !target.nil? && target.color != @color
      end
      
      false
    end

    def valid_knight_move?(from, to, board)
      from_row, from_col = board.send(:position_to_coordinates, from)
      to_row, to_col = board.send(:position_to_coordinates, to)
      
      delta_row = (to_row - from_row).abs
      delta_col = (to_col - from_col).abs
      
      # Конь ходит буквой "Г": 2 и 1 или 1 и 2
      (delta_row == 2 && delta_col == 1) || (delta_row == 1 && delta_col == 2)
    end

    def valid_rook_move?(from, to, board)
      from_row, from_col = board.send(:position_to_coordinates, from)
      to_row, to_col = board.send(:position_to_coordinates, to)
      
      delta_row = (to_row - from_row).abs
      delta_col = (to_col - from_col).abs
      
      # Ладья ходит только по горизонтали или вертикали
      return false unless delta_row == 0 || delta_col == 0
      # Нельзя стоять на месте
      return false if delta_row == 0 && delta_col == 0

      path_clear?(from_row, from_col, to_row, to_col, board)
    end

    def valid_bishop_move?(from, to, board)
      from_row, from_col = board.send(:position_to_coordinates, from)
      to_row, to_col = board.send(:position_to_coordinates, to)
      
      delta_row = (to_row - from_row).abs
      delta_col = (to_col - from_col).abs
      
      # Слон ходит только по диагонали
      return false unless delta_row == delta_col
      # Нельзя стоять на месте
      return false if delta_row == 0

      path_clear?(from_row, from_col, to_row, to_col, board)
    end

    def valid_queen_move?(from, to, board)
      from_row, from_col = board.send(:position_to_coordinates, from)
      to_row, to_col = board.send(:position_to_coordinates, to)
      
      delta_row = (to_row - from_row).abs
      delta_col = (to_col - from_col).abs
      
      # Ферзь ходит как ладья или как слон
      is_rook_move = (delta_row == 0 || delta_col == 0)
      is_bishop_move = (delta_row == delta_col)
      
      return false unless is_rook_move || is_bishop_move
      return false if delta_row == 0 && delta_col == 0
      
      path_clear?(from_row, from_col, to_row, to_col, board)
    end

    def valid_king_move?(from, to, board)
      from_row, from_col = board.send(:position_to_coordinates, from)
      to_row, to_col = board.send(:position_to_coordinates, to)
      
      delta_row = (to_row - from_row).abs
      delta_col = (to_col - from_col).abs
      
      # Король ходит на 1 клетку в любом направлении
      delta_row <= 1 && delta_col <= 1 && (delta_row + delta_col) > 0
    end

    def path_clear?(from_row, from_col, to_row, to_col, board)
      row_step = to_row <=> from_row
      col_step = to_col <=> from_col
      
      current_row = from_row + row_step
      current_col = from_col + col_step
      
      while current_row != to_row || current_col != to_col
        position = board.send(:coordinates_to_position, current_row, current_col)
        return false unless board.piece_at(position).nil?
        
        current_row += row_step
        current_col += col_step
      end
      
      true
    end
  end
end