"Filed out from Dolphin Smalltalk"!

Kernel.Tests.ScopedBindingReferenceTest
	subclass: #'Kernel.Tests.MetaBindingReferenceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.MetaBindingReferenceTest guid: (Core.GUID fromString: '{fd978d4f-c029-4293-a636-297a14b7fa15}')!
Kernel.Tests.MetaBindingReferenceTest comment: ''!
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
	inst := BindingReference pathString: 'Object'.
	subject := inst meta.
	self assert: subject instance identicalTo: inst!

testLessOrEqual
	| a b |
	super testLessOrEqual.
	a := self newSubjectWithPathString: 'Core.Object'.
	b := self newSubjectWithPathString: 'Core.object'.
	self deny: a <= b instance.
	self assert: a <=> b equals: 0.
	self deny: a <= b instance.
	self assert: a <=> b instance equals: 1!

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
	subject := self newSubjectWithPathString: 'Object'.
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
			subject := self newSubjectWithPathString: pathString.
			self assert: subject pathString
				equals: (path first = '_' ifTrue: [pathString copyFrom: 3] ifFalse: [pathString])].
	subject := self newSubjectWithPathString: ''.
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
			subject := BindingReference pathString: each.
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

testStbConvertFromVersion1
	| subject expected |
	subject := Object
				fromBinaryStoreBytes: #[33 83 84 66 32 52 32 6 1 27 0 75 101 114 110 101 108 46 77 101 116 97 66 105 110 100 105 110 103 82 101 102 101 114 101 110 99 101 70 5 23 0 1 0 0 0 75 101 114 110 101 108 46 66 105 110 100 105 110 103 82 101 102 101 114 101 110 99 101 18 1 0 0 11 0 0 0 67 111 114 101 46 79 98 106 101 99 116 0 0 0 0 16 0 0 0 0 0 0 0 0 0 0 0].
	self deny: subject isRelative.
	expected := MetaBindingReference pathString: 'Core.Object' private: true.
	self assert: subject equals: expected.
	self assert: subject value identicalTo: Object class!

testStbConvertRelativeFromVersion1
	| subject expected |
	subject := Object
				fromBinaryStoreBytes: #[33 83 84 66 32 52 32 6 1 27 0 75 101 114 110 101 108 46 77 101 116 97 66 105 110 100 105 110 103 82 101 102 101 114 101 110 99 101 70 6 31 0 1 0 0 0 75 101 114 110 101 108 46 82 101 108 97 116 105 118 101 66 105 110 100 105 110 103 82 101 102 101 114 101 110 99 101 18 1 0 0 6 0 0 0 79 98 106 101 99 116 0 0 0 0 32 0 0 0 0 0 0 0 0 0 0 0 154 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 4 0 0 0 67 111 114 101].
	self assert: subject isRelative.
	expected := MetaBindingReference pathString: 'Object' scope: Core.
	self assert: subject equals: expected.
	self assert: subject value identicalTo: Object class!

testStlConvertFromVersion1
	| subject expected |
	expected := MetaBindingReference pathString: 'Core.Object' private: true.
	subject := Compiler
				evaluate: '(Object fromLiteralStoreArray: #(#''!!STL'' 4 1769734 ##(Kernel.MetaBindingReference) 1508678 1 ##(Kernel.BindingReference) 8 ''Core.Object'' nil true nil nil))'.
	self deny: subject isRelative.
	self assert: subject equals: expected.
	self assert: subject value identicalTo: Object class!

testStlConvertRelativeFromVersion1
	| subject expected |
	expected := MetaBindingReference pathString: 'Object' scope: Core.
	subject := Compiler
				evaluate: '(Object fromLiteralStoreArray: #(#''!!STL'' 4 1769734 ##(Kernel.MetaBindingReference) 2033222 1 ##(Kernel.RelativeBindingReference) 8 ''Object'' nil false nil nil ##(Core)))'.
	self assert: subject isRelative.
	self assert: subject equals: expected.
	self assert: subject value identicalTo: Object class!

valueOfBinding: aVariableBinding
	^aVariableBinding value class! !
!Kernel.Tests.MetaBindingReferenceTest categoriesForMethods!
nameSuffix!constants!private! !
printStringTestCases!constants!private! !
subjectClass!constants!private! !
testEqualityOfMetaAndInstance!public!unit tests! !
testInstance!public!unit tests! !
testLessOrEqual!public!unit tests! !
testLiteral!public!unit tests! !
testLiteralImplicitEnvironmentRelative!public!unit tests! !
testMeta!public!unit tests! !
testPathPrivateScope!public!unit tests! !
testPathString!public!unit tests! !
testPathStringScope!public!unit tests! !
testPathStringWithClass!public!unit tests! !
testRefersToLiteral!public!unit tests! !
testStbConvertFromVersion1!public!unit tests! !
testStbConvertRelativeFromVersion1!public!unit tests! !
testStlConvertFromVersion1!public!unit tests! !
testStlConvertRelativeFromVersion1!public!unit tests! !
valueOfBinding:!helpers!private! !
!

