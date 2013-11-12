=begin
%%{
  machine bel;

  action call_set {fcall set;}
  action out_docprop {puts "document property {#{name}: #{value}}"}
  action out_annotation {puts "annotation {#{name}: #{value}}"}

  include 'common.rl';

  SET = /SET/i;
  DOC = /DOCUMENT/i;
  DOC_PROPS = (/Name/i | /Description/i | /Version/i |
               /Copyright/i | /Authors/i | /Licenses/i |
               /ContactInfo/i);

  docprop = 
    DOC SP+ DOC_PROPS >s $n %name SP+ '='
    SP+ (STRING | IDENT) >s $n %val %out_docprop SP* '\n' @return;
  annotation =
    IDENT >s $n %name SP+ '=' SP+
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
