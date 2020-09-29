"Filed out from Dolphin Smalltalk 7"!

Core.Tests.ClassDescriptionTest subclass: #'Core.Tests.ClassTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ClassTest guid: (Core.GUID fromString: '{3c2fe318-ee64-4a1e-8b1a-8bf38c6d1803}')!
Core.Tests.ClassTest comment: ''!
!Core.Tests.ClassTest categoriesForClass!Unclassified! !
!Core.Tests.ClassTest methodsFor!

allClassHierarchyInstancesDo: aMonadicValuable
	Smalltalk allClasses do: aMonadicValuable!

testAllRoots
	| roots |
	roots := Class allRoots.
	self assert: roots first identicalTo: Object.
	roots do: [:each | self assertIsNil: each superclass]!

testClassPoolsWellFormed
	"https://github.com/dolphinsmalltalk/Dolphin/issues/562"

	| badPools |
	badPools := Smalltalk allClasses reject: 
					[:each |
					| classVars |
					classVars := each classPool.
					classVars class == Dictionary and: 
							[each classPool associations
								allSatisfy: [:v | v class == VariableBinding and: [v environment == each]]]].
	self assert: badPools asArray equals: #()!

testImportsValid
	Smalltalk allClasses do: [:each | self assert: (each imports allSatisfy: [:i | i isDefined])]!

testIncludesNamespace
	self assert: (Root includesNamespace: Root).
	self assert: (Root includesNamespace: nil).
	self deny: (Root includesNamespace: Smalltalk).
	self assert: (Smalltalk includesNamespace: Root).
	self assert: (Smalltalk includesNamespace: nil).
	self assert: (Core includesNamespace: Core).
	self assert: (Core includesNamespace: Root).
	self deny: (Core includesNamespace: Kernel).
	self deny: (Core includesNamespace: Smalltalk).
	self assert: (Core.Tests includesNamespace: Core).
	self assert: (Core.Tests includesNamespace: Root).
	self assert: (Class includesNamespace: Class).
	self assert: (Class includesNamespace: ClassDescription).
	self assert: (Class includesNamespace: Behavior).
	self assert: (Class includesNamespace: Object).
	self assert: (Class includesNamespace: nil).

!

testLessOrEqual
	self assert: ArithmeticError <= ArithmeticError description: 'Classes must be <= to themselves'.
	self assert: ArithmeticError <= ArithmeticError class
		description: 'Classes must be <= their Metaclass'.
	self assert: ArithmeticError <= ArithmeticValue.
	self assert: ArithmeticError <= ArithmeticValue class.
	self deny: ArithmeticValue <= ArithmeticError.
	self deny: ArithmeticValue <= ArithmeticError class.
	self assert: Behavior <= Class.
	self assert: Behavior <= Behavior.
	self deny: Behavior <= Array.
	"Namespaces"
	self assert: Root <= Smalltalk.
	self assert: Root <= Root.
	self deny: Root <= Core.
	self assert: Core <= Root.
	self assert: Smalltalk <= Smalltalk.
	self deny: Smalltalk <= Root.
	self assert: Core <= Kernel.
	self deny: Kernel <= Core.
	self assert: Core <= Core.
	"Classes in Namespaces"
	self assert: Core.Tests <= Kernel.Tests.
	self assert: Core.Tests <= Core.Tests.
	self deny: Kernel.Tests <= Core.Tests.
	self assert: TestCase <= TestCaseResult!

testPoolBinding
	"Should be able to resolve imported pool bindings from the class"

	self assert: (Exception fullBindingFor: 'WS_CHILD') notNil.
	"But the imports are private, and so not be exported as externally resolvable names"
	self assert: (Smalltalk fullBindingFor: 'Exception.WS_CHILD') isNil!

testStoreOn
	self assert: self class storeString equals: 'Core.Tests.ClassTest'! !
!Core.Tests.ClassTest categoriesFor: #allClassHierarchyInstancesDo:!helpers!private! !
!Core.Tests.ClassTest categoriesFor: #testAllRoots!public!unit tests! !
!Core.Tests.ClassTest categoriesFor: #testClassPoolsWellFormed!public!unit tests! !
!Core.Tests.ClassTest categoriesFor: #testImportsValid!public!unit tests! !
!Core.Tests.ClassTest categoriesFor: #testIncludesNamespace!private! !
!Core.Tests.ClassTest categoriesFor: #testLessOrEqual!public!unit tests! !
!Core.Tests.ClassTest categoriesFor: #testPoolBinding!public!unit tests! !
!Core.Tests.ClassTest categoriesFor: #testStoreOn!public!unit tests! !

