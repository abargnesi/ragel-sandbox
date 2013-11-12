=begin
%%{
  machine bel;

  action call_statement {fcall statement;}
  action out_statement {puts "statement"}

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
    FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @call_term SP+
    RELATIONSHIP SP+
    (
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @call_term SP*
      |
      '(' @call_statement ')'
    ) '\n' @out_statement @return;
  
  statement_main :=
    (
      '\n' |
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
