"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.MoveMethodRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.MoveMethodRefactoringTest guid: (Core.GUID fromString: '{7313b46f-a4cc-4401-8345-57823fb459af}')!

Refactory.Browser.Tests.MoveMethodRefactoringTest comment: ''!

!Refactory.Browser.Tests.MoveMethodRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.MoveMethodRefactoringTest methodsFor!

testMoveMethodIntoArgument
	| refactoring class classVar |
	refactoring := MoveMethodRefactoring
				selector: #checkMethod:
				class: TransformationRuleTestData
				variable: 'aSmalllintContext'.
	class := refactoring model classFor: TransformationRuleTestData.
	classVar := class bindingFor: 'RecursiveSelfRule'.
	classVar isPrivate: true.
	self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
	self setupVariableTypesFor: refactoring
		toReturn: { refactoring model classNamed: #'Refactory.Browser.SmalllintContext' }.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	refactoring setOption: #abstractVariables
		toUse: 
			[:abstractVars |
			self assert: abstractVars instVarReaders asSortedArray equals: #('builder' 'class' 'rewriteRule').
			self assert: abstractVars instVarWriters asSortedArray equals: #('class').
			self assert: abstractVars privateClassVarReaders single equals: classVar.
			self assert: abstractVars privateClassVarWriters isEmpty.
			true].
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (self parseMethod: 'checkMethod: aSmalllintContext aSmalllintContext foo: self').
	self
		assert: ((refactoring model classNamed: #'Refactory.Browser.SmalllintContext') parseTreeFor: #foo:)
		equals: (self
				parseMethod: 'foo: transformationRule
	transformationRule class: self selectedClass.
	(transformationRule rewriteRule executeTree: self parseTree) ifTrue: 
			[(transformationRule class recursiveSelfRule executeTree: transformationRule rewriteRule tree initialAnswer: false)
				ifFalse: 
					[transformationRule builder compile: transformationRule rewriteRule tree printString
						in: transformationRule class1
						categories: self protocols]]').
	self assert: (class parseTreeFor: #class1) equals: (self parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:)
		equals: (self parseMethod: 'class: anObject class := anObject').
	self assert: (class metaclass parseTreeFor: #recursiveSelfRule:)
		equals: (self parseMethod: 'recursiveSelfRule: anObject RecursiveSelfRule := anObject').
	self assert: (class metaclass parseTreeFor: #recursiveSelfRule)
		equals: (self parseMethod: 'recursiveSelfRule ^RecursiveSelfRule').
	self assert: (class parseTreeFor: #builder) equals: (self parseMethod: 'builder ^builder').
	self assert: (class parseTreeFor: #builder:)
		equals: (self parseMethod: 'builder: anObject builder := anObject').
	self assert: (class parseTreeFor: #rewriteRule)
		equals: (self parseMethod: 'rewriteRule ^rewriteRule').
	self assert: (class parseTreeFor: #rewriteRule:)
		equals: (self parseMethod: 'rewriteRule: anObject rewriteRule := anObject')!

testMoveMethodIntoClassVariable
	| refactoring class |
	refactoring := MoveMethodRefactoring
				selector: #checkMethod:
				class: TransformationRuleTestData
				variable: 'RecursiveSelfRule'.
	self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
	self setupVariableTypesFor: refactoring
		toReturn: {refactoring model classNamed: #'Refactory.Browser.ParseTreeSearcher'}.
	self
		setupMethodNameFor: refactoring
		toReturn: #foo:foo:
		withArguments: #('transformationRule' 'aSmalllintContext').
	refactoring setOption: #abstractVariables toUse: [true].
	self executeRefactoring: refactoring.
	class := refactoring model classFor: TransformationRuleTestData.
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (self
				parseMethod: 'checkMethod: aSmalllintContext RecursiveSelfRule foo: self foo: aSmalllintContext').
	self assert: ((refactoring model classNamed: #'Refactory.Browser.ParseTreeSearcher')
				parseTreeFor: #foo:foo:)
		equals: (self
				parseMethod: 'foo: transformationRule foo: aSmalllintContext
	transformationRule class: aSmalllintContext selectedClass.
	(transformationRule rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
			[(self executeTree: transformationRule rewriteRule tree initialAnswer: false)
				ifFalse: 
					[transformationRule builder compile: transformationRule rewriteRule tree printString
						in: transformationRule class1
						categories: aSmalllintContext protocols]]').
	self assert: (class parseTreeFor: #class1) equals: (self parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:)
		equals: (self parseMethod: 'class: anObject class := anObject').
	self assert: (class parseTreeFor: #builder) equals: (self parseMethod: 'builder ^builder').
	self assert: (class parseTreeFor: #builder:)
		equals: (self parseMethod: 'builder: anObject builder := anObject').
	self assert: (class parseTreeFor: #rewriteRule)
		equals: (self parseMethod: 'rewriteRule ^rewriteRule').
	self assert: (class parseTreeFor: #rewriteRule:)
		equals: (self parseMethod: 'rewriteRule: anObject rewriteRule := anObject')!

testMoveMethodIntoInstanceVariable
	| refactoring class |
	refactoring := MoveMethodRefactoring
				selector: #checkMethod:
				class: TransformationRuleTestData
				variable: 'rewriteRule'.
	self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
	self setupVariableTypesFor: refactoring
		toReturn: { refactoring model classNamed: #'Refactory.Browser.ParseTreeRewriter' }.
	self
		setupMethodNameFor: refactoring
		toReturn: #foo:foo:
		withArguments: #('transformationRule' 'aSmalllintContext').
	refactoring setOption: #abstractVariables
		toUse: 
			[:abstractVars |
			self assert: abstractVars instVarReaders asSortedArray equals: #('builder' 'class').
			self assert: abstractVars instVarWriters asSortedArray equals: #('class').
			self assert: abstractVars privateClassVarReaders isEmpty.
			self assert: abstractVars privateClassVarWriters isEmpty.
			true].
	self executeRefactoring: refactoring.
	class := refactoring model classFor: TransformationRuleTestData.
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (self
				parseMethod: 'checkMethod: aSmalllintContext rewriteRule foo: self foo: aSmalllintContext').
	self assert: ((refactoring model classNamed: #'Refactory.Browser.ParseTreeRewriter')
				parseTreeFor: #foo:foo:)
		equals: (self
				parseMethod: 'foo: transformationRule foo: aSmalllintContext
	transformationRule class: aSmalllintContext selectedClass.
	(self executeTree: aSmalllintContext parseTree) ifTrue: 
			[(TestData.TransformationRuleTestData.RecursiveSelfRule executeTree: self tree initialAnswer: false)
				ifFalse: 
					[transformationRule builder compile: self tree printString
						in: transformationRule class1
						categories: aSmalllintContext protocols]]').
	self assert: (class parseTreeFor: #class1) equals: (self parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:)
		equals: (self parseMethod: 'class: anObject class := anObject').
	self deny: (class metaclass includesSelector: #recursiveSelfRule).
	self deny: (class metaclass includesSelector: #recursiveSelfRule:).
	self assert: (class parseTreeFor: #builder) equals: (self parseMethod: 'builder ^builder').
	self assert: (class parseTreeFor: #builder:)
		equals: (self parseMethod: 'builder: anObject builder := anObject')!

testMoveMethodThatReferencesPoolDictionary
	| refactoring class refactoringTestDataClass |
	refactoring := MoveMethodRefactoring
				selector: #junk
				class: LintRuleTestData
				variable: 'RefactoryTestDataApp'.
	self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
	refactoringTestDataClass := refactoring model metaclassNamed: RefactoryTestDataApp fullName.
	self setupVariableTypesFor: refactoring toReturn: {refactoringTestDataClass}.
	self setupMethodNameFor: refactoring toReturn: #junk1.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: LintRuleTestData fullName.
	self assert: (class parseTreeFor: #junk)
		equals: (self parseMethod: 'junk ^RefactoryTestDataApp junk1').
	self
		assert: ((refactoring model metaclassNamed: RefactoryTestDataApp fullName) parseTreeFor: #junk1)
		equals: (self parseMethod: 'junk1
	^self printString copyFrom: 1 to: _EM_INVALID').
	self assert: (class directlyImportsNamespace: #{OS.CRTConstants})!

testMovePrimitiveMethod
	| refactoring |
	(model classNamed: #'Core.Object') compile: 'foo <primitive: 100> ^#() primitiveFailed'
		classified: #accessing.
	refactoring := MoveMethodRefactoring
				model: model
				selector: #foo
				class: Object
				variable: 'OrderedCollection'.
	self shouldFail: refactoring withMessage: 'Cannot move primitive methods'! !

!Refactory.Browser.Tests.MoveMethodRefactoringTest categoriesForMethods!
testMoveMethodIntoArgument!public!tests! !
testMoveMethodIntoClassVariable!public!tests! !
testMoveMethodIntoInstanceVariable!public!tests! !
testMoveMethodThatReferencesPoolDictionary!public!tests! !
testMovePrimitiveMethod!failure tests!public! !
!

