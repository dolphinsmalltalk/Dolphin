"Filed out from Dolphin Smalltalk XP"!

SmaCCRegularExpressionNode subclass: #SmaCCRepeatingRENode
	instanceVariableNames: 'node minimumMatches maximumMatches'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCRepeatingRENode guid: (GUID fromString: '{CB14D12E-2ED2-4A50-8705-FCCBE191ACDA}')!
SmaCCRepeatingRENode comment: 'SmaCCRepeatingRENode represents a repeating node in a regular expression.

Instance Variables:
	maximumMatches	<Integer>	the minimum number of matches required
	minimumMatches	<Integer>	the maximum number of matches allowed. An infinite amount of matches is represented by (SmaCCRepeatingRENode finiteInfinity).
	node	<SmaCCRegularExpressionNode>	what we need to match'!
!SmaCCRepeatingRENode categoriesForClass!SmaCC Runtime! !
!SmaCCRepeatingRENode methodsFor!

asNFAStartingWith: startNode 
	| endNode start |
	endNode := SmaCCNode new.
	endNode action: action.
	start := startNode.
	minimumMatches timesRepeat: [start := node asNFAStartingWith: start].
	start addEdgeTo: endNode.
	maximumMatches < self class finiteInfinity 
		ifTrue: 
			[maximumMatches - minimumMatches timesRepeat: 
					[start := node asNFAStartingWith: start.
					start addEdgeTo: endNode]]
		ifFalse: [(node asNFAStartingWith: start) addEdgeTo: start].
	^endNode!

component: aScannerNode minimum: minInteger maximum: maxInteger 
	node := aScannerNode.
	minimumMatches := minInteger.
	maximumMatches := maxInteger!

possibleMatchesDo: aBlock on: aStream 
	self 
		possibleMatchesDo: aBlock
		on: aStream
		startingAt: 1!

possibleMatchesDo: aBlock on: aStream startingAt: anInteger 
	(anInteger between: minimumMatches and: maximumMatches) 
		ifTrue: [aBlock value].
	anInteger = maximumMatches 
		ifTrue: [node possibleMatchesDo: aBlock on: aStream]
		ifFalse: 
			[node possibleMatchesDo: 
					[self 
						possibleMatchesDo: aBlock
						on: aStream
						startingAt: anInteger + 1]
				on: aStream]!

possibleMatchesSize
	^node possibleMatchesSize * (maximumMatches - minimumMatches + 1)!

printOn: aStream 
	node printOn: aStream.
	maximumMatches = (1 bitShift: 31) 
		ifTrue: 
			[minimumMatches = 0 ifTrue: [^aStream nextPut: $*].
			minimumMatches = 1 ifTrue: [^aStream nextPut: $+].
			^aStream
				nextPut: ${;
				nextPutAll: minimumMatches printString;
				nextPutAll: ',}'].
	aStream
		nextPut: ${;
		nextPutAll: minimumMatches printString;
		nextPut: $,;
		nextPutAll: maximumMatches printString;
		nextPut: $}! !
!SmaCCRepeatingRENode categoriesFor: #asNFAStartingWith:!private! !
!SmaCCRepeatingRENode categoriesFor: #component:minimum:maximum:!initialize-release!public! !
!SmaCCRepeatingRENode categoriesFor: #possibleMatchesDo:on:!private! !
!SmaCCRepeatingRENode categoriesFor: #possibleMatchesDo:on:startingAt:!private! !
!SmaCCRepeatingRENode categoriesFor: #possibleMatchesSize!accessing!public! !
!SmaCCRepeatingRENode categoriesFor: #printOn:!printing!public! !

!SmaCCRepeatingRENode class methodsFor!

component: aScannerNode 
	^self component: aScannerNode minimum: 0!

component: aScannerNode minimum: anInteger 
	^self 
		component: aScannerNode
		minimum: anInteger
		maximum: self finiteInfinity!

component: aScannerNode minimum: minInteger maximum: maxInteger 
	^(self new)
		component: aScannerNode
			minimum: minInteger
			maximum: maxInteger;
		yourself!

finiteInfinity
	"The number that we consider to be 'infinite'"

	^2147483648! !
!SmaCCRepeatingRENode class categoriesFor: #component:!instance creation!public! !
!SmaCCRepeatingRENode class categoriesFor: #component:minimum:!instance creation!public! !
!SmaCCRepeatingRENode class categoriesFor: #component:minimum:maximum:!instance creation!public! !
!SmaCCRepeatingRENode class categoriesFor: #finiteInfinity!constants!public! !

