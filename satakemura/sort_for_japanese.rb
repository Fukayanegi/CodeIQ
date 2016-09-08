class J_letter
  @@nigori = {
    'g' => 'k', 'z' => 's', 'j' => 's', 'd' => 't', 'b' => 'h'
  }

  @@haretsu = {
    'p' => 'h'
  }

  @@map_mother = {
    'a' => 1, 'i' => 2, 'u' => 3, 'e' => 4, 'o' => 5, 'n' => 6
  }
  @@map_child = {
    'a' => 0, 'i' => 0, 'u' => 0, 'e' => 0, 'o' => 0, 
    'k'=> 1, 's' => 2, 't' => 3, 'c' => 3, 'n' => 4, 
    'h' => 5, 'f' => 5, 'm' => 6, 'y' => 7, 'r' => 8, 'w' => 9, 'n' => 10
  }

  attr_accessor :letter, :mother, :child, :option

  def initialize letter
    @letter = letter
    @option = 0
    key = letter.dup

    if !@@nigori[key[0]].nil?
      @option = 1
      key[0] = @@nigori[key[0]]
    elsif !@@haretsu[key[0]].nil?
      @option = 2
      key[0] = @@haretsu[key[0]]
    end

    @mother = @@map_mother[key[-1]]
    @child = @@map_child[key[0]]
    yield(self) if block_given?
  end

  def <=> other
    (@child <=> other.child).nonzero? || \
      (@mother <=> other.mother)
  end
end

class J_word
  attr_accessor :word

  def initialize
    @word = []
  end

  def << letter
    @word.concat letter
  end

  def <=> other
    res_first = 0.upto @word.length-1 do |i_word|
      tmp = (@word[i_word] <=> other.word[i_word])
      break tmp if tmp.nonzero?
      if @word.length != other.word.length
        break 1 if i_word == other.word.length - 1
        break -1 if i_word == @word.length - 1
      end
      tmp
    end

    (res_first).nonzero? || \
      (0.upto @word.length-1 do |idx|
        tmp = (@word[idx].option <=> other.word[idx].option)
        break tmp if tmp.nonzero?
        tmp
      end)
  end
end

def build_J_letter letters
  if (letters.length > 2 && letters[1] == 'y')
    letter = [J_letter.new(letters[0]+'i')]
    letter << J_letter.new('y'+letters[-1]){|obj| obj.option = -1}
  else
    letter = [J_letter.new(letters[0]+letters[-1])]

    if letters[0] == 'j'
      letter << J_letter.new('y'+letters[-1]){|obj| obj.option = -1}
    end
  end
  return letter
end

mother = ['a', 'i', 'u', 'e', 'o']
texts = {}
while line = STDIN.gets do
  text = J_word.new
  tmp = ""
  line.chomp.each_char do |c|
    # "ん"対応
    # kanya は ka n ya? それとも ka nya?
    # ka n ya の場合はkannyaとなると想定
    if tmp == 'n' && (c == 'n' || (!(mother.include? c) && c != 'y'))
      text << (build_J_letter tmp)
      tmp = ""
      # nnの2文字目は読み捨て
      c = "" if (c == 'n')
    end

    tmp << c
    if mother.include? c
      text << (build_J_letter tmp)
      tmp = ""
    end
  end
  texts[line] = text
end

texts.sort_by{|k, v| v}.each do |k, v|
  puts k
end
