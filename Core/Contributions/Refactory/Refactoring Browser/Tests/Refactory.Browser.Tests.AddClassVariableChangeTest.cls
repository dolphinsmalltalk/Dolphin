"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.AddClassVariableChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddClassVariableChangeTest guid: (Core.GUID fromString: '{39121a9d-614d-4604-bae6-f73a67daff4b}')!
Refactory.Browser.Tests.AddClassVariableChangeTest comment: ''!
!Refactory.Browser.Tests.AddClassVariableChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddClassVariableChangeTest methodsFor!

subjectClass
	^AddClassVariableChange!

testAsUndo
	| subject undo |
	subject := AddClassVariableChange add: 'Foo' to: TransformationRuleTestData.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: self undoClass.
	self assert: undo variable identicalTo: subject variable.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject |
	subject := self subjectClass add: 'Foo' to: TransformationRuleTestData.
	self assert: subject beforeText equals: TransformationRuleTestData definition.
	self assert: subject afterText
		equals: 'Refactory.Browser.TestData.FooLintRuleTestData subclass: #''Refactory.Browser.TestData.TransformationRuleTestData''
	instanceVariableNames: ''rewriteRule builder class''
	classVariableNames: ''Foo RecursiveSelfRule''
	imports: #()
	classInstanceVariableNames: ''''
	classConstants: {
		''Bar'' -> 16r7B
	}'.
	self assert: subject changeString
		equals: 'Add class variable named, Foo, to Refactory.Browser.TestData.TransformationRuleTestData'.
	self assert: subject printString
		equals: 'Refactory.Browser.TestData.TransformationRuleTestData addClassVarNamed: ''Foo''!!'!

undoClass
	^RemoveClassVariableChange! !
!Refactory.Browser.Tests.AddClassVariableChangeTest categoriesForMethods!
subjectClass!constants!private! !
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
undoClass!constants!private! !
!

