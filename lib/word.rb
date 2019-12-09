class Word
  attr_reader :is_break

  def self.get
    new
  end

  def initialize
    @letters = []
    loop do
      display
      input = Input.new

      break if input.is_enter

      if input.is_break
        @is_break = true
        break
      end

      if input.is_delete
        @letters.pop
        next
      end

      @letters << input.letter
    end

    puts ""
    @letters.join
  end

  def display
    print "\r" + " "*100
    print "\rword> #{@letters.join}"
  end
end
