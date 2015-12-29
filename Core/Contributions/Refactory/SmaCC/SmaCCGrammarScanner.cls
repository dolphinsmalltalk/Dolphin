"Filed out from Dolphin Smalltalk XP"!

SmaCCScanner subclass: #SmaCCGrammarScanner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCGrammarScanner guid: (GUID fromString: '{FDAF9BAD-A671-4378-86AD-443A1797448E}')!
SmaCCGrammarScanner comment: 'SmaCCGrammarScanner is the scanner for the grammar parser'!
!SmaCCGrammarScanner categoriesForClass!SmaCC Runtime! !
!SmaCCGrammarScanner methodsFor!

emptySymbolTokenId
	^42!

errorTokenId
	^43!

scan1
	
	[
	[self step.
	currentCharacter ~~ $"] whileTrue.
	self recordMatch: #(21).
	self step.
	currentCharacter == $"] 
			whileTrue: [].
	^self reportLastMatch!

scan2
	self step.
	currentCharacter == $> ifTrue: [^self recordAndReportMatch: #(12)].
	currentCharacter == $i 
		ifTrue: 
			[self step.
			currentCharacter == $d ifTrue: [^self recordAndReportMatch: #(3)].
			^self reportLastMatch].
	currentCharacter == $l 
		ifTrue: 
			[self step.
			currentCharacter == $e 
				ifTrue: 
					[self step.
					currentCharacter == $f 
						ifTrue: 
							[self step.
							currentCharacter == $t ifTrue: [^self recordAndReportMatch: #(7)].
							^self reportLastMatch].
					^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $n 
		ifTrue: 
			[self step.
			currentCharacter == $o 
				ifTrue: 
					[self step.
					currentCharacter == $n 
						ifTrue: 
							[self step.
							currentCharacter == $a 
								ifTrue: 
									[self step.
									currentCharacter == $s 
										ifTrue: 
											[self step.
											currentCharacter == $s 
												ifTrue: 
													[self step.
													currentCharacter == $o 
														ifTrue: 
															[self step.
															currentCharacter == $c ifTrue: [^self recordAndReportMatch: #(1)].
															^self reportLastMatch].
													^self reportLastMatch].
											^self reportLastMatch].
									^self reportLastMatch].
							^self reportLastMatch].
					^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $r 
		ifTrue: 
			[self step.
			currentCharacter == $i 
				ifTrue: 
					[self step.
					currentCharacter == $g 
						ifTrue: 
							[self step.
							currentCharacter == $h 
								ifTrue: 
									[self step.
									currentCharacter == $t ifTrue: [^self recordAndReportMatch: #(5)].
									^self reportLastMatch].
							^self reportLastMatch].
					^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $s 
		ifTrue: 
			[self step.
			currentCharacter == $t 
				ifTrue: 
					[self step.
					currentCharacter == $a 
						ifTrue: 
							[self step.
							currentCharacter == $r 
								ifTrue: 
									[self step.
									currentCharacter == $t ifTrue: [^self recordAndReportMatch: #(8)].
									^self reportLastMatch].
							^self reportLastMatch].
					^self reportLastMatch].
			^self reportLastMatch].
	^self reportLastMatch!

scanForToken
	self step.
	((currentCharacter between: $A and: $Z) 
		or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]) 
			ifTrue: 
				[
				[self recordMatch: #(20).
				self step.
				currentCharacter isHexDigit or: 
						[(currentCharacter between: $G and: $Z) 
							or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]] 
						whileTrue.
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
	currentCharacter == $" ifTrue: [^self scan1].
	currentCharacter == $# 
		ifTrue: 
			[
			[self recordMatch: #comment.
			self step.
			currentCharacter <= $	 
				or: [(currentCharacter between: $ and: $) or: [currentCharacter >= $]]] 
					whileTrue.
			^self reportLastMatch].
	currentCharacter == $% ifTrue: [^self scan2].
	currentCharacter == $' 
		ifTrue: 
			[self step.
			((currentCharacter between: $A and: $Z) 
				or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]) 
					ifTrue: 
						[
						[self step.
						currentCharacter isHexDigit or: 
								[(currentCharacter between: $G and: $Z) 
									or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]] 
								whileTrue.
						currentCharacter == $' ifTrue: [^self recordAndReportMatch: #(24)].
						^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $( ifTrue: [^self recordAndReportMatch: #(16)].
	currentCharacter == $) ifTrue: [^self recordAndReportMatch: #(11)].
	currentCharacter == $* ifTrue: [^self recordAndReportMatch: #(10)].
	currentCharacter == $+ ifTrue: [^self recordAndReportMatch: #(17)].
	currentCharacter == $: 
		ifTrue: 
			[self recordMatch: #(25).
			self step.
			currentCharacter == $: 
				ifTrue: 
					[self step.
					currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(25)].
					^self reportLastMatch].
			^self reportLastMatch].
	currentCharacter == $; ifTrue: [^self recordAndReportMatch: #(2)].
	currentCharacter == $< 
		ifTrue: 
			[self step.
			((currentCharacter between: $A and: $Z) 
				or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]) 
					ifTrue: 
						[
						[self step.
						currentCharacter isHexDigit or: 
								[(currentCharacter between: $G and: $Z) 
									or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]] 
								whileTrue.
						currentCharacter == $> ifTrue: [^self recordAndReportMatch: #(19)].
						^self reportLastMatch].
			currentCharacter == $% ifTrue: [^self recordAndReportMatch: #(13)].
			^self reportLastMatch].
	currentCharacter == $? ifTrue: [^self recordAndReportMatch: #(14)].
	currentCharacter == $[ ifTrue: [^self recordAndReportMatch: #(9)].
	currentCharacter == $] ifTrue: [^self recordAndReportMatch: #(4)].
	currentCharacter == ${ 
		ifTrue: 
			[self step.
			currentCharacter ~~ $} 
				ifTrue: 
					[
					[self step.
					currentCharacter ~~ $}] whileTrue.
					^self recordAndReportMatch: #(23)].
			^self reportLastMatch].
	currentCharacter == $| ifTrue: [^self recordAndReportMatch: #(6)].
	^self reportLastMatch! !
!SmaCCGrammarScanner categoriesFor: #emptySymbolTokenId!generated-tokens!public! !
!SmaCCGrammarScanner categoriesFor: #errorTokenId!generated-tokens!public! !
!SmaCCGrammarScanner categoriesFor: #scan1!generated-scanner!public! !
!SmaCCGrammarScanner categoriesFor: #scan2!generated-scanner!public! !
!SmaCCGrammarScanner categoriesFor: #scanForToken!generated-scanner!public! !

!SmaCCGrammarScanner class methodsFor!

initializeKeywordMap
	keywordMap := Dictionary new.
	#(#(20 'error' 15)) do: 
			[:each | 
			(keywordMap at: each first ifAbsentPut: [Dictionary new]) at: (each at: 2) put: each last].
	^keywordMap!

needsLineNumbers
	^true!

scannerDefinitionComment

	"<name> : [a-zA-Z_] \w* ;
<whitespace>	:	\s+ ;
<tokenname>	:	\< <name> \> ;
<symbolname>	:	<name>	 ;
<keyword>	:	(\"" [^\""]* \"") + ;
<comment>	:	\# [^\r\n]* ;
<code>:	\{ [^\}]+ \} ;
<variablename> :	\' <name> \' ;
<production> : \: (\: \=)? ;"! !
!SmaCCGrammarScanner class categoriesFor: #initializeKeywordMap!generated-initialization!public! !
!SmaCCGrammarScanner class categoriesFor: #needsLineNumbers!public!testing! !
!SmaCCGrammarScanner class categoriesFor: #scannerDefinitionComment!generated-comments!public! !

