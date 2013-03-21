/* description: Basic grammar that contains a nullable A nonterminal. */

%lex
%%

\s+               {/* skip whitespace */}
[a-zA-Z_]\w*      {return 'ID';}
\d+(\.\d*)?([-+]?[eE]\d+)?      {yytext = Number(yytext);  return 'NUM';}
[=;]  { return yytext; }
.     {return 'INVALID';}

/lex

%{
	var s = {};
	var make_traverse = function() {
		var seen = [];
		return function(key, val) {
			if (typeof val == "object") {
				if (seen.indexOf(val) >= 0) return undefined;
				seen.push(val);
			}
			return val;
		}
	};
%}

%%

P   : S
          {
             var ss = JSON.stringify(s, undefined, 2); 
             console.log(ss);
	     return "<ul>\n<li> symbol table;<p> "+ ss + "\n </ul>";
	  }
    ;

S   :  e
    |  S ';' e
    ;
		
e   : ID '=' NUM     {s[$1] = $$ = $3}
    |  ID '=' INVALID 
          {
 	   throw new Error('Number expected on line ' + (yy.lexer.yylineno + 1) + ":\n" + yy.lexer.showPosition() + '\n');
	  }
    ;


