"Filed out from Dolphin Smalltalk"!

StValueNode subclass: #StCascadeNode
	instanceVariableNames: 'messages semicolons'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StCascadeNode guid: (GUID fromString: '{b29f06cb-e796-47d8-baf3-b24f873b0474}')!

StCascadeNode comment: 'StCascadeNode is a parse tree node for cascaded messages (e.g., "self print1 ; print2").

Instance Variables:
	messages		<SequenceableCollection> of <StMessageNode> the messages 
	semicolons	<SequenceableCollection> of <Integer> positions of the ; between messages

'!

!StCascadeNode categoriesForClass!System-Compiler! !

!StCascadeNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	self messages size = anObject messages size ifFalse: [^false].
	1 to: self messages size
		do: [:i | (self messages at: i) = (anObject messages at: i) ifFalse: [^false]].
	^true!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitCascadeNode: self!

addStatementCommentsTo: anOrderedCollection
	comments ifNotNil: [anOrderedCollection addAllLast: comments].
	messages first receiver addStatementCommentsTo: anOrderedCollection.
	messages do: [:each | each arguments do: [:arg | arg addStatementCommentsTo: anOrderedCollection]]!

bestNodeFor: anInterval 
	| selectedChildren |
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval) ifTrue: [^self].
	messages 
		reverseDo: [:each | (each containedBy: anInterval) ifTrue: [^each]].
	selectedChildren := (messages 
				collect: [:each | each bestNodeFor: anInterval]) 
					reject: [:each | each isNil].
	^selectedChildren detect: [:each | true] ifNone: [nil]!

children
	^self messages!

childrenDo: aMonadicValuable 
	self messages do: aMonadicValuable!

directlyUses: aNode 
	^messages last = aNode and: [self isDirectlyUsed]!

hash
	^self messages hash!

isCascade
	^true!

messages
	^messages!

messages: messageNodeCollection 
	messages := messageNodeCollection.
	messages do: [:each | each parent: self]!

messages: messageNodes semicolons: integerCollection 
	self messages: messageNodes.
	semicolons := integerCollection!

needsParenthesis
	^parent isNil 
		ifTrue: [false]
		ifFalse: [self precedence > parent precedence]!

postCopy
	super postCopy.
	self messages: (messages collect: [:each | each copy]).
	^self!

precedence
	^4!

receiver
	^self messages first receiver!

semicolons
	^semicolons!

startWithoutParentheses
	^messages first start!

stopWithoutParentheses
	^messages last stop!

uses: aNode 
	^messages last = aNode and: [self isUsed]!

whichNodeIsContainedBy: anInterval 
	| selectedChildren |
	(self intersectsInterval: anInterval) ifFalse: [^nil].
	(self containedBy: anInterval) ifTrue: [^self].
	messages 
		reverseDo: [:each | (each containedBy: anInterval) ifTrue: [^each]].
	selectedChildren := (messages 
				collect: [:each | each whichNodeIsContainedBy: anInterval]) 
					reject: [:each | each isNil].
	^selectedChildren detect: [:each | true] ifNone: [nil]! !

!StCascadeNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
addStatementCommentsTo:!accessing!private! !
bestNodeFor:!public!querying! !
children!accessing!public! !
childrenDo:!accessing!public! !
directlyUses:!public!testing! !
hash!comparing!public! !
isCascade!public!testing! !
messages!accessing!public! !
messages:!accessing!public! !
messages:semicolons:!initializing!public! !
needsParenthesis!public!testing! !
postCopy!copying!public! !
precedence!accessing!public! !
receiver!accessing!public! !
semicolons!accessing!public! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
uses:!public!testing! !
whichNodeIsContainedBy:!public!querying! !
!

!StCascadeNode class methodsFor!

messages: messageNodes 
	^self new messages: messageNodes!

messages: messageNodes semicolons: integerCollection 
	^self new messages: messageNodes semicolons: integerCollection! !

!StCascadeNode class categoriesForMethods!
messages:!instance creation!public! !
messages:semicolons:!instance creation!public! !
!

