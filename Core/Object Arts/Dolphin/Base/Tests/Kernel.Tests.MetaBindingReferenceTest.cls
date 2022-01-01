"Filed out from Dolphin Smalltalk"!

Kernel.Tests.AbstractBindingReferenceTest subclass: #'Kernel.Tests.MetaBindingReferenceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.MetaBindingReferenceTest guid: (Core.GUID fromString: '{fd978d4f-c029-4293-a636-297a14b7fa15}')!
Kernel.Tests.MetaBindingReferenceTest comment: ''!
!Kernel.Tests.MetaBindingReferenceTest categoriesForClass!Unclassified! !
!Kernel.Tests.MetaBindingReferenceTest methodsFor!

nameSuffix
	^' class'!

printStringTestCases
	^#(#(#(#Object) '#{Object class}') #(#('A' 'B' 'C') '#{A.B.C class}')  #(#('_' 'SUnit' 'TestCase') '#{_.SUnit.TestCase class}'))!

subjectClass
	^MetaBindingReference!

testEqualityOfMetaAndInstance
	"Meta and instance references should never be equal, whether or not the path is the same."

	self deny: #{Core.Object class} equals: #{Core.Object}.
	self deny: #{_.Object class} equals: #{_.Object}
!

testInstance
	| inst subject |
	inst := AbstractBindingReference pathString: 'Object'.
	subject := inst meta.
	self assert: subject instance identicalTo: inst!

testLessOrEqual
	| a b |
	super testLessOrEqual.
	a := self subjectClass pathString: 'Core.Object'.
	b := self subjectClass pathString: 'Core.object'.
	self deny: a <= b instance.
	self deny: a <= b instance!

testLiteral
	| subject |
	#(#{Object class} #{_.Object class} #{_.Core.Object class}) do: 
			[:each |
			"When a relative literal BindingReference is compiled in a method in the method class' namespace, then the context can be the method class"
			self assert: each scope identicalTo: ##(self).
			self assert: each valueOrNil identicalTo: Object class].
	"Absolute references always have nil context"
	subject := #{Core.Object class}.
	self assertIsNil: subject scope.
	self assert: subject valueOrNil identicalTo: Object class!

testLiteralImplicitEnvironmentRelative
	| method source |
	source := 'thisTestClass ^#{<1s> class} valueOrNil' << self class unqualifiedName.
	method := Compiler compile: source in: Object.
	"The unqualified name of this class should not normally be bindable from a method of Core.Object"
	self assertIsNil: (method value: Object new withArguments: #()).
	"But when compiled in the Kernel.Tests environment, it should resolve"
	method := Compiler
				compile: source
				in: Object
				environment: self class environment.
	self assert: method environment identicalTo: self class environment.
	self assert: (method value: Object new withArguments: #()) identicalTo: self class class!

testMeta
	| subject |
	subject := self subjectClass pathString: 'Object'.
	self assert: subject meta identicalTo: subject!

testPathPrivateScope
	| subject |
	subject := MetaBindingReference
				path: #('MetaBindingReferenceTest')
				private: true
				scope: Kernel.Tests.
	self assert: subject value identicalTo: self class class.
	subject := MetaBindingReference
				path: #('_' 'Tests' 'MetaBindingReferenceTest')
				private: true
				scope: Kernel.
	self assert: subject value identicalTo: self class class!

testPathString
	| subject pathString |
	self bindingTestCases do: 
			[:each |
			| path |
			path := each first.
			pathString := $. join: path.
			subject := self subjectClass pathString: pathString.
			self assert: subject pathString
				equals: (path first = '_' ifTrue: [pathString copyFrom: 3] ifFalse: [pathString])].
	subject := self subjectClass pathString: ''.
	self assert: subject path equals: #()!

testPathStringScope
	| subject |
	subject := MetaBindingReference
				pathString: 'MetaBindingReferenceTest'
				scope: Kernel.Tests.
	self assert: subject value identicalTo: self class class.
	subject := MetaBindingReference
				pathString: '_.Tests.MetaBindingReferenceTest'
				scope: Kernel.
	self assert: subject value identicalTo: self class class!

testPathStringWithClass
	#('Association class' 'Core.Association class' 'Association private class' 'Core.Association class private')
		do: 
			[:each |
			| subject |
			subject := AbstractBindingReference pathString: each.
			self assert: subject value identicalTo: Association class]!

testRefersToLiteral
	| method |
	method := self class >> testSelector.
	"A BindingReference matches literals for the same path..."

	"self assert: (Object class fullyQualifiedReference refersToLiteral: (self subjectClass pathString: 'Object'))."

	".. and the binding to which it would resolve ..."

	self assert: (#{Object class} refersTo: Object binding asLiteralOf: method).
	"... but not the target value."
	self deny: (#{Object class} refersTo: #{Object class} value asLiteralOf: method)!

valueOfBinding: aVariableBinding
	^aVariableBinding value class! !
!Kernel.Tests.MetaBindingReferenceTest categoriesForMethods!
nameSuffix!constants!private! !
printStringTestCases!constants!private! !
subjectClass!constants!private! !
testEqualityOfMetaAndInstance!public!unit tests! !
testInstance!public!unit tests! !
testLessOrEqual!public!unit tests! !
testLiteral!public! !
testLiteralImplicitEnvironmentRelative!public! !
testMeta!public!unit tests! !
testPathPrivateScope!public! !
testPathString!public!unit tests! !
testPathStringScope!public! !
testPathStringWithClass!public!unit tests! !
testRefersToLiteral!public!unit tests! !
valueOfBinding:!helpers!private! !
!

