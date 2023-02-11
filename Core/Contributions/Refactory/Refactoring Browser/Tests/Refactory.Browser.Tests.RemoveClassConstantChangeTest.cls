"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest
	subclass: #'Refactory.Browser.Tests.RemoveClassConstantChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveClassConstantChangeTest guid: (Core.GUID fromString: '{54e95b33-15df-4faf-955d-94ca3ede3ab9}')!
Refactory.Browser.Tests.RemoveClassConstantChangeTest comment: ''!
!Refactory.Browser.Tests.RemoveClassConstantChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveClassConstantChangeTest methodsFor!

subjectClass
	^RemoveClassConstantChange!

testAsUndo
	| subject undo |
	subject := self subjectClass remove: (TransformationRuleTestData bindingFor: 'Bar')
				from: TransformationRuleTestData.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: self undoClass.
	self assert: undo variable identicalTo: subject variable.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject |
	subject := self subjectClass remove: (TransformationRuleTestData bindingFor: 'Bar')
				from: TransformationRuleTestData.
	self assert: subject beforeText equals: TransformationRuleTestData definition.
	self assert: subject afterText
		equals: 'Refactory.Browser.TestData.FooLintRuleTestData
	subclass: #''Refactory.Browser.TestData.TransformationRuleTestData''
	instanceVariableNames: ''rewriteRule builder class''
	classVariableNames: ''RecursiveSelfRule''
	imports: #()
	classInstanceVariableNames: ''''
	classConstants: {}'.
	self assert: subject changeString
		equals: 'Remove class constant named, Bar, from Refactory.Browser.TestData.TransformationRuleTestData'.
	self assert: subject printString
		equals: 'Refactory.Browser.TestData.TransformationRuleTestData removeClassConstant: ''Bar'' -> 123!!'!

undoClass
	^AddClassConstantChange! !
!Refactory.Browser.Tests.RemoveClassConstantChangeTest categoriesForMethods!
subjectClass!constants!private! !
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
undoClass!constants!private! !
!

