"Filed out from Dolphin Smalltalk 7"!

Kernel.ParseNodeVisitor subclass: #'Tools.MessageNodeCollector'
	instanceVariableNames: 'messages'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MessageNodeCollector guid: (Core.GUID fromString: '{b98dfe2a-9aa1-44c8-aa19-91e7c68513de}')!
Tools.MessageNodeCollector comment: 'MessageNodeCollector is a <StParseNodeVisitor>s that builds an ordered collection of the StMessageNode (message sends) it encounters while walking  a parse tree. Its purpose is to allow one to enumerate all messages sent by a method.'!
!Tools.MessageNodeCollector categoriesForClass!System-Compiler! !
!Tools.MessageNodeCollector methodsFor!

initialize
	messages := OrderedCollection new!

messages
	^messages!

visitMessageNode: aMessageNode
	messages addLast: aMessageNode.
	super visitMessageNode: aMessageNode! !
!Tools.MessageNodeCollector categoriesFor: #initialize!initializing!private! !
!Tools.MessageNodeCollector categoriesFor: #messages!accessing!public! !
!Tools.MessageNodeCollector categoriesFor: #visitMessageNode:!public!visitor/double dispatching! !

!Tools.MessageNodeCollector class methodsFor!

messagesSentBy: anStProgramNode 
	^(self new)
		visitNode: anStProgramNode;
		messages! !
!Tools.MessageNodeCollector class categoriesFor: #messagesSentBy:!enquiries!public! !

