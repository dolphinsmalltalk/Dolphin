"Filed out from Dolphin Smalltalk X6"!

StParseNodeVisitor subclass: #MessageNodeCollector
	instanceVariableNames: 'messages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MessageNodeCollector guid: (GUID fromString: '{B98DFE2A-9AA1-44C8-AA19-91E7C68513DE}')!
MessageNodeCollector comment: 'MessageNodeCollector is a <StParseNodeVisitor>s that builds an ordered collection of the StMessageNode (message sends) it encounters while walking  a parse tree. Its purpose is to allow one to enumerate all messages sent by a method.'!
!MessageNodeCollector categoriesForClass!System-Compiler! !
!MessageNodeCollector methodsFor!

acceptMessageNode: aMessageNode 
	messages addLast: aMessageNode.
	super acceptMessageNode: aMessageNode!

initialize
	messages := OrderedCollection new!

messages
	^messages! !
!MessageNodeCollector categoriesFor: #acceptMessageNode:!public!visitor/double dispatching! !
!MessageNodeCollector categoriesFor: #initialize!initializing!private! !
!MessageNodeCollector categoriesFor: #messages!accessing!public! !

!MessageNodeCollector class methodsFor!

messagesSentBy: anStProgramNode 
	^(self new)
		visitNode: anStProgramNode;
		messages! !
!MessageNodeCollector class categoriesFor: #messagesSentBy:!enquiries!public! !

