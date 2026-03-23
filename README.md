# ChessEngine

Шахматный движок на Ruby для проверки ходов и управления состоянием доски.

## Установка

Добавьте в Gemfile:

```ruby
gem 'chess_engine'
```

или установите вручную:

```bash
gem install chess_engine
```

## Использование

```ruby
require 'chess_engine'

# Создаем новую доску с начальной расстановкой
board = ChessEngine.new_game

# Проверяем, кто стоит на клетке
puts board.piece_at('e2').type   # pawn
puts board.piece_at('e2').color  # white

# Делаем ход пешкой
board.move_piece('e2', 'e4')

# Делаем ход конем
board.move_piece('g1', 'f3')

# Проверяем результат
puts board.piece_at('e4').type  # pawn
puts board.piece_at('f3').type  # knight
```

## Методы

| Метод                          | Описание                                |
| ------------------------------ | --------------------------------------- |
| `Board.new`                    | Создает новую пустую доску              |
| `ChessEngine.new_game`         | Создает доску с начальной расстановкой  |
| `setup_initial_position`       | Расставляет фигуры в начальную позицию  |
| `place_piece(position, piece)` | Ставит фигуру на клетку                 |
| `piece_at(position)`           | Возвращает фигуру на клетке или nil     |
| `move_piece(from, to)`         | Пытается сходить, возвращает true/false |
| `empty?(position)`             | Проверяет, пустая ли клетка             |
| `piece_color_at(position)`     | Возвращает цвет фигуры или nil          |

## Правила хода

* Пешка — 1 клетка вперед, 2 с начальной позиции, ест по диагонали
* Конь — буквой "Г" (2+1)
* Ладья — по горизонтали и вертикали
* Слон — по диагонали
* Ферзь — как ладья и слон вместе
* Король — на 1 клетку в любую сторону

## Разработка

### Запуск тестов

```bash
bundle install
rspec spec/
```

## CI/CD

Проект использует GitHub Actions для автоматического запуска тестов при каждом пуше.

## Команда
@VKJNQ
