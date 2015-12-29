"Filed out from Dolphin Smalltalk XP"!

SmaCCScanner subclass: #JavaScanner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
JavaScanner guid: (GUID fromString: '{713A087A-F65B-4EB3-9EAD-98BD29715C56}')!
JavaScanner comment: ''!
!JavaScanner categoriesForClass!SmaCC Runtime! !
!JavaScanner methodsFor!

emptySymbolTokenId
	^254!

errorTokenId
	^255!

multipleLineComment
	| char |
	
	[[(char := stream next) isNil or: [char == $*]] whileFalse.
	stream atEnd ifTrue: [self scannerError].
	stream peekFor: $/] 
			whileFalse.
	^self whitespace!

scan1
	
	[self recordMatch: #(94).
	self step.
	currentCharacter isDigit] whileTrue.
	(currentCharacter == $D 
		or: [currentCharacter == $F or: [currentCharacter == $d or: [currentCharacter == $f]]]) 
			ifTrue: [^self recordAndReportMatch: #(94)].
	(currentCharacter == $E or: [currentCharacter == $e]) ifTrue: [^self scan2].
	^self reportLastMatch!

scan2
	self step.
	currentCharacter isDigit ifTrue: [^self scan3].
	(currentCharacter == $+ or: [currentCharacter == $-]) 
		ifTrue: 
			[self step.
			currentCharacter isDigit ifTrue: [^self scan3].
			^self reportLastMatch].
	^self reportLastMatch!

scan3
	
	[self recordMatch: #(94).
	self step.
	currentCharacter isDigit] whileTrue.
	(currentCharacter == $D 
		or: [currentCharacter == $F or: [currentCharacter == $d or: [currentCharacter == $f]]]) 
			ifTrue: [^self recordAndReportMatch: #(94)].
	^self reportLastMatch!

scan4
	self step.
	currentCharacter == $' ifTrue: [^self recordAndReportMatch: #(96)].
	^self reportLastMatch!

scan5
	self step.
	(currentCharacter between: $0 and: $7) ifTrue: [^self scan4].
	currentCharacter == $' ifTrue: [^self recordAndReportMatch: #(96)].
	^self reportLastMatch!

scan6
	
	[self step.
	currentCharacter <= $!! 
		or: [(currentCharacter between: $# and: $[) or: [currentCharacter >= $]]]] 
			whileTrue.
	currentCharacter == $" ifTrue: [^self recordAndReportMatch: #(97)].
	currentCharacter == $\ 
		ifTrue: 
			[self step.
			(currentCharacter == $" or: 
					[currentCharacter == $' or: 
							[(currentCharacter between: $0 and: $7) or: 
									[currentCharacter == $\ or: 
											[currentCharacter == $b or: 
													[currentCharacter == $f 
														or: [currentCharacter == $n or: [currentCharacter == $r or: [currentCharacter == $t]]]]]]]]) 
				ifTrue: [^self scan6].
			^self reportLastMatch].
	^self reportLastMatch!

scan7
	
	[self step.
	currentCharacter isDigit] whileTrue.
	(currentCharacter == $D 
		or: [currentCharacter == $F or: [currentCharacter == $d or: [currentCharacter == $f]]]) 
			ifTrue: [^self recordAndReportMatch: #(94)].
	(currentCharacter == $E or: [currentCharacter == $e]) ifTrue: [^self scan2].
	currentCharacter == $. ifTrue: [^self scan1].
	^self reportLastMatch!

scanForToken
	self step.
	((currentCharacter between: $A and: $Z) 
		or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]) 
			ifTrue: 
				[
				[self recordMatch: #(99).
				self step.
				currentCharacter isHexDigit or: 
						[(currentCharacter between: $G and: $Z) 
							or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]] 
						whileTrue.
				^self reportLastMatch].
	(currentCharacter between: $1 and: $9) 
		ifTrue: 
			[
			[self recordMatch: #(93).
			self step.
			currentCharacter isDigit] whileTrue.
			(currentCharacter == $D 
				or: [currentCharacter == $F or: [currentCharacter == $d or: [currentCharacter == $f]]]) 
					ifTrue: [^self recordAndReportMatch: #(94)].
			(currentCharacter == $E or: [currentCharacter == $e]) ifTrue: [^self scan2].
			(currentCharacter == $L or: [currentCharacter == $l]) 
				ifTrue: [^self recordAndReportMatch: #(93)].
			currentCharacter == $. ifTrue: [^self scan1].
			^self reportLastMatch].
	((currentCharacter between: $	 and: $
) or: [currentCharacter == $ ]) 
		ifTrue: 
			[
			[self recordMatch: #whitespace.
			self step.
			(currentCharacter between: $	 and: $
) or: [currentCharacter == $ ]] 
					whileTrue.
			^self reportLastMatch].
	currentCharacter == $!! 
		ifTrue: 
			[self recordMatch: #(84).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(53)].
			^self reportLastMatch].
	currentCharacter == $" ifTrue: [^self scan6].
	currentCharacter == $% 
		ifTrue: 
			[self recordMatch: #(87).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(67)].
			^self reportLastMatch].
	currentCharacter == $& 
		ifTrue: 
			[self recordMatch: #(48).
			self step.
			currentCharacter == $& ifTrue: [^self recordAndReportMatch: #(57)].
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(61)].
			^self reportLastMatch].
	currentCharacter == $' 
		ifTrue: 
			[self step.
			(currentCharacter <= $& 
				or: [(currentCharacter between: $( and: $[) or: [currentCharacter >= $]]]) 
					ifTrue: [^self scan4].
			currentCharacter == $\ 
				ifTrue: 
					[self step.
					(currentCharacter == $" or: 
							[currentCharacter == $' or: 
									[currentCharacter == $\ or: 
											[currentCharacter == $b or: 
													[currentCharacter == $f 
														or: [currentCharacter == $n or: [currentCharacter == $r or: [currentCharacter == $t]]]]]]]) 
						ifTrue: [^self scan4].
					(currentCharacter between: $0 and: $3) 
						ifTrue: 
							[self step.
							(currentCharacter between: $0 and: $7) ifTrue: [^self scan5].
							currentCharacter == $' ifTrue: [^self recordAndReportMatch: #(96)].
							^self reportLastMatch].
					(currentCharacter between: $4 and: $7) ifTrue: [^self scan5].
					^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $( ifTrue: [^self recordAndReportMatch: #(7)].
	currentCharacter == $) ifTrue: [^self recordAndReportMatch: #(21)].
	currentCharacter == $* 
		ifTrue: 
			[self recordMatch: #(45).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(54)].
			^self reportLastMatch].
	currentCharacter == $+ 
		ifTrue: 
			[self recordMatch: #(92).
			self step.
			currentCharacter == $+ ifTrue: [^self recordAndReportMatch: #(77)].
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(66)].
			^self reportLastMatch].
	currentCharacter == $, ifTrue: [^self recordAndReportMatch: #(6)].
	currentCharacter == $- 
		ifTrue: 
			[self recordMatch: #(91).
			self step.
			currentCharacter == $- ifTrue: [^self recordAndReportMatch: #(89)].
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(60)].
			^self reportLastMatch].
	currentCharacter == $. 
		ifTrue: 
			[self recordMatch: #(34).
			self step.
			currentCharacter isDigit ifTrue: [^self scan1].
			^self reportLastMatch].
	currentCharacter == $/ 
		ifTrue: 
			[self recordMatch: #(83).
			self step.
			currentCharacter == $* ifTrue: [^self recordAndReportMatch: #multipleLineComment].
			currentCharacter == $/ 
				ifTrue: 
					[
					[self step.
					currentCharacter <= $	 
						or: [(currentCharacter between: $ and: $) or: [currentCharacter >= $]]] 
							whileTrue.
					currentCharacter isLinefeed ifTrue: [^self recordAndReportMatch: #comment].
					currentCharacter == $
 
						ifTrue: 
							[self recordMatch: #comment.
							self step.
							currentCharacter isLinefeed ifTrue: [^self recordAndReportMatch: #comment].
							^self reportLastMatch].
					^self reportLastMatch].
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(68)].
			^self reportLastMatch].
	currentCharacter == $0 
		ifTrue: 
			[self recordMatch: #(93).
			self step.
			(currentCharacter between: $0 and: $7) 
				ifTrue: 
					[
					[self recordMatch: #(93).
					self step.
					currentCharacter between: $0 and: $7] 
							whileTrue.
					(currentCharacter == $D 
						or: [currentCharacter == $F or: [currentCharacter == $d or: [currentCharacter == $f]]]) 
							ifTrue: [^self recordAndReportMatch: #(94)].
					(currentCharacter between: $8 and: $9) ifTrue: [^self scan7].
					(currentCharacter == $E or: [currentCharacter == $e]) ifTrue: [^self scan2].
					(currentCharacter == $L or: [currentCharacter == $l]) 
						ifTrue: [^self recordAndReportMatch: #(93)].
					currentCharacter == $. ifTrue: [^self scan1].
					^self reportLastMatch].
			(currentCharacter == $D 
				or: [currentCharacter == $F or: [currentCharacter == $d or: [currentCharacter == $f]]]) 
					ifTrue: [^self recordAndReportMatch: #(94)].
			(currentCharacter between: $8 and: $9) ifTrue: [^self scan7].
			(currentCharacter == $E or: [currentCharacter == $e]) ifTrue: [^self scan2].
			(currentCharacter == $L or: [currentCharacter == $l]) 
				ifTrue: [^self recordAndReportMatch: #(93)].
			(currentCharacter == $X or: [currentCharacter == $x]) 
				ifTrue: 
					[self step.
					(currentCharacter isHexDigit or: [currentCharacter between: $a and: $f]) 
						ifTrue: 
							[
							[self recordMatch: #(93).
							self step.
							currentCharacter isHexDigit or: [currentCharacter between: $a and: $f]] 
									whileTrue.
							(currentCharacter == $L or: [currentCharacter == $l]) 
								ifTrue: [^self recordAndReportMatch: #(93)].
							^self reportLastMatch].
					^self reportLastMatch].
			currentCharacter == $. ifTrue: [^self scan1].
			^self reportLastMatch].
	currentCharacter == $: ifTrue: [^self recordAndReportMatch: #(16)].
	currentCharacter == $; ifTrue: [^self recordAndReportMatch: #(30)].
	currentCharacter == $< 
		ifTrue: 
			[self recordMatch: #(82).
			self step.
			currentCharacter == $< 
				ifTrue: 
					[self recordMatch: #(86).
					self step.
					currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(59)].
					^self reportLastMatch].
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(69)].
			^self reportLastMatch].
	currentCharacter == $= 
		ifTrue: 
			[self recordMatch: #(3).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(49)].
			^self reportLastMatch].
	currentCharacter == $> 
		ifTrue: 
			[self recordMatch: #(58).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(56)].
			currentCharacter == $> 
				ifTrue: 
					[self recordMatch: #(85).
					self step.
					currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(63)].
					currentCharacter == $> 
						ifTrue: 
							[self recordMatch: #(65).
							self step.
							currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(62)].
							^self reportLastMatch].
					^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $? ifTrue: [^self recordAndReportMatch: #(64)].
	currentCharacter == $[ ifTrue: [^self recordAndReportMatch: #(10)].
	currentCharacter == $] ifTrue: [^self recordAndReportMatch: #(5)].
	currentCharacter == $^ 
		ifTrue: 
			[self recordMatch: #(51).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(47)].
			^self reportLastMatch].
	currentCharacter == ${ ifTrue: [^self recordAndReportMatch: #(1)].
	currentCharacter == $| 
		ifTrue: 
			[self recordMatch: #(50).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(15)].
			currentCharacter == $| ifTrue: [^self recordAndReportMatch: #(52)].
			^self reportLastMatch].
	currentCharacter == $} ifTrue: [^self recordAndReportMatch: #(4)].
	currentCharacter == $~ ifTrue: [^self recordAndReportMatch: #(90)].
	^self reportLastMatch! !
!JavaScanner categoriesFor: #emptySymbolTokenId!generated-tokens!public! !
!JavaScanner categoriesFor: #errorTokenId!generated-tokens!public! !
!JavaScanner categoriesFor: #multipleLineComment!public!scanning! !
!JavaScanner categoriesFor: #scan1!generated-scanner!public! !
!JavaScanner categoriesFor: #scan2!generated-scanner!public! !
!JavaScanner categoriesFor: #scan3!generated-scanner!public! !
!JavaScanner categoriesFor: #scan4!generated-scanner!public! !
!JavaScanner categoriesFor: #scan5!generated-scanner!public! !
!JavaScanner categoriesFor: #scan6!generated-scanner!public! !
!JavaScanner categoriesFor: #scan7!generated-scanner!public! !
!JavaScanner categoriesFor: #scanForToken!generated-scanner!public! !

!JavaScanner class methodsFor!

initializeKeywordMap
	keywordMap := Dictionary new.
	#(#(99 'abstract' 40) #(99 'boolean' 33) #(99 'break' 78) #(99 'byte' 32) #(99 'case' 23) #(99 'catch' 73) #(99 'char' 28) #(99 'class' 9) #(99 'continue' 72) #(99 'default' 41) #(99 'do' 80) #(99 'double' 26) #(99 'else' 14) #(99 'extends' 8) #(99 'false' 95) #(99 'final' 39) #(99 'finally' 81) #(99 'float' 27) #(99 'for' 79) #(99 'if' 46) #(99 'implements' 2) #(99 'import' 42) #(99 'instanceof' 55) #(99 'int' 25) #(99 'interface' 12) #(99 'long' 24) #(99 'native' 38) #(99 'new' 76) #(99 'null' 98) #(99 'package' 29) #(99 'private' 37) #(99 'protected' 43) #(99 'public' 44) #(99 'return' 71) #(99 'short' 31) #(99 'static' 36) #(99 'strictfp' 22) #(99 'super' 13) #(99 'switch' 70) #(99 'synchronized' 18) #(99 'this' 19) #(99 'throw' 75) #(99 'throws' 20) #(99 'transient' 35) #(99 'true' 95) #(99 'try' 74) #(99 'void' 17) #(99 'volatile' 11) #(99 'while' 88)) 
		do: 
			[:each | 
			(keywordMap at: each first ifAbsentPut: [Dictionary new]) at: (each at: 2) put: each last].
	^keywordMap!

scannerDefinitionComment

	"<DECIMAL_INTEGER>: 0 | [1-9] [0-9]*	;
<HEX_INTEGER>: 0[xX][0-9a-fA-F]+	;
<OCTAL_INTEGER>: 0[0-7]+	;

<EXPONENT>: [eE] [\-\+]? [0-9]+ 	;
<FLOAT_TYPE>: [fFdD]	;

<ESCAPE_SEQUENCE>: \\ ([btnfr\""\'\\] | ([0-3] [0-7]{0,2} | [4-7][0-7]?))	;

<INTEGER_LITERAL>: (<DECIMAL_INTEGER> | <HEX_INTEGER> | <OCTAL_INTEGER>) [lL]?	;
<FLOATING_POINT_LITERAL>: [0-9]+ \. [0-9]* <EXPONENT>? <FLOAT_TYPE>? | \. [0-9]+ <EXPONENT>? <FLOAT_TYPE>? | [0-9]+ <EXPONENT> <FLOAT_TYPE>? | [0-9]+ <FLOAT_TYPE>	;
<BOOLEAN_LITERAL>: true | false	;
<CHARACTER_LITERAL>: \' ([^\\\'] | <ESCAPE_SEQUENCE> ) \'	;
<STRING_LITERAL>: \"" ([^\\\""] | <ESCAPE_SEQUENCE> )* \""	;
<NULL_LITERAL>: null	;

<IDENTIFIER>: [a-zA-Z_] \w*	;

<eol>: \r | \n | \r\n	;
<whitespace>: \s+	;
<comment>: \/\/ [^\r\n]* <eol>	;
<multipleLineComment>: \/ \* 	;"! !
!JavaScanner class categoriesFor: #initializeKeywordMap!generated-initialization!public! !
!JavaScanner class categoriesFor: #scannerDefinitionComment!generated-comments!public! !

