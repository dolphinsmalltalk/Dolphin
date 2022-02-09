"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.RBMethodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RBMethodTest guid: (Core.GUID fromString: '{dcaa75d7-68c0-41bd-9701-dbecb814444c}')!
Refactory.Browser.Tests.RBMethodTest comment: ''!
!Refactory.Browser.Tests.RBMethodTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RBMethodTest methodsFor!

testLiteralStringsDoNotMatchSymbols
	| model class method |
	model := RBModel new.
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	method := class methodFor: #returnInEnsure.
	self deny: (method refersToSymbol: #asdf).
	method := class methodFor: #literalArrayStringsAndSymbols.
	self deny: (method refersToSymbol: #abc)!

testParseTreeEnvironment
	| model class methodWithCustomNamespace methodInClassNamespace |
	model := RBModel new.
	class := model classNamed: 'Refactory.Browser.TestData.RefactoryTestDataApp'.
	methodWithCustomNamespace := class
				methodFor: #refersToDolphinTestPartiallyQualifiedBindingMethodNamespace.
	self assert: methodWithCustomNamespace environment identicalTo: (model classFor: Core).
	methodInClassNamespace := class methodFor: #refersToClassFullyQualified.
	self assert: methodInClassNamespace environment
		identicalTo: (model classFor: Refactory.Browser.TestData).
	"It is important for class renames that move a class between namespaces that the parse trees of methods in the class namespace do not cache the class namespace"
	class name: 'Refactory.Browser.RefactoryTestDataApp'.
	self assert: methodWithCustomNamespace environment identicalTo: (model classFor: Core).
	methodInClassNamespace := class methodFor: #refersToClassFullyQualified.
	self assert: methodInClassNamespace environment identicalTo: class environment.
	self assert: class environment identicalTo: (model classFor: Refactory.Browser)!

testRefersToClassBinding
	| model class targetClass |
	model := RBModel new.
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	targetClass := model classNamed: 'Refactory.Browser.Tests.ClassToRename'.
	#(#refersToClassFullyQualifiedBinding #refersToClassFullyQualifiedBindingInArray #refersToClassUnqualifiedBinding #refersToClassUnqualifiedBindingInArray)
		do: 
			[:each |
			| method |
			method := class methodFor: each.
			self assert: (method refersToClass: targetClass)]!

testRefersToClassBindingFromCustomNamespace
	| model class method |
	model := RBModel new.
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	method := class methodFor: #refersToDolphinTestPartiallyQualifiedBindingMethodNamespace.
	self assert: (method refersToClass: (model classNamed: 'Core.Tests.DolphinTest')).
	class := model classFor: Object class.
	method := class methodFor: #publishedAspectsOfInstances.
	self assert: (method refersToClass: (model classNamed: 'Tools.Aspect'))!

testRefersToClassVariable
	| model class method targetClass |
	model := RBModel new.
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	method := class methodFor: #atIfAbsent.
	self assert: (method refersToClass: (model classNamed: #Smalltalk)).
	targetClass := model classNamed: 'Refactory.Browser.Tests.ClassToRename'.
	#(#refersToClassUnqualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2 #refersToClassFullyQualified)
		do: 
			[:each |
			method := class methodFor: each.
			self assert: (method refersToClass: targetClass)]!

testRefersToSymbol
	| model class method |
	model := RBModel new.
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	method := class methodFor: #searchingLiteral.
	self assert: (method refersToSymbol: #printString).
	self assert: (method refersToSymbol: #abc).
	method := class methodFor: #literalArrayStringsAndSymbols.
	self assert: (method refersToSymbol: #def)! !
!Refactory.Browser.Tests.RBMethodTest categoriesForMethods!
testLiteralStringsDoNotMatchSymbols!public! !
testParseTreeEnvironment!public! !
testRefersToClassBinding!public! !
testRefersToClassBindingFromCustomNamespace!public! !
testRefersToClassVariable!public! !
testRefersToSymbol!public! !
!

