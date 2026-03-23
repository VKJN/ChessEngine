require_relative "../lib/chess_engine"

RSpec.describe ChessEngine::Board do
  let(:board) { ChessEngine::Board.new }
  let(:white_pawn) { ChessEngine::Piece.new(:white, :pawn) }
  let(:black_pawn) { ChessEngine::Piece.new(:black, :pawn) }
  let(:white_knight) { ChessEngine::Piece.new(:white, :knight) }
  let(:black_knight) { ChessEngine::Piece.new(:black, :knight) }
  let(:white_rook) { ChessEngine::Piece.new(:white, :rook) }
  let(:white_bishop) { ChessEngine::Piece.new(:white, :bishop) }
  let(:white_queen) { ChessEngine::Piece.new(:white, :queen) }
  let(:white_king) { ChessEngine::Piece.new(:white, :king) }

  describe "#new" do
    it "создает пустую доску" do
      expect(board.piece_at('e2')).to be_nil
    end
  end

  describe "#place_piece и #piece_at" do
    it "ставит фигуру на доску и возвращает её" do
      board.place_piece('e2', white_pawn)
      
      piece = board.piece_at('e2')
      expect(piece).to eq(white_pawn)
      expect(piece.color).to eq(:white)
      expect(piece.type).to eq(:pawn)
    end

    it "возвращает nil для пустой клетки" do
      expect(board.piece_at('e2')).to be_nil
    end
  end

  describe "#setup_initial_position" do
    before do
      board.setup_initial_position
    end

    it "расставляет белые пешки на 2-й горизонтали" do
      ('a'..'h').each do |file|
        piece = board.piece_at("#{file}2")
        expect(piece.type).to eq(:pawn)
        expect(piece.color).to eq(:white)
      end
    end

    it "расставляет черные пешки на 7-й горизонтали" do
      ('a'..'h').each do |file|
        piece = board.piece_at("#{file}7")
        expect(piece.type).to eq(:pawn)
        expect(piece.color).to eq(:black)
      end
    end

    it "расставляет белые фигуры на 1-й горизонтали" do
      expect(board.piece_at('a1').type).to eq(:rook)
      expect(board.piece_at('b1').type).to eq(:knight)
      expect(board.piece_at('c1').type).to eq(:bishop)
      expect(board.piece_at('d1').type).to eq(:queen)
      expect(board.piece_at('e1').type).to eq(:king)
      expect(board.piece_at('f1').type).to eq(:bishop)
      expect(board.piece_at('g1').type).to eq(:knight)
      expect(board.piece_at('h1').type).to eq(:rook)
    end

    it "расставляет черные фигуры на 8-й горизонтали" do
      expect(board.piece_at('a8').type).to eq(:rook)
      expect(board.piece_at('b8').type).to eq(:knight)
      expect(board.piece_at('c8').type).to eq(:bishop)
      expect(board.piece_at('d8').type).to eq(:queen)
      expect(board.piece_at('e8').type).to eq(:king)
      expect(board.piece_at('f8').type).to eq(:bishop)
      expect(board.piece_at('g8').type).to eq(:knight)
      expect(board.piece_at('h8').type).to eq(:rook)
    end
  end

  describe "#move_piece" do
    before do
      board.setup_initial_position
    end

    describe "ход пешкой" do
      it "позволяет белой пешке ходить на 2 клетки с начальной позиции" do
        expect(board.move_piece('e2', 'e4')).to eq(true)
        expect(board.piece_at('e2')).to be_nil
        expect(board.piece_at('e4').type).to eq(:pawn)
      end

      it "позволяет черной пешке ходить на 2 клетки с начальной позиции" do
        expect(board.move_piece('e7', 'e5')).to eq(true)
        expect(board.piece_at('e7')).to be_nil
        expect(board.piece_at('e5').type).to eq(:pawn)
      end

      it "позволяет пешке ходить на 1 клетку вперед" do
        board.move_piece('e2', 'e4')
        expect(board.move_piece('e4', 'e5')).to eq(true)
        expect(board.piece_at('e4')).to be_nil
        expect(board.piece_at('e5').type).to eq(:pawn)
      end

      it "не позволяет пешке ходить на 2 клетки не с начальной позиции" do
        board.move_piece('e2', 'e4')
        expect(board.move_piece('e4', 'e6')).to eq(false)
      end

      it "не позволяет пешке ходить назад" do
        board.move_piece('e2', 'e4')
        expect(board.move_piece('e4', 'e3')).to eq(false)
      end

      it "не позволяет пешке ходить на 2 клетки, если путь перекрыт" do
        board.place_piece('e3', black_pawn)
        expect(board.move_piece('e2', 'e4')).to eq(false)
      end

      it "позволяет пешке есть по диагонали" do
        board.place_piece('d3', black_pawn)
        board.move_piece('e2', 'e4')
        expect(board.move_piece('e4', 'd5')).to eq(false) 
        board.place_piece('d5', black_pawn)
        expect(board.move_piece('e4', 'd5')).to eq(true)
      end
    end

    describe "ход конем" do
      it "позволяет коню ходить буквой Г" do
        expect(board.move_piece('g1', 'f3')).to eq(true)
        expect(board.piece_at('g1')).to be_nil
        expect(board.piece_at('f3').type).to eq(:knight)
      end

      it "позволяет коню ходить в разных направлениях" do
        expect(board.move_piece('b1', 'c3')).to eq(true)
        expect(board.piece_at('b1')).to be_nil
        expect(board.piece_at('c3').type).to eq(:knight)
      end

      it "не позволяет коню ходить не буквой Г" do
        expect(board.move_piece('g1', 'g3')).to eq(false)
        expect(board.move_piece('g1', 'f2')).to eq(false)
      end
    end

    describe "ход ладьей" do
      before do
        board.move_piece('a2', 'a4')
        board.move_piece('a4', 'a5')

        board.place_piece('b1', nil)  # убираем коня
        board.place_piece('c1', nil)  # убираем слона
      end

      it "позволяет ладье ходить по вертикали" do
        expect(board.move_piece('a1', 'a3')).to eq(true)
      end

      it "позволяет ладье ходить по горизонтали" do
        expect(board.move_piece('a1', 'c1')).to eq(true)
      end

      it "не позволяет ладье ходить по диагонали" do
        expect(board.move_piece('a1', 'b2')).to eq(false)
      end

      it "не позволяет ладье перепрыгивать через фигуры" do
        board.place_piece('a3', white_pawn)
        expect(board.move_piece('a1', 'a4')).to eq(false)
      end
    end

    describe "ход слоном" do
      it "позволяет слону ходить по диагонали" do
        board.move_piece('d2', 'd4')
        expect(board.move_piece('c1', 'e3')).to eq(true)
      end

      it "не позволяет слону ходить по горизонтали" do
        expect(board.move_piece('c1', 'c3')).to eq(false)
      end

      it "не позволяет слону перепрыгивать через фигуры" do
        board.place_piece('d2', white_pawn)
        expect(board.move_piece('c1', 'e3')).to eq(false)
      end
    end

    describe "ход ферзем" do
      before do
        board.move_piece('d2', 'd4')
        board.move_piece('e2', 'e4')
        board.place_piece('e1', nil)
        board.place_piece('f1', nil)  
        board.place_piece('c1', nil) 
      end

      it "позволяет ферзю ходить по вертикали" do
          expect(board.move_piece('d1', 'd3')).to eq(true)  
      end

      it "позволяет ферзю ходить по горизонтали" do
          expect(board.move_piece('d1', 'f1')).to eq(true)  
      end

      it "позволяет ферзю ходить по диагонали" do
          expect(board.move_piece('d1', 'e2')).to eq(true)
      end

      it "не позволяет ферзю перепрыгивать через фигуры" do
          board.place_piece('d3', white_pawn)
          expect(board.move_piece('d1', 'd4')).to eq(false)
      end
    end

    describe "ход королем" do
      it "позволяет королю ходить на 1 клетку" do
        board.move_piece('e2', 'e4')
        expect(board.move_piece('e1', 'e2')).to eq(true)
      end

      it "позволяет королю ходить по диагонали на 1 клетку" do
        board.move_piece('d2', 'd4')
        expect(board.move_piece('e1', 'd2')).to eq(true)
      end

      it "не позволяет королю ходить на 2 клетки" do
        expect(board.move_piece('e1', 'e3')).to eq(false)
      end
    end

    describe "общие правила" do
      it "не позволяет сходить на свою фигуру" do
        expect(board.move_piece('e2', 'e1')).to eq(false)
      end

      it "позволяет съесть чужую фигуру" do
        board.move_piece('e2', 'e4')
        board.place_piece('d5', black_pawn)
        expect(board.move_piece('e4', 'd5')).to eq(true)
        expect(board.piece_at('e4')).to be_nil
        expect(board.piece_at('d5').color).to eq(:white)
      end

      it "не позволяет ходить, если нет фигуры на начальной клетке" do
        expect(board.move_piece('e5', 'e6')).to eq(false)
      end
    end
  end

  describe "#empty?" do
    it "возвращает true для пустой клетки" do
      expect(board.empty?('e2')).to eq(true)
    end

    it "возвращает false для клетки с фигурой" do
      board.place_piece('e2', white_pawn)
      expect(board.empty?('e2')).to eq(false)
    end
  end

  describe "#piece_color_at" do
    it "возвращает цвет фигуры" do
      board.place_piece('e2', white_pawn)
      expect(board.piece_color_at('e2')).to eq(:white)
    end

    it "возвращает nil для пустой клетки" do
      expect(board.piece_color_at('e2')).to be_nil
    end
  end
end