"Filed out from Dolphin Smalltalk"!

ArithmeticExpressionVisitor subclass: #SizeIsExpressionFormatter
	instanceVariableNames: 'codeStream structClass variable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SizeIsExpressionFormatter guid: (GUID fromString: '{f36862f0-90a8-4da9-be07-e725aae71ae5}')!

SizeIsExpressionFormatter comment: 'Simple and very limited formatter for printing arithmetic expressions. Used by ExternalFields for emitting size_is expressions so that the base system does not need to depend on the RBFormatters package.'!

!SizeIsExpressionFormatter categoriesForClass!Refactory-ParseTree Matching! !

!SizeIsExpressionFormatter methodsFor!

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

!SizeIsExpressionFormatter categoriesForMethods!
format:on:!public! !
structClass:variable:!initializing!private! !
visitLiteralNode:!public!visitor/double dispatching! !
visitMessageNode:!public!visiting! !
visitVariableNode:!public!visiting! !
!

!SizeIsExpressionFormatter class methodsFor!

structClass: anExternalStructureClass
	^self new structClass: anExternalStructureClass!

structClass: anExternalStructureClass variable: aString
	^self new structClass: anExternalStructureClass variable: aString! !

!SizeIsExpressionFormatter class categoriesForMethods!
structClass:!instance creation!public! !
structClass:variable:!instance creation!public! !
!

