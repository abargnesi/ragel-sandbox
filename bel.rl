=begin
%%{
machine bel;

  action return {fret;}
  action call_set {fcall set;}
  action out_docprop {puts "document property {#{name}: #{value}}"}
  action out_annotation {puts "annotation {#{name}: #{value}}"}

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
  FUNCTION     = ('proteinAbundance'|'p'|'rnaAbundance'|'r'|'abundance'|'a'|
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
  RELATIONSHIP = ('increases'|'->'|'decreases'|'-|'|'directlyIncreases'|'=>'|
                  'directlyDecreases'|'=|'|'causesNoChange'|
                  'positiveCorrelation'|'negativeCorrelation'|
                  'translatedTo'|'>>'|'transcribedTo'|':>'|'isA'|
                  'subProcessOf'|'rateLimitingStepOf'|'biomarkerFor'|
                  'prognosticBiomarkerFor'|'orthologous'|'analogous'|
                  'association'|'--'|'hasMembers'|'hasComponents'|
                  'hasMember'|'hasComponent');
  IDENT = [a-zA-Z0-9]+;
  STRING = '"' ([^"] | '\\\"')* '"';

  docprop = 
    DOC SP+ DOC_PROPS >s $n %name SP+ '='
    SP+ (STRING | IDENT) >s $n %val %out_docprop SP* '\n'+ @return;
  annotation =
    IDENT >s $n %name SP+ '=' SP+
    (STRING | IDENT) >s $n %val %out_annotation SP* '\n'+ @return;
  set :=
    (docprop | annotation);
   
  term = FUNCTION '(' SP* (IDENT ':')? (STRING | IDENT) (SP* ',' SP* (IDENT ':')? (STRING | IDENT))* SP* ')';
  stmt = term SP+ RELATIONSHIP SP+ term @{puts "statement!"} SP* '\n'+;
  main :=
    (SET SP+ @call_set)+;
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
