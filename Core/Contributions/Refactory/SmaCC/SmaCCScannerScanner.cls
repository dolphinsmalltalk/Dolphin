"Filed out from Dolphin Smalltalk XP"!

SmaCCScanner subclass: #SmaCCScannerScanner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCScannerScanner guid: (GUID fromString: '{C48B576D-0A3D-4EEF-9D22-2FB4D9523DB3}')!
SmaCCScannerScanner comment: 'SmaCCScannerScanner is the scanner for the scanner definition'!
!SmaCCScannerScanner categoriesForClass!SmaCC Runtime! !
!SmaCCScannerScanner methodsFor!

emptySymbolTokenId
	^18!

errorTokenId
	^17!

scan1
	
	[self step.
	currentCharacter <= $[ or: [currentCharacter >= $^]] whileTrue.
	currentCharacter == $\ ifTrue: [^self scan2].
	currentCharacter == $] ifTrue: [^self recordAndReportMatch: #(10)].
	^self reportLastMatch!

scan2
	self step.
	(currentCharacter <= $b 
		or: [(currentCharacter between: $d and: $w) or: [currentCharacter >= $y]]) 
			ifTrue: [^self scan1].
	currentCharacter == $c 
		ifTrue: 
			[self step.
			(currentCharacter between: $A and: $Z) ifTrue: [^self scan1].
			^self reportLastMatch].
	currentCharacter == $x 
		ifTrue: 
			[self step.
			(currentCharacter isHexDigit or: [currentCharacter between: $a and: $f]) 
				ifTrue: [^self scan1].
			^self reportLastMatch].
	^self reportLastMatch!

scanForToken
	self step.
	(currentCharacter <= $ or: 
			[currentCharacter == $ or: 
					[(currentCharacter between: $ and: $) or: 
							[(currentCharacter between: $!! and: $") or: 
									[(currentCharacter between: $$ and: $') or: 
											[(currentCharacter between: $, and: $-) or: 
													[(currentCharacter between: $/ and: $9) or: 
															[(currentCharacter between: $= and: $>) or: 
																	[(currentCharacter between: $@ and: $Z) 
																		or: [(currentCharacter between: $] and: $z) or: [currentCharacter >= $}]]]]]]]]]]) 
		ifTrue: [^self recordAndReportMatch: #(15)].
	((currentCharacter between: $	 and: $) 
		or: [currentCharacter == $
 or: [currentCharacter == $ ]]) 
			ifTrue: 
				[
				[self recordMatch: #whitespace.
				self step.
				(currentCharacter between: $	 and: $) 
					or: [currentCharacter == $
 or: [currentCharacter == $ ]]] 
						whileTrue.
				^self reportLastMatch].
	currentCharacter == $# 
		ifTrue: 
			[self recordMatch: #comment.
			self step.
			(currentCharacter <= $	 
				or: [(currentCharacter between: $ and: $) or: [currentCharacter >= $]]) 
					ifTrue: 
						[
						[self recordMatch: #comment.
						self step.
						currentCharacter <= $	 
							or: [(currentCharacter between: $ and: $) or: [currentCharacter >= $]]] 
								whileTrue.
						^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $( ifTrue: [^self recordAndReportMatch: #(4)].
	currentCharacter == $) ifTrue: [^self recordAndReportMatch: #(1 15)].
	currentCharacter == $* ifTrue: [^self recordAndReportMatch: #(2 15)].
	currentCharacter == $+ ifTrue: [^self recordAndReportMatch: #(6 15)].
	currentCharacter == $. ifTrue: [^self recordAndReportMatch: #(16)].
	currentCharacter == $: ifTrue: [^self recordAndReportMatch: #(5 15)].
	currentCharacter == $; ifTrue: [^self recordAndReportMatch: #(7 15)].
	currentCharacter == $< 
		ifTrue: 
			[self recordMatch: #(15).
			self step.
			((currentCharacter between: $A and: $Z) 
				or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]) 
					ifTrue: 
						[
						[self step.
						currentCharacter isHexDigit or: 
								[(currentCharacter between: $G and: $Z) 
									or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]] 
								whileTrue.
						currentCharacter == $> ifTrue: [^self recordAndReportMatch: #(12)].
						^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $? ifTrue: [^self recordAndReportMatch: #(8 15)].
	currentCharacter == $[ 
		ifTrue: 
			[self step.
			(currentCharacter <= $[ or: [currentCharacter >= $^]) ifTrue: [^self scan1].
			currentCharacter == $\ ifTrue: [^self scan2].
			^self reportLastMatch].
	currentCharacter == $\ 
		ifTrue: 
			[self step.
			(currentCharacter <= $b 
				or: [(currentCharacter between: $d and: $w) or: [currentCharacter >= $y]]) 
					ifTrue: [^self recordAndReportMatch: #(9)].
			currentCharacter == $c 
				ifTrue: 
					[self step.
					(currentCharacter between: $A and: $Z) ifTrue: [^self recordAndReportMatch: #(9)].
					^self reportLastMatch].
			currentCharacter == $x 
				ifTrue: 
					[self step.
					(currentCharacter isHexDigit or: [currentCharacter between: $a and: $f]) 
						ifTrue: 
							[self recordMatch: #(9).
							self step.
							(currentCharacter isHexDigit or: [currentCharacter between: $a and: $f]) 
								ifTrue: 
									[self recordMatch: #(9).
									self step.
									(currentCharacter isHexDigit or: [currentCharacter between: $a and: $f]) 
										ifTrue: 
											[self recordMatch: #(9).
											self step.
											(currentCharacter isHexDigit or: [currentCharacter between: $a and: $f]) 
												ifTrue: [^self recordAndReportMatch: #(9)].
											^self reportLastMatch].
									^self reportLastMatch].
							^self reportLastMatch].
					^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == ${ 
		ifTrue: 
			[
			[self step.
			currentCharacter isDigit] whileTrue.
			currentCharacter == $, 
				ifTrue: 
					[
					[self step.
					currentCharacter isDigit] whileTrue.
					currentCharacter == $} ifTrue: [^self recordAndReportMatch: #(14)].
					^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $| ifTrue: [^self recordAndReportMatch: #(3 15)].
	^self reportLastMatch! !
!SmaCCScannerScanner categoriesFor: #emptySymbolTokenId!generated-tokens!public! !
!SmaCCScannerScanner categoriesFor: #errorTokenId!generated-tokens!public! !
!SmaCCScannerScanner categoriesFor: #scan1!generated-scanner!public! !
!SmaCCScannerScanner categoriesFor: #scan2!generated-scanner!public! !
!SmaCCScannerScanner categoriesFor: #scanForToken!generated-scanner!public! !

!SmaCCScannerScanner class methodsFor!

scannerDefinitionComment

	"<backslashcharacter>	:	\\ [^cx] | \\ c [A-Z] | \\ x [0-9A-Fa-f]{1,4} ;
<characterblock>	: \[ ([^\]\\] | <backslashcharacter> )+ \] ;
<whitespace>	:	[\ \t\v\r\n]+ ;
<tokenname>	:	\< [a-zA-Z_] \w* \> ;
<comment>	:	\# [^\r\n]* ;
<repeat>	:	\{ [0-9]* \, [0-9]* \} ;
<character>	:	[^\ \t\v\\\r\n\{\(\[\.] ; 
<anycharacter>	: \. ;"! !
!SmaCCScannerScanner class categoriesFor: #scannerDefinitionComment!generated-comments!public! !

