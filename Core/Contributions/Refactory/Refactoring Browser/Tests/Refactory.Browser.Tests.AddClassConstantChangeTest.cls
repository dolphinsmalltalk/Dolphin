"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.AddClassConstantChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddClassConstantChangeTest guid: (Core.GUID fromString: '{085e07b5-392d-431a-8fab-4cd76377f244}')!
Refactory.Browser.Tests.AddClassConstantChangeTest comment: ''!
!Refactory.Browser.Tests.AddClassConstantChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddClassConstantChangeTest methodsFor!

subjectClass
	^AddClassConstantChange!

testAsUndo
	| subject undo |
	subject := AddClassConstantChange add: 'Foo' -> 'Bar' to: TransformationRuleTestData.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: self undoClass.
	self assert: undo variable identicalTo: subject variable.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject |
	subject := self subjectClass add: 'Foo' -> 'Bar' to: TransformationRuleTestData.
	self assert: subject beforeText equals: TransformationRuleTestData definition.
	self assert: subject afterText
		equals: 'Refactory.Browser.TestData.FooLintRuleTestData subclass: #''Refactory.Browser.TestData.TransformationRuleTestData''
	instanceVariableNames: ''rewriteRule builder class''
	classVariableNames: ''RecursiveSelfRule''
	imports: #()
	classInstanceVariableNames: ''''
	classConstants: {
		''Bar'' -> 16r7B.
		''Foo'' -> ''Bar''
	}'.
	self assert: subject changeString
		equals: 'Add class constant named, Foo, to Refactory.Browser.TestData.TransformationRuleTestData'.
	self assert: subject printString
		equals: 'Refactory.Browser.TestData.TransformationRuleTestData addClassConstant: ''Foo'' -> ''Bar''!!'!

undoClass
	^RemoveClassConstantChange! !
!Refactory.Browser.Tests.AddClassConstantChangeTest categoriesForMethods!
subjectClass!constants!private! !
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
undoClass!constants!private! !
!

