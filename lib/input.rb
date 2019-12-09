class Input
  attr_reader :letter, :is_enter, :is_break, :is_delete, :flag

  DELETE = "\u007F"
  BREAKS = [
    "\u0003",
    "\u0004",
  ]
  ENTER = "\r"
  ESC = "\e"

  SPECIAL_LETTERS = [
    "\e[A", #top
    "\e[B", #down
    "\e[C", #right
    "\e[D", #left
    "\e", #esc
  ]

  def initialize
    @letter = STDIN.raw(&:getc)
    @is_enter = is_enter
    @is_delete = is_delete
    @is_break = is_break
  end

  def is_enter
    @letter == ENTER
  end

  def is_delete
    @letter == DELETE
  end

  def is_break
    BREAKS.include?(@letter)
  end
end
