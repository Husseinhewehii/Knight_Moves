class Square
    attr_accessor :coord, :children, :parent
    def initialize(coord)
        @coord = coord
        @children = []
        @parent = nil
    end
end


class Board
    attr_accessor :squares_hash
    def initialize
        @squares_hash = {}
        (1..8).each {|x| (1..8).each {|y| @squares_hash[[x,y]] = Square.new([x,y])}}
        fill_children()
    end

    def fill_children()
        knight_moves = [[2,1],[2,-1],[1,2],[-1,2],[-2,1],[-2,-1],[-1,-2],[1,-2]]
        @squares_hash.values.each do |square|
            knight_moves.each do |move|
                if @squares_hash[new_coords(square.coord,move)]
                    square.children.push(@squares_hash[new_coords(square.coord,move)])
                end
            end
        end
    end

    def new_coords(pos,move)
        return [pos[0]+move[0],pos[1]+move[1]]
    end
end

def assemble_path(square)
    path = [square.coord]
    until square.parent.nil?
        square = square.parent
        path.unshift(square.coord)
    end
    path
end

def find_path(anfang,ende)
    board = Board.new
    queue = [board.squares_hash[anfang]]
    checked_squares = []
    until queue.nil?
        square = queue.shift

        return assemble_path(square) if square.coord == ende

        checked_squares.push(square)
        square.children.each do |child|
            unless checked_squares.include?(child)
                child.parent = square
                queue.push(child)
            end
        end
    end
end


p find_path([1,1],[8,8])
