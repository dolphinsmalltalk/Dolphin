"Filed out from Dolphin Smalltalk XP"!

SmaCCScanner subclass: #StScanner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StScanner guid: (GUID fromString: '{A783BAD6-B8EA-46E4-A85A-7F11461120BF}')!
StScanner comment: ''!
!StScanner categoriesForClass!SmaCC Runtime! !
!StScanner methodsFor!

binary_symbolId
	^26!

emptySymbolTokenId
	^63!

errorTokenId
	^64!

nameId
	^20!

negative_number
	stream skip: -2.
	self scanNumber: self negative_numberId!

negative_numberId
	^22!

number
	stream skip: -1.
	self scanNumber: self numberId!

numberId
	^21!

scan1
	
	[self step.
	currentCharacter ~~ $'] whileTrue.
	^self scan2!

scan2
	self recordMatch: #(23).
	self step.
	currentCharacter == $' ifTrue: [^self scan1].
	^self reportLastMatch!

scan3
	
	[self step.
	currentCharacter isHexDigit or: 
			[(currentCharacter between: $G and: $Z) 
				or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]] 
			whileTrue.
	currentCharacter == $: 
		ifTrue: 
			[self recordMatch: #(25).
			self step.
			((currentCharacter between: $A and: $Z) 
				or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]) 
					ifTrue: [^self scan3].
			^self reportLastMatch].
	^self reportLastMatch!

scan4
	self step.
	((currentCharacter between: $A and: $Z) 
		or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]) 
			ifTrue: 
				[
				[self recordMatch: #(29).
				self step.
				currentCharacter isHexDigit or: 
						[(currentCharacter between: $G and: $Z) 
							or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]] 
						whileTrue.
				currentCharacter == $. ifTrue: [^self scan4].
				^self reportLastMatch].
	^self reportLastMatch!

scan5
	self recordMatch: #(24).
	self step.
	((currentCharacter between: $A and: $Z) 
		or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]) 
			ifTrue: [^self scan3].
	currentCharacter == $= ifTrue: [^self recordAndReportMatch: #variable_assignment].
	^self reportLastMatch!

scanForToken
	self step.
	((currentCharacter between: $A and: $Z) 
		or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]) 
			ifTrue: 
				[self recordMatch: #(20 32).
				self step.
				(currentCharacter isHexDigit or: 
						[(currentCharacter between: $G and: $Z) 
							or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]) 
					ifTrue: 
						[
						[self recordMatch: #(20).
						self step.
						currentCharacter isHexDigit or: 
								[(currentCharacter between: $G and: $Z) 
									or: [currentCharacter == $_ or: [currentCharacter between: $a and: $z]]]] 
								whileTrue.
						currentCharacter == $: ifTrue: [^self scan5].
						currentCharacter == $. ifTrue: [^self scan4].
						^self reportLastMatch].
				currentCharacter == $: ifTrue: [^self scan5].
				currentCharacter == $. ifTrue: [^self scan4].
				^self reportLastMatch].
	((currentCharacter between: $	 and: $
) or: [currentCharacter == $ ]) 
		ifTrue: 
			[self recordMatch: #whitespace.
			self step.
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
			^self reportLastMatch].
	(currentCharacter isDigit or: 
			[currentCharacter <= $ or: 
					[(currentCharacter between: $ and: $) 
						or: [currentCharacter == $` or: [currentCharacter >= $]]]]) 
		ifTrue: [^self recordAndReportMatch: #(32)].
	currentCharacter == $: 
		ifTrue: 
			[self recordMatch: #(16 32).
			self step.
			currentCharacter == $= ifTrue: [^self recordAndReportMatch: #(11)].
			^self reportLastMatch].
	currentCharacter == $. ifTrue: [^self recordAndReportMatch: #(5 32)].
	(currentCharacter == $!! or: 
			[(currentCharacter between: $% and: $&) or: 
					[(currentCharacter between: $* and: $,) or: 
							[currentCharacter == $/ or: 
									[currentCharacter == $= or: 
											[(currentCharacter between: $? and: $@) 
												or: [currentCharacter == $\ or: [currentCharacter == $~]]]]]]]) 
		ifTrue: 
			[self recordMatch: #(26 32).
			self step.
			(currentCharacter == $!! or: 
					[(currentCharacter between: $% and: $&) or: 
							[(currentCharacter between: $* and: $,) or: 
									[currentCharacter == $/ or: 
											[(currentCharacter between: $< and: $@) 
												or: [currentCharacter == $\ or: [currentCharacter == $| or: [currentCharacter == $~]]]]]]]) 
				ifTrue: [^self recordAndReportMatch: #(26)].
			^self reportLastMatch].
	currentCharacter == $# ifTrue: [^self recordAndReportMatch: #(4 32)].
	currentCharacter == $] ifTrue: [^self recordAndReportMatch: #(12 32)].
	currentCharacter == $[ ifTrue: [^self recordAndReportMatch: #(18 32)].
	currentCharacter == $( ifTrue: [^self recordAndReportMatch: #(2 32)].
	currentCharacter == $) ifTrue: [^self recordAndReportMatch: #(1 32)].
	currentCharacter == $" 
		ifTrue: 
			[self recordMatch: #(32).
			self step.
			currentCharacter ~~ $" 
				ifTrue: 
					[
					[self step.
					currentCharacter ~~ $"] whileTrue.
					^self recordAndReportMatch: #comment].
			currentCharacter == $" ifTrue: [^self recordAndReportMatch: #comment].
			^self reportLastMatch].
	currentCharacter == $' 
		ifTrue: 
			[self recordMatch: #(32).
			self step.
			currentCharacter ~~ $' ifTrue: [^self scan1].
			currentCharacter == $' ifTrue: [^self scan2].
			^self reportLastMatch].
	currentCharacter == $^ ifTrue: [^self recordAndReportMatch: #(19 32)].
	currentCharacter == $| 
		ifTrue: 
			[self recordMatch: #(17 26 32).
			self step.
			(currentCharacter == $!! or: 
					[(currentCharacter between: $% and: $&) or: 
							[(currentCharacter between: $* and: $,) or: 
									[currentCharacter == $/ or: 
											[(currentCharacter between: $< and: $@) 
												or: [currentCharacter == $\ or: [currentCharacter == $~]]]]]]) 
				ifTrue: [^self recordAndReportMatch: #(26)].
			currentCharacter == $| ifTrue: [^self recordAndReportMatch: #(15 26)].
			^self reportLastMatch].
	currentCharacter == $; ifTrue: [^self recordAndReportMatch: #(9 32)].
	currentCharacter == $- 
		ifTrue: 
			[self recordMatch: #(26 32).
			self step.
			currentCharacter isDigit ifTrue: [^self recordAndReportMatch: #negative_number].
			(currentCharacter == $!! or: 
					[(currentCharacter between: $% and: $&) or: 
							[(currentCharacter between: $* and: $,) or: 
									[currentCharacter == $/ or: 
											[(currentCharacter between: $< and: $@) 
												or: [currentCharacter == $\ or: [currentCharacter == $| or: [currentCharacter == $~]]]]]]]) 
				ifTrue: [^self recordAndReportMatch: #(26)].
			^self reportLastMatch].
	currentCharacter == $> 
		ifTrue: 
			[self recordMatch: #(7 26 32).
			self step.
			(currentCharacter == $!! or: 
					[(currentCharacter between: $% and: $&) or: 
							[(currentCharacter between: $* and: $,) or: 
									[currentCharacter == $/ or: 
											[(currentCharacter between: $< and: $@) 
												or: [currentCharacter == $\ or: [currentCharacter == $| or: [currentCharacter == $~]]]]]]]) 
				ifTrue: [^self recordAndReportMatch: #(26)].
			^self reportLastMatch].
	currentCharacter == $< 
		ifTrue: 
			[self recordMatch: #(8 26 32).
			self step.
			(currentCharacter == $!! or: 
					[(currentCharacter between: $% and: $&) or: 
							[(currentCharacter between: $* and: $,) or: 
									[currentCharacter == $/ or: 
											[(currentCharacter between: $< and: $@) 
												or: [currentCharacter == $\ or: [currentCharacter == $| or: [currentCharacter == $~]]]]]]]) 
				ifTrue: [^self recordAndReportMatch: #(26)].
			^self reportLastMatch].
	currentCharacter == $} ifTrue: [^self recordAndReportMatch: #(3 32)].
	currentCharacter == ${ ifTrue: [^self recordAndReportMatch: #(6 32)].
	currentCharacter == $$ 
		ifTrue: 
			[self recordMatch: #(32).
			self step.
			^self recordAndReportMatch: #(30)].
	^self reportLastMatch!

scanNumber: id 
	| token number |
	number := Number readFrom: stream.
	outputStream reset.
	token := SmaCCToken 
				value: number
				start: start
				id: (Array with: id).
	matchActions := nil.
	returnMatchBlock value: token!

variable_assignment
	| token |
	outputStream skip: -2.
	stream skip: -2.
	token := SmaCCToken 
				value: outputStream contents
				start: start
				id: (Array with: self nameId).
	outputStream reset.
	matchActions := nil.
	returnMatchBlock value: token! !
!StScanner categoriesFor: #binary_symbolId!generated-tokens!public! !
!StScanner categoriesFor: #emptySymbolTokenId!generated-tokens!public! !
!StScanner categoriesFor: #errorTokenId!generated-tokens!public! !
!StScanner categoriesFor: #nameId!generated-tokens!public! !
!StScanner categoriesFor: #negative_number!public!scanning! !
!StScanner categoriesFor: #negative_numberId!generated-tokens!public! !
!StScanner categoriesFor: #number!public!scanning! !
!StScanner categoriesFor: #numberId!generated-tokens!public! !
!StScanner categoriesFor: #scan1!generated-scanner!public! !
!StScanner categoriesFor: #scan2!generated-scanner!public! !
!StScanner categoriesFor: #scan3!generated-scanner!public! !
!StScanner categoriesFor: #scan4!generated-scanner!public! !
!StScanner categoriesFor: #scan5!generated-scanner!public! !
!StScanner categoriesFor: #scanForToken!generated-scanner!public! !
!StScanner categoriesFor: #scanNumber:!public!scanning! !
!StScanner categoriesFor: #variable_assignment!public!scanning! !

!StScanner class methodsFor!

frequencyTable
	^#(0.0 1.31372e-7 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0481767 0.0 0.0 0.0 0.0252514 0.0 0.0 2.62743e-7 1.31372e-7 5.25487e-7 1.31372e-7 1.31372e-7 0.0 1.31372e-7 0.0 2.62743e-7 0.0 1.31372e-7 7.8823e-7 2.62743e-7 2.62743e-7 1.31372e-7 5.25487e-7 0.106011 5.13007e-5 0.004554 0.00655584 2.41133e-4 3.60615e-5 1.93248e-4 0.00410241 0.00463893 0.0046369 2.82712e-4 4.64268e-4 0.0011675 9.75895e-4 0.00982753 2.26945e-4 0.00795055 0.00590903 0.0036363 0.00220212 0.00180485 0.00224265 0.00183191 0.00138545 0.00146217 0.00115246 0.0248349 0.00129723 7.50395e-4 0.00496762 8.97532e-4 1.44378e-4 0.00164497 0.00403659 0.00332443 0.00587547 0.00266882 0.00223293 0.00382922 9.91266e-4 9.99673e-4 0.00418163 3.27773e-5 6.31044e-4 0.00271013 0.00248917 0.00292348 0.00278226 0.00359742 7.08751e-4 0.00239287 0.00749351 0.00486778 0.00145908 0.00167453 0.00112251 2.2458e-4 2.32856e-4 4.40752e-5 0.00467815 1.22701e-4 0.00470173 0.00298378 7.73451e-4 2.634e-4 0.0515694 0.00918972 0.0257636 0.0226939 0.09244 0.0167193 0.0108988 0.0138365 0.042864 9.52379e-4 0.00366494 0.0402202 0.0159142 0.0440905 0.0418992 0.0154463 5.66869e-4 0.043972 0.0443068 0.0543899 0.0180997 0.00593537 0.00725816 0.00494884 0.00808567 0.00128285 7.45009e-4 0.00281083 7.45206e-4 1.08907e-4 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 6.56859e-8 3.28429e-7 0.0 0.0 1.97058e-7 0.0 0.0 0.0 0.0 3.94115e-7 6.56859e-8 0.0 2.62743e-7 1.31372e-7 0.0 1.31372e-7 1.31372e-7 0.0 0.0 1.97058e-7 1.31372e-7 6.56859e-8 1.31372e-7 0.0 0.0 7.8823e-7 0.0 0.0 1.31372e-7 1.31372e-7 4.59801e-7 7.8823e-7 0.0 9.85288e-7 5.25487e-7 1.31372e-7 6.56859e-8 1.05097e-6 0.0 2.62743e-7 0.0 1.97058e-7 4.59801e-7 1.97058e-7 5.25487e-7 2.62743e-7 0.0 1.51078e-6 5.91173e-7 1.11666e-6 0.0 1.97058e-7 8.53916e-7 1.57646e-6 0.0 0.0 0.0 0.0 0.0 0.0 0.0 6.56859e-8 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 5.25487e-7 0.0 0.0 0.0 0.0 0.0 0.0 7.8823e-7 0.0 2.62743e-7 0.0 0.0 3.28429e-7 1.31372e-7 0.0 2.62743e-7 0.0 3.28429e-7 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 2.62743e-7 0.0 5.25487e-7 0.0 0.0 1.31372e-7 0.0 0.0 0.0 0.0)!

initializeKeywordMap
	keywordMap := Dictionary new.
	#(#(32 '0' #number) #(32 '1' #number) #(32 '2' #number) #(32 '3' #number) #(32 '4' #number) #(32 '5' #number) #(32 '6' #number) #(32 '7' #number) #(32 '8' #number) #(32 '9' #number) #(20 'false' 13) #(20 'nil' 10) #(20 'true' 14)) 
		do: 
			[:each | 
			(keywordMap at: each first ifAbsentPut: [Dictionary new]) at: (each at: 2) put: each last].
	^keywordMap!

scannerDefinitionComment

	"<name>	:	[a-zA-Z_] \w*	;
<number>:	[0-9]	;
<negative_number>	:	\- <number>	;
<string>	:	\'  [^\']* \' (\' [^\']* \')*	;
<keyword>	:	<name> \:	;
<multikeyword>	:	<name> \: (<name> \: )+	;
<binary_symbol>	:	[\~\-\!!\@\%\&\*\+\=\\\|\?\/\>\<\,] [\~\!!\@\%\&\*\+\=\\\|\?\/\>\<\,]?	;
<whitespace>	:	\s+	;
<comment>	:	\"" [^\""]* \""	;
<dotted_name>	:	<name> (\. <name>)+	;
<character>	:	\$ .	;
<variable_assignment> : <name> \: \=	;

<any_char> : . ; # For VW literal arrays that handle #(;) -> #(#';')"! !
!StScanner class categoriesFor: #frequencyTable!accessing!public! !
!StScanner class categoriesFor: #initializeKeywordMap!generated-initialization!public! !
!StScanner class categoriesFor: #scannerDefinitionComment!generated-comments!public! !

