# コマンドライン引数に"-dlog"があった場合にログを出力する関数
def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

class Fixnum
  def factorial
    return 1 if self < 1
    (1..self).to_a.inject{|acc, v| acc * v}
  end

  def combination r = self
    self.permutation(r) / r.factorial
  end

  def permutation r = self
    self.factorial / (self - r).factorial
  end

  def repeated_combination r = self
    (self + r -1).combination r
  end
end

n = STDIN.gets.chomp.to_i

class Solver
  def initialize n
    @n = n
  end

  def solve_inner_chain card, pos1, pos2, cards, rest
    # dlog({:card => card, :pos1 => pos1, :pos2 => pos2, :cards => cards, :rest => rest}) if cards == [2, 4, nil, nil]
    # 2 4 nil 1
    # card = 1
    # pos1 = 2
    # pos2 = 3

    # 2 3 1
    # card = 1
    # pos1 = 2
    # pos2 = 2

    answer = 0
    (pos1..pos2).each do |next_pos|
      if rest.include?(card) && cards[next_pos].nil?
        # dlog({:next_pos => next_pos}) if cards == [2, 4, nil, nil]
        rest.delete(card)
        cards[next_pos] = card
        if next_pos == pos2
          # 交換元に来たカードの正しい場所に交換元のindexのカードがある場合
          dlog({:cards => cards, :rest => rest}) if cards == [2, 4, nil, nil]
          answer += solve_inner(cards, rest)
        else
          answer += solve_inner_chain(next_pos + 1, next_pos + 1, pos2, cards, rest)
        end
        cards[next_pos] = nil
        rest << card
      end
    end
    answer
  end

  def solve_inner cards, rest
    if rest == []
      # dlog({:cards_fin => cards})
      return 1
    end
    # dlog({:cards => cards, :rest => rest})
    rest_dup = rest.dup

    answer = 0
    rest.each do |card, i|
      # dlog({:card => card})
      rest_dup.delete(card)
      indexes = cards.map.with_index{|card, index| card.nil? ? index : nil}.select{|index| !index.nil?}
      pos = indexes.shift
      cards[pos] = card

      if pos + 1 == card
        # 選択したカードが正しい位置の場合
        # dlog({:cards => cards})
        answer += solve_inner(cards, rest_dup)
      else
        # dlog({:cards => cards})
        rest_dup_2 = rest_dup.dup
        rest_dup_2.each do |card2|
          # dlog({:card2 => card2})
          rest_dup.delete(card2)
          # 選択したカードの交換先に2枚目のカードを配置
          cards[card - 1] = card2
          indexes.delete(card - 1)
          if card2 != pos + 1
            # 交換元に間違った配置場所のカードが来る場合
            # dlog({:cards => cards, :indexes => indexes, :rest => rest_dup})
            # dlog({:card => pos + 1, :pos1 => indexes.first, :card2 =>card2 - 1, :cards => cards, :rest => rest_dup})
            answer += solve_inner_chain(pos + 1, indexes.first, card2 - 1, cards, rest_dup)
          else
            # 交換元、交換先が正しく配置される場合
            answer += solve_inner(cards, rest_dup)
          end
          indexes << (card - 1)
          cards[card - 1] = nil
          rest_dup << card2
        end
      end
      cards[pos] = nil
      rest_dup << card
    end

    answer
  end

  def solve
    ok = solve_inner(Array.new(@n), (1..@n).to_a)
    # dlog({:ok => ok})
    # dlog({:permutation => @n.permutation})
    @n.permutation - ok

    # 2 4 3 1
    # 4 2 3 1
    # 4 2 3 1
    # 4 2 3 1
  end
end

solver = Solver.new(n)
puts solver.solve
