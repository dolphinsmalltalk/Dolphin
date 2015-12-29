"Filed out from Dolphin Smalltalk X6.1"!

TestCase subclass: #ParserGeneratorTest
	instanceVariableNames: 'wrappers'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ParserGeneratorTest guid: (GUID fromString: '{3C86D0EE-B6EE-4D46-888B-BD5E0B68619E}')!
ParserGeneratorTest comment: ''!
!ParserGeneratorTest categoriesForClass!SmaCC Runtime! !
!ParserGeneratorTest methodsFor!

expressionParserString
	^'
%left "+" "-" ;
%left "*" "/" ;
%right "^" ;

Expression: Expression ''first'' "+" Expression ''last'' {first + last}
	| Expression "-" Expression {''1'' - ''3''}
	| Expression "*" Expression {''1'' * ''3''}
	| Expression "/" Expression {''1'' / ''3''}
	| Expression "^" Expression {''1'' raisedTo: ''3''} 
	| "(" Expression ")" {''2''}
	| <number> {''1'' value asNumber};'!

expressionScannerString
	^'
<number>	:	[0-9]+ (\. [0-9]+) ? ;
<whitespace>	:	\s+;'!

removeAllSelectorsFrom: class 
	class selectors do: [:each | class removeSelector: each]!

supportsUnicodeStrings
	^
	[String with: (Character value: 16rFF00).
	true] on: Error
			do: [:ex | ex return: false]!

tearDown
	self
		removeAllSelectorsFrom: TestParser;
		removeAllSelectorsFrom: TestParser class;
		removeAllSelectorsFrom: TestScanner;
		removeAllSelectorsFrom: TestScanner class!

testBadCharacterBlock
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	self should: 
			[parserCompiler buildScanner: '<foo> : [a-] ;' andParser: 'Start : <foo>;'.
			parserCompiler compileInto: TestScanner andParser: TestParser]
		raise: SmaCCParserError!

testBadSmalltalkBlock
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	self should: 
			[parserCompiler buildScanner: '<foo> : foo ;' andParser: 'Start : <foo> {self printOn: };'.
			parserCompiler compileInto: TestScanner andParser: TestParser]
		raise: SmaCCParserError!

testBraceRepeatToken
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<LETTER> : [a-zA-Z_] ;
						<DIGIT> : [0-9] ;
						<IDENTIFIER>: <LETTER> (<LETTER>|<DIGIT>)*	;
						<whitespace>: \s+	;'
		andParser: 'begin : <%<IDENTIFIER>%>;'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	parserCompiler
		compileItemSetsComment;
		compileSymbolComment.
	self 
		assert: ((TestParser parse: 'a b c') collect: [:each | each value]) asArray 
				= #('a' 'b' 'c').
	self assert: (TestParser parse: '') size = 0!

testBracketOptionalToken
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<LETTER> : [a-zA-Z_] ;
						<DIGIT> : [0-9] ;
						<IDENTIFIER>: <LETTER> (<LETTER>|<DIGIT>)*	;
						<whitespace>: \s+	;'
		andParser: 'begin : <IDENTIFIER> [":"] begin {''1'' value , ''3''} | <IDENTIFIER> {''1'' value};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	parserCompiler
		compileDefinitionComments;
		compileItemSetsComment;
		compileSymbolComment.
	self assert: (TestParser parse: 'a b : c') = 'abc'!

testErrors
	| parserCompiler position |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler buildScanner: self expressionScannerString
		andParser: self expressionParserString.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	TestParser parse: '+3*4' onError: [:str :pos | position := pos].
	self assert: position = 1.
	TestParser parseStream: (ReadStream on: '1+a+4')
		onError: [:str :pos | position := pos].
	self assert: position = 3!

testErrorToken
	| parserCompiler countingBlock |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler buildScanner: '<name> : [a-zA-Z]+; <whitespace>: \s+;'
		andParser: '%left "+"; Expression : <name> | Expression "+" Expression {[Notification signal] on: Error do: [:ex | ex return: (Notification raise)]} | error "+" Expression ;'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	countingBlock := 
			[:each | 
			| count |
			count := 0.
			
			[[TestParser parse: each] on: Notification
				do: 
					[:ex | 
					count := count + 1.
					[ex resume] on: Error
						do: 
							[:ex1 | 
							ex isResumable: true.
							ex1 retry]]] 
					on: SmaCCParserError
					do: [:ex | ex return].
			count].
	#(#('a + b + c' 2) #('+ a + b + c' 2) #('a + b +' 1) #('a + 1 / 2 + b + c + 3' 2) #('1 + 1 / 2 + b + c + 3' 1)) 
		do: [:each | self assert: (countingBlock value: each first) = each last]!

testExpressions
	#(#LR1 #LALR1) do: 
			[:each | 
			| parserCompiler |
			parserCompiler := SmaCCGrammarCompiler new.
			parserCompiler grammar type: each.
			parserCompiler buildScanner: self expressionScannerString
				andParser: self expressionParserString.
			parserCompiler compileInto: TestScanner andParser: TestParser.
			self assert: (TestParser parse: '2 + 3 * 4 / 5 ^ 3 ^ 2') 
						= (2 + (3 * 4 / (5 raisedTo: (3 raisedTo: 2)))).
			self assert: (TestParser parse: '1.0*2/3+4.0^2^3+3') 
						= (1.0 * 2 / 3 + (4.0 raisedTo: (2 raisedTo: 3)) + 3).
			self assert: (TestParser parse: '(((1 + 2) * 3) ^ 2) ^ 3') 
						= (((1 + 2) * 3 raisedTo: 2) raisedTo: 3)]!

testIgnoreCaseKeywords
	| parserCompiler case |
	case := SmaCCGrammar ignoreCase.
	SmaCCGrammar ignoreCase: true.
	
	[parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<identifier> : [a-z_]+ ; <whitespace> : \s+ ;'
		andParser: 'Start ::= "Foo" {true} | <identifier> <identifier> {false};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self assert: (TestParser parse: 'FOo').
	self deny: (TestParser parse: 'FoObAr ASDS')] 
			ensure: [SmaCCGrammar ignoreCase: case]!

testInvertedCharactersBlock
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<A> : a{1,3} ;
						<ID> : [^a]+ ;
						<comment> : \s+ ;'
		andParser: 'begin : {0} | begin <A> {''1'' + 1} | begin <ID> {''1'' - 1};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self assert: (TestParser parse: 'aa') = 1.
	self assert: (TestParser parse: 'aaaa') = 2.
	self assert: (TestParser parse: 'a bab') = 0!

testKeywords
	| parserCompiler size case |
	size := SmaCCGrammar maximumCharacterValue.
	case := SmaCCGrammar ignoreCase.
	SmaCCGrammar ignoreCase: true.
	self supportsUnicodeStrings 
		ifTrue: [SmaCCGrammar maximumCharacterValue: (2 raisedTo: 16) - 1].
	
	[parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler buildScanner: '' andParser: 'Start ::= "Foo" "bar";'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	TestParser parse: 'FoObAr'] 
			ensure: 
				[SmaCCGrammar
					ignoreCase: case;
					maximumCharacterValue: size]!

testLALRErrorHandler
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler buildScanner: '<whitespace> : \s+ ;'
		andParser: 'Start : Foo "]" Foo ")";
					Foo : "a" Bar ;
					Bar : "b" | error ;'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self should: [TestParser parse: 'a ] a b )'] raise: SmaCCParserError.
	self should: [TestParser parse: 'a ) a b )'] raise: SmaCCParserError.
	self should: [TestParser parse: 'a b ] a  ]'] raise: SmaCCParserError!

testMultipleStartingPositions
	| parserCompiler position |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler buildScanner: '<name> : \w+;'
		andParser: '%start plus ;

					multiply: plus "*" plus {true};
					plus: <name> {false} | <name> "+" <name> {false};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self assert: (TestParser parse: 'a*a').
	self assert: (TestParser parse: 'a+a*a').
	self should: [TestParser parse: 'a+a'] raise: SmaCCParserError.
	self 
		deny: (TestParser parse: 'a+a' startingAt: TestParser startingStateForplus).
	TestParser 
		parse: 'a*a'
		startingAt: TestParser startingStateForplus
		onError: [:str :pos | position := pos].
	self assert: position = 2!

testNonAssociativeTokens
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<IDENTIFIER> : \w+ ; <whitespace> : \s+ ;'
		andParser: '%left "and" ;
					%nonassoc "=" "<=";
					%left "+" ;

					expr : expr "=" expr {true} | expr "<=" expr {true} | expr "and" expr {true} | expr "+" expr {true} | <IDENTIFIER> {true};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self should: [TestParser parse: 'a=b=c'] raise: SmaCCParserError.
	self should: [TestParser parse: 'a=b<=c'] raise: SmaCCParserError.
	self should: [TestParser parse: 'a=b+c=d'] raise: SmaCCParserError.
	self assert: (TestParser parse: 'a=b and c=d')!

testOptionalToken
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<LETTER> : [a-zA-Z_] ;
						<DIGIT> : [0-9] ;
						<IDENTIFIER>: <LETTER> (<LETTER>|<DIGIT>)*	;
						<whitespace>: \s+	;'
		andParser: 'begin : <IDENTIFIER> ":" ? begin {''1'' value , ''3''} | <IDENTIFIER> {''1'' value};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	parserCompiler
		compileItemSetsComment;
		compileSymbolComment.
	self assert: (TestParser parse: 'a b : c') = 'abc'!

testParenthesesOptionalToken
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<LETTER> : [a-zA-Z_] ;
						<DIGIT> : [0-9] ;
						<IDENTIFIER>: <LETTER> (<LETTER>|<DIGIT>)*	;
						<whitespace>: \s+	;'
		andParser: 'begin : <IDENTIFIER> (":" | "|") begin {''1'' value , ''3''} | <IDENTIFIER> {''1'' value};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	parserCompiler
		compileItemSetsComment;
		compileSymbolComment.
	self assert: (TestParser parse: 'a | b : c') = 'abc'!

testPriority
	| parserCompiler |
	TestScanner 
		compile: 'all self recordAndReportMatch: (Array with: self allId)'.
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler buildScanner: '<a> : \{ | \< \% ;
						<all> : .;'
		andParser: '%id <all> <a>;  begin : A {true}
							| All {false};
					A : <a> ;
					All: <all>;'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self assert: (TestParser parse: '{').
	self assert: (TestParser parse: '<%').
	self deny: (TestParser parse: '}')!

testRecursiveRule
	#(#LR1 #LALR1) do: 
			[:each | 
			| parserCompiler |
			parserCompiler := SmaCCGrammarCompiler new.
			parserCompiler grammar type: each.
			parserCompiler buildScanner: self expressionScannerString
				andParser: 'Test: Test1 Recursive;
							Test1: <number> {''1'' value};
							Recursive: | Recursive "|" <number> {''1'' add: ''3'' value; yourself};'.
			parserCompiler compileInto: TestScanner andParser: TestParser.
			self 
				assert: ((parserCompiler grammar nonTerminalSymbolNamed: 'Recursive') 
						firstTerminals 
							includes: (parserCompiler grammar keywordTerminalNamed: '"|"')).
			self 
				assert: (TestParser parse: '2|3|4') = (OrderedCollection 
								with: '2'
								with: '3'
								with: '4')]!

testReduceReduceConflict
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler buildScanner: '<letter> : \w ;
						<whitespace>: \s+	;'
		andParser: 'begin : Foo <letter> {true} | Bar <letter> {false};
					Foo :  ;
					Bar : ;'.
	self 
		assert: (
			[parserCompiler compileInto: TestScanner andParser: TestParser.
			false] 
					on: SmaCCCompilationNotification
					do: 
						[:ex | 
						('*Reduce/Reduce*' match: ex messageText) 
							ifTrue: [ex return: true]
							ifFalse: [ex resume: nil]])!

testRepeatingCharactersBlock
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<A> : a{1,3} ;
						<ID> : \w+ ;
						<whitespace> : \s+ ;'
		andParser: 'begin : {true} | begin <A> {''1''} | begin <ID> {false};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self assert: (TestParser parse: 'aa').
	self deny: (TestParser parse: 'aaaa')!

testRepeatMultipleToken
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<LETTER> : [a-zA-Z_] ;
						<DIGIT> : [0-9] ;
						<IDENTIFIER>: <LETTER> (<LETTER>|<DIGIT>){1,2}	;
						<whitespace>: \s+	;'
		andParser: 'begin : <IDENTIFIER> + ;'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	parserCompiler
		compileItemSetsComment;
		compileSymbolComment.
	self 
		assert: ((TestParser parse: 'a1 bb c44') collect: [:each | each value]) 
				asArray = #('a1' 'bb' 'c44').
	self 
		assert: ((TestParser parse: 'aaaaa') collect: [:each | each value]) asArray 
				= #('aaa' 'aa').
	self should: [TestParser parse: ''] raise: SmaCCParserError!

testRepeatToken
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<LETTER> : [a-zA-Z_] ;
						<DIGIT> : [0-9] ;
						<IDENTIFIER>: <LETTER> (<LETTER>|<DIGIT>)*	;
						<whitespace>: \s+	;'
		andParser: 'begin : <IDENTIFIER> * ;'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	parserCompiler
		compileItemSetsComment;
		compileSymbolComment.
	self 
		assert: ((TestParser parse: 'a b c') collect: [:each | each value]) asArray 
				= #('a' 'b' 'c').
	self assert: (TestParser parse: '') size = 0!

testReuseCompositeToken
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<LETTERDIGIT> : [a-zA-Z_] \d ;
						<AAorBB> :  aa | bb;
						<IDENTIFIER>: <LETTERDIGIT> | <AAorBB>	;
						<whitespace>: \s+	;'
		andParser: 'begin : <IDENTIFIER> begin {false} | <IDENTIFIER> {true};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self should: [TestParser parse: '2'] raise: SmaCCParserError.
	self assert: (TestParser parse: 'aa').
	self assert: (TestParser parse: 'bb').
	self assert: (TestParser parse: 'a4').
	self should: [TestParser parse: 'ab'] raise: SmaCCParserError.
	self should: [TestParser parse: '4b'] raise: SmaCCParserError!

testReuseSimpleToken
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler 
		buildScanner: '<LETTER> : [a-zA-Z_\\] ;
						<DIGIT> : [0-9] ;
						<IDENTIFIER>: <LETTER> (<LETTER>|<DIGIT>)*	;
						<whitespace>: \s+	;'
		andParser: 'begin : <IDENTIFIER> begin {false} | <IDENTIFIER> {true};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self should: [TestParser parse: '2'] raise: SmaCCParserError.
	self assert: (TestParser parse: '\')!

testSimple
	| parserCompiler |
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler buildScanner: '<a> : a ;' andParser: 'begin : <a> {true};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self should: [TestParser parse: '2'] raise: SmaCCParserError.
	self assert: (TestParser parse: 'a')!

testSpecialCharacters
	| parserCompiler |
	[String with: (Character value: 16rFF00)] on: Error do: [:ex | ^self].	"Unicode characters not supported"
	parserCompiler := SmaCCGrammarCompiler new.
	parserCompiler buildScanner: '<name> : \x3g \x20 \xFF \xFF1 \xFF00 \cC;'
		andParser: 'begin ::= <name> {true};'.
	parserCompiler compileInto: TestScanner andParser: TestParser.
	self assert: (TestParser 
				parse: (String withAll: (#(3 103 16r20 16rFF 16rFF1 16rFF00 2) 
								collect: [:each | Character value: each])))! !
!ParserGeneratorTest categoriesFor: #expressionParserString!public!testing! !
!ParserGeneratorTest categoriesFor: #expressionScannerString!public!testing! !
!ParserGeneratorTest categoriesFor: #removeAllSelectorsFrom:!private! !
!ParserGeneratorTest categoriesFor: #supportsUnicodeStrings!private! !
!ParserGeneratorTest categoriesFor: #tearDown!initialize-release!public! !
!ParserGeneratorTest categoriesFor: #testBadCharacterBlock!public!testing! !
!ParserGeneratorTest categoriesFor: #testBadSmalltalkBlock!public!testing! !
!ParserGeneratorTest categoriesFor: #testBraceRepeatToken!public!testing! !
!ParserGeneratorTest categoriesFor: #testBracketOptionalToken!public!testing! !
!ParserGeneratorTest categoriesFor: #testErrors!public!testing! !
!ParserGeneratorTest categoriesFor: #testErrorToken!public!testing! !
!ParserGeneratorTest categoriesFor: #testExpressions!public!testing! !
!ParserGeneratorTest categoriesFor: #testIgnoreCaseKeywords!public!testing! !
!ParserGeneratorTest categoriesFor: #testInvertedCharactersBlock!public!testing! !
!ParserGeneratorTest categoriesFor: #testKeywords!public!testing! !
!ParserGeneratorTest categoriesFor: #testLALRErrorHandler!public!testing! !
!ParserGeneratorTest categoriesFor: #testMultipleStartingPositions!public!testing! !
!ParserGeneratorTest categoriesFor: #testNonAssociativeTokens!public!testing! !
!ParserGeneratorTest categoriesFor: #testOptionalToken!public!testing! !
!ParserGeneratorTest categoriesFor: #testParenthesesOptionalToken!public!testing! !
!ParserGeneratorTest categoriesFor: #testPriority!public!testing! !
!ParserGeneratorTest categoriesFor: #testRecursiveRule!public!testing! !
!ParserGeneratorTest categoriesFor: #testReduceReduceConflict!public!testing! !
!ParserGeneratorTest categoriesFor: #testRepeatingCharactersBlock!public!testing! !
!ParserGeneratorTest categoriesFor: #testRepeatMultipleToken!public!testing! !
!ParserGeneratorTest categoriesFor: #testRepeatToken!public!testing! !
!ParserGeneratorTest categoriesFor: #testReuseCompositeToken!public!testing! !
!ParserGeneratorTest categoriesFor: #testReuseSimpleToken!public!testing! !
!ParserGeneratorTest categoriesFor: #testSimple!public!testing! !
!ParserGeneratorTest categoriesFor: #testSpecialCharacters!public!testing! !

