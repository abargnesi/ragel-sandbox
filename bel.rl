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
      '#' any+ %{puts 'matched doc comment'} '\n' |
      SET @call_set |
      UNSET @call_unset |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n}
      @statement_init @call_statement
    )+;
}%%
=end

module BEL
  DocumentProperty = Struct.new(:name, :value)
  Annotation = Struct.new(:name, :value)
  StatementGroup = Struct.new(:name, :statements, :annotations)
  Parameter = Struct.new(:ns, :value)
  Term = Struct.new(:fx, :args) do
    def <<(item)
      self.args << item
    end
  end
  Statement = Struct.new(:subject, :rel, :object, :annotations, :comment) do
      def subject_only?
        !rel 
      end  
      def simple?
        object.is_a? TermDefinition
      end  
      def nested?
        object.is_a? StatementDefinition
      end
  end
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
