"Filed out from Dolphin Smalltalk XP"!

SmaCCRegularExpressionNode subclass: #SmaCCOrRENode
	instanceVariableNames: 'nodes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCOrRENode guid: (GUID fromString: '{18ABFA1B-9770-4F36-AD71-25CD2C0E1493}')!
SmaCCOrRENode comment: 'SmaCCOrRENode is a SmaCCRegularExpressionNode that represents an alternative.

Instance Variables:
	nodes	<Collection of: SmaCCRegularExpressionNode>	our possible choices'!
!SmaCCOrRENode categoriesForClass!SmaCC Runtime! !
!SmaCCOrRENode methodsFor!

| aScannerNode 
	self action = aScannerNode action ifFalse: [^super | aScannerNode].
	nodes add: aScannerNode.
	^self!

asNFAStartingWith: startNode 
	| endNode |
	endNode := SmaCCNode new.
	endNode action: action.
	nodes do: 
			[:each | 
			| componentStart |
			componentStart := SmaCCNode new.
			startNode addEdgeTo: componentStart.
			(each asNFAStartingWith: componentStart) addEdgeTo: endNode].
	^endNode!

nodes: aCollection 
	nodes := aCollection!

possibleMatchesDo: aBlock on: aStream 
	nodes do: 
			[:each | 
			| pos |
			pos := aStream position.
			each possibleMatchesDo: aBlock on: aStream.
			aStream position: pos]!

possibleMatchesSize
	^nodes inject: 0 into: [:sum :each | sum + each possibleMatchesSize]!

postCopy
	super postCopy.
	nodes := nodes copy.
	^self!

printOn: aStream 
	aStream nextPut: $(.
	nodes do: [:each | each printOn: aStream]
		separatedBy: [aStream nextPutAll: ' | '].
	aStream nextPut: $)! !
!SmaCCOrRENode categoriesFor: #|!accessing!public! !
!SmaCCOrRENode categoriesFor: #asNFAStartingWith:!private! !
!SmaCCOrRENode categoriesFor: #nodes:!initialize-release!public! !
!SmaCCOrRENode categoriesFor: #possibleMatchesDo:on:!private! !
!SmaCCOrRENode categoriesFor: #possibleMatchesSize!accessing!public! !
!SmaCCOrRENode categoriesFor: #postCopy!copying!public! !
!SmaCCOrRENode categoriesFor: #printOn:!printing!public! !

!SmaCCOrRENode class methodsFor!

nodes: aCollection 
	^(self new)
		nodes: aCollection;
		yourself! !
!SmaCCOrRENode class categoriesFor: #nodes:!instance creation!public! !

