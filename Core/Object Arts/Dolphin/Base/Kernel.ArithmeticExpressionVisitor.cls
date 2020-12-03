"Filed out from Dolphin Smalltalk 7"!

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

visitArgumentNode: anStParameterNode
	^self errorInvalidArithmeticExpression: anStParameterNode!

visitAssignmentNode: anStAssignmentNode
	^self errorInvalidArithmeticExpression: anStAssignmentNode!

visitCascadeNode: aCascadeNode
	^self errorInvalidArithmeticExpression: aCascadeNode!

visitExternalArgTypeNode: anAssignmentNode
	^self errorInvalidArithmeticExpression: anAssignmentNode!

visitExternalCallNode: anStExternalCallNode
	^self errorInvalidArithmeticExpression: anStExternalCallNode!

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

visitPrimitiveNode: anStPrimitiveNode
	^self errorInvalidArithmeticExpression: self!

visitReturnNode: aReturnNode
	^self errorInvalidArithmeticExpression: aReturnNode!

visitStatements: aNodeCollection
	^self errorInvalidArithmeticExpression: aNodeCollection!

visitVariableNode: aVariableNode
	^self subclassResponsibility! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #errorInvalidArithmeticExpression:!exceptions!private! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitArgumentNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitAssignmentNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitCascadeNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitExternalArgTypeNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitExternalCallNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitLiteralArrayNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitLiteralNode:!public!visitor/double dispatching! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitMessageNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitMethodNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitOptimizedNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitPrimitiveNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitReturnNode:!public!visiting! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitStatements:!helpers!private! !
!Kernel.ArithmeticExpressionVisitor categoriesFor: #visitVariableNode:!public!visiting! !

