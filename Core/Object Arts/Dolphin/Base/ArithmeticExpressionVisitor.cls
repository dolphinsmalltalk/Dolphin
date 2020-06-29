"Filed out from Dolphin Smalltalk 7"!

StParseNodeVisitor subclass: #ArithmeticExpressionVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArithmeticExpressionVisitor guid: (GUID fromString: '{aef2d77a-820d-495f-9347-bffdde83a15d}')!
ArithmeticExpressionVisitor isAbstract: true!
ArithmeticExpressionVisitor comment: ''!
!ArithmeticExpressionVisitor categoriesForClass!Refactory-ParseTree Matching! !
!ArithmeticExpressionVisitor methodsFor!

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
!ArithmeticExpressionVisitor categoriesFor: #errorInvalidArithmeticExpression:!exceptions!private! !
!ArithmeticExpressionVisitor categoriesFor: #visitArgumentNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitAssignmentNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitCascadeNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitExternalArgTypeNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitExternalCallNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitLiteralArrayNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitLiteralNode:!public!visitor/double dispatching! !
!ArithmeticExpressionVisitor categoriesFor: #visitMessageNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitMethodNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitOptimizedNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitPrimitiveNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitReturnNode:!public!visiting! !
!ArithmeticExpressionVisitor categoriesFor: #visitStatements:!helpers!private! !
!ArithmeticExpressionVisitor categoriesFor: #visitVariableNode:!public!visiting! !

