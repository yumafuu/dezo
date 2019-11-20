require "./dezo.rb"

loop do
  print "word> "
  word = gets.chomp
  #word = Word.new

  break if word === "Q"
  next if word ==  ""
  Dezo.search(word)
end
