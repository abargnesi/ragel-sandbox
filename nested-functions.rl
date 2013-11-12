# This ragel example recognizes nested function call.  Function arguments
# can either be a digit+ or a nested function call (ad infinitum).
# Example:
# foo(bar(baz(42)))

=begin
%%{
  # machine specification
  machine recursive;

  # actions
  action s {
    buffer = []
  }
  action n {
    buffer << fc.chr
  }
  action out {
    puts buffer.join()
  }

  # machine definitions, e.g.
  NAME = [_a-zA-Z] [_a-zA-Z0-9]*;
  NUMBER = digit+;

  function := (NUMBER >s $n %out | NAME >s $n %out '(' @{fcall function;} ) ')' @{fret;};
  main := NAME >s $n %out '(' @{fcall function;} ')' @{puts 'function call'};
}%%
=end

class Parser

  def initialize
    %% write data;
  end

  def exec(input)
    stack = []
    data = input.read.unpack('c*')
    %% write init;
    %% write exec;
  end
end
Parser.new.exec(ARGV[0] ? File.open(ARGV[0]) : $stdin)
