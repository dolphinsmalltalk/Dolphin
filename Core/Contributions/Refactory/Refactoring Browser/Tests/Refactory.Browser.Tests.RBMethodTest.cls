"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest
	subclass: #'Refactory.Browser.Tests.RBMethodTest'
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
	self assert: class environment identicalTo: (model classFor: Refactory.Browser).
	"Test a method with a custom namespace from it's package - the main IDE package has Tools as its custom namespace, as it has very many loose methods."
	self assert: ((model classFor: Object) methodFor: #halt) parseTree environment
		identicalTo: (model classFor: Tools)!

testRefersToClassDirectly
	| model class method targetClass |
	model := RBModel new.
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	targetClass := model classNamed: 'Refactory.Browser.Tests.ClassToRename'.
	#(#refersToClassUnqualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2 #refersToClassFullyQualified)
		do: 
			[:each |
			method := class methodFor: each.
			self assert: (method refersToClass: targetClass)].
	self assert: ((class methodFor: #atIfAbsent) refersToClass: (model classNamed: #Smalltalk))!

testRefersToClassVariable
	| model class method targetVar |
	model := RBModel new.
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	targetVar := class bindingFor: 'ClassVar1'.
	#(#refersToOwnClassVariable #refersToOwnClassVariableUnqualifiedBinding) do: 
			[:each |
			method := class methodFor: each.
			self assert: (method refersToBinding: targetVar)].
	"Class method"
	self assert: ((class metaclass methodFor: #initialize) refersToBinding: targetVar).
	"From another class"
	class := model classNamed: 'Refactory.Browser.Tests.ClassToRename'.
	self assert: ((class methodFor: #refersToClassVariablePartiallyQualified)
				refersToBinding: targetVar)!

testRefersToClassVariableIndirectly
	| model class1 class2 method binding |
	model := RBModel new.
	class1 := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	"ClassToRename refers to a class variable of RefactoryTestDataApp, and therefore refers indirectly to the variable binding for RefactoryTestDataApp itself, and also for its enclosing environments"
	class2 := model classNamed: 'Refactory.Browser.Tests.ClassToRename'.
	method := class2 methodFor: #refersToClassVariablePartiallyQualified.
	binding := class1 binding.
	
	[self assert: (method refersToBinding: binding).
	binding value == model rootNamespace]
			whileFalse: [binding := binding environment binding]!

testRefersToClassVariableOfAnotherClass
	| model class1 class2 method targetVar |
	model := RBModel new.
	class1 := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	class2 := model classNamed: 'Refactory.Browser.Tests.ClassToRename'.
	targetVar := class2 bindingFor: 'ClassVar1'.
	#(#refersToClassVariableFullyQualified #refersToClassVariablePartiallyQualified #refersToClassVariablePartiallyQualifiedBinding)
		do: 
			[:each |
			method := class1 methodFor: each.
			self assert: (method refersToBinding: targetVar)].
	self deny: ((class1 methodFor: #refersToOwnClassVariable) refersToBinding: targetVar)!

testRefersToClassViaBindingReference
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

testRefersToClassViaBindingReferenceFromMethodNamespace
	| model class method |
	model := RBModel new.
	class := model classNamed: #'Refactory.Browser.TestData.RefactoryTestDataApp'.
	method := class methodFor: #refersToDolphinTestPartiallyQualifiedBindingMethodNamespace.
	self assert: (method refersToClass: (model classNamed: 'Core.Tests.DolphinTest')).
	class := model classFor: Object class.
	method := class methodFor: #publishedAspectsOfInstances.
	self assert: (method refersToClass: (model classNamed: 'Tools.Aspect'))!

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
testRefersToClassDirectly!public! !
testRefersToClassVariable!public! !
testRefersToClassVariableIndirectly!public! !
testRefersToClassVariableOfAnotherClass!public! !
testRefersToClassViaBindingReference!public! !
testRefersToClassViaBindingReferenceFromMethodNamespace!public! !
testRefersToSymbol!public! !
!

