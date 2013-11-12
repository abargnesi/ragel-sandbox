=begin
%%{
machine bel;

  action s {
    buffer = []
  }

  action n {
    buffer << fc
  }

  action name {
    name = buffer.map(&:chr).join()
  }

  action val {
    if buffer[0] == 34 && buffer[-1] == 34
      buffer = buffer[1...-1]
    end
    value = buffer.map(&:chr).join()
  }

  SP = ' ';
  SET = /SET/i;
  DOC = /DOCUMENT/i;
  DOC_PROPS = (/Name/i | /Description/i | /Version/i |
                         /Copyright/i | /Authors/i | /Licenses/i |
                         /ContactInfo/i);
  IDENT = [a-zA-Z0-9]+;
  STRING = '"' ([^"] | '\\\"')* '"';
  set_document_header = SET SP+ DOC SP+ DOC_PROPS >s $n %name SP+ '='
                        SP+ (STRING | IDENT) >s $n %val %{puts "document property {#{name}: #{value}}"} SP* '\n'+;
  set_annotation = SET SP+ IDENT >s $n %name SP+ '='
                   SP+ (STRING | IDENT) >s $n %val %{puts "annotation {#{name}: #{value}}"} SP* '\n'+;
  record = set_document_header | set_annotation;
  main := record+;
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
    data = input.read.unpack('c*')

    %% write init;
    %% write exec;
  end
end
Parser.new.exec($stdin)
