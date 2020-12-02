"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StParseNodeVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StParseNodeVisitor categoriesFor: #processBlock:!helpers!private! !
!StParseNodeVisitor categoriesFor: #visitAnnotationNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitArgumentNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitArgumentNodes:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitArrayNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitAssignmentNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitBlockNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitCascadeNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitExternalArgTypeNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitExternalCallNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitLiteralArrayNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitLiteralNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitMessageNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitMethodNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitOptimizedNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitParameterNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitPrimitiveNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitQualifiedReferenceNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitReturnNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitSelfVariableNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitSequenceNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitSpecialVariableNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitStatements:!helpers!private! !
!StParseNodeVisitor categoriesFor: #visitSuperVariableNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitTempDeclNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitTemporaryNodes:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitThisContextVariableNode:!public!visiting! !
!StParseNodeVisitor categoriesFor: #visitVariableNode:!public!visiting! !

!StParseNodeVisitor class methodsFor!

new
	^super new initialize! !
!StParseNodeVisitor class categoriesFor: #new!instance creation!public! !

