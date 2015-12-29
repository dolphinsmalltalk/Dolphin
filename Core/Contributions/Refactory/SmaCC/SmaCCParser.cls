"Filed out from Dolphin Smalltalk XP"!

Object subclass: #SmaCCParser
	instanceVariableNames: 'scanner currentToken errorToken stateStack nodeStack'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCParser guid: (GUID fromString: '{5035B8B4-AB19-42C3-AA34-F0A0CB24DBD9}')!
SmaCCParser comment: 'SmaCCParser is an abstract class that defines most of the parsing actions. Subclasses will define methods that specify their transitions and reduction actions. These are normally defined automatically when compiling the parser.

Subclasses must implement the following messages:
	accessing
		emptySymbolTokenId
		reduceTable
		transitionTable

Instance Variables:
	currentToken	<SmaCCToken>	the token last returned by the scanner that has not been shifted (reduce actions leave the current token alone)
	nodeStack	<OrderedCollection>	collection of items on stack. These items are specific to the parser and can be any object. 
	scanner	<SmaCCScanner>	our scanner
	stateStack	<OrderedCollection of: Integer>	the stack of states for our parser (standard LR state stack)

'!
!SmaCCParser categoriesForClass!SmaCC Runtime! !
!SmaCCParser methodsFor!

acceptAction
	^0!

actionFor: aSymbolIndex 
	^self actionForState: self currentState and: aSymbolIndex!

actionForCurrentToken
	^self actionFor: currentToken id first!

actionForState: stateIndex and: aSymbolIndex 
	| index row |
	row := self transitionTable at: stateIndex.
	^(row at: 1) == 0 
		ifTrue: 
			[index := self 
						binarySearchIn: row
						for: aSymbolIndex
						size: 2.
			index == 0 
				ifTrue: [^self errorAction]
				ifFalse: [^((row at: 2) bitShift: 8) + (row at: 3)]]
		ifFalse: 
			[index := self 
						binarySearchIn: row
						for: aSymbolIndex
						size: 4.
			index == 0 
				ifTrue: [^self errorAction]
				ifFalse: [^((row at: index - 2) bitShift: 8) + (row at: index - 1)]]!

actionMask
	^2r11!

binarySearchIn: aRow for: aSymbolIndex size: step 
	| start mid length high low midItem stop |
	high := aSymbolIndex bitShift: -8.
	low := aSymbolIndex bitAnd: 16rFF.
	start := 4.
	stop := aRow size - 1.
	length := (stop - start) // step.
	[length > 4] whileTrue: 
			[length := length bitShift: -1.
			mid := length * step + start.
			midItem := aRow at: mid.
			((midItem == high and: [(aRow at: mid + 1) <= low]) or: [midItem < high]) 
				ifTrue: [start := mid]
				ifFalse: [stop := mid]].
	[start <= stop] whileTrue: 
			[((aRow at: start) == high and: [(aRow at: start + 1) == low]) 
				ifTrue: [^start].
			start := start + step].
	^0!

checkForErrors
	"If we have an error correction installed, we might have handled the errors. If we did, we don't 
	want to return the result, so we raise a final exception that can't be proceeded."

	errorToken isNil ifTrue: [^self].
	currentToken := errorToken.
	self reportErrorMessage: 'Token not expected'!

currentState
	^stateStack last!

dismissErrorToken
	currentToken := nil.
	self getNextToken!

dismissStackTopForErrorRecovery
	stateStack removeLast.
	^nodeStack removeLast!

emptySymbolTokenId
	^scanner emptySymbolTokenId!

errorAction
	^3!

errorHandlerStates
	^stateStack collect: 
			[:each | 
			| action |
			action := self actionForState: each and: self errorTokenId.
			(action bitAnd: self actionMask) = 1 
				ifTrue: [action bitShift: -2]
				ifFalse: [0]]!

errorTable
	^#()!

errorTokenId
	^scanner errorTokenId!

findErrorHandlerIfNoneUseErrorNumber: anInteger
	| handlerStates index startingErrorToken newStack |
	handlerStates := self errorHandlerStates reverse.
	startingErrorToken := currentToken.
	
	[index := (1 to: handlerStates size) detect: 
					[:each | 
					| state |
					state := handlerStates at: each.
					state ~= 0 and: 
							[newStack := stateStack copyFrom: 1 to: handlerStates size - each + 1.
							newStack add: state.
							self willShift: newStack]]
				ifNone: [nil].
	index isNil] 
			whileTrue: 
				[self dismissErrorToken.
				self isEOFToken 
					ifTrue: 
						[currentToken := startingErrorToken.
						self reportError: anInteger]].
	index - 1 timesRepeat: [self dismissStackTopForErrorRecovery].
	stateStack addLast: (handlerStates at: index).
	nodeStack addLast: startingErrorToken!

getNextToken
	currentToken isNil ifTrue: [currentToken := scanner next]!

handleError: anInteger
	errorToken isNil ifTrue: [errorToken := currentToken].
	(self isEOFToken or: [self hasErrorHandler not]) ifTrue: [self reportError: anInteger].
	self findErrorHandlerIfNoneUseErrorNumber: anInteger!

hasErrorHandler
	^self errorHandlerStates anySatisfy: [:each | each ~~ 0]!

initialize
	nodeStack := OrderedCollection new!

isEOFToken
	^currentToken id first = self emptySymbolTokenId!

liftFirstValue: aCollection 
	^aCollection first!

liftLastValue: aCollection 
	^aCollection last!

liftSecondValue: aCollection 
	^aCollection at: 2!

parse
	self setDefaultStartingStateIfNone.
	self performParsingLoop.
	^nodeStack last!

performParsingLoop
	| action actionType |
	
	[self getNextToken.
	action := self actionForCurrentToken.
	action = self acceptAction] 
			whileFalse: 
				[actionType := action bitAnd: self actionMask.
				action := action bitShift: -2.
				actionType == self shiftAction 
					ifTrue: [self shift: action]
					ifFalse: 
						[actionType == self reduceAction 
							ifTrue: [self reduce: action]
							ifFalse: [self handleError: action]]].
	self checkForErrors!

performReduceMethod: aSymbol with: items 
	^aSymbol last == $: 
		ifTrue: [self perform: aSymbol with: items]
		ifFalse: [self perform: aSymbol]!

position
	^currentToken isNil 
		ifTrue: [scanner position]
		ifFalse: [currentToken startPosition]!

reduce: anInteger 
	| reduceEntry items size |
	reduceEntry := self reduceTable at: anInteger.
	items := OrderedCollection new: (size := reduceEntry at: 2).
	size timesRepeat: 
			[items addFirst: nodeStack removeLast.
			stateStack removeLast].
	nodeStack add: (self performReduceMethod: (reduceEntry at: 3) with: items).
	stateStack add: ((self actionFor: (reduceEntry at: 1)) bitShift: -2)!

reduceAction
	^2r10!

reduceFor: aCollection 
	| newCollection item |
	(aCollection allSatisfy: [:each | each class ~~ OrderedCollection]) 
		ifTrue: [^aCollection].
	aCollection first class == OrderedCollection 
		ifTrue: 
			[newCollection := aCollection first.
			2 to: aCollection size
				do: 
					[:i | 
					item := aCollection at: i.
					item class = OrderedCollection 
						ifTrue: [newCollection addAll: item]
						ifFalse: [newCollection add: item]].
			^newCollection].
	newCollection := OrderedCollection new.
	aCollection do: 
			[:each | 
			each class == OrderedCollection 
				ifTrue: [newCollection addAll: each]
				ifFalse: [newCollection add: each]].
	^newCollection!

reduceTable
	^self subclassResponsibility!

reportError: anInteger 
	self reportErrorMessage: (anInteger = 0 
				ifTrue: ['Token not expected']
				ifFalse: [self errorTable at: anInteger])!

reportErrorMessage: aString
	SmaCCParserError signal: aString with: self!

scanner: aScanner 
	scanner := aScanner!

setDefaultStartingStateIfNone
	stateStack isNil 
		ifTrue: [self setStartingState: self class defaultStartingState]!

setStartingState: startingState 
	stateStack := OrderedCollection with: startingState!

shift: stateIndex 
	stateStack add: stateIndex.
	nodeStack add: currentToken.
	currentToken := nil!

shiftAction
	^2r01!

transitionTable
	^self subclassResponsibility!

willShift: potentialStateStack 
	| action compoundAction reduceEntry size |
	compoundAction := self actionForState: potentialStateStack last
				and: currentToken id first.
	action := compoundAction bitAnd: self actionMask.
	action == self shiftAction ifTrue: [^true].
	action == self reduceAction 
		ifTrue: 
			[reduceEntry := self reduceTable at: (compoundAction bitShift: -2).
			size := reduceEntry at: 2.
			size timesRepeat: [potentialStateStack removeLast].
			potentialStateStack 
				add: ((self actionForState: potentialStateStack last
						and: (reduceEntry at: 1)) bitShift: -2).
			^self willShift: potentialStateStack].
	^false! !
!SmaCCParser categoriesFor: #acceptAction!private! !
!SmaCCParser categoriesFor: #actionFor:!private! !
!SmaCCParser categoriesFor: #actionForCurrentToken!private! !
!SmaCCParser categoriesFor: #actionForState:and:!private! !
!SmaCCParser categoriesFor: #actionMask!private! !
!SmaCCParser categoriesFor: #binarySearchIn:for:size:!private! !
!SmaCCParser categoriesFor: #checkForErrors!private-error handling!public! !
!SmaCCParser categoriesFor: #currentState!private! !
!SmaCCParser categoriesFor: #dismissErrorToken!private-error handling!public! !
!SmaCCParser categoriesFor: #dismissStackTopForErrorRecovery!private-error handling!public! !
!SmaCCParser categoriesFor: #emptySymbolTokenId!accessing!public! !
!SmaCCParser categoriesFor: #errorAction!private! !
!SmaCCParser categoriesFor: #errorHandlerStates!private-error handling!public! !
!SmaCCParser categoriesFor: #errorTable!accessing!public! !
!SmaCCParser categoriesFor: #errorTokenId!accessing!public! !
!SmaCCParser categoriesFor: #findErrorHandlerIfNoneUseErrorNumber:!private! !
!SmaCCParser categoriesFor: #getNextToken!private! !
!SmaCCParser categoriesFor: #handleError:!private-error handling!public! !
!SmaCCParser categoriesFor: #hasErrorHandler!private-error handling!public! !
!SmaCCParser categoriesFor: #initialize!initialize-release!public! !
!SmaCCParser categoriesFor: #isEOFToken!public!testing! !
!SmaCCParser categoriesFor: #liftFirstValue:!private! !
!SmaCCParser categoriesFor: #liftLastValue:!private! !
!SmaCCParser categoriesFor: #liftSecondValue:!private! !
!SmaCCParser categoriesFor: #parse!accessing!public! !
!SmaCCParser categoriesFor: #performParsingLoop!private! !
!SmaCCParser categoriesFor: #performReduceMethod:with:!private! !
!SmaCCParser categoriesFor: #position!accessing!public! !
!SmaCCParser categoriesFor: #reduce:!private! !
!SmaCCParser categoriesFor: #reduceAction!private! !
!SmaCCParser categoriesFor: #reduceFor:!private! !
!SmaCCParser categoriesFor: #reduceTable!accessing!public! !
!SmaCCParser categoriesFor: #reportError:!private-error handling!public! !
!SmaCCParser categoriesFor: #reportErrorMessage:!private-error handling!public! !
!SmaCCParser categoriesFor: #scanner:!initialize-release!public! !
!SmaCCParser categoriesFor: #setDefaultStartingStateIfNone!private! !
!SmaCCParser categoriesFor: #setStartingState:!initialize-release!public! !
!SmaCCParser categoriesFor: #shift:!private! !
!SmaCCParser categoriesFor: #shiftAction!private! !
!SmaCCParser categoriesFor: #transitionTable!accessing!public! !
!SmaCCParser categoriesFor: #willShift:!private-error handling!public! !

!SmaCCParser class methodsFor!

defaultStartingState
	^1!

new
	^(super new)
		initialize;
		yourself!

on: aStream 
	| parser scanner |
	scanner := self scannerClass on: aStream.
	parser := self new.
	parser scanner: scanner.
	^parser!

parse: aString 
	^self parse: aString startingAt: self defaultStartingState!

parse: aString onError: aBlock
	^[self parse: aString] on: SmaCCParserError
		do: [:ex | ex return: (aBlock value: ex description value: ex tag position)]!

parse: aString startingAt: anInteger 
	^self parseStream: (ReadStream on: aString) startingAt: anInteger!

parse: aString startingAt: anInteger onError: aBlock
	^[self parse: aString startingAt: anInteger] on: SmaCCParserError
		do: [:ex | ex return: (aBlock value: ex description value: ex tag position)]!

parseStream: aStream 
	^self parseStream: aStream startingAt: self defaultStartingState!

parseStream: aStream onError: aBlock
	^[self parseStream: aStream] on: SmaCCParserError
		do: [:ex | ex return: (aBlock value: ex description value: ex tag position)]!

parseStream: aStream startingAt: anInteger 
	| parser |
	parser := self on: aStream.
	parser setStartingState: anInteger.
	^parser parse!

parseStream: aStream startingAt: anInteger onError: aBlock
	^[self parseStream: aStream startingAt: anInteger] on: SmaCCParserError
		do: [:ex | ex return: (aBlock value: ex description value: ex tag position)]!

scannerClass
	^self subclassResponsibility! !
!SmaCCParser class categoriesFor: #defaultStartingState!private! !
!SmaCCParser class categoriesFor: #new!instance creation!public! !
!SmaCCParser class categoriesFor: #on:!instance creation!public! !
!SmaCCParser class categoriesFor: #parse:!accessing!public! !
!SmaCCParser class categoriesFor: #parse:onError:!accessing!public! !
!SmaCCParser class categoriesFor: #parse:startingAt:!accessing!public! !
!SmaCCParser class categoriesFor: #parse:startingAt:onError:!accessing!public! !
!SmaCCParser class categoriesFor: #parseStream:!accessing!public! !
!SmaCCParser class categoriesFor: #parseStream:onError:!accessing!public! !
!SmaCCParser class categoriesFor: #parseStream:startingAt:!accessing!public! !
!SmaCCParser class categoriesFor: #parseStream:startingAt:onError:!accessing!public! !
!SmaCCParser class categoriesFor: #scannerClass!private! !

