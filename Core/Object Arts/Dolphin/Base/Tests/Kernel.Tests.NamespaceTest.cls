"Filed out from Dolphin Smalltalk"!

Kernel.Tests.AbstractNamespaceTest
	subclass: #'Kernel.Tests.NamespaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Kernel.VariableBinding})
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.NamespaceTest guid: (Core.GUID fromString: '{1528fd18-37cc-469b-bd8e-ea26ea522759}')!

Kernel.Tests.NamespaceTest comment: ''!

!Kernel.Tests.NamespaceTest methodsFor!

canonicalSubject
	<namespace: Kernel>
	^Tests!

nameCases
	^#(#Core #Kernel #XProgramming 'XProgramming.SUnit' #Smalltalk) collect: [:each | each asQualifiedReference]

!

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

testAssociationAt
	| assoc |
	assoc := Core associationAt: #Association.
	self assert: assoc key identicalTo: #Association.
	self assert: assoc value identicalTo: Association.
	self deny: assoc isClassVariable.
	self should: [Core associationAt: #Wibble] raise: NotFoundError.
	"associationAt: is a local lookup, i.e. it will only resolve unqualfied names from the classPool of the Namespace"
	self should: [Root associationAt: #'Core.Object'] raise: NotFoundError.
	self should: [UI associationAt: #Object] raise: NotFoundError.
	self should: [UI associationAt: #'Core.Object'] raise: NotFoundError.!

testAssociationAtIfAbsent
	| assoc absent |
	assoc := Core associationAt: #Association ifAbsent: nil.
	self assert: assoc key identicalTo: #Association.
	self assert: assoc value identicalTo: Association.
	self deny: assoc isClassVariable.
	absent := Object new.
	self assert: (Core associationAt: #Wibble ifAbsent: [absent]) identicalTo: absent.
	"associationAt: is a local lookup, i.e. it will only resolve unqualfied names from the classPool of the Namespace"
	self assert: (Root associationAt: #'Core.Object' ifAbsent: absent) identicalTo: absent.
	self assert: (UI associationAt: #Object ifAbsent: absent) identicalTo: absent.
	self assert: (UI associationAt: #'Core.Object' ifAbsent: absent) identicalTo: absent!

testAt
	| assoc |
	assoc := Core at: #Association.
	self assert: assoc identicalTo: Association.
	self should: [Core at: #Wibble] raise: NotFoundError.
	"at: is a local lookup, i.e. it will only resolve unqualfied names from the classPool of the Namespace"
	self should: [Root at: #'Core.Object'] raise: NotFoundError.
	self should: [UI at: #Object] raise: NotFoundError.
	self should: [UI at: #'Core.Object'] raise: NotFoundError.!

testAtIfAbsent
	| missing |
	missing := Object new.
	self assert: (External at: 'Handle' ifAbsent: [missing]) identicalTo: Handle.
	self assert: (External at: 'NothingToSeeHere' ifAbsent: [missing]) identicalTo: missing.
	"Core is imported into most namespaces, but the Dictionary protocols perform a local lookup"
	self assert: (External at: #Association ifAbsent: [missing]) identicalTo: missing.
	self assert: (External at: self class fullName ifAbsent: [missing]) identicalTo: missing.
	self assert: (External at: 'Core.Tests.NothingToSeeHere' ifAbsent: [missing]) identicalTo: missing!

testAtIfPresent
	| foundBlock present |
	present := Object new.
	foundBlock := [:obj | present -> obj].
	self assert: (Core at: #Association ifPresent: foundBlock) equals: present -> Association.
	self assertIsNil: (Core at: 'NothingToSeeHere' ifPresent: foundBlock).
	"at: is a local lookup, i.e. it will only resolve unqualfied names from the classPool of the Namespace"
	self assertIsNil: (Core at: 'Core.Object' ifPresent: foundBlock).
	self assertIsNil: (UI at: #Object ifPresent: foundBlock).
	self assertIsNil: (UI at: 'Core.Object' ifPresent: foundBlock)!

testBindingFromNamespaceWithCustomEnvironment
	"Test the case of resolving an unqualified name in a method that is defined in a Namespace class in a different environment than that of the Namespace class itself, where the identifier is not bindable in the namespace class, but is bindable in the method environment (bug #1129)."

	| direct indirect |
	direct := UI bindingFor: 'ConfirmationRequiredWarning'.
	"Resolve an unqualified name in the context of a namespace that has a direct import of the namespace in which the identifier resides."
	self assert: (Tools fullBindingFor: 'ConfirmationRequiredWarning') identicalTo: direct.
	"Resolve an unqualified name in the context of a class that cannot resolve the identifier, but with a custom namespace that does import the target namespace."
	self assertIsNil: (SharedPool class fullBindingFor: 'ConfirmationRequiredWarning').
	"If we specify a custom environment in which the identifier is bindable, we should be able to find it"
	indirect := SharedPool class fullBindingFor: 'ConfirmationRequiredWarning' environment: Tools.
	self assertNotNil: indirect.
	self assert: direct identicalTo: indirect!

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

testClassVariableNames
	self assert: self canonicalSubject classVariableNames equals: #()!

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

testNonInstantiable
	| instantiable |
	instantiable := Namespace withAllSubclasses reject: [:each | each isNonInstantiable].
	self assert: instantiable asArray equals: #()!

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
	self deny: #{External.CompiledMethod} isDefined.

	"External.Tests should inherit the private import of Kernel."
	self deny: (External.Tests imports includes: Kernel fullyQualifiedReference).
	self assert: (External.Tests fullBindingFor: 'CompiledMethod') value equals: CompiledMethod.
	self deny: #{External.Tests.CompiledMethod} isDefined!

testResolveClassVarViaClassImport
	"Tests using a class in the role of a namespace, which should make its class variables/constants visible, used e.g. when a Class is imported into another."

	self assert: (self class fullBindingFor: 'ClassMask')
		identicalTo: (VariableBinding bindingFor: 'ClassMask').
	self assertIsNil: (self class fullBindingFor: 'NothingToSeeHere')!

testResolveImportedVarViaClassEnvironment
	"Test fullBindingFor:environment: using a normal Class as the 2nd argument rather than a Namespace. This may happen if, e.g., a class is specified as the argument to a method namespace annotation."

	self assertIsNil: (self class fullBindingFor: 'BlockCopy').
	self assert: (self class fullBindingFor: 'BlockCopy' environment: CompiledCode)
		identicalTo: (OpcodePool bindingFor: 'BlockCopy').
	self assertIsNil: (self class fullBindingFor: 'NothingToSeeHere' environment: CompiledCode)!

testResolveImportIntoCustomEnvironment
	"Test the case of resolving an unqualified name in a method that is in a different namespace than its class, where the unqualified name has a match in a namespace imported into the method namespace, but is not bindable in the class' namespace."

	| direct indirect |
	"Resolve an unqualified name in the context of a namespace that has a direct import of the namespace in which the identifier resides."
	direct := Tools fullBindingFor: 'ConfirmationRequiredWarning'.
	self assertNotNil: direct.
	"As Tools imports UI, we should be able to find it"
	self assert: (SharedPool class fullBindingFor: 'UI' environment: Tools) identicalTo: UI binding.
	"Resolve an unqualified name in the context of a class that cannot resolve the identifier, but with a custom namespace that does import the target namespace."
	indirect := SharedPool class fullBindingFor: 'ConfirmationRequiredWarning' environment: Tools.
	self assertNotNil: indirect.
	self assert: direct identicalTo: indirect
	
	!

testShortName
	"The short name of a namespace is it's unqualified name if it is defined in Smalltalk, or in one of Smalltalk's imports, otherwise it is the full name."
	self assert: XProgramming shortName equals: 'XProgramming'.
	self assert: XProgramming.SUnit shortName equals: 'XProgramming.SUnit'.

	"Where there is ambiguity in imported namespaces, the order of imports takes precedence (Core is imported into Smaltlalk before Kernel)."
	self assert: Core.Tests shortName equals: 'Tests'.
	self assert: Kernel.Tests shortName equals: 'Kernel.Tests'.
!

testSimpleName
	"#simpleName is defined for compatibility. It is the same as the #unqualifiedName (or indeed the #name)."

	self nameCases
		do: [:each | self assert: each value simpleName identicalTo: each unqualifiedName asSymbol]!

testUnqualifiedName
	self nameCases
		do: [:each | self assert: each value unqualifiedName identicalTo: each unqualifiedName asSymbol]! !

!Kernel.Tests.NamespaceTest categoriesForMethods!
canonicalSubject!private! !
nameCases!constants!private! !
testAbsoluteName!public!unit tests! !
testAbsoluteReference!public!unit tests! !
testAllClasses!public!unit tests! !
testAllEnvironments!public!unit tests! !
testAssociationAt!public! !
testAssociationAtIfAbsent!public! !
testAt!public! !
testAtIfAbsent!public! !
testAtIfPresent!public! !
testBindingFromNamespaceWithCustomEnvironment!public! !
testBindingInParentNamespace!public!unit tests! !
testClassVariableNames!public! !
testEnvironment!public!unit tests! !
testFullName!public!unit tests! !
testFullyQualifiedReference!public!unit tests! !
testImportedBinding!public!unit tests! !
testImportIntoParentNamespace!public!unit tests! !
testIncludesKey!public!unit tests! !
testName!public!unit tests! !
testNonInstantiable!public!unit tests! !
testPrintOn!public!unit tests! !
testPrivateImportIntoParentNamespace!public!unit tests! !
testResolveClassVarViaClassImport!public! !
testResolveImportedVarViaClassEnvironment!public! !
testResolveImportIntoCustomEnvironment!public! !
testShortName!public!unit tests! !
testSimpleName!public!unit tests! !
testUnqualifiedName!public!unit tests! !
!

