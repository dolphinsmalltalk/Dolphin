"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Tools.Tests.ParseContextTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ParseContextTest guid: (Core.GUID fromString: '{a63a7d3e-7ec8-4e28-b987-21b4c2c88ae9}')!
Tools.Tests.ParseContextTest comment: ''!
!Tools.Tests.ParseContextTest methodsFor!

testClassParseContext
	| subject var |
	subject := self class parseContext.
	self assert: subject methodClass identicalTo: self class.
	self assert: subject environment identicalTo: Tools.Tests.
	self assert: subject owningPackage identicalTo: self class owningPackage.
	"Unqualified name that is visible in the parse context: Tools.ParseContext"
	var := subject resolveIdentifier: 'ParseContext'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: ParseContext binding.
	"Unqualified name that is not visible in the parse context (OS.CRTLibrary)"
	var := subject resolveIdentifier: 'DolphinTest'.
	self assertIsNil: var.
	"Qualified name"
	var := subject resolveIdentifier: 'Core.Tests.DolphinTest'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: Core.Tests.DolphinTest binding.
	"pseudo vars"
	var := subject resolveIdentifier: 'self'.
	self assert: var isKindOf: StSelfVariable.
	self assert: var valueClass identicalTo: self class.
	var := subject resolveIdentifier: 'super'.
	self assert: var isKindOf: StSuperVariable.
	self assert: var valueClass identicalTo: Core.Tests.DolphinTest.
	#todo.	"Should be able to resolve thisContext always"
	var := subject resolveIdentifier: 'thisContext'.
	false
		ifTrue: 
			[self assert: var isKindOf: StThisContextVariable.
			self assert: var valueClass identicalTo: Integer]
		ifFalse: [self assertIsNil: var]!

testDefaultParseContext
	| subject var |
	subject := SmalltalkSystem current defaultParseContext.
	self assert: subject methodClass identicalTo: UndefinedObject.
	self assert: subject environment identicalTo: Smalltalk.
	self assert: subject owningPackage identicalTo: Smalltalk owningPackage.
	var := subject resolveIdentifier: 'Object'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: Object binding.
	var := subject resolveIdentifier: 'self'.
	self assert: var isKindOf: StSelfVariable.
	self assert: var valueClass identicalTo: UndefinedObject.
	var := subject resolveIdentifier: 'super'.
	self assert: var isKindOf: StSuperVariable.
	self assert: var valueClass identicalTo: Object.
	#todo.	"Should be able to resolve thisContext always"
	var := subject resolveIdentifier: 'thisContext'.
	false
		ifTrue: 
			[self assert: var isKindOf: StThisContextVariable.
			self assert: var valueClass identicalTo: Integer]
		ifFalse: [self assertIsNil: var]!

testLooseMethodParseContext
	| subject var |
	subject := (CompiledMethod >> #searchForInTool:) parseContext.
	self assert: subject methodClass identicalTo: CompiledMethod.
	"Dev Sys has a default environment, so the loose methods are compiled into it, not Kernel"
	self assert: subject environment identicalTo: Tools.
	self assert: subject owningPackage identicalTo: SmalltalkSystem owningPackage.
	"Unqualified name that is visible in the parse context"
	var := subject resolveIdentifier: 'SmalltalkSystem'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: SmalltalkSystem binding.
	"Unqualified name that is not visible in the parse context"
	var := subject resolveIdentifier: 'CRTLibrary'.
	self assertIsNil: var.
	"Qualified name"
	var := subject resolveIdentifier: 'OS.CRTLibrary'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: OS.CRTLibrary binding.
	"Instance variable"
	var := subject resolveIdentifier: 'selector'.
	self assert: var isKindOf: StInstanceVariable.
	"Type is unknown"
	self assert: var valueClass identicalTo: nil.
	"Pseudo'"
	var := subject resolveIdentifier: 'self'.
	self assert: var isKindOf: StSelfVariable.
	self assert: var valueClass identicalTo: CompiledMethod.
	var := subject resolveIdentifier: 'super'.
	self assert: var isKindOf: StSuperVariable.
	self assert: var valueClass identicalTo: CompiledCode.

	#todo.	"Should be able to resolve thisContext always"
	var := subject resolveIdentifier: 'thisContext'.
	false
		ifTrue: 
			[self assert: var isKindOf: StThisContextVariable.
			self assert: var valueClass identicalTo: Integer]
		ifFalse: [self assertIsNil: var]!

testLooseRBMethodParseContext
	| model subject var compiledMethod |
	model := Refactory.Browser.RBModel onEnvironment: (Refactory.Browser.BrowserEnvironment new
						forClasses: { CompiledMethod. SmalltalkSystem. CompiledCode. Tools }).
	compiledMethod := model classFor: CompiledMethod.
	subject := (compiledMethod >> #searchForInTool:) parseContext.
	self assert: subject methodClass identicalTo: compiledMethod.
	"Dev Sys has a default environment, so the loose methods are compiled into it, not Kernel"
	self assert: subject environment identicalTo: (model classFor: Tools).
	self assert: subject owningPackage identicalTo: SmalltalkSystem owningPackage.
	var := subject resolveIdentifier: 'SmalltalkSystem'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: (model classFor: SmalltalkSystem) binding.
	var := subject resolveIdentifier: 'self'.
	self assert: var isKindOf: StSelfVariable.
	self assert: var valueClass identicalTo: compiledMethod.
	var := subject resolveIdentifier: 'super'.
	self assert: var isKindOf: StSuperVariable.
	self assert: var valueClass identicalTo: (model classFor: CompiledCode).
	var := subject resolveIdentifier: 'selector'.
	self assert: var isKindOf: StInstanceVariable.
	"Type is unknown"
	self assert: var valueClass identicalTo: nil.

	#todo.	"Should be able to resolve thisContext always"
	var := subject resolveIdentifier: 'thisContext'.
	false
		ifTrue: 
			[self assert: var isKindOf: StThisContextVariable.
			self assert: var valueClass identicalTo: (model classFor: Integer)]
		ifFalse: [self assertIsNil: var]!

testMethodParseContext
	| subject var |
	subject := (CompiledMethod >> #owningPackage) parseContext.
	self assert: subject methodClass identicalTo: CompiledMethod.
	self assert: subject environment identicalTo: Kernel.
	self assert: subject owningPackage identicalTo: Package manager systemPackage.
	"Unqualified name that is visible in the parse context"
	var := subject resolveIdentifier: 'CRTLibrary'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: OS.CRTLibrary binding.
	"Unqualified name that is not visible in the parse context"
	var := subject resolveIdentifier: 'SmalltalkSystem'.
	self assertIsNil: var.
	"Qualified name"
	var := subject resolveIdentifier: 'Tools.SmalltalkSystem'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: Tools.SmalltalkSystem binding.
	"pseudo vars"
	var := subject resolveIdentifier: 'self'.
	self assert: var isKindOf: StSelfVariable.
	self assert: var valueClass identicalTo: CompiledMethod.
	var := subject resolveIdentifier: 'super'.
	self assert: var isKindOf: StSuperVariable.
	self assert: var valueClass identicalTo: CompiledCode.
	#todo.	"Should be able to resolve thisContext always"
	var := subject resolveIdentifier: 'thisContext'.
	false
		ifTrue: 
			[self assert: var isKindOf: StThisContextVariable.
			self assert: var valueClass identicalTo: Integer]
		ifFalse: [self assertIsNil: var]!

testRBClassParseContext
	| model subject var myClass mySuperclass |
	model := Refactory.Browser.RBModel onEnvironment: (Refactory.Browser.BrowserEnvironment new
						forClasses: { self class. self class superclass. self class environment. ParseContext }).
	myClass := model classFor: self class.
	subject := myClass parseContext.
	self assert: subject methodClass identicalTo: myClass.
	self assert: subject environment identicalTo: (model classFor: Tools.Tests).
	self assert: subject owningPackage identicalTo: self class owningPackage.
	"Unqualified name that is visible in the parse context: Tools.ParseContext"
	var := subject resolveIdentifier: 'ParseContext'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: (model fullBindingFor: 'Tools.ParseContext').
	"Unqualified name that is not visible in the parse context (OS.CRTLibrary)"
	var := subject resolveIdentifier: 'DolphinTest'.
	self assertIsNil: var.
	"Qualified name"
	var := subject resolveIdentifier: 'Core.Tests.DolphinTest'.
	self assert: var isKindOf: StStaticVariable.
	mySuperclass := model classNamed: 'Core.Tests.DolphinTest'.
	self assert: var binding identicalTo: mySuperclass binding.
	"pseudo vars"
	var := subject resolveIdentifier: 'self'.
	self assert: var isKindOf: StSelfVariable.
	self assert: var valueClass identicalTo: myClass.
	var := subject resolveIdentifier: 'super'.
	self assert: var isKindOf: StSuperVariable.
	self assert: var valueClass identicalTo: mySuperclass.
	#todo.	"Should be able to resolve thisContext always"
	var := subject resolveIdentifier: 'thisContext'.
	false
		ifTrue: 
			[self assert: var isKindOf: StThisContextVariable.
			self assert: var valueClass identicalTo: (model classFor: Integer)]
		ifFalse: [self assertIsNil: var]!

testRBMethodParseContext
	| model subject var compiledMethod |
	model := Refactory.Browser.RBModel onEnvironment: (Refactory.Browser.BrowserEnvironment new
						forClasses: { CompiledMethod. SmalltalkSystem. CompiledCode. OS.CRTLibrary. OS. Tools. Kernel }).
	compiledMethod := model classFor: CompiledMethod.
	subject := (compiledMethod >> #owningPackage) parseContext.
	self assert: subject methodClass identicalTo: compiledMethod.
	self assert: subject environment identicalTo: (model classFor: Kernel).
	self assert: subject owningPackage identicalTo: Package manager systemPackage.
	"Unqualified name that is visible in the parse context"
	var := subject resolveIdentifier: 'CRTLibrary'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: (model classFor: OS.CRTLibrary) binding.
	"Unqualified name that is not visible in the parse context (OS.CRTLibrary)"
	var := subject resolveIdentifier: 'SmalltalkSystem'.
	self assertIsNil: var.
	"Qualified name"
	var := subject resolveIdentifier: 'Tools.SmalltalkSystem'.
	self assert: var isKindOf: StStaticVariable.
	self assert: var binding identicalTo: (model classFor: Tools.SmalltalkSystem) binding.
	"pseudo vars"
	var := subject resolveIdentifier: 'self'.
	self assert: var isKindOf: StSelfVariable.
	self assert: var valueClass identicalTo: compiledMethod.
	var := subject resolveIdentifier: 'super'.
	self assert: var isKindOf: StSuperVariable.
	self assert: var valueClass identicalTo: (model classFor: CompiledCode).
	#todo.	"Should be able to resolve thisContext always"
	var := subject resolveIdentifier: 'thisContext'.
	false
		ifTrue: 
			[self assert: var isKindOf: StThisContextVariable.
			self assert: var valueClass identicalTo: (model classFor: Integer)]
		ifFalse: [self assertIsNil: var]! !
!Tools.Tests.ParseContextTest categoriesForMethods!
testClassParseContext!public! !
testDefaultParseContext!public! !
testLooseMethodParseContext!public! !
testLooseRBMethodParseContext!public! !
testMethodParseContext!public! !
testRBClassParseContext!public! !
testRBMethodParseContext!public! !
!

