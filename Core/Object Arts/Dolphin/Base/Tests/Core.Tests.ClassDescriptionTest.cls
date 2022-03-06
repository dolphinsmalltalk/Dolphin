"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Core.Tests.ClassDescriptionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ClassDescriptionTest guid: (Core.GUID fromString: '{2e47ba8b-6e05-41a9-87ce-ccfeabd45cb7}')!
Core.Tests.ClassDescriptionTest isNonInstantiable: true!
Core.Tests.ClassDescriptionTest comment: ''!
!Core.Tests.ClassDescriptionTest categoriesForClass!Unclassified! !
!Core.Tests.ClassDescriptionTest methodsFor!

allClassHierarchyInstancesDo: aMonadicValuable
	self subclassResponsibility!

canonicalInstance
	^ClassDescriptionTest!

testClassBindingNames
	self subclassResponsibility!

testInstVarName
	Smalltalk allClasses do: 
			[:each |
			| expected actual |
			expected := each allInstanceVariableNames.
			actual := (1 to: expected size) collect: [:i | each instVarName: i].
			self assert: actual equals: expected]!

testIsLiteral
	self deny: self canonicalInstance isLiteral!

testIsSelfEvaluating
	self assert: self canonicalInstance isSelfEvaluating!

testLessOrEqual
	self subclassResponsibility!

testLocalEnvironment
	self assert: self canonicalInstance localEnvironment equals: Tests!

testLocalScope
	self assert: self canonicalInstance localScope equals: Core.Tests.ClassDescriptionTest!

testStoreOn
	self assert: self canonicalInstance storeString equals: self canonicalInstance fullName!

testSubclasses
	self allClassHierarchyInstancesDo: 
			[:each |
			each subclasses do: [:subclass | self assert: subclass superclass identicalTo: each].
			self assert: each subclasses equals: each subclasses distinct]!

testWhichClassDefinesClassVar
	self assert: (self canonicalInstance whichClassDefinesClassVar: '_AssertionFailureSignal')
		identicalTo: Object! !
!Core.Tests.ClassDescriptionTest categoriesForMethods!
allClassHierarchyInstancesDo:!helpers!private! !
canonicalInstance!constants!public! !
testClassBindingNames!public! !
testInstVarName!public!unit tests! !
testIsLiteral!public! !
testIsSelfEvaluating!public! !
testLessOrEqual!public!unit tests! !
testLocalEnvironment!public!unit tests! !
testLocalScope!public!unit tests! !
testStoreOn!public!unit tests! !
testSubclasses!public!unit tests! !
testWhichClassDefinesClassVar!public!unit tests! !
!

