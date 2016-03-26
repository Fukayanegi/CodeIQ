while enigma = STDIN.gets do
  enigma = enigma.chomp!
  while match_data = /((.)(.)\2).*/.match(enigma) do
    enigma = enigma.sub(match_data[1], match_data[3])
  end
  puts enigma
end