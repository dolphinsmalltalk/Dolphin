"Filed out from Dolphin Smalltalk XP"!

Object subclass: #SmaCCRegularExpressionNode
	instanceVariableNames: 'action position'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCRegularExpressionNode guid: (GUID fromString: '{F095B1F6-D78C-4273-812D-57A473859C2A}')!
SmaCCRegularExpressionNode comment: 'SmaCCRegularExpressionNode represents a regular expression. The scanner is represented by a regular expression. These are the initial objects created in producing the scanner. From these nodes, we create a directed graph and then we compile the graph.

Subclasses must implement the following messages:
	accessing
		possibleMatchesSize
	private
		asNFAStartingWith:
		possibleMatchesDo:on:

Instance Variables:
	action	<SequenceableCollection>	the actions to be performed when we find a match
	position	<Integer>	the position of the RE in the scanner. If we have multiple matches, we prefer the ones listed first.'!
!SmaCCRegularExpressionNode categoriesForClass!SmaCC Runtime! !
!SmaCCRegularExpressionNode methodsFor!

, aScannerNode 
	^SmaCCSequenceRENode nodes: (OrderedCollection with: self with: aScannerNode)!

| aScannerNode 
	^SmaCCOrRENode nodes: (OrderedCollection with: self with: aScannerNode)!

action
	^action!

action: aString
	action := aString!

asDFA
	| startNode |
	startNode := SmaCCNode new.
	self asNFAStartingWith: startNode.
	^startNode asNFAWithoutEpsilonTransitions asDFA!

asNFAStartingWith: startNode 
	^self subclassResponsibility!

initialize!

isKeywordLiteral
	self possibleMatchesSize < 50 ifFalse: [^false].
	self possibleMatchesDo: 
			[:each | 
			(each allSatisfy: [:char | char isAlphaNumeric or: [char == $_]]) 
				ifFalse: [^false]].
	^true!

position
	^position!

position: anInteger
	position := anInteger!

possibleMatches
	| matches |
	matches := OrderedCollection new.
	self possibleMatchesDo: [:each | matches add: each].
	^matches!

possibleMatchesDo: aBlock 
	| stream |
	stream := WriteStream on: String new.
	self possibleMatchesDo: [aBlock value: stream contents] on: stream!

possibleMatchesDo: aBlock on: aStream 
	self subclassResponsibility!

possibleMatchesSize
	^self subclassResponsibility!

repeat
	^SmaCCRepeatingRENode component: self!

repeatFor: minimum to: maximum 
	^SmaCCRepeatingRENode 
		component: self
		minimum: minimum
		maximum: maximum!

repeatForAtLeast: minimum 
	^SmaCCRepeatingRENode component: self minimum: minimum! !
!SmaCCRegularExpressionNode categoriesFor: #,!accessing!public! !
!SmaCCRegularExpressionNode categoriesFor: #|!accessing!public! !
!SmaCCRegularExpressionNode categoriesFor: #action!initialize-release!public! !
!SmaCCRegularExpressionNode categoriesFor: #action:!initialize-release!public! !
!SmaCCRegularExpressionNode categoriesFor: #asDFA!converting!public! !
!SmaCCRegularExpressionNode categoriesFor: #asNFAStartingWith:!private! !
!SmaCCRegularExpressionNode categoriesFor: #initialize!initialize-release!public! !
!SmaCCRegularExpressionNode categoriesFor: #isKeywordLiteral!public!testing! !
!SmaCCRegularExpressionNode categoriesFor: #position!accessing!public! !
!SmaCCRegularExpressionNode categoriesFor: #position:!accessing!public! !
!SmaCCRegularExpressionNode categoriesFor: #possibleMatches!accessing!public! !
!SmaCCRegularExpressionNode categoriesFor: #possibleMatchesDo:!accessing!public! !
!SmaCCRegularExpressionNode categoriesFor: #possibleMatchesDo:on:!private! !
!SmaCCRegularExpressionNode categoriesFor: #possibleMatchesSize!accessing!public! !
!SmaCCRegularExpressionNode categoriesFor: #repeat!accessing!public! !
!SmaCCRegularExpressionNode categoriesFor: #repeatFor:to:!accessing!public! !
!SmaCCRegularExpressionNode categoriesFor: #repeatForAtLeast:!accessing!public! !

!SmaCCRegularExpressionNode class methodsFor!

new
	^(super new)
		initialize;
		yourself! !
!SmaCCRegularExpressionNode class categoriesFor: #new!instance creation!public! !

