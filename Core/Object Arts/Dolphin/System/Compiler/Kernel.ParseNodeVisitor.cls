"Filed out from Dolphin Smalltalk 7"!

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

visitExternalArgTypeNode: anStExternalArgTypeNode
	"Dolphin specific extension"

	!

visitExternalCallNode: anStExternalCallNode
	"Dolphin specific extension"

	self visitNode: anStExternalCallNode returnType.
	anStExternalCallNode argumentTypes do: [:each | self visitNode: each]!

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

visitQualifiedReferenceNode: aQualifiedReferenceNode
	^aQualifiedReferenceNode!

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
!Kernel.ParseNodeVisitor categoriesFor: #processBlock:!helpers!private! !
!Kernel.ParseNodeVisitor categoriesFor: #visitAnnotationNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitArgumentNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitArgumentNodes:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitArrayNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitAssignmentNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitBlockNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitCascadeNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitExternalArgTypeNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitExternalCallNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitLiteralArrayNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitLiteralNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitMessageNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitMethodNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitOptimizedNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitParameterNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitPrimitiveNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitQualifiedReferenceNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitReturnNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitSelfVariableNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitSequenceNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitSpecialVariableNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitStatements:!helpers!private! !
!Kernel.ParseNodeVisitor categoriesFor: #visitSuperVariableNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitTempDeclNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitTemporaryNodes:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitThisContextVariableNode:!public!visiting! !
!Kernel.ParseNodeVisitor categoriesFor: #visitVariableNode:!public!visiting! !

!Kernel.ParseNodeVisitor class methodsFor!

new
	^super new initialize! !
!Kernel.ParseNodeVisitor class categoriesFor: #new!instance creation!public! !

