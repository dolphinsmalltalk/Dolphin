"Filed out from Dolphin Smalltalk"!

Kernel.Tests.ScopedBindingReferenceTest subclass: #'Kernel.Tests.FullBindingReferenceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.FullBindingReferenceTest guid: (Core.GUID fromString: '{bc0780da-05e7-464d-af4f-48755f8f8d52}')!
Kernel.Tests.FullBindingReferenceTest comment: ''!
!Kernel.Tests.FullBindingReferenceTest methodsFor!

subjectClass
	^FullBindingReference!

testAsQualifiedReference
	| object |
	super testAsQualifiedReference.
	object := self newSubjectWithPath: #(#'Core.Object').
	self assert: #'Core.Object' asQualifiedReference equals: object.
	"Although these two binding refs would resolve to the same binding, they are not equivalent as one has a more specific path."
	self deny: 'Smalltalk.Object' asQualifiedReference equals: object.
	self assert: object asQualifiedReference identicalTo: object.
	self assert: 'Object._EventsRegister' asQualifiedReference
		equals: (self newSubjectWithPath: #(#Object #_EventsRegister))!

testEnvironment
	| subject |
	subject := self newSubjectWithPathString: 'Core.Object'.
	self assert: subject environment identicalTo: Core.
	subject := self newSubjectWithPathString: 'Core'.
	self assert: subject environment identicalTo: Root.
	"A variable that does not exist is assumed to be in Smalltalk (we cannot tell if the target is intended to be a class or namespace)"
	subject := self newSubjectWithPathString: 'NothingToSeeHere'.
	self assert: subject environment identicalTo: Smalltalk.
	"A namespace that does not exist, well doesn't exist"
	subject := self newSubjectWithPathString: 'NothingToSeeHere.Really'.
	self assertIsNil: subject environment!

testEnvironmentNameRelative
	#(#{Object} #{_.Object}) do: [:each | self assert: each environmentName equals: self class fullName].
	self assert: #{_.Core.Object} environmentName equals: self class fullName , '.Core'!

testEqualityOfRelativeAndAbsolute
	"Relative binding references are not equivalent to absolute binding references, even if they would actually bind to the same target - i.e. the equality comparison is based on static equivalence of the reference itself and so is independent of its result when evaluated. This makes sense because it provides a temporally stable comparison for references, whereas the binding to which they evaluate may differ over time, as it depends on other properties of its context that may change after it is created. For example a class may have relative literal binding references in its methods. If the class is moved to a different environment, or its imports are changed, then the value of the binding references may change. In consequence many BindingReferences that are not considered equivalent may eventually bind to the same target binding - this is a necessary condition for BindingReference equivalence at a point in time, but it is not sufficient. BindingReferences are only equivalent if they represent the same binding path and, if relative, from the same starting point. Absolute binding references with the same path are considered equivalent even if they are compiled in a different context, or provided with a different context when instantiated."

	| subject |
	self deny: #'Core.Object' asQualifiedReference equals: #{Object}.
	self assert: #'Core.Object' asQualifiedReference equals: #{Core.Object}.
	"Even if we specify a context, an absolute reference should still be equal to one without a specified context."
	self assert: (self newSubjectWithPath: #('Core' 'Object') scope: self class)
		equals: 'Core.Object' asQualifiedReference.
	subject := self newSubjectWithPath: #('_' 'Object') scope: self class.
	self assert: #{_.Object} equals: subject.
	self deny: subject equals: 'Core.Object' asQualifiedReference.
	self assert: subject equals: #{Object}.
	self assert: #{_.Object} equals: #{Object}!

testEqualsLiteral
	"Literal binding references may be relative, or absolute. Simple unqualified names are considered to be relative by default. Qualified names are considered to be absolute by default. The addition of a '_' name component prefix to a qualified name makes it relative. Relative binding references are never equivalent to absolute binding references, even if they would actually bind to the same target - i.e. the equality comparison is based on static equivalence of the reference itself and so is independent of its result when evaluated. This makes sense because it provides a temporally stable comparison for references, whereas the binding to which they evaluate may differ over time, as it depends on other properties of its context that may change after it is created. For example a class may have relative literal binding references in its methods. If the class is moved to a different environment, or its imports are changed, then the value of the binding references may change. In consequence many BindingReferences that are not considered equivalent may eventually bind to the same target binding - this is a necessary condition for BindingReference equivalence at a point in time, but it is not sufficient. BindingReferences are only equivalent if they represent the same binding path and, if relative, from the same starting point. Absolute binding references with the same path are considered equivalent even if they are compiled in a different context, or provided with a different context when instantiated."

	self assert: #{Object} equals: (self newSubjectWithPathString: #Object scope: self class).
	self assert: #{Object}
		equals: (self newSubjectWithPathString: #Object scope: (self class lookupMethod: self selector)).
	self assert: #{_.Object} equals: (self newSubjectWithPathString: #Object scope: self class).
	self assert: #{_.Object} equals: #{Object}.
	self deny: #{Object} equals: #'Core.Object' asQualifiedReference.
	self deny: #{_.Object} equals: #'Core.Object' asQualifiedReference.
	"Literal binding references with qualified name is considered to be absolute"
	self assert: #{Core.Object} equals: #'Core.Object' asQualifiedReference.
	self deny: #{_.Object} equals: #'Core.Object' asQualifiedReference.
	self deny: #{_.Core.Object} equals: #'Core.Object' asQualifiedReference.
	self assert: #{_.Core.Object}
		equals: (self newSubjectWithPath: #('_' 'Core' 'Object') scope: self class)!

testIsValidGlobalName
	#('A' 'A1' 'A_' '_A' 'a' '_a' '__A_B' 'A.B' 'Abc.D' '_Abc._d' 'abc.d')
		do: [:each | self assert: (BindingReference isValidQualifiedName: each)].
	#('_' '_.' 'A.' '.A' '_A.' '_.A' '.' 'a.' '_.a' '*' '' 'A.*' '*.' 'A..B')
		do: [:each | self deny: (BindingReference isValidQualifiedName: each)]!

testLessOrEqual
	| a b |
	super testLessOrEqual.
	a := self newSubjectWithPathString: 'Core.Object'.
	b := self newSubjectWithPathString: 'Core.object'.
	self assert: a <= a meta.
	self assert: a <=> a meta equals: -1.
	self assert: a <==> a meta equals: -1.
	self deny: a <= b.
	self deny: a <= b meta.
	self assert: a <=> b equals: 0.
	self assert: a <=> b meta equals: -1.
	self assert: a <==> b equals: 1.
	self assert: a <=> b meta equals: -1!

testLiteral
	| subject |
	#(#{Object} #{_.Object private} #{_.Core.Object}) do: 
			[:each |
			self assert: each isRelative.
			"When a relative literal BindingReference is compiled in a method in the method class' namespace, then the context can be the method class"
			self assert: each scope identicalTo: ##(self).
			self assert: each valueOrNil identicalTo: Object].
	"Absolute references always have nil context"
	subject := #{Core.Object}.
	self deny: subject isRelative.
	self assert: subject isLiteral.
	self assert: subject isSelfEvaluating.
	self assertIsNil: subject scope.
	self assert: subject bindingScope identicalTo: Smalltalk.
	self assert: subject valueOrNil identicalTo: Object!

testLiteralExplicitEnvironmentRelative
	| method source |
	source := 'thisTestClass %<namespace: Kernel.Tests> ^#{<1s>} valueOrNil' << self class unqualifiedName.
	method := Compiler
				compile: source
				in: Object
				environment: nil.
	self assert: method isAnnotated.
	self assert: method customEnvironment identicalTo: self class environment.
	self assert: (method value: Object new withArguments: #()) identicalTo: self class.
!

testLiteralExplicitEnvironmentRelative2
	| method source env |
	env := self class environment.
	source := 'thisTestClass %<foo> %<namespace: Kernel> %<bar> %<namespace: <2p>> ^#{<1s>} valueOrNil'
				expandMacrosWith: self class unqualifiedName
				with: env.
	method := Compiler
				compile: source
				in: Object
				environment: nil.
	self assert: method isAnnotated.
	"Latest namespace annotation wins"
	self assert: method annotations asArray
		equals: {Message selector: #foo.
				Message selector: #namespace: arguments: {env}.
				Message selector: #bar}.
	self assert: method customEnvironment identicalTo: env.
	self assert: (method value: Object new withArguments: #()) identicalTo: self class!

testLiteralImplicitEnvironmentRelative
	| method source |
	source := 'thisTestClass ^#{<1s>} valueOrNil' << self class unqualifiedName.
	method := Compiler compile: source in: Object.
	"The unqualified name of this class should not normally be bindable from a method of Core.Object"
	self assertIsNil: (method value: Object new withArguments: #()).
	"But when compiled in the Kernel.Tests environment, it should resolve"
	method := Compiler
				compile: source
				in: Object
				environment: self class environment.
	self assert: method isAnnotated.
	self assert: method customEnvironment identicalTo: self class environment.
	self assert: (method value: Object new withArguments: #()) identicalTo: self class!

testLiteralImplicitExplicitEnvironmentRelative
	| method source name env |
	name := self class unqualifiedName.
	env := self class environment.
	source := 'thisTestClass %<foo> %<namespace: <2p>> %<bar> ^#{<1s>} valueOrNil'
				expandMacrosWith: name
				with: env.
	self assertIsNil: (Graphics fullBindingFor: name).
	method := Compiler
				compile: source
				in: Object
				environment: Graphics.
	self assert: method isAnnotated.
	"Note the order: The implicit namespace provided to the Compiler caused an initial namespace annotation to be added that was then changed by the explicit namespace: annotation"
	self assert: method annotations asArray
		equals: {Message selector: #namespace: arguments: {env}.
				Message selector: #foo.
				Message selector: #bar}.
	self assert: method customEnvironment identicalTo: env.
	self assert: (method value: Object new withArguments: #()) identicalTo: self class!

testStbConvertFromVersion0
	| subject |
	subject := Compiler
				evaluate: 'Object
				fromLiteralStoreArray: #(#''!!STL'' 4 1508870 ##(Kernel.BindingReference) nil 34 2 8 ''Core'' 8 ''Object'' nil 5 1442886 2 ##(Kernel.VariableBinding) #Object ##(Core.Object) ##(Core) 1 1)'.
	self assert: subject class identicalTo: self subjectClass.
	self assert: subject isPrivate.
	self assert: subject value identicalTo: Object!

testStbConvertFromVersion1
	| subject |
	subject := Object
				fromBinaryStoreBytes: #[33 83 84 66 32 52 32 70 5 23 0 1 0 0 0 75 101 114 110 101 108 46 66 105 110 100 105 110 103 82 101 102 101 114 101 110 99 101 18 1 0 0 11 0 0 0 67 111 114 101 46 79 98 106 101 99 116 0 0 0 0 16 0 0 0 0 0 0 0 0 0 0 0].
	self assert: subject class identicalTo: self subjectClass.
	self assert: subject isPrivate.
	self assert: subject value identicalTo: Object!

testStbConvertRelativeFromVersion0
	| subject |
	subject := Compiler
				evaluate: 'Object fromLiteralStoreArray: #(#''!!STL'' 4 1508870 ##(Kernel.BindingReference) 8 ''Object'' nil ##(Core) 9 nil nil)'.
	self assert: subject class identicalTo: RelativeBindingReference.
	self deny: subject isPrivate.
	self assert: subject scope identicalTo: Core.
	self assert: subject value identicalTo: Object!

testStbConvertRelativeFromVersion1
	| subject |
	subject := Object
				fromBinaryStoreBytes: #[33 83 84 66 32 52 32 70 6 31 0 1 0 0 0 75 101 114 110 101 108 46 82 101 108 97 116 105 118 101 66 105 110 100 105 110 103 82 101 102 101 114 101 110 99 101 18 1 0 0 6 0 0 0 79 98 106 101 99 116 0 0 0 0 32 0 0 0 0 0 0 0 0 0 0 0 154 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 4 0 0 0 67 111 114 101].
	self assert: subject class identicalTo: RelativeBindingReference.
	self deny: subject isPrivate.
	self assert: subject scope identicalTo: Core.
	self assert: subject value identicalTo: Object!

testStlConvertFromVersion1
	| subject |
	subject := Compiler
				evaluate: '(Object fromLiteralStoreArray: #(#''!!STL'' 4 1508678 1 ##(Kernel.BindingReference) 8 ''Core.Object'' nil true nil nil))'.
	self assert: subject class identicalTo: self subjectClass.
	self assert: subject isPrivate.
	self assert: subject value identicalTo: Object!

testStlConvertRelativeFromVersion1
	| subject |
	subject := Compiler
				evaluate: '(Object fromLiteralStoreArray: #(#''!!STL'' 4 2033222 1 ##(Kernel.RelativeBindingReference) 8 ''Object'' nil false nil nil ##(Core)))'.
	self assert: subject class identicalTo: RelativeBindingReference.
	self deny: subject isPrivate.
	self assert: subject scope identicalTo: Core.
	self assert: subject value identicalTo: Object! !
!Kernel.Tests.FullBindingReferenceTest categoriesForMethods!
subjectClass!constants!private! !
testAsQualifiedReference!public!unit tests! !
testEnvironment!public!unit tests! !
testEnvironmentNameRelative!public!unit tests! !
testEqualityOfRelativeAndAbsolute!public!unit tests! !
testEqualsLiteral!public!unit tests! !
testIsValidGlobalName!public!unit tests! !
testLessOrEqual!public!unit tests! !
testLiteral!public!unit tests! !
testLiteralExplicitEnvironmentRelative!public!unit tests! !
testLiteralExplicitEnvironmentRelative2!public!unit tests! !
testLiteralImplicitEnvironmentRelative!public!unit tests! !
testLiteralImplicitExplicitEnvironmentRelative!public!unit tests! !
testStbConvertFromVersion0!public!unit tests! !
testStbConvertFromVersion1!public!unit tests! !
testStbConvertRelativeFromVersion0!public!unit tests! !
testStbConvertRelativeFromVersion1!public!unit tests! !
testStlConvertFromVersion1!public!unit tests! !
testStlConvertRelativeFromVersion1!public!unit tests! !
!

