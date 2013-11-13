=begin
%%{
  machine bel;

  action call_set {fcall set;}
  action out_docprop {
    docprop = BEL::DocumentProperty.new(@name, @value)
    puts docprop
  }
  action out_annotation {
    annotation = BEL::Annotation.new(@name, @value)
    puts annotation
  }

  include 'common.rl';

  SET = /SET/i;
  DOC = /DOCUMENT/i;
  DOC_PROPS = (/Name/i | /Description/i | /Version/i |
               /Copyright/i | /Authors/i | /Licenses/i |
               /ContactInfo/i);

  docprop = 
    SP+ DOC SP+ DOC_PROPS >s $n %name SP+ '='
    SP+ (STRING | IDENT) >s $n %val %out_docprop SP* '\n' @return;
  annotation =
    SP+ IDENT >s $n %name SP+ '=' SP+
    (STRING | IDENT) >s $n %val %out_annotation SP* '\n' @return;
  set :=
    (docprop | annotation);
  set_main :=
    (
      '\n' |
      SET @call_set
    )+;
}%%
=end

module BEL
  DocumentProperty = Struct.new(:name, :value)
  Annotation = Struct.new(:name, :value)
end

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

