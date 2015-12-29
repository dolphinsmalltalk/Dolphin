"Filed out from Dolphin Smalltalk XP"!

SmaCCScanner subclass: #CScanner
	instanceVariableNames: 'typeNames'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CScanner guid: (GUID fromString: '{71A7FE37-3F9A-40EB-9563-DA0DB720C04E}')!
CScanner comment: ''!
!CScanner categoriesForClass!SmaCC Runtime! !
!CScanner methodsFor!

addTypeName: aString 
	typeNames add: aString!

comment
	| char |
	
	[[(char := stream next) isNil or: [char == $*]] whileFalse.
	stream atEnd ifTrue: [self scannerError].
	stream peekFor: $/] 
			whileFalse.
	^self whitespace!

CONSTANTId
	^77!

emptySymbolTokenId
	^146!

errorTokenId
	^147!

IDENTIFIER
	| name token |
	name := outputStream contents.
	matchActions := (typeNames includes: name) 
				ifTrue: [Array with: self TYPE_NAMEId]
				ifFalse: [Array with: self IDENTIFIERId].
	outputStream reset.
	token := SmaCCToken 
				value: name
				start: start
				id: matchActions.
	matchActions := nil.
	returnMatchBlock value: token!

IDENTIFIERId
	^76!

initialize
	super initialize.
	typeNames := Set new!

scan1
	self step.
	currentCharacter isDigit ifTrue: [^self scan2].
	^self reportLastMatch!

scan2
	
	[self recordMatch: #(77).
	self step.
	currentCharacter isDigit] whileTrue.
	(currentCharacter == $F 
		or: [currentCharacter == $L or: [currentCharacter == $f or: [currentCharacter == $l]]]) 
			ifTrue: [^self recordAndReportMatch: #(77)].
	(currentCharacter == $E or: [currentCharacter == $e]) ifTrue: [^self scan3].
	^self reportLastMatch!

scan3
	self step.
	currentCharacter isDigit ifTrue: [^self scan4].
	(currentCharacter == $+ or: [currentCharacter == $-]) 
		ifTrue: 
			[self step.
			currentCharacter isDigit ifTrue: [^self scan4].
			^self reportLastMatch].
	^self reportLastMatch!

scan4
	
	[self recordMatch: #(77).
	self step.
	currentCharacter isDigit] whileTrue.
	(currentCharacter == $F 
		or: [currentCharacter == $L or: [currentCharacter == $f or: [currentCharacter == $l]]]) 
			ifTrue: [^self recordAndReportMatch: #(77)].
	^self reportLastMatch!

scan5
	self step.
	(currentCharacter <= $!! 
		or: [(currentCharacter between: $# and: $[) or: [currentCharacter >= $]]]) 
			ifTrue: [^self scan7].
	currentCharacter == $\ ifTrue: [^self scan6].
	^self reportLastMatch!

scan6
	self step.
	^self scan7!

scan7
	
	[self step.
	currentCharacter <= $!! or: 
			[(currentCharacter between: $# and: $&) 
				or: [(currentCharacter between: $( and: $[) or: [currentCharacter >= $]]]]] 
			whileTrue.
	currentCharacter == $' 
		ifTrue: 
			[
			[self recordMatch: #(77).
			self step.
			(currentCharacter <= $!! or: 
					[(currentCharacter between: $# and: $&) 
						or: [(currentCharacter between: $( and: $[) or: [currentCharacter >= $]]]]) 
				ifTrue: [^self scan7].
			currentCharacter == $'] 
					whileTrue.
			currentCharacter == $\ ifTrue: [^self scan6].
			^self reportLastMatch].
	currentCharacter == $\ ifTrue: [^self scan6].
	^self reportLastMatch!

scan8
	
	[
	[self step.
	currentCharacter <= $!! 
		or: [(currentCharacter between: $# and: $[) or: [currentCharacter >= $]]]] 
			whileTrue.
	currentCharacter == $" ifTrue: [^self recordAndReportMatch: #(78)].
	currentCharacter == $\] 
			whileTrue: [self step].
	^self reportLastMatch!

scan9
	
	[self recordMatch: #(77).
	self step.
	currentCharacter isDigit] whileTrue.
	(currentCharacter == $L 
		or: [currentCharacter == $U or: [currentCharacter == $l or: [currentCharacter == $u]]]) 
			ifTrue: [^self recordAndReportMatch: #(77)].
	(currentCharacter == $E or: [currentCharacter == $e]) ifTrue: [^self scan3].
	currentCharacter == $. ifTrue: [^self scan1].
	^self reportLastMatch!

scanForToken
	self step.
	((currentCharacter between: $A and: $K) or: 
			[(currentCharacter between: $M and: $Z) 
				or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]) 
		ifTrue: 
			[
			[self recordMatch: #IDENTIFIER.
			self step.
			currentCharacter isHexDigit or: 
					[(currentCharacter between: $G and: $Z) 
						or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]] 
					whileTrue.
			^self reportLastMatch].
	(currentCharacter between: $1 and: $9) ifTrue: [^self scan9].
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
			[self recordMatch: #(31).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(3)].
			^self reportLastMatch].
	currentCharacter == $" ifTrue: [^self scan8].
	currentCharacter == $% 
		ifTrue: 
			[self recordMatch: #(13).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(36)].
			currentCharacter == $> ifTrue: [^self recordAndReportMatch: #(82)].
			^self reportLastMatch].
	currentCharacter == $& 
		ifTrue: 
			[self recordMatch: #(24).
			self step.
			currentCharacter == $& ifTrue: [^self recordAndReportMatch: #(6)].
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(58)].
			^self reportLastMatch].
	currentCharacter == $' ifTrue: [^self scan5].
	currentCharacter == $( ifTrue: [^self recordAndReportMatch: #(25)].
	currentCharacter == $) ifTrue: [^self recordAndReportMatch: #(20)].
	currentCharacter == $* 
		ifTrue: 
			[self recordMatch: #(35).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(10)].
			^self reportLastMatch].
	currentCharacter == $+ 
		ifTrue: 
			[self recordMatch: #(34).
			self step.
			currentCharacter == $+ ifTrue: [^self recordAndReportMatch: #(21)].
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(18)].
			^self reportLastMatch].
	currentCharacter == $, ifTrue: [^self recordAndReportMatch: #(22)].
	currentCharacter == $- 
		ifTrue: 
			[self recordMatch: #(29).
			self step.
			currentCharacter == $- ifTrue: [^self recordAndReportMatch: #(26)].
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(56)].
			currentCharacter == $> ifTrue: [^self recordAndReportMatch: #(19)].
			^self reportLastMatch].
	currentCharacter == $. 
		ifTrue: 
			[self recordMatch: #(23).
			self step.
			currentCharacter isDigit ifTrue: [^self scan2].
			currentCharacter == $. 
				ifTrue: 
					[self step.
					currentCharacter == $. ifTrue: [^self recordAndReportMatch: #(74)].
					^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $/ 
		ifTrue: 
			[self recordMatch: #(30).
			self step.
			currentCharacter == $* ifTrue: [^self recordAndReportMatch: #comment].
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(12)].
			^self reportLastMatch].
	currentCharacter == $0 
		ifTrue: 
			[self recordMatch: #(77).
			self step.
			currentCharacter isDigit ifTrue: [^self scan9].
			(currentCharacter == $L 
				or: [currentCharacter == $U or: [currentCharacter == $l or: [currentCharacter == $u]]]) 
					ifTrue: [^self recordAndReportMatch: #(77)].
			(currentCharacter == $E or: [currentCharacter == $e]) ifTrue: [^self scan3].
			(currentCharacter == $X or: [currentCharacter == $x]) 
				ifTrue: 
					[self step.
					(currentCharacter isHexDigit or: [currentCharacter between: $a and: $f]) 
						ifTrue: 
							[
							[self recordMatch: #(77).
							self step.
							currentCharacter isHexDigit or: [currentCharacter between: $a and: $f]] 
									whileTrue.
							(currentCharacter == $L 
								or: [currentCharacter == $U or: [currentCharacter == $l or: [currentCharacter == $u]]]) 
									ifTrue: [^self recordAndReportMatch: #(77)].
							^self reportLastMatch].
					^self reportLastMatch].
			currentCharacter == $. ifTrue: [^self scan1].
			^self reportLastMatch].
	currentCharacter == $: 
		ifTrue: 
			[self recordMatch: #(11).
			self step.
			currentCharacter == $> ifTrue: [^self recordAndReportMatch: #(80)].
			^self reportLastMatch].
	currentCharacter == $; ifTrue: [^self recordAndReportMatch: #(59)].
	currentCharacter == $< 
		ifTrue: 
			[self recordMatch: #(17).
			self step.
			currentCharacter == $% ifTrue: [^self recordAndReportMatch: #(81)].
			currentCharacter == $: ifTrue: [^self recordAndReportMatch: #(79)].
			currentCharacter == $< 
				ifTrue: 
					[self recordMatch: #(27).
					self step.
					currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(33)].
					^self reportLastMatch].
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(2)].
			^self reportLastMatch].
	currentCharacter == $= 
		ifTrue: 
			[self recordMatch: #(14).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(1)].
			^self reportLastMatch].
	currentCharacter == $> 
		ifTrue: 
			[self recordMatch: #(7).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(5)].
			currentCharacter == $> 
				ifTrue: 
					[self recordMatch: #(9).
					self step.
					currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(63)].
					^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $? ifTrue: [^self recordAndReportMatch: #(16)].
	currentCharacter == $L 
		ifTrue: 
			[self recordMatch: #IDENTIFIER.
			self step.
			(currentCharacter isHexDigit or: 
					[(currentCharacter between: $G and: $Z) 
						or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]) 
				ifTrue: 
					[
					[self recordMatch: #IDENTIFIER.
					self step.
					currentCharacter isHexDigit or: 
							[(currentCharacter between: $G and: $Z) 
								or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]] 
							whileTrue.
					^self reportLastMatch].
			currentCharacter == $" ifTrue: [^self scan8].
			currentCharacter == $' ifTrue: [^self scan5].
			^self reportLastMatch].
	currentCharacter == $[ ifTrue: [^self recordAndReportMatch: #(79)].
	currentCharacter == $] ifTrue: [^self recordAndReportMatch: #(80)].
	currentCharacter == $^ 
		ifTrue: 
			[self recordMatch: #(8).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(61)].
			^self reportLastMatch].
	currentCharacter == ${ ifTrue: [^self recordAndReportMatch: #(81)].
	currentCharacter == $| 
		ifTrue: 
			[self recordMatch: #(4).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(57)].
			currentCharacter == $| ifTrue: [^self recordAndReportMatch: #(15)].
			^self reportLastMatch].
	currentCharacter == $} ifTrue: [^self recordAndReportMatch: #(82)].
	currentCharacter == $~ ifTrue: [^self recordAndReportMatch: #(28)].
	^self reportLastMatch!

TYPE_NAMEId
	^131! !
!CScanner categoriesFor: #addTypeName:!public!scanning! !
!CScanner categoriesFor: #comment!default token handling!public! !
!CScanner categoriesFor: #CONSTANTId!generated-tokens!public! !
!CScanner categoriesFor: #emptySymbolTokenId!generated-tokens!public! !
!CScanner categoriesFor: #errorTokenId!generated-tokens!public! !
!CScanner categoriesFor: #IDENTIFIER!public!scanning! !
!CScanner categoriesFor: #IDENTIFIERId!generated-tokens!public! !
!CScanner categoriesFor: #initialize!initialize-release!public! !
!CScanner categoriesFor: #scan1!generated-scanner!public! !
!CScanner categoriesFor: #scan2!generated-scanner!public! !
!CScanner categoriesFor: #scan3!generated-scanner!public! !
!CScanner categoriesFor: #scan4!generated-scanner!public! !
!CScanner categoriesFor: #scan5!generated-scanner!public! !
!CScanner categoriesFor: #scan6!generated-scanner!public! !
!CScanner categoriesFor: #scan7!generated-scanner!public! !
!CScanner categoriesFor: #scan8!generated-scanner!public! !
!CScanner categoriesFor: #scan9!generated-scanner!public! !
!CScanner categoriesFor: #scanForToken!generated-scanner!public! !
!CScanner categoriesFor: #TYPE_NAMEId!generated-tokens!public! !

!CScanner class methodsFor!

initializeKeywordMap
	keywordMap := Dictionary new.
	#(#(#IDENTIFIER 'auto' 62) #(#IDENTIFIER 'break' 37) #(#IDENTIFIER 'case' 45) #(#IDENTIFIER 'char' 67) #(#IDENTIFIER 'const' 38) #(#IDENTIFIER 'continue' 49) #(#IDENTIFIER 'default' 41) #(#IDENTIFIER 'do' 48) #(#IDENTIFIER 'double' 52) #(#IDENTIFIER 'else' 43) #(#IDENTIFIER 'enum' 42) #(#IDENTIFIER 'extern' 60) #(#IDENTIFIER 'float' 71) #(#IDENTIFIER 'for' 47) #(#IDENTIFIER 'goto' 50) #(#IDENTIFIER 'if' 51) #(#IDENTIFIER 'int' 69) #(#IDENTIFIER 'long' 68) #(#IDENTIFIER 'register' 73) #(#IDENTIFIER 'return' 65) #(#IDENTIFIER 'short' 66) #(#IDENTIFIER 'signed' 46) #(#IDENTIFIER 'sizeof' 32) #(#IDENTIFIER 'static' 70) #(#IDENTIFIER 'struct' 44) #(#IDENTIFIER 'switch' 54) #(#IDENTIFIER 'typedef' 64) #(#IDENTIFIER 'union' 39) #(#IDENTIFIER 'unsigned' 55) #(#IDENTIFIER 'void' 72) #(#IDENTIFIER 'volatile' 40) #(#IDENTIFIER 'while' 53)) 
		do: 
			[:each | 
			(keywordMap at: each first ifAbsentPut: [Dictionary new]) at: (each at: 2) put: each last].
	^keywordMap!

needsLineNumbers
	^true!

scannerDefinitionComment

	"<H>: [a-fA-F0-9]	;
<IS>: [uUlL]	;
<D>: [0-9]	;
<E>: [Ee][\+\-]?<D>+	;
<FS>: [fFlL]	;
<ELLIPSIS> : \.\.\. ;
<comment>: \/ \*	;
<LETTER> : [a-zA-Z_] ;
<DIGIT> : [0-9] ;
<IDENTIFIER>: <LETTER> (<LETTER>|<DIGIT>)*	;
<CONSTANT>: (0[xX]<H>+<IS>?) | 
				(<D>+<IS>?) | 
				(<D>+<E><FS>?) | 
				<D>*\.<D>+<E>?<FS>? | 
				(L? \' ( (\\ .) | ([^\\\""]) )+ \')	;

<STRING_LITERAL>: L? \"" ( (\\ .) | ([^\\\""]) )* \""	;

<LEFT_BLOCK>: \[ | (\< \:)	;
<RIGHT_BLOCK>: \] | (\: \>)	;
<LEFT_BRACE>: \{ | (\< \%)	;
<RIGHT_BRACE>: \} | (\% \>)	;

<whitespace>: \s+	;"! !
!CScanner class categoriesFor: #initializeKeywordMap!generated-initialization!public! !
!CScanner class categoriesFor: #needsLineNumbers!public!testing! !
!CScanner class categoriesFor: #scannerDefinitionComment!generated-comments!public! !

