"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #MethodCategoryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MethodCategoryTest guid: (GUID fromString: '{bf38215d-fed2-4dc6-9f36-92956bc1b19d}')!

MethodCategoryTest comment: ''!

!MethodCategoryTest categoriesForClass!Unclassified! !

!MethodCategoryTest methodsFor!

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

!MethodCategoryTest categoriesForMethods!
testMethodsInBehavior!public! !
!

