=begin
%%{
machine bel;

  action call_term {fcall term;}
  action out_term {puts "term"}

  include 'common.rl';
  
  FUNCTION = ('proteinAbundance'|'p'|'rnaAbundance'|'r'|'abundance'|'a'|
              'microRNAAbundance'|'m'|'geneAbundance'|'g'|
              'biologicalProcess'|'bp'|'pathology'|'path'|
              'complexAbundance'|'complex'|'translocation'|'tloc'|
              'cellSecretion'|'sec'|'cellSurfaceExpression'|'surf'|
              'reaction'|'rxn'|'compositeAbundance'|'composite'|
              'fusion'|'fus'|'degradation'|'deg'|
              'molecularActivity'|'act'|'catalyticActivity'|'cat'|
              'kinaseActivity'|'kin'|'phosphataseActivity'|'phos'|
              'peptidaseActivity'|'pep'|'ribosylationActivity'|'ribo'|
              'transcriptionalActivity'|'tscript'|
              'transportActivity'|'tport'|'gtpBoundActivity'|'gtp'|
              'chaperoneActivity'|'chap'|'proteinModification'|'pmod'|
              'substitution'|'sub'|'truncation'|'trunc'|'reactants'|
              'products'|'list');

  term :=
    FUNCTION '(' SP* 
    (
      (IDENT ':')? (STRING | IDENT) |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @call_term
    )
    (
      SP* ',' SP* 
      (
        (IDENT ':')? (STRING | IDENT) |
        FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @call_term
      )
    )* SP* ')' @return;

  term_main :=
    (
      '\n' |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @call_term '\n' @out_term
    )+;
}%%
=end

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
