"Filed out from Dolphin Smalltalk 7"!

Kernel.ArithmeticExpressionVisitor subclass: #'External.SizeIsExpressionFormatter'
	instanceVariableNames: 'codeStream structClass variable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SizeIsExpressionFormatter guid: (Core.GUID fromString: '{f36862f0-90a8-4da9-be07-e725aae71ae5}')!
External.SizeIsExpressionFormatter comment: 'Simple and very limited formatter for printing arithmetic expressions. Used by ExternalFields for emitting size_is expressions so that the base system does not need to depend on the RBFormatters package.'!
!External.SizeIsExpressionFormatter categoriesForClass!Refactory-ParseTree Matching! !
!External.SizeIsExpressionFormatter methodsFor!

format: anStProgramNode on: aPuttableStream
	codeStream := aPuttableStream.
	self visitNode: anStProgramNode!

structClass: aClass variable: aString
	structClass := aClass.
	variable := aString!

visitLiteralNode: aLiteralNode
	aLiteralNode token formatOn: codeStream source: aLiteralNode source!

visitMessageNode: aMessageNode
	(aMessageNode isCascaded or: [aMessageNode isBinary not])
		ifTrue: [self errorInvalidArithmeticExpression: aMessageNode].
	codeStream nextPut: $(.
	self visitNode: aMessageNode receiver.
	codeStream
		space;
		nextPutAll: aMessageNode selector;
		space.
	self visitNode: aMessageNode arguments first.
	codeStream nextPut: $)!

visitVariableNode: aVariableNode
	| identifier |
	identifier := aVariableNode name.
	(structClass template includesKey: identifier asSymbol)
		ifTrue: 
			[codeStream
				nextPutAll: variable;
				space].
	codeStream nextPutAll: identifier! !
!External.SizeIsExpressionFormatter categoriesFor: #format:on:!public! !
!External.SizeIsExpressionFormatter categoriesFor: #structClass:variable:!initializing!private! !
!External.SizeIsExpressionFormatter categoriesFor: #visitLiteralNode:!public!visitor/double dispatching! !
!External.SizeIsExpressionFormatter categoriesFor: #visitMessageNode:!public!visiting! !
!External.SizeIsExpressionFormatter categoriesFor: #visitVariableNode:!public!visiting! !

!External.SizeIsExpressionFormatter class methodsFor!

structClass: anExternalStructureClass
	^self new structClass: anExternalStructureClass!

structClass: anExternalStructureClass variable: aString
	^self new structClass: anExternalStructureClass variable: aString! !
!External.SizeIsExpressionFormatter class categoriesFor: #structClass:!instance creation!public! !
!External.SizeIsExpressionFormatter class categoriesFor: #structClass:variable:!instance creation!public! !

