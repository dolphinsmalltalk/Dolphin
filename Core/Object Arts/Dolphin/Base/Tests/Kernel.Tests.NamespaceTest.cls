"Filed out from Dolphin Smalltalk 7"!

Kernel.Tests.AbstractNamespaceTest subclass: #'Kernel.Tests.NamespaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.NamespaceTest guid: (Core.GUID fromString: '{1528fd18-37cc-469b-bd8e-ea26ea522759}')!
Kernel.Tests.NamespaceTest comment: ''!
!Kernel.Tests.NamespaceTest categoriesForClass!Unclassified! !
!Kernel.Tests.NamespaceTest methodsFor!

canonicalSubject
	^Kernel.Tests!

nameCases
	^#(#Core #Kernel #XProgramming #'XProgramming.SUnit') collect: [:each | each asQualifiedReference]!

testAbsoluteName
	self nameCases
		do: [:each | self assert: each value absoluteName equals: 'Root.' , each pathString]!

testAbsoluteReference
	self nameCases do: 
			[:each |
			self assert: each value absoluteReference
				equals: ('Root.' , each pathString) asQualifiedReference]!

testAllClasses
	"The XProgramming namespace is empty apart from it's SUnit sub-namespace."

	self assert: (XProgramming allClasses difference: XProgramming.SUnit allClasses asSet)
		equals: {XProgramming.SUnit}!

testAllEnvironments
	self assert: XProgramming allEnvironments equals: {Root}.
	self assert: XProgramming.SUnit allEnvironments equals: {XProgramming. Root}.
	self assert: TestCase allEnvironments equals: {XProgramming.SUnit. XProgramming. Root}!

testBindingInParentNamespace
	"We should be able to resolve bindings in enclosing namespaces from nested namespaces"

	self assert: (XProgramming.SUnit fullBindingFor: #'Core.Object') value identicalTo: Object.
	self assert: (XProgramming.SUnit fullBindingFor: 'Object') value identicalTo: Object.
	"Another less obvious case - in Core, which is imported into XProgramming parent namespace"
	self assert: (XProgramming.SUnit fullBindingFor: #Float) value
		identicalTo: Float.
	"Namespaces implicitly import their parent as if a private import. This is the normal expectation based on the behaviour of namespace systems in other languages. A side effect is that a namespace is visible within itself, but as the implicit import is effectively private this only applies for attempts to bind the unqualified name, or as the first component of a qualified name."
	self assert: (XProgramming.SUnit fullBindingFor: #SUnit) value identicalTo: XProgramming.SUnit.
	self assertIsNil: (XProgramming.SUnit fullBindingFor: 'SUnit.SUnit').
	"Root has a binding in itself, so this should be found via the environment binding search (before imports are checked)"
	self assert: (XProgramming.SUnit fullBindingFor: 'Root') value identicalTo: Root.
	"Search up should not work other than for the primary name component"
	self assertIsNil: (XProgramming.SUnit fullBindingFor: 'Root.Smalltalk.XProgramming.SUnit.SUnit')!

testEnvironment
	self assert: XProgramming environment identicalTo: Root.
	self assert: Kernel environment identicalTo: Root.
	self assert: XProgramming.SUnit environment identicalTo: XProgramming!

testFullName
	"The fullName of a namespace is it's name relative to Smalltalk."

	self nameCases do: [:each | self assert: each value fullName equals: each pathString asSymbol]!

testFullyQualifiedReference
	self nameCases
		do: [:each | self assert: each value fullyQualifiedReference equals: each pathString asQualifiedReference]!

testImportedBinding
	| kernelRef |
	"Core imports Kernel privately - sanity check"
	kernelRef := Kernel fullyQualifiedReference isPrivate: true; yourself.
	self assert: (Core imports detect: [:each | each = kernelRef]) isPrivate.
	"Search for a binding directly defined in an immediate import"
	self assert: (Core fullBindingFor: 'CompiledMethod') identicalTo: CompiledMethod binding.
	"Or from any member of Core"
	self assert: (Array fullBindingFor: 'CompiledMethod') identicalTo: CompiledMethod binding.
	"XProgramming imports Core only."
	self assert: XProgramming imports equals: {Core fullyQualifiedReference}.
	"Search for a binding defined in a private import of an import - this should fail as private imports should not be exported."
	self assertIsNil: (XProgramming fullBindingFor: 'CompiledMethod').
	"And from a sub-namespace"
	self assertIsNil: (XProgramming.SUnit fullBindingFor: 'CompiledMethod').
	"And finally a class in a sub-namespace"
	self assertIsNil: (TestCase fullBindingFor: 'CompiledMethod').
!

testImportIntoParentNamespace
	"We should be able to resolve bindings that are found in the imports of parent namespaces, even if not locally imported."

	| coreRef |
	"Object is in Core, which is imported into XProgramming, but not directly into XProgramming.SUnit"
	coreRef := Core fullyQualifiedReference.
	self assert: (XProgramming imports includes: coreRef).
	self deny: (XProgramming.SUnit imports includes: coreRef).
	self assert: (XProgramming.SUnit fullBindingFor: #'Core.Object') value identicalTo: Object.
	self assert: (XProgramming.SUnit fullBindingFor: 'Object') value identicalTo: Object.

	"Should also work for a class in nested namespace."
	self assert: (TestCase fullBindingFor: 'Object') value identicalTo: Object.

	"Imports should not be exported - even though Object is visible in SUnit, that doesn't mean it should be reachable via there"
	self assertIsNil: (XProgramming fullBindingFor: 'SUnit.Object').
	self assertIsNil: (XProgramming fullBindingFor: 'SUnit.TestCase.Object')!

testIncludesKey
	"At the moment all classes are still in the system namespace."

	#('SUnit') do: [:each | self assert: (XProgramming includesKey: each)].
	{#Smalltalk. 'XProgramming'. '_' , (GUID newUnique idlString readStream upTo: $-)}
		do: [:each | self deny: (XProgramming includesKey: each)]!

testName
	"#name is historic and is and will always be the unqualified name. As it is not very explicit it is generally preferable to use #unqualifiedName."

	self nameCases do: [:each | self assert: each value name identicalTo: each unqualifiedName asSymbol]!

testPrintOn
	#(#Core #Kernel #XProgramming)
		do: [:each | self assert: each asQualifiedReference value printString equals: each].
	self assert: XProgramming.SUnit printString equals: 'XProgramming.SUnit'!

testPrivateImportIntoParentNamespace
	"We should be able to resolve bindings that are found in the private imports of enclosing namespaces, even if not locally imported, but these should not be exported to importers."

	"This test relies on the fact that External imports Kernel privately."

	self assert: (External imports anySatisfy: [:each | each printString = '#{Kernel private}']).
	self assert: CompiledMethod environment equals: Kernel.
	"Obviously we expect the privately imported names to be visible in the namespace"
	self assert: (External fullBindingFor: 'CompiledMethod') value equals: CompiledMethod.
	"But they should not be exported as names from that scope"
	self deny: 'External.CompiledMethod' asQualifiedReference isDefined.

	"External.Tests should inherit the private import of Kernel."
	self deny: (External.Tests imports includes: Kernel fullyQualifiedReference).
	self assert: (External.Tests fullBindingFor: 'CompiledMethod') value equals: CompiledMethod.
	self deny: 'External.Tests.CompiledMethod' asQualifiedReference isDefined!

testShortName
	"The short name of a namespace is it's unqualified name if it is defined in Smalltalk, or in one of Smalltalk's imports, otherwise it is the full name."

	self assert: Behavior shortName equals: 'Behavior'.
	self assert: XProgramming shortName equals: 'XProgramming'.
	self assert: XProgramming.SUnit shortName equals: 'XProgramming.SUnit'.
	self assert: TestCase shortName equals: 'XProgramming.SUnit.TestCase'!

testSimpleName
	"#simpleName is defined for compatibility. It is the same as the #unqualifiedName (or indeed the #name)."

	self nameCases
		do: [:each | self assert: each value simpleName identicalTo: each unqualifiedName asSymbol]!

testUnqualifiedName
	self nameCases
		do: [:each | self assert: each value unqualifiedName identicalTo: each unqualifiedName asSymbol]! !
!Kernel.Tests.NamespaceTest categoriesFor: #canonicalSubject!private! !
!Kernel.Tests.NamespaceTest categoriesFor: #nameCases!constants!private! !
!Kernel.Tests.NamespaceTest categoriesFor: #testAbsoluteName!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testAbsoluteReference!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testAllClasses!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testAllEnvironments!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testBindingInParentNamespace!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testEnvironment!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testFullName!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testFullyQualifiedReference!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testImportedBinding!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testImportIntoParentNamespace!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testIncludesKey!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testName!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testPrintOn!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testPrivateImportIntoParentNamespace!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testShortName!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testSimpleName!public!unit tests! !
!Kernel.Tests.NamespaceTest categoriesFor: #testUnqualifiedName!public!unit tests! !

