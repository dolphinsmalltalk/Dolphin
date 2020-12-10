"Filed out from Dolphin Smalltalk 7"!

StParseNodeVisitor subclass: #MessageNodeCollector
	instanceVariableNames: 'messages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MessageNodeCollector guid: (GUID fromString: '{b98dfe2a-9aa1-44c8-aa19-91e7c68513de}')!
MessageNodeCollector comment: 'MessageNodeCollector is a <StParseNodeVisitor>s that builds an ordered collection of the StMessageNode (message sends) it encounters while walking  a parse tree. Its purpose is to allow one to enumerate all messages sent by a method.'!
!MessageNodeCollector categoriesForClass!System-Compiler! !
!MessageNodeCollector methodsFor!

initialize
	messages := OrderedCollection new!

messages
	^messages!

visitMessageNode: aMessageNode
	messages addLast: aMessageNode.
	super visitMessageNode: aMessageNode! !
!MessageNodeCollector categoriesFor: #initialize!initializing!private! !
!MessageNodeCollector categoriesFor: #messages!accessing!public! !
!MessageNodeCollector categoriesFor: #visitMessageNode:!public!visitor/double dispatching! !

!MessageNodeCollector class methodsFor!

messagesSentBy: anStProgramNode 
	^(self new)
		visitNode: anStProgramNode;
		messages! !
!MessageNodeCollector class categoriesFor: #messagesSentBy:!enquiries!public! !

