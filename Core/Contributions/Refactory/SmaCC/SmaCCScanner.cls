"Filed out from Dolphin Smalltalk X6"!

Object subclass: #SmaCCScanner
	instanceVariableNames: 'stream start matchActions matchEnd currentCharacter outputStream lastOutputStreamMatchPosition lastMatchWasEmpty returnMatchBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'keywordMap'!
SmaCCScanner guid: (GUID fromString: '{4D3B3483-521C-48C4-9443-1725F23B7726}')!
SmaCCScanner comment: 'SmaCCScanner is an abstract class that represents a scanner for the parser. The scanner converts its string input into SmaCCToken objects that the parser then uses for its parsing.

Subclasses must implement the following messages:
	accessing
		scanForToken

Instance Variables:
	currentCharacter	<Character>	the current character we are scanning
	lastMatchWasEmpty	<Boolean>	was our last scanning match an empty string -- don''t allow two empty matches in a row
	lastOutputStreamMatchPosition	<Integer>	the position in the outputStream of the last match
	matchActions	<Array | Symbol>	the actions for the last match (a symbol means that the action should be performed on the scanner)
	matchEnd	<Integer>	the position of the last match in the stream (our input stream)
	outputStream	<PositionableStream>	the matched characters go in this stream. After a match is made, we take this stream''s contents and create a token object.
	returnMatchBlock	<BlockClosure>	when we match a token evaluate this block with the token (hack to return from multiple levels)
	start	<Integer>	the starting position of a match in the stream
	stream	<Stream>	our input

'!
!SmaCCScanner categoriesForClass!SmaCC Runtime! !
!SmaCCScanner methodsFor!

atEnd
	^stream atEnd!

checkForKeyword: aString 
	| stateMap action |
	action := matchActions isSymbol 
				ifTrue: [matchActions]
				ifFalse: [matchActions first].
	stateMap := self class keywordMap at: action ifAbsent: [nil].
	stateMap isNil ifTrue: [^self].
	matchActions := stateMap at: (self keywordFor: aString)
				ifAbsent: [matchActions].
	matchActions isInteger 
		ifTrue: [matchActions := Array with: matchActions with: action]!

checkForValidMatch
	matchActions isNil ifTrue: [self scannerError]!

comment
	"In case someone wants to record the comments"

	self whitespace!

contents
	| writeStream token |
	writeStream := WriteStream on: Array new.
	[self atEnd] whileFalse: 
			[token := self next.
			token notNil ifTrue: [writeStream nextPut: token]].
	^writeStream contents!

createTokenFor: string 
	| token |
	token := self tokenClass 
				value: string
				start: start
				id: matchActions.
	outputStream reset.
	matchActions := nil.
	returnMatchBlock value: token!

emptySymbolTokenId
	^self subclassResponsibility!

errorTokenId
	^self subclassResponsibility!

initialBufferSize
	^128!

initialize
	outputStream := WriteStream on: (String new: self initialBufferSize).
	lastMatchWasEmpty := true!

keywordFor: aString 
	"Subclasses can override this to ignore case"

	^aString!

lineNumber
	"This requires the stream to be a line number stream (see the #needsLineNumbers class method)."

	^stream lineNumber!

next
	self resetScanner.
	returnMatchBlock := [:match | ^match].
	self scanForToken!

on: aStream 
	stream := aStream.
	start := stream position!

position
	^stream position!

position: anInteger
	^stream position: anInteger!

recordAndReportMatch: aCollection 
	self
		recordMatch: aCollection;
		reportLastMatch!

recordMatch: aCollection 
	matchActions := aCollection.
	matchEnd := stream position.
	lastOutputStreamMatchPosition := outputStream position!

reportLastMatch
	"The scanner has found the end of a token and must report it"

	| string |
	self checkForValidMatch.
	self resetOutputToLastMatch.
	stream position: matchEnd.
	string := outputStream contents.
	self checkForKeyword: string.
	^matchActions isSymbol 
		ifTrue: [self perform: matchActions]
		ifFalse: [self createTokenFor: string]!

resetOutputToLastMatch
	outputStream position: lastOutputStreamMatchPosition.
	lastOutputStreamMatchPosition == 0 
		ifTrue: 
			[lastMatchWasEmpty ifTrue: [self scannerError].
			lastMatchWasEmpty := true]
		ifFalse: [lastMatchWasEmpty := false]!

resetScanner
	start := stream position.
	outputStream reset.
	lastOutputStreamMatchPosition := 0!

scanForToken
	^self subclassResponsibility!

scannerError
	(stream atEnd and: [start == stream position]) 
		ifTrue: 
			[returnMatchBlock value: (self tokenClass 
						value: ''
						start: stream position
						id: (Array with: self emptySymbolTokenId))].
	stream position: start.
	returnMatchBlock value: (self tokenClass 
				value: (String with: stream next)
				start: start
				id: #(0))!

step
	stream atEnd ifTrue: [^self reportLastMatch].
	currentCharacter := stream next.
	outputStream nextPut: currentCharacter!

tokenClass
	^SmaCCToken!

whitespace
	"By default, eat the whitespace"

	self resetScanner.
	self scanForToken! !
!SmaCCScanner categoriesFor: #atEnd!public!testing! !
!SmaCCScanner categoriesFor: #checkForKeyword:!private! !
!SmaCCScanner categoriesFor: #checkForValidMatch!private! !
!SmaCCScanner categoriesFor: #comment!default token handling!public! !
!SmaCCScanner categoriesFor: #contents!accessing!public! !
!SmaCCScanner categoriesFor: #createTokenFor:!private! !
!SmaCCScanner categoriesFor: #emptySymbolTokenId!accessing!public! !
!SmaCCScanner categoriesFor: #errorTokenId!accessing!public! !
!SmaCCScanner categoriesFor: #initialBufferSize!private! !
!SmaCCScanner categoriesFor: #initialize!initialize-release!public! !
!SmaCCScanner categoriesFor: #keywordFor:!private-utility!public! !
!SmaCCScanner categoriesFor: #lineNumber!accessing!public! !
!SmaCCScanner categoriesFor: #next!accessing!public! !
!SmaCCScanner categoriesFor: #on:!initialize-release!public! !
!SmaCCScanner categoriesFor: #position!accessing!public! !
!SmaCCScanner categoriesFor: #position:!accessing!public! !
!SmaCCScanner categoriesFor: #recordAndReportMatch:!private! !
!SmaCCScanner categoriesFor: #recordMatch:!private! !
!SmaCCScanner categoriesFor: #reportLastMatch!private! !
!SmaCCScanner categoriesFor: #resetOutputToLastMatch!private! !
!SmaCCScanner categoriesFor: #resetScanner!private! !
!SmaCCScanner categoriesFor: #scanForToken!accessing!public! !
!SmaCCScanner categoriesFor: #scannerError!private! !
!SmaCCScanner categoriesFor: #step!private! !
!SmaCCScanner categoriesFor: #tokenClass!private! !
!SmaCCScanner categoriesFor: #whitespace!default token handling!public! !

!SmaCCScanner class methodsFor!

initialize
	self initializeKeywordMap!

initializeKeywordMap
	keywordMap := self keywordMapClass new!

keywordMap
	keywordMap isNil ifTrue: [self initializeKeywordMap].
	^keywordMap!

keywordMapClass
	^LookupTable!

needsLineNumbers
	"Redefine to return true, if you need line number information"

	^false!

new
	^(super new)
		initialize;
		yourself!

on: aStream 
	^(self new)
		on: (self needsLineNumbers 
					ifTrue: [SmaCCLineNumberStream on: aStream]
					ifFalse: [aStream]);
		yourself! !
!SmaCCScanner class categoriesFor: #initialize!class initialization!public! !
!SmaCCScanner class categoriesFor: #initializeKeywordMap!class initialization!public! !
!SmaCCScanner class categoriesFor: #keywordMap!accessing!public! !
!SmaCCScanner class categoriesFor: #keywordMapClass!class initialization!public! !
!SmaCCScanner class categoriesFor: #needsLineNumbers!public!testing! !
!SmaCCScanner class categoriesFor: #new!instance creation!public! !
!SmaCCScanner class categoriesFor: #on:!instance creation!public! !

