"Filed out from Dolphin Smalltalk 7"!

StParseNodeVisitor subclass: #MessageNodeCollector
	instanceVariableNames: 'messages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MessageNodeCollector guid: (GUID fromString: '{B98DFE2A-9AA1-44C8-AA19-91E7C68513DE}')!
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

