"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.ParseNodeVisitor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ParseNodeVisitor guid: (Core.GUID fromString: '{8cf81be6-059c-46da-86e3-b21a6781066b}')!
Kernel.ParseNodeVisitor comment: 'BRProgramNodeVisitor is an abstract visitor for the BRProgramNodes.

'!
!Kernel.ParseNodeVisitor categoriesForClass!Refactory-ParseTree Matching! !
!Kernel.ParseNodeVisitor methodsFor!

processBlock: aBlockNode
	self visitArgumentNodes: aBlockNode arguments.
	self visitNode: aBlockNode body!

visitAnnotationNode: anAnnotationNode
	anAnnotationNode arguments do: [:arg | self visitNode: arg].
	^anAnnotationNode!

visitArgumentNode: aParameterNode
	"Here to allow subclasses to detect arguments or temporaries."

	^self visitVariableNode: aParameterNode!

visitArgumentNodes: aNodeCollection
	^aNodeCollection do: [:each | self visitNode: each]!

visitArrayNode: aBraceArrayNode
	aBraceArrayNode statements do: [:each | self visitNode: each].
	^aBraceArrayNode!

visitAssignmentNode: anAssignmentNode
	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode value.
	^anAssignmentNode!

visitBlockNode: aBlockNode
	self processBlock: aBlockNode.
	^aBlockNode!

visitCascadeNode: aCascadeNode
	aCascadeNode messages do: [:each | self visitNode: each].
	^aCascadeNode!

visitExternalArgTypeNode: anExternalArgTypeNode
	anExternalArgTypeNode structClass ifNotNil: [:structVar | self visitNode: structVar].
	^anExternalArgTypeNode!

visitExternalCallNode: anExternalCallNode
	"Dolphin specific extension"

	self visitNode: anExternalCallNode returnType.
	anExternalCallNode argumentTypes do: [:each | self visitNode: each].
	^anExternalCallNode!

visitLiteralArrayNode: aLiteralArrayNode
	aLiteralArrayNode contents do: [:each | self visitNode: each].
	^aLiteralArrayNode!

visitLiteralByteArrayNode: aLiteralByteArrayNode
	self visitLiteralArrayNode: aLiteralByteArrayNode!

visitLiteralNode: aLiteralNode
	^aLiteralNode
	!

visitMessageNode: aMessageNode
	aMessageNode isFirstSendToReceiver ifTrue: [self visitNode: aMessageNode receiver].
	aMessageNode arguments do: [:each | self visitNode: each].
	^aMessageNode!

visitMethodNode: aMethodNode
	self visitArgumentNodes: aMethodNode arguments.
	aMethodNode tags do: [:each | self visitNode: each].
	self visitNode: aMethodNode body.
	^aMethodNode!

visitNode: aNode 
	^aNode acceptVisitor: self!

visitOptimizedNode: anOptimizedNode
	self visitNode: anOptimizedNode body.
	^anOptimizedNode!

visitParameterNode: aStParameterNode
	^self visitVariableNode: aStParameterNode!

visitPrimitiveNode: aPrimitiveNode
	aPrimitiveNode errorTemp ifNotNil: [:temp | self visitNode: temp].
	^aPrimitiveNode!

visitQualifiedReferenceNode: aQualifiedReferenceNode
	^aQualifiedReferenceNode!

visitReturnNode: aReturnNode
	self visitNode: aReturnNode value.
	^aReturnNode!

visitSelfVariableNode: aSelfVariableNode
	^self visitVariableNode: aSelfVariableNode!

visitSequenceNode: aSequenceNode
	self visitTemporaryNodes: aSequenceNode temporaries.
	aSequenceNode statements do: [:each | self visitNode: each].
	^aSequenceNode!

visitSpecialVariableNode: aSpecialVariableNode
	^self visitVariableNode: aSpecialVariableNode!

visitSuperVariableNode: aSuperVariableNode
	^self visitSpecialVariableNode: aSuperVariableNode!

visitTempDeclNode: aTempDeclNode
	^self visitVariableNode: aTempDeclNode!

visitTemporaryNodes: aNodeCollection
	"Visit temporary declarations in a method or block body"

	^self visitArgumentNodes: aNodeCollection!

visitThisContextVariableNode: aStSelfVariableNode
	^self visitSpecialVariableNode: aStSelfVariableNode!

visitVariableNode: aVariableNode
	^aVariableNode! !
!Kernel.ParseNodeVisitor categoriesForMethods!
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
visitLiteralByteArrayNode:!public!visiting! !
visitLiteralNode:!public!visiting! !
visitMessageNode:!public!visiting! !
visitMethodNode:!public!visiting! !
visitNode:!public!visiting! !
visitOptimizedNode:!public!visiting! !
visitParameterNode:!public!visiting! !
visitPrimitiveNode:!public!visiting! !
visitQualifiedReferenceNode:!public!visiting! !
visitReturnNode:!public!visiting! !
visitSelfVariableNode:!public!visiting! !
visitSequenceNode:!public!visiting! !
visitSpecialVariableNode:!public!visiting! !
visitSuperVariableNode:!public!visiting! !
visitTempDeclNode:!public!visiting! !
visitTemporaryNodes:!public!visiting! !
visitThisContextVariableNode:!public!visiting! !
visitVariableNode:!public!visiting! !
!

Kernel.ParseNodeVisitor methodProtocol: #parseNodeVisitor attributes: #() selectors: #(#visitAnnotationNode: #visitArgumentNode: #visitArrayNode: #visitAssignmentNode: #visitBlockNode: #visitCascadeNode: #visitExternalArgTypeNode: #visitExternalCallNode: #visitLiteralArrayNode: #visitLiteralNode: #visitMessageNode: #visitMethodNode: #visitOptimizedNode: #visitParameterNode: #visitPrimitiveNode: #visitQualifiedReferenceNode: #visitReturnNode: #visitSelfVariableNode: #visitSequenceNode: #visitSpecialVariableNode: #visitSuperVariableNode: #visitTempDeclNode: #visitThisContextVariableNode: #visitVariableNode:)!

!Kernel.ParseNodeVisitor class methodsFor!

new
	^super new initialize! !
!Kernel.ParseNodeVisitor class categoriesForMethods!
new!instance creation!public! !
!

