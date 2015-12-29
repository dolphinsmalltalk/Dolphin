"Filed out from Dolphin Smalltalk XP"!

SmaCCRegularExpressionNode subclass: #SmaCCSequenceRENode
	instanceVariableNames: 'nodes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCSequenceRENode guid: (GUID fromString: '{A27894B0-15F2-46B3-ADDE-9EB80D7AE39E}')!
SmaCCSequenceRENode comment: 'SmaCCSequenceRENode represents a regular expression that is made up of several other regular expressions concatenated together.

Instance Variables:
	nodes	<Collection of: SmaCCRegularExpressionNode>	our children nodes in left-to-right order'!
!SmaCCSequenceRENode categoriesForClass!SmaCC Runtime! !
!SmaCCSequenceRENode methodsFor!

, aScannerNode 
	self action = aScannerNode action ifFalse: [^super , aScannerNode].
	nodes add: aScannerNode.
	^self!

asNFAStartingWith: startNode 
	| endNode |
	endNode := SmaCCNode new.
	endNode action: action.
	(nodes inject: startNode into: [:sum :each | each asNFAStartingWith: sum]) 
		addEdgeTo: endNode.
	^endNode!

nodes: aCollection 
	nodes := aCollection!

possibleMatchesDo: aBlock on: aStream 
	self 
		possibleMatchesDo: aBlock
		on: aStream
		startingAt: 1!

possibleMatchesDo: aBlock on: aStream startingAt: anInteger 
	| node |
	node := nodes at: anInteger.
	nodes size = anInteger 
		ifTrue: [node possibleMatchesDo: aBlock on: aStream]
		ifFalse: 
			[node possibleMatchesDo: 
					[self 
						possibleMatchesDo: aBlock
						on: aStream
						startingAt: anInteger + 1]
				on: aStream]!

possibleMatchesSize
	^nodes inject: 1 into: [:sum :each | sum * each possibleMatchesSize]!

postCopy
	super postCopy.
	nodes := nodes copy.
	^self!

printOn: aStream 
	nodes do: [:each | each printOn: aStream] separatedBy: [aStream space]! !
!SmaCCSequenceRENode categoriesFor: #,!accessing!public! !
!SmaCCSequenceRENode categoriesFor: #asNFAStartingWith:!private! !
!SmaCCSequenceRENode categoriesFor: #nodes:!initialize-release!public! !
!SmaCCSequenceRENode categoriesFor: #possibleMatchesDo:on:!private! !
!SmaCCSequenceRENode categoriesFor: #possibleMatchesDo:on:startingAt:!private! !
!SmaCCSequenceRENode categoriesFor: #possibleMatchesSize!accessing!public! !
!SmaCCSequenceRENode categoriesFor: #postCopy!copying!public! !
!SmaCCSequenceRENode categoriesFor: #printOn:!printing!public! !

!SmaCCSequenceRENode class methodsFor!

nodes: aCollection 
	^(self new)
		nodes: aCollection;
		yourself! !
!SmaCCSequenceRENode class categoriesFor: #nodes:!instance creation!public! !

