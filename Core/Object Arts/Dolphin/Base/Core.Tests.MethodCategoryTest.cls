"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.MethodCategoryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.MethodCategoryTest guid: (Core.GUID fromString: '{d6293ad9-d0bd-4c64-8666-f44cdb20805a}')!
Core.Tests.MethodCategoryTest comment: ''!
!Core.Tests.MethodCategoryTest categoriesForClass!Unclassified! !
!Core.Tests.MethodCategoryTest methodsFor!

testMethodsInBehavior
	| subject testBehavior methods keyMethod |
	subject := 'accessing' asMethodCategory.
	methods := subject methodsInBehavior: Association.
	keyMethod := Association compiledMethodAt: #key.
	self assert: (methods includes: keyMethod).
	testBehavior := Association newAnonymousSubclass.
	testBehavior methodsCatalogue: Association methodsCatalogue copy.
	testBehavior methodDictionary: (MethodDictionary with: #key -> keyMethod).
	methods := subject methodsInBehavior: testBehavior.
	self assert: methods asArray equals: {keyMethod}! !
!Core.Tests.MethodCategoryTest categoriesFor: #testMethodsInBehavior!public! !

