"Filed out from Dolphin Smalltalk 7"!

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

testEqualityOfRelativeAndAbsolute
	"Relative binding references are not equivalent to absolute binding references, even if they would actually bind to the same target - i.e. the equality comparison is based on static equivalence of the reference itself and so is independent of its result when evaluated. This makes sense because it provides a temporally stable comparison for references, whereas the binding to which they evaluate may differ over time, as it depends on other properties of its context that may change after it is created. For example a class may have relative literal binding references in its methods. If the class is moved to a different environment, or its imports are changed, then the value of the binding references may change. In consequence many BindingReferences that are not considered equivalent may eventually bind to the same target binding - this is a necessary condition for BindingReference equivalence at a point in time, but it is not sufficient. BindingReferences are only equivalent if they represent the same binding path and, if relative, from the same starting point. Absolute binding references with the same path are considered equivalent even if they are compiled in a different context, or provided with a different context when instantiated."

	| subject |
	self deny: #'Core.Object' asQualifiedReference equals: #{Object}.
	self assert: #'Core.Object' asQualifiedReference equals: #{Core.Object}.
	"Even if we specify a context, an absolute reference should still be equal to one without a specified context."
	self assert: (self subjectClass path: #('Core' 'Object') context: self class)
		equals: 'Core.Object' asQualifiedReference.
	subject := self subjectClass path: #('_' 'Object') context: self class.
	self assert: #{_.Object} equals: subject.
	self deny: subject equals: 'Core.Object' asQualifiedReference.
	self assert: subject equals: #{Object}.
	self assert: #{_.Object} equals: #{Object}!

testEquals
	self assert: (self subjectClass path: #(#Smalltalk))
		equals: (self subjectClass pathString: #Smalltalk).
	self assert: (self subjectClass path: #(#Smalltalk #Object))
		equals: (self subjectClass pathString: 'Smalltalk.Object').
	self deny: (self subjectClass path: #(#Smalltalk)) equals: Object new.
	"BindingReference equality is a stable property based on the path and starting point. Different paths to the same target binding (of which there may be many) are not equal."
	self deny: (self subjectClass path: #(#Core #Object))
		equals: (self subjectClass path: #(#Smalltalk #Object)).
	self assert: (self subjectClass path: #('Core'))
		equals: (self subjectClass simpleName: 'Core' in: Smalltalk).
	"Relative binding references are not equivalent to absolute binding references, even if they would actually bind to the same target - i.e. the equality comparison is based on static equivalence of the reference itself and so is independent of its result when evaluated. This makes sense because it provides a temporally stable comparison for references, whereas the binding to which they evaluate may differ over time, as it depends on other properties of its context that may change after it is created. For example a class may have relative literal binding references in its methods. If the class is moved to a different environment, or its imports are changed, then the value of the binding references may change. In consequence many BindingReferences that are not considered equivalent may eventually bind to the same target binding - this is a necessary condition for BindingReference equivalence at a point in time, but it is not sufficient. BindingReferences are only equivalent if they represent the same binding path and, if relative, from the same starting point. Absolute binding references with the same path are considered equivalent even if they are compiled in a different context, or provided with a different context when instantiated."
	self deny: #'Core.Object' asQualifiedReference equals: #{Object}.
	self assert: #'Core.Object' asQualifiedReference equals: #{Core.Object}.
	self assert: (self subjectClass path: #('Core' 'Object') context: self class)
		equals: 'Core.Object' asQualifiedReference!

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
	self deny: a <= b meta! !
!Kernel.Tests.BindingReferenceTest categoriesFor: #subjectClass!constants!private! !
!Kernel.Tests.BindingReferenceTest categoriesFor: #testAsQualifiedReference!public! !
!Kernel.Tests.BindingReferenceTest categoriesFor: #testEqualityOfRelativeAndAbsolute!public!unit tests! !
!Kernel.Tests.BindingReferenceTest categoriesFor: #testEquals!public!unit tests! !
!Kernel.Tests.BindingReferenceTest categoriesFor: #testIsValidGlobalName!public!unit tests! !
!Kernel.Tests.BindingReferenceTest categoriesFor: #testLessOrEqual!public!unit tests! !

