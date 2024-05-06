"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #MoveMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MoveMethodTest guid: (GUID fromString: '{7313b46f-a4cc-4401-8345-57823fb459af}')!

MoveMethodTest comment: ''!

!MoveMethodTest categoriesForClass!Refactory-Testing! !

!MoveMethodTest methodsFor!

testMoveMethodIntoArgument
	| refactoring class |
	self proceedThroughWarning: 
			[refactoring := MoveMethodRefactoring
						selector: #checkMethod:
						class: TransformationRuleTest
						variable: 'aSmalllintContext'.
			self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
			self setupVariableTypesFor: refactoring
				toReturn: (Array with: (refactoring model classNamed: #SmalllintContext)).
			self setupMethodNameFor: refactoring toReturn: #foo:.
			self executeRefactoring: refactoring].
	class := refactoring model classNamed: #TransformationRuleTest.
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (RBParser parseMethod: 'checkMethod: aSmalllintContext aSmalllintContext foo: self').
	self assert: ((refactoring model classNamed: #SmalllintContext) parseTreeFor: #foo:)
		equals: (RBParser
				parseMethod: 'foo: transformationRule
	transformationRule class: self selectedClass.
	(transformationRule rewriteRule executeTree: self parseTree) ifTrue: 
			[(transformationRule class recursiveSelfRule executeTree: transformationRule rewriteRule tree initialAnswer: false)
				ifFalse: 
					[transformationRule builder compile: transformationRule rewriteRule tree printString
						in: transformationRule class1
						classified: self protocols]]').
	self assert: (class parseTreeFor: #class1) equals: (RBParser parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:)
		equals: (RBParser parseMethod: 'class: anObject class := anObject').
	self assert: (class metaclass parseTreeFor: #recursiveSelfRule:)
		equals: (RBParser parseMethod: 'recursiveSelfRule: anObject RecursiveSelfRule := anObject').
	self assert: (class metaclass parseTreeFor: #recursiveSelfRule)
		equals: (RBParser parseMethod: 'recursiveSelfRule ^RecursiveSelfRule').
	self assert: (class parseTreeFor: #builder) equals: (RBParser parseMethod: 'builder ^builder').
	self assert: (class parseTreeFor: #builder:)
		equals: (RBParser parseMethod: 'builder: anObject builder := anObject').
	self assert: (class parseTreeFor: #rewriteRule)
		equals: (RBParser parseMethod: 'rewriteRule ^rewriteRule').
	self assert: (class parseTreeFor: #rewriteRule:)
		equals: (RBParser parseMethod: 'rewriteRule: anObject rewriteRule := anObject')!

testMoveMethodIntoClassVariable
	| refactoring class |
	self proceedThroughWarning: 
			[refactoring := MoveMethodRefactoring
						selector: #checkMethod:
						class: TransformationRuleTest
						variable: 'RecursiveSelfRule'.
			self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
			self setupVariableTypesFor: refactoring
				toReturn: (Array with: (refactoring model classNamed: #ParseTreeSearcher)).
			self
				setupMethodNameFor: refactoring
				toReturn: #foo:foo:
				withArguments: #('transformationRule' 'aSmalllintContext').
			self executeRefactoring: refactoring].
	class := refactoring model classNamed: #TransformationRuleTest.
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (RBParser
				parseMethod: 'checkMethod: aSmalllintContext RecursiveSelfRule foo: self foo: aSmalllintContext').
	self assert: ((refactoring model classNamed: #ParseTreeSearcher) parseTreeFor: #foo:foo:)
		equals: (RBParser
				parseMethod: 'foo: transformationRule foo: aSmalllintContext
	transformationRule class: aSmalllintContext selectedClass.
	(transformationRule rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
			[(self executeTree: transformationRule rewriteRule tree initialAnswer: false)
				ifFalse: 
					[transformationRule builder compile: transformationRule rewriteRule tree printString
						in: transformationRule class1
						classified: aSmalllintContext protocols]]').
	self assert: (class parseTreeFor: #class1) equals: (RBParser parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:)
		equals: (RBParser parseMethod: 'class: anObject class := anObject').
	self assert: (class parseTreeFor: #builder) equals: (RBParser parseMethod: 'builder ^builder').
	self assert: (class parseTreeFor: #builder:)
		equals: (RBParser parseMethod: 'builder: anObject builder := anObject').
	self assert: (class parseTreeFor: #rewriteRule)
		equals: (RBParser parseMethod: 'rewriteRule ^rewriteRule').
	self assert: (class parseTreeFor: #rewriteRule:)
		equals: (RBParser parseMethod: 'rewriteRule: anObject rewriteRule := anObject')!

testMoveMethodIntoInstanceVariable
	| refactoring class |
	self proceedThroughWarning: 
			[refactoring := MoveMethodRefactoring
						selector: #checkMethod:
						class: TransformationRuleTest
						variable: 'rewriteRule'.
			self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
			self setupVariableTypesFor: refactoring
				toReturn: (Array with: (refactoring model classNamed: #ParseTreeRewriter)).
			self
				setupMethodNameFor: refactoring
				toReturn: #foo:foo:
				withArguments: #('transformationRule' 'aSmalllintContext').
			self executeRefactoring: refactoring].
	class := refactoring model classNamed: #TransformationRuleTest.
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (RBParser
				parseMethod: 'checkMethod: aSmalllintContext rewriteRule foo: self foo: aSmalllintContext').
	self assert: ((refactoring model classNamed: #ParseTreeRewriter) parseTreeFor: #foo:foo:)
		equals: (RBParser
				parseMethod: 'foo: transformationRule foo: aSmalllintContext
	transformationRule class: aSmalllintContext selectedClass.
	(self executeTree: aSmalllintContext parseTree) ifTrue: 
			[(transformationRule class recursiveSelfRule executeTree: self tree initialAnswer: false)
				ifFalse: 
					[transformationRule builder compile: self tree printString
						in: transformationRule class1
						classified: aSmalllintContext protocols]]').
	self assert: (class parseTreeFor: #class1) equals: (RBParser parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:)
		equals: (RBParser parseMethod: 'class: anObject class := anObject').
	self assert: (class metaclass parseTreeFor: #recursiveSelfRule:)
		equals: (RBParser parseMethod: 'recursiveSelfRule: anObject RecursiveSelfRule := anObject').
	self assert: (class metaclass parseTreeFor: #recursiveSelfRule)
		equals: (RBParser parseMethod: 'recursiveSelfRule ^RecursiveSelfRule').
	self assert: (class parseTreeFor: #builder) equals: (RBParser parseMethod: 'builder ^builder').
	self assert: (class parseTreeFor: #builder:)
		equals: (RBParser parseMethod: 'builder: anObject builder := anObject')!

testMoveMethodThatReferencesPoolDictionary
	| refactoring class |
	self proceedThroughWarning: 
			[| refactoringTestDataClass |
			refactoring := MoveMethodRefactoring
						selector: #junk
						class: LintRuleTest
						variable: 'RefactoryTestDataApp'.
			self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
			refactoringTestDataClass := refactoring model metaclassNamed: #RefactoryTestDataApp.
			self setupVariableTypesFor: refactoring toReturn: (Array with: refactoringTestDataClass).
			self setupMethodNameFor: refactoring toReturn: #junk1.
			self executeRefactoring: refactoring].
	class := refactoring model classNamed: #LintRuleTest.
	self assert: (class parseTreeFor: #junk)
		equals: (RBParser parseMethod: 'junk ^RefactoryTestDataApp junk1').
	self assert: ((refactoring model metaclassNamed: #RefactoryTestDataApp) parseTreeFor: #junk1)
		equals: (RBParser parseMethod: 'junk1
	^self printString copyFrom: 1 to: _EM_INVALID').
	self assert: (class directlyDefinesPoolDictionary: 'CRTConstants' asSymbol)!

testMovePrimitiveMethod
	| refactoring |
	(model classNamed: #Object) 
		compile: 'foo <primitive: 100> ^#() primitiveFailed'
		classified: #(#accessing).
	refactoring := MoveMethodRefactoring 
				model: model
				selector: #foo
				class: Object
				variable: 'OrderedCollection'.
	self shouldFail: refactoring! !

!MoveMethodTest categoriesForMethods!
testMoveMethodIntoArgument!public!tests! !
testMoveMethodIntoClassVariable!public!tests! !
testMoveMethodIntoInstanceVariable!public!tests! !
testMoveMethodThatReferencesPoolDictionary!public!tests! !
testMovePrimitiveMethod!failure tests!public! !
!

