"Filed out from Dolphin Smalltalk"!

Kernel.Tests.AbstractBindingReferenceTest subclass: #'Kernel.Tests.BindingReferenceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.BindingReferenceTest guid: (Core.GUID fromString: '{bc0780da-05e7-464d-af4f-48755f8f8d52}')!
Kernel.Tests.BindingReferenceTest comment: ''!
!Kernel.Tests.BindingReferenceTest categoriesForClass!Unclassified! !
!Kernel.Tests.BindingReferenceTest methodsFor!

subjectClass
	^BindingReference!

testAsQualifiedReference
	| object |
	super testAsQualifiedReference.
	object := self subjectClass path: #(#'Core.Object').
	self assert: #'Core.Object' asQualifiedReference equals: object.
	"Although these two binding refs would resolve to the same binding, they are not equivalent as one has a more specific path."
	self deny: 'Smalltalk.Object' asQualifiedReference equals: object.
	self assert: object asQualifiedReference identicalTo: object.
	self assert: 'Object._EventsRegister' asQualifiedReference
		equals: (self subjectClass path: #(#Object #_EventsRegister))!

testEnvironmentName
	| subject |
	#('Core.Object' 'Core' 'Smalltalk' nil 'Root' nil 'Root.Smalltalk' 'Root' 'Smalltalk.Animal' 'Smalltalk' 'Animal' nil 'XProgramming.SUnit' 'XProgramming' 'XProgramming.SUnit.TestRunConsoleLogger' 'XProgramming.SUnit')
		pairsDo: 
			[:each :expected |
			subject := self subjectClass pathString: each.
			self assert: subject environmentName equals: expected].
	subject := (self subjectClass pathString: 'Root' scope: Root) instance.
	self assert: subject environmentName equals: 'Root'.
	subject := (self subjectClass pathString: 'TestCase' scope: XProgramming.SUnit) instance.
	self assert: subject environmentName equals: 'XProgramming.SUnit'!

testEnvironmentNameRelative
	#(#{Object} #{_.Object}) do: [:each | self assert: each environmentName equals: self class fullName].
	self assert: #{_.Core.Object} environmentName equals: self class fullName , '.Core'!

testEqualityOfRelativeAndAbsolute
	"Relative binding references are not equivalent to absolute binding references, even if they would actually bind to the same target - i.e. the equality comparison is based on static equivalence of the reference itself and so is independent of its result when evaluated. This makes sense because it provides a temporally stable comparison for references, whereas the binding to which they evaluate may differ over time, as it depends on other properties of its context that may change after it is created. For example a class may have relative literal binding references in its methods. If the class is moved to a different environment, or its imports are changed, then the value of the binding references may change. In consequence many BindingReferences that are not considered equivalent may eventually bind to the same target binding - this is a necessary condition for BindingReference equivalence at a point in time, but it is not sufficient. BindingReferences are only equivalent if they represent the same binding path and, if relative, from the same starting point. Absolute binding references with the same path are considered equivalent even if they are compiled in a different context, or provided with a different context when instantiated."

	| subject |
	self deny: #'Core.Object' asQualifiedReference equals: #{Object}.
	self assert: #'Core.Object' asQualifiedReference equals: #{Core.Object}.
	"Even if we specify a context, an absolute reference should still be equal to one without a specified context."
	self assert: (self subjectClass path: #('Core' 'Object') scope: self class)
		equals: 'Core.Object' asQualifiedReference.
	subject := self subjectClass path: #('_' 'Object') scope: self class.
	self assert: #{_.Object} equals: subject.
	self deny: subject equals: 'Core.Object' asQualifiedReference.
	self assert: subject equals: #{Object}.
	self assert: #{_.Object} equals: #{Object}!

testEqualsLiteral
	"Literal binding references may be relative, or absolute. Simple unqualified names are considered to be relative by default. Qualified names are considered to be absolute by default. The addition of a '_' name component prefix to a qualified name makes it relative. Relative binding references are never equivalent to absolute binding references, even if they would actually bind to the same target - i.e. the equality comparison is based on static equivalence of the reference itself and so is independent of its result when evaluated. This makes sense because it provides a temporally stable comparison for references, whereas the binding to which they evaluate may differ over time, as it depends on other properties of its context that may change after it is created. For example a class may have relative literal binding references in its methods. If the class is moved to a different environment, or its imports are changed, then the value of the binding references may change. In consequence many BindingReferences that are not considered equivalent may eventually bind to the same target binding - this is a necessary condition for BindingReference equivalence at a point in time, but it is not sufficient. BindingReferences are only equivalent if they represent the same binding path and, if relative, from the same starting point. Absolute binding references with the same path are considered equivalent even if they are compiled in a different context, or provided with a different context when instantiated."

	self assert: #{Object} equals: (self subjectClass pathString: #Object scope: self class).
	self assert: #{Object}
		equals: (self subjectClass pathString: #Object scope: (self class lookupMethod: self selector)).
	self assert: #{_.Object} equals: (self subjectClass pathString: #Object scope: self class).
	self assert: #{_.Object} equals: #{Object}.
	self deny: #{Object} equals: #'Core.Object' asQualifiedReference.
	self deny: #{_.Object} equals: #'Core.Object' asQualifiedReference.
	"Literal binding references with qualified name is considered to be absolute"
	self assert: #{Core.Object} equals: #'Core.Object' asQualifiedReference.
	self deny: #{_.Object} equals: #'Core.Object' asQualifiedReference.
	self deny: #{_.Core.Object} equals: #'Core.Object' asQualifiedReference.
	self assert: #{_.Core.Object}
		equals: (self subjectClass path: #('_' 'Core' 'Object') scope: self class)!

testIsValidGlobalName
	#('A' 'A1' 'A_' '_A' 'a' '_a' '__A_B' 'A.B' 'Abc.D' '_Abc._d' 'abc.d')
		do: [:each | self assert: (BindingReference isValidQualifiedName: each)].
	#('_' '_.' 'A.' '.A' '_A.' '_.A' '.' 'a.' '_.a' '*' '' 'A.*' '*.' 'A..B')
		do: [:each | self deny: (BindingReference isValidQualifiedName: each)]!

testLessOrEqual
	| a b |
	super testLessOrEqual.
	a := self subjectClass pathString: 'Core.Object'.
	b := self subjectClass pathString: 'Core.object'.
	self assert: a <= a meta.
	self deny: a <= b meta!

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

testRelativeNoScope
	self should: [BindingReference path: #('_' 'Object')] raise: Error!

testStbConvertFromVersion0
	| subject |
	subject := Object
				fromLiteralStoreArray: #(#'!!STL' 4 1508870 ##(Kernel.BindingReference) nil 34 2 8 'Core' 8 'Object' nil 5 1442886 2 ##(Kernel.VariableBinding) #Object ##(Core.Object) ##(Core) 1 1).
	self assert: subject class identicalTo: BindingReference.
	self assert: subject isPrivate.
	self assert: subject value identicalTo: Object.
	subject := (Object fromLiteralStoreArray: #(#'!!STL' 4 1508870 ##(Kernel.BindingReference) 8 'Object' nil ##(Core) 9 nil nil)).
	self assert: subject class identicalTo: RelativeBindingReference.
	self deny: subject isPrivate.
	self assert: subject scope identicalTo: Core.
	self assert: subject value identicalTo: Object! !
!Kernel.Tests.BindingReferenceTest categoriesForMethods!
subjectClass!constants!private! !
testAsQualifiedReference!public! !
testEnvironmentName!public!unit tests! !
testEnvironmentNameRelative!public!unit tests! !
testEqualityOfRelativeAndAbsolute!public!unit tests! !
testEqualsLiteral!public!unit tests! !
testIsValidGlobalName!public!unit tests! !
testLessOrEqual!public!unit tests! !
testLiteral!public! !
testLiteralExplicitEnvironmentRelative!public! !
testLiteralExplicitEnvironmentRelative2!public! !
testLiteralImplicitEnvironmentRelative!public! !
testLiteralImplicitExplicitEnvironmentRelative!public! !
testRelativeNoScope!public!unit tests! !
testStbConvertFromVersion0!public! !
!

