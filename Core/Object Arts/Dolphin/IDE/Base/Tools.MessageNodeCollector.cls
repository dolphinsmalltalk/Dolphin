"Filed out from Dolphin Smalltalk"!

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
!Tools.MessageNodeCollector categoriesForMethods!
initialize!initializing!private! !
messages!accessing!public! !
visitMessageNode:!public!visitor/double dispatching! !
!

!Tools.MessageNodeCollector class methodsFor!

messagesSentBy: aStProgramNode
	^self new
		visitNode: aStProgramNode;
		messages! !
!Tools.MessageNodeCollector class categoriesForMethods!
messagesSentBy:!enquiries!public! !
!

