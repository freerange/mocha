class String
  def strip_trailing_slash
    self[-1..-1] == "/" ? self[0..-2] : self
  end
end