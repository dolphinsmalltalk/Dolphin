"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Kernel.ParseNodeVisitor'
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

visitAnnotationNode: anStAnnotationNode
	anStAnnotationNode arguments do: [:arg | self visitNode: arg]!

visitArgumentNode: anStParameterNode
	"Here to allow subclasses to detect arguments or temporaries."

	^self visitVariableNode: anStParameterNode!

visitArgumentNodes: aNodeCollection
	^aNodeCollection do: [:each | self visitNode: each]!

visitArrayNode: anStBraceArrayNode
	anStBraceArrayNode statements do: [:each | self visitNode: each]!

visitAssignmentNode: anAssignmentNode
	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode value!

visitBlockNode: aBlockNode
	self processBlock: aBlockNode!

visitCascadeNode: aCascadeNode
	aCascadeNode messages do: [:each | self visitNode: each]!

visitExternalArgTypeNode: anStExternalArgTypeNode
	anStExternalArgTypeNode structClass ifNotNil: [:structVar | self visitNode: structVar]!

visitExternalCallNode: anStExternalCallNode
	"Dolphin specific extension"

	self visitNode: anStExternalCallNode returnType.
	anStExternalCallNode argumentTypes do: [:each | self visitNode: each]!

visitLiteralArrayNode: aLiteralArrayNode
	aLiteralArrayNode contents do: [:each | self visitNode: each]!

visitLiteralByteArrayNode: aLiteralByteArrayNode
	self visitLiteralArrayNode: aLiteralByteArrayNode!

visitLiteralNode: aLiteralNode
	!

visitMessageNode: aMessageNode
	aMessageNode isFirstSendToReceiver ifTrue: [self visitNode: aMessageNode receiver].
	aMessageNode arguments do: [:each | self visitNode: each]!

visitMethodNode: aMethodNode
	self visitArgumentNodes: aMethodNode arguments.
	aMethodNode tags do: [:each | self visitNode: each].
	self visitNode: aMethodNode body!

visitNode: aNode 
	^aNode acceptVisitor: self!

visitOptimizedNode: anOptimizedNode
	self visitNode: anOptimizedNode body!

visitParameterNode: anStParameterNode
	^self visitVariableNode: anStParameterNode!

visitPrimitiveNode: anStPrimitiveNode
	anStPrimitiveNode errorTemp ifNotNil: [:temp | self visitNode: temp]!

visitQualifiedReferenceNode: aQualifiedReferenceNode
	^aQualifiedReferenceNode!

visitReturnNode: aReturnNode
	self visitNode: aReturnNode value!

visitSelfVariableNode: anStSelfVariableNode
	^self visitVariableNode: anStSelfVariableNode!

visitSequenceNode: aSequenceNode
	self visitTemporaryNodes: aSequenceNode temporaries.
	aSequenceNode statements do: [:each | self visitNode: each]!

visitSpecialVariableNode: anStSpecialVariableNode
	^self visitVariableNode: anStSpecialVariableNode!

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

