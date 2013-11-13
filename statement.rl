=begin
%%{
  machine bel;

  action call_statement {fcall statement;}
  action out_statement {puts "#{@statement}"}
  action statement_init {
    statement_stack = [@statement = BEL::Statement.new()]
  }
  action statement_subject {
    statement_stack.last.subject = @term
  }
  action statement_oterm {
    statement_stack.last.object = @term
  }
  action statement_ostmt {
    statement_stack.last.object = BEL::Statement.new()
    statement_stack.push statement_stack.last.object
  }
  action statement_pop {
    @statement = statement_stack.pop
  }

  include 'common.rl';
  include 'term.rl';

  RELATIONSHIP = ('increases'|'->'|'decreases'|'-|'|'directlyIncreases'|'=>'|                                                       
                  'directlyDecreases'|'=|'|'causesNoChange'|
                  'positiveCorrelation'|'negativeCorrelation'|
                  'translatedTo'|'>>'|'transcribedTo'|':>'|'isA'|
                  'subProcessOf'|'rateLimitingStepOf'|'biomarkerFor'|
                  'prognosticBiomarkerFor'|'orthologous'|'analogous'|
                  'association'|'--'|'hasMembers'|'hasComponents'|
                  'hasMember'|'hasComponent');

  statement :=
    FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @term_init @call_term SP+ %statement_subject
    RELATIONSHIP SP+
    (
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @term_init @call_term %statement_oterm SP* ')'? @return
      |
      '(' @statement_ostmt @call_statement %statement_pop
    ) '\n' @out_statement @return;
  
  statement_main :=
    (
      '\n' |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @statement_init @call_statement
    )+;
}%%
=end

# brings in BEL::Parameter and BEL::Term
require './term.rb'

module BEL
  Statement = Struct.new(:subject, :rel, :object, :comment) do
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
