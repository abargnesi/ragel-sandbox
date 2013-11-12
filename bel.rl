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
  set_document_header = SET SP+ DOC SP+ DOC_PROPS >s $n %name SP+ '='
                        SP+ (STRING | IDENT) >s $n %val %{puts "document property {#{name}: #{value}}"} SP* '\n'+;
  set_annotation = SET SP+ IDENT >s $n %name SP+ '='
                   SP+ (STRING | IDENT) >s $n %val %{puts "annotation {#{name}: #{value}}"} SP* '\n'+;
   
  term = FUNCTION '(' SP* (IDENT ':')? (STRING | IDENT) (SP* ',' SP* (IDENT ':')? (STRING | IDENT))* SP* ')';
  stmt = term SP+ RELATIONSHIP SP+ term @{puts "statement!"} SP* '\n'+;
  record = set_document_header | set_annotation | stmt;
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
Parser.new.exec(ARGV[0] ? File.open(ARGV[0]) : $stdin)
