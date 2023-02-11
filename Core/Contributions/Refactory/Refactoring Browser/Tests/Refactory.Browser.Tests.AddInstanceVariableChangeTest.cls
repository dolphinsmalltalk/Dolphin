"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest
	subclass: #'Refactory.Browser.Tests.AddInstanceVariableChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddInstanceVariableChangeTest guid: (Core.GUID fromString: '{d2e15e01-300c-47df-ae75-73ae2ec99802}')!
Refactory.Browser.Tests.AddInstanceVariableChangeTest comment: ''!
!Refactory.Browser.Tests.AddInstanceVariableChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddInstanceVariableChangeTest methodsFor!

subjectClass
	^AddInstanceVariableChange!

testAsUndo
	| subject undo |
	subject := AddInstanceVariableChange add: 'foo' to: TransformationRuleTestData.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: self undoClass.
	self assert: undo variable identicalTo: subject variable.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject |
	subject := self subjectClass add: 'foo' to: TransformationRuleTestData.
	self assert: subject beforeText equals: TransformationRuleTestData definition.
	self assert: subject afterText
		equals: 'Refactory.Browser.TestData.FooLintRuleTestData
	subclass: #''Refactory.Browser.TestData.TransformationRuleTestData''
	instanceVariableNames: ''rewriteRule builder class foo''
	classVariableNames: ''RecursiveSelfRule''
	imports: #()
	classInstanceVariableNames: ''''
	classConstants: { ''Bar'' -> 16r7B }'.
	self assert: subject changeString
		equals: 'Add instance variable named, foo, to Refactory.Browser.TestData.TransformationRuleTestData'.
	self assert: subject printString
		equals: 'Refactory.Browser.TestData.TransformationRuleTestData addInstVarName: ''foo''!!'!

undoClass
	^RemoveInstanceVariableChange! !
!Refactory.Browser.Tests.AddInstanceVariableChangeTest categoriesForMethods!
subjectClass!constants!private! !
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
undoClass!constants!private! !
!

