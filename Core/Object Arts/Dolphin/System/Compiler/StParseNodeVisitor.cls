"Filed out from Dolphin Smalltalk"!

Object subclass: #StParseNodeVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StParseNodeVisitor guid: (GUID fromString: '{8cf81be6-059c-46da-86e3-b21a6781066b}')!
StParseNodeVisitor comment: 'BRProgramNodeVisitor is an abstract visitor for the BRProgramNodes.

'!
!StParseNodeVisitor categoriesForClass!Refactory-ParseTree Matching! !
!StParseNodeVisitor methodsFor!

processBlock: aBlockNode
	self visitArgumentNodes: aBlockNode arguments.
	self visitNode: aBlockNode body!

visitAnnotationNode: anStAnnotationNode!

visitArgumentNode: anStParameterNode
	"Here to allow subclasses to detect arguments or temporaries."

	^self visitVariableNode: anStParameterNode!

visitArgumentNodes: aNodeCollection
	^aNodeCollection do: [:each | self visitArgumentNode: each]!

visitArrayNode: anStBraceArrayNode
	anStBraceArrayNode children do: [:each | self visitNode: each]!

visitAssignmentNode: anAssignmentNode
	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode value!

visitBlockNode: aBlockNode
	self processBlock: aBlockNode!

visitCascadeNode: aCascadeNode
	aCascadeNode messages do: [:each | self visitNode: each]!

visitExternalArgTypeNode: anAssignmentNode
	"Dolphin specific extension"

	!

visitExternalCallNode: anStExternalCallNode
	"Dolphin specific extension"

	!

visitLiteralArrayNode: aLiteralArrayNode
	aLiteralArrayNode contents do: [:each | self visitNode: each]!

visitLiteralNode: aLiteralNode
	!

visitMessageNode: aMessageNode
	(aMessageNode isCascaded not or: [aMessageNode isFirstCascaded])
		ifTrue: [self visitNode: aMessageNode receiver].
	aMessageNode arguments do: [:each | self visitNode: each]!

visitMethodNode: aMethodNode
	self visitArgumentNodes: aMethodNode arguments.
	aMethodNode tag ifNotNil: [:tag | self visitNode: tag].
	self visitNode: aMethodNode body!

visitNode: aNode 
	^aNode acceptVisitor: self!

visitOptimizedNode: anOptimizedNode
	self visitNode: anOptimizedNode body!

visitParameterNode: anStParameterNode
	^self visitVariableNode: anStParameterNode!

visitPrimitiveNode: anStPrimitiveNode
	anStPrimitiveNode errorTemp ifNotNil: [:temp | self visitNode: temp]!

visitReturnNode: aReturnNode
	self visitNode: aReturnNode value!

visitSelfVariableNode: anStSelfVariableNode
	^self visitVariableNode: anStSelfVariableNode!

visitSequenceNode: aSequenceNode
	self visitTemporaryNodes: aSequenceNode temporaries.
	self visitStatements: aSequenceNode statements!

visitSpecialVariableNode: anStSpecialVariableNode
	^self visitVariableNode: anStSpecialVariableNode!

visitStatements: aNodeCollection
	aNodeCollection do: [:each | self visitNode: each]!

visitSuperVariableNode: anStSelfVariableNode
	^self visitSpecialVariableNode: anStSelfVariableNode!

visitTempDeclNode: anStTempDeclNode
	^self visitVariableNode: anStTempDeclNode!

visitTemporaryNodes: aNodeCollection
	"Visit temporary declarations in a method or block body"

	^self visitArgumentNodes: aNodeCollection!

visitThisContextVariableNode: anStSelfVariableNode
	^self visitSpecialVariableNode: anStSelfVariableNode!

visitVariableNode: aVariableNode
	^aVariableNode! !
!StParseNodeVisitor categoriesForMethods!
processBlock:!helpers!private! !
visitAnnotationNode:!public!visiting! !
visitArgumentNode:!public!visiting! !
visitArgumentNodes:!public!visiting! !
visitArrayNode:!public!visiting! !
visitAssignmentNode:!public!visiting! !
visitBlockNode:!public!visiting! !
visitCascadeNode:!public!visiting! !
visitExternalArgTypeNode:!public!visiting! !
visitExternalCallNode:!public!visiting! !
visitLiteralArrayNode:!public!visiting! !
visitLiteralNode:!public!visiting! !
visitMessageNode:!public!visiting! !
visitMethodNode:!public!visiting! !
visitNode:!public!visiting! !
visitOptimizedNode:!public!visiting! !
visitParameterNode:!public!visiting! !
visitPrimitiveNode:!public!visiting! !
visitReturnNode:!public!visiting! !
visitSelfVariableNode:!public!visiting! !
visitSequenceNode:!public!visiting! !
visitSpecialVariableNode:!public!visiting! !
visitStatements:!helpers!private! !
visitSuperVariableNode:!public!visiting! !
visitTempDeclNode:!public!visiting! !
visitTemporaryNodes:!public!visiting! !
visitThisContextVariableNode:!public!visiting! !
visitVariableNode:!public!visiting! !
!

!StParseNodeVisitor class methodsFor!

new
	^super new initialize! !
!StParseNodeVisitor class categoriesForMethods!
new!instance creation!public! !
!

