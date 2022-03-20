"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.RemoveClassVariableChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveClassVariableChangeTest guid: (Core.GUID fromString: '{96ec70f7-1051-442b-a194-8cfa49095e81}')!
Refactory.Browser.Tests.RemoveClassVariableChangeTest comment: ''!
!Refactory.Browser.Tests.RemoveClassVariableChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveClassVariableChangeTest methodsFor!

testAsUndo
	| subject undo |
	subject := RemoveClassVariableChange remove: 'RecursiveSelfRule' from: TransformationRuleTestData.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: AddClassVariableChange.
	self assert: undo variable identicalTo: subject variable.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject |
	subject := RemoveClassVariableChange remove: 'RecursiveSelfRule'
				from: TransformationRuleTestData.
	self assert: subject beforeText equals: TransformationRuleTestData definition.
	self assert: subject afterText
		equals: 'Refactory.Browser.TestData.FooLintRuleTestData subclass: #''Refactory.Browser.TestData.TransformationRuleTestData''
	instanceVariableNames: ''rewriteRule builder class''
	classVariableNames: ''''
	imports: #()
	classInstanceVariableNames: ''''
	classConstants: {
		''Bar'' -> 16r7B
	}'.
	self assert: subject changeString
		equals: 'Remove class variable named, RecursiveSelfRule, from Refactory.Browser.TestData.TransformationRuleTestData'.
	self assert: subject printString
		equals: 'Refactory.Browser.TestData.TransformationRuleTestData removeClassVarName: ''RecursiveSelfRule''!!'! !
!Refactory.Browser.Tests.RemoveClassVariableChangeTest categoriesForMethods!
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
!

