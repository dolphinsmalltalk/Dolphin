"Filed out from Dolphin Smalltalk"!

Kernel.ParseNodeVisitor subclass: #'Kernel.ArithmeticExpressionVisitor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ArithmeticExpressionVisitor guid: (Core.GUID fromString: '{aef2d77a-820d-495f-9347-bffdde83a15d}')!
Kernel.ArithmeticExpressionVisitor isNonInstantiable: true!
Kernel.ArithmeticExpressionVisitor comment: ''!
!Kernel.ArithmeticExpressionVisitor categoriesForClass!Refactory-ParseTree Matching! !
!Kernel.ArithmeticExpressionVisitor methodsFor!

errorInvalidArithmeticExpression: aStProgramNode
	^self error: 'Unexpected node type in expression: ' , aStProgramNode printString!

visitArgumentNode: aStParameterNode
	^self errorInvalidArithmeticExpression: aStParameterNode!

visitAssignmentNode: aStAssignmentNode
	^self errorInvalidArithmeticExpression: aStAssignmentNode!

visitCascadeNode: aCascadeNode
	^self errorInvalidArithmeticExpression: aCascadeNode!

visitExternalArgTypeNode: anAssignmentNode
	^self errorInvalidArithmeticExpression: anAssignmentNode!

visitExternalCallNode: aStExternalCallNode
	^self errorInvalidArithmeticExpression: aStExternalCallNode!

visitLiteralArrayNode: aLiteralArrayNode
	^self errorInvalidArithmeticExpression: aLiteralArrayNode!

visitLiteralNode: aLiteralNode
	^self subclassResponsibility!

visitMessageNode: aMessageNode
	^self subclassResponsibility!

visitMethodNode: aMethodNode
	^self errorInvalidArithmeticExpression: aMethodNode!

visitOptimizedNode: anOptimizedNode
	^self errorInvalidArithmeticExpression: anOptimizedNode!

visitPrimitiveNode: aStPrimitiveNode
	^self errorInvalidArithmeticExpression: self!

visitReturnNode: aReturnNode
	^self errorInvalidArithmeticExpression: aReturnNode!

visitSequenceNode: aSequenceNode
	^self errorInvalidArithmeticExpression: aSequenceNode!

visitVariableNode: aVariableNode
	^self subclassResponsibility! !
!Kernel.ArithmeticExpressionVisitor categoriesForMethods!
errorInvalidArithmeticExpression:!exceptions!private! !
visitArgumentNode:!public!visiting! !
visitAssignmentNode:!public!visiting! !
visitCascadeNode:!public!visiting! !
visitExternalArgTypeNode:!public!visiting! !
visitExternalCallNode:!public!visiting! !
visitLiteralArrayNode:!public!visiting! !
visitLiteralNode:!public!visitor/double dispatching! !
visitMessageNode:!public!visiting! !
visitMethodNode:!public!visiting! !
visitOptimizedNode:!public!visiting! !
visitPrimitiveNode:!public!visiting! !
visitReturnNode:!public!visiting! !
visitSequenceNode:!public!visiting! !
visitVariableNode:!public!visiting! !
!

