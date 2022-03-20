"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.RemoveInstanceVariableChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveInstanceVariableChangeTest guid: (Core.GUID fromString: '{8a02a901-c042-4e7d-bcec-d78d6cf5ba0a}')!
Refactory.Browser.Tests.RemoveInstanceVariableChangeTest comment: ''!
!Refactory.Browser.Tests.RemoveInstanceVariableChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveInstanceVariableChangeTest methodsFor!

testAsUndo
	| subject undo |
	subject := RemoveInstanceVariableChange remove: 'class' from: TransformationRuleTestData.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: AddInstanceVariableChange.
	self assert: undo variable identicalTo: subject variable.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject |
	subject := RemoveInstanceVariableChange remove: 'class'
				from: TransformationRuleTestData.
	self assert: subject beforeText equals: TransformationRuleTestData definition.
	self assert: subject afterText
		equals: 'Refactory.Browser.TestData.FooLintRuleTestData subclass: #''Refactory.Browser.TestData.TransformationRuleTestData''
	instanceVariableNames: ''rewriteRule builder''
	classVariableNames: ''RecursiveSelfRule''
	imports: #()
	classInstanceVariableNames: ''''
	classConstants: {
		''Bar'' -> 16r7B
	}'.
	self assert: subject changeString
		equals: 'Remove instance variable named, class, from Refactory.Browser.TestData.TransformationRuleTestData'.
	self assert: subject printString
		equals: 'Refactory.Browser.TestData.TransformationRuleTestData removeInstVarName: ''class''!!'! !
!Refactory.Browser.Tests.RemoveInstanceVariableChangeTest categoriesForMethods!
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
!

