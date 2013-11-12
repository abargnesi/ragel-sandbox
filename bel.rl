=begin
%%{
machine bel;

  include 'common.rl';
  include 'set.rl';
  include 'term.rl';
  include 'statement.rl';

  document_main :=
    (
      '\n' |
      SET SP+ @call_set |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @call_statement
    )+;
}%%
=end

DocumentProperty = Struct.new(:property, :value)
SetAnnotation = Struct.new(:property, :value)

class Parser

  def initialize
    @items = []
    %% write data;
  end

  def exec(input)
    buffer = []
    stack = []
    data = input.read.unpack('c*')

    %% write init;
    %% write exec;
  end
end
Parser.new.exec(ARGV[0] ? File.open(ARGV[0]) : $stdin)
