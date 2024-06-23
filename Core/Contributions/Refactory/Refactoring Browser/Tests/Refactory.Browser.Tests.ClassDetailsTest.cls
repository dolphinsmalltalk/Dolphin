"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest
	subclass: #'Refactory.Browser.Tests.ClassDetailsTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.ClassDetailsTest guid: (Core.GUID fromString: '{64e516b9-5b21-43b7-ae23-d6e32cd674ae}')!

Refactory.Browser.Tests.ClassDetailsTest comment: ''!

!Refactory.Browser.Tests.ClassDetailsTest methodsFor!

testImports
	| subject smalltalkImports |
	subject := ClassDetails new.
	self assert: subject imports equals: #().
	self assert: subject sharedPoolNames equals: #().
	subject := ClassDetails fromClass: Smalltalk.
	smalltalkImports := #(#{Core} #{Kernel} #{Graphics} #{UI} #{OS} #{External} #{Tools private}).
	self assert: subject imports
		equals: (smalltalkImports collect: [:each | each asFullyQualifiedReference]).
	self assert: subject sharedPoolNames equals: (smalltalkImports collect: [:each | each pathString])!

testInstanceSpec
	| subject |
	subject := ClassDetails fromClass: Array.
	self assert: subject isVariable.
	self deny: subject isBytes.
	self deny: subject isNullTerminated.
	self deny: subject isIndirection.
	self assert: subject isPointers.
	self deny: subject isNonInstantiable.
	subject isVariable: false.
	self deny: subject isVariable.
	subject isPointers: false.
	self deny: subject isPointers.
	self assert: subject isBytes.
	subject := ClassDetails fromClass: Utf8String.
	self assert: subject isVariable.
	self assert: subject isBytes.
	self assert: subject isNullTerminated.
	self deny: subject isIndirection.
	self deny: subject isPointers.
	self deny: subject isNonInstantiable.
	subject isNullTerminated: false.
	self deny: subject isNullTerminated.
	subject := ClassDetails fromClass: Namespace.
	self deny: subject isVariable.
	self deny: subject isBytes.
	self deny: subject isNullTerminated.
	self deny: subject isIndirection.
	self assert: subject isPointers.
	self assert: subject isNonInstantiable.
	subject isNonInstantiable: false.
	self deny: subject isNonInstantiable.
	subject := ClassDetails fromClass: External.Address.
	self assert: subject isVariable.
	self assert: subject isBytes.
	self deny: subject isNullTerminated.
	self assert: subject isIndirection.
	self deny: subject isPointers.
	self deny: subject isNonInstantiable.
	subject isIndirection: false.
	self deny: subject isIndirection!

testOnRBClass
	| model class details |
	model := RBModel new.
	class := model classFor: RefactoryTestDataApp.
	details := ClassDetails fromClass: class.
	self assert: details storeString equals: (ClassDetails fromClass: RefactoryTestDataApp) storeString!

testPrintString
	| subject |
	subject := ClassDetails fromClass: self class.
	self assert: subject printString equals: self class definition!

testPrintStringLegacy
	| subject legacyClass |
	legacyClass := #{Smalltalk.Scribble} valueOrNil.
	self skipUnless: [legacyClass notNil].
	subject := ClassDetails fromClass: legacyClass.
	subject classVariableNames: #('FooBar').
	subject classConstants: {'Foo' -> 1. 'Bar' -> 2}.
	self assert: subject printString
		equals: (legacyClass definition copyReplaceAll: 'classVariableNames: '''''
				with: 'classVariableNames: ''Bar Foo FooBar''')!

testPrintStringMissingSuperclass
	| subject |
	subject := ClassDetails fromClass: self class.
	subject superclassName: 'Foo'.
	self assert: subject printString
		equals: (self class definition copyReplaceAll: self class superclass fullName with: 'Foo')!

testPrintStringRootClass
	| subject |
	subject := ClassDetails fromClass: Object.
	self assert: subject printString equals: Object definition!

testPrintStringRootClassLegacy
	| subject |
	subject := ClassDetails fromClass: Smalltalk.Scribble.
	subject superclass: nil.
	self assert: subject printString
		equals: 'nil subclass: #Scribble
	instanceVariableNames: ''newStroke trackingCanvas''
	classVariableNames: ''''
	poolDictionaries: ''''
	classInstanceVariableNames: '''''!

testShortName
	{
		Root.
		Smalltalk.
		Graphics.
		Object.
		ProtoObject.
		self class.
		Smalltalk.Scribble.
		Core.Tests.
		Core.Tests.ClassTest.
		Kernel.Tests.
		Kernel.Tests.VariableBindingTest
	} do: [:each | self assert: (ClassDetails fromClass: each) shortName equals: each shortName]!

testStoreStringFull
	| subject rehydrated storeString |
	subject := ClassDetails fromClass: Refactory.Browser.TestData.RefactoryTestDataApp.
	subject classInstanceVariableString: 'foo'.
	subject classConstants: {'Foo' -> 1. 'Bar' -> 2}.
	storeString := subject storeString.
	self assert: storeString
		equals: '(Refactory.Browser.ClassDetails new
	className: #{Refactory.Browser.TestData.RefactoryTestDataApp};
	superclassName: #{Core.Object};
	instanceVariableNames: #(''temporaryVariable'');
	classVariableNames: #(''ClassVar1'' ''ClassVar2'');
	imports: #(#{OS.CRTConstants});
	classInstanceVariableNames: #(''foo'');
	classConstants: {''Foo'' -> 1. ''Bar'' -> 2};
	instanceSpec: 8193;
	guid: (GUID fromString: ''{dd22adf0-7b3f-4465-aa71-377108619c45}'');
	comment: ''Test class for Smalllint. Contains lots of smelly code'';
	categories: #(''Refactory-Test data'');
	packageName: ''RBTestMethods'';
	yourself)'.
	rehydrated := Compiler evaluate: storeString.
	self assert: rehydrated storeString equals: storeString!

testStoreStringMinimal
	| subject rehydrated storeString |
	subject := ClassDetails new.
	subject className: 'Foo.Bar'.
	storeString := subject storeString.
	self assert: storeString
		equals: '(Refactory.Browser.ClassDetails new
	className: #{Foo.Bar};
	yourself)'.
	rehydrated := Compiler evaluate: storeString.
	self assert: rehydrated storeString equals: storeString!

testVariables
	| subject |
	subject := ClassDetails new.
	subject className: 'Foo.Bar'.
	self assert: subject classVariableNames equals: #().
	self assert: subject classVariableString equals: ''.
	self assert: subject instanceVariableNames equals: #().
	self assert: subject classInstanceVariableNames equals: #().
	subject := ClassDetails fromClass: ClassToRename.
	self assert: subject classVariableNames equals: #('ClassVar1').
	self assert: subject classVariableString equals: 'ClassConst1 ClassVar1'.
	self assert: subject classConstants equals: ClassToRename classConstants.
	self assert: subject classInstanceVariableNames equals: #('notUsed')! !

!Refactory.Browser.Tests.ClassDetailsTest categoriesForMethods!
testImports!public! !
testInstanceSpec!public! !
testOnRBClass!public! !
testPrintString!public! !
testPrintStringLegacy!public! !
testPrintStringMissingSuperclass!public! !
testPrintStringRootClass!public! !
testPrintStringRootClassLegacy!public! !
testShortName!public! !
testStoreStringFull!public! !
testStoreStringMinimal!public! !
testVariables!public! !
!

