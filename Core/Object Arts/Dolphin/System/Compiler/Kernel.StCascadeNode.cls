"Filed out from Dolphin Smalltalk 7"!

Kernel.StValueNode subclass: #'Kernel.StCascadeNode'
	instanceVariableNames: 'messages semicolons'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StCascadeNode guid: (Core.GUID fromString: '{b29f06cb-e796-47d8-baf3-b24f873b0474}')!
Kernel.StCascadeNode comment: 'StCascadeNode is a parse tree node for cascaded messages (e.g., "self print1 ; print2").

Instance Variables:
	messages		<SequenceableCollection> of <StMessageNode> the messages 
	semicolons	<SequenceableCollection> of <Integer> positions of the ; between messages

'!
!Kernel.StCascadeNode categoriesForClass!System-Compiler! !
!Kernel.StCascadeNode methodsFor!

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
!Kernel.StCascadeNode categoriesFor: #=!comparing!public! !
!Kernel.StCascadeNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StCascadeNode categoriesFor: #addStatementCommentsTo:!accessing!private! !
!Kernel.StCascadeNode categoriesFor: #bestNodeFor:!public!querying! !
!Kernel.StCascadeNode categoriesFor: #children!accessing!public! !
!Kernel.StCascadeNode categoriesFor: #childrenDo:!accessing!public! !
!Kernel.StCascadeNode categoriesFor: #directlyUses:!public!testing! !
!Kernel.StCascadeNode categoriesFor: #hash!comparing!public! !
!Kernel.StCascadeNode categoriesFor: #isCascade!public!testing! !
!Kernel.StCascadeNode categoriesFor: #messages!accessing!public! !
!Kernel.StCascadeNode categoriesFor: #messages:!accessing!public! !
!Kernel.StCascadeNode categoriesFor: #messages:semicolons:!initializing!public! !
!Kernel.StCascadeNode categoriesFor: #needsParenthesis!public!testing! !
!Kernel.StCascadeNode categoriesFor: #postCopy!copying!public! !
!Kernel.StCascadeNode categoriesFor: #precedence!accessing!public! !
!Kernel.StCascadeNode categoriesFor: #receiver!accessing!public! !
!Kernel.StCascadeNode categoriesFor: #semicolons!accessing!public! !
!Kernel.StCascadeNode categoriesFor: #startWithoutParentheses!accessing!public! !
!Kernel.StCascadeNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!Kernel.StCascadeNode categoriesFor: #uses:!public!testing! !
!Kernel.StCascadeNode categoriesFor: #whichNodeIsContainedBy:!public!querying! !

!Kernel.StCascadeNode class methodsFor!

messages: messageNodes 
	^self new messages: messageNodes!

messages: messageNodes semicolons: integerCollection 
	^self new messages: messageNodes semicolons: integerCollection! !
!Kernel.StCascadeNode class categoriesFor: #messages:!instance creation!public! !
!Kernel.StCascadeNode class categoriesFor: #messages:semicolons:!instance creation!public! !

