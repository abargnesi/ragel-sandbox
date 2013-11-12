=begin
%%{
  # machine specification
  machine template;

  # actions

  # machine definitions, e.g.
  SP = ' ';
  IDENT = [a-zA-Z0-9]+;
  STRING = '"' ([^"] | '\\\"')* '"';
  array = '(' SP* IDENT (SP* ',' SP* IDENT)* SP* ')' @{ puts "array!"};

  main := array+;
}%%
=end

class Parser

  def initialize
    %% write data;
  end

  def exec(input)
    data = input.read.unpack('c*')
    %% write init;
    %% write exec;
  end
end
Parser.new.exec($stdin)
