=begin
%%{
machine bel;

  action call_term {fcall term;}
  action out_term {puts "term -> #{@term}";}
  action term_init {
    term_stack = []
  }
  action term_fx {
    fx = buffer.map(&:chr).join().to_sym
    term_stack.push(Term.new(fx, []))
    pfxbuffer = []
    valbuffer = []
  }
  action term_arg {
    pfx = pfxbuffer.empty? ? nil : pfxbuffer.map(&:chr).join()
    term_stack.last << Parameter.new(pfx, valbuffer.map(&:chr).join())
  }
  action term_pop {
    @term = term_stack.pop
    if not term_stack.empty?
      term_stack.last << @term
    end
  }

  action pfxn {pfxbuffer << fc}
  action valn {valbuffer << fc}

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
    FUNCTION >s $n %term_fx '(' SP* 
    (
      (IDENT $pfxn ':')? <: (STRING $valn | IDENT $valn) %term_arg |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @call_term
    )
    (
      SP* ',' SP* 
      (
        (IDENT ':')? (STRING | IDENT) |
        FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @call_term
      )
    )* SP* ')' @term_pop @return;

  term_main :=
    (
      '\n' |
      FUNCTION >{n = 0} ${n += 1} @{fpc -= n} @term_init @call_term '\n' @out_term
    )+;
}%%
=end

Term = Struct.new(:fx, :args) do
  def <<(item)
    self.args << item
  end
end
Parameter = Struct.new(:ns, :value)

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
