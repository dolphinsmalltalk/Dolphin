"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.BindingReferenceTest'
	instanceVariableNames: ''
	classVariableNames: 'TestVar'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.BindingReferenceTest guid: (Core.GUID fromString: '{aca86665-9b25-4f35-bdb8-0c0e434df4e6}')!
Kernel.Tests.BindingReferenceTest isNonInstantiable: true!
Kernel.Tests.BindingReferenceTest comment: ''!
!Kernel.Tests.BindingReferenceTest methodsFor!

bindingTestCases
	^self subclassResponsibility!

nameSuffix
	^''!

newSubjectWithPath: anArray
	| subject |
	subject := self subjectClass path: anArray.
	self assert: subject isImmutable.
	^subject!

newSubjectWithPath: anArray scope: aBindingScope
	| subject |
	subject := self subjectClass path: anArray scope: aBindingScope.
	self assert: subject isImmutable.
	^subject!

newSubjectWithPathString: pathString
	| subject |
	subject := self subjectClass pathString: pathString.
	self assert: subject isImmutable.
	^subject!

newSubjectWithPathString: pathString scope: aBindingScope
	| subject |
	subject := self subjectClass pathString: pathString scope: aBindingScope.
	self assert: subject isImmutable.
	^subject!

pathTestCases
	^self subclassResponsibility!

printStringTestCases
	^self subclassResponsibility!

subjectClass
	self subclassResponsibility!

testAppend
	| subject nested |
	"Class variables can be bound on both sides, so this should work for meta binding refs too."
	subject := self newSubjectWithPath: #(#Core #Object).
	nested := subject append: '_EventsRegister'.
	self assert: nested binding identicalTo: (Object localBindingFor: #_EventsRegister)!

testAsNamespaceImport
	| subject import |
	"Class"
	subject := self newSubjectWithPath: #(#Core #Object).
	import := subject asNamespaceImport.
	self assert: import equals: subject.
	"Namespace"
	subject := self newSubjectWithPath: #(#XProgramming #SUnit).
	import := subject asNamespaceImport.
	self assert: import equals: subject.
	"Missing"
	subject := self newSubjectWithPath: #(#Core 'Blah').
	import := subject asNamespaceImport.
	self assert: import equals: subject.
	"Not an importable namespace"
	subject := self newSubjectWithPath: #(#Core #Object '_EventsRegister').
	self
		should: [subject asNamespaceImport]
		raise: Error
		matching: [:ex | ex messageText = 'Invalid import: #{Core.Object._EventsRegister}']!

testAsQualifiedReference
	| subject |
	subject := self newSubjectWithPath: #(#'Core.Object').
	self assert: subject asQualifiedReference identicalTo: subject!

testAsString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self newSubjectWithPath: each first scope: each second value.
			self assert: subject asString equals: (each last copyFrom: 3 to: each last size - 1)]!

testAsSymbol
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self newSubjectWithPath: each first scope: each second value.
			self assert: subject asSymbol identicalTo: (each last copyFrom: 3 to: each last size - 1) asSymbol]!

testBinding
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each last.
			subject := self newSubjectWithPath: each first scope: each second.
			path
				ifNil: [self should: [subject binding] raise: NotFoundError]
				ifNotNil: 
					[| expected actual |
					actual := subject binding.
					expected := Smalltalk resolveBindingPath: path.
					self assert: actual identicalTo: expected]]!

testBindingOrNil
	| subject |
	self bindingTestCases do: 
			[:each |
			| actual path |
			actual := (self newSubjectWithPath: each first scope: each second) bindingOrNil.
			path := each last.
			path
				ifNil: [self assertIsNil: actual]
				ifNotNil: 
					[| expected |
					expected := Smalltalk resolveBindingPath: path.
					self assert: actual identicalTo: expected]].
	"Check that we don't arbitrarily bind class variables of Object"
	subject := BindingReference pathString: '_EventsRegister'.
	self assertIsNil: subject bindingOrNil!

testBindingScope
	^self subclassResponsibility!

testEnvironmentName
	#('Core.Object' 'Core' 'Smalltalk' nil 'Root' nil 'Root.Smalltalk' 'Root' 'Smalltalk.Animal' 'Smalltalk' 'Animal' nil 'XProgramming.SUnit' 'XProgramming' 'XProgramming.SUnit.TestRunConsoleLogger' 'XProgramming.SUnit')
		pairsDo: 
			[:each :expected |
			| subject |
			subject := self newSubjectWithPathString: each.
			self assert: subject environmentName equals: expected]!

testEquals
	| subject1 subject2 |
	subject1 := self newSubjectWithPath: #(#Smalltalk).
	subject2 := self newSubjectWithPathString: #Smalltalk.
	self assert: subject1 equals: subject2.
	self assert: subject1 <=> subject2 equals: 0.
	self assert: subject1 <==> subject2 equals: 0.
	subject1 := self newSubjectWithPath: #(#Smalltalk #Object).
	subject2 := self newSubjectWithPathString: 'Smalltalk.Object'.
	self assert: subject1 equals: subject2.
	self assert: subject1 <=> subject2 equals: 0.
	self assert: subject1 <==> subject2 equals: 0.
	self deny: (self newSubjectWithPath: #(#Smalltalk)) equals: Object new.
	"BindingReference equality is a stable property based on the path and starting point. Different paths to the same target binding (of which there may be many) are not equal."
	subject1 := self newSubjectWithPath: #(#Core #Object).
	subject2 := self newSubjectWithPath: #(#Smalltalk #Object).
	self deny: subject1 equals: subject2.
	self assert: subject1 <=> subject2 equals: -1.
	self assert: subject2 <=> subject1 equals: 1.
	self assert: subject1 <==> subject2 equals: -1.
	self assert: subject2 <==> subject1 equals: 1!

testHash
	self assert: (self newSubjectWithPath: #(#Kernel 'OpcodePool' 'Nop')) hash
		equals: (self newSubjectWithPathString: 'Kernel.OpcodePool.Nop') hash.
	"Same target variable, but different paths, so different hashes."
	self deny: (self newSubjectWithPath: #(#Core 'Object')) hash
		equals: (self newSubjectWithPath: #(#Smalltalk 'Object')) hash.
	self deny: (self newSubjectWithPath: #(#Core)) hash
		equals: (self newSubjectWithPath: #(#Smalltalk)) hash!

testHome
	self subclassResponsibility!

testIfDefined
	self bindingTestCases do: 
			[:each |
			| subject actual path expected |
			subject := self newSubjectWithPath: each first scope: each second.
			actual := subject ifDefined: [:value | value].
			path := each last.
			expected := path isNil ifFalse: [self valueOfBinding: (Smalltalk resolveBindingPath: path)].
			self assert: actual identicalTo: expected]!

testIfDefinedIfNotDefined
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self newSubjectWithPath: each first scope: each second.
			subject ifDefined: 
					[:value |
					self assert: value identicalTo: (self valueOfBinding: (Smalltalk resolveBindingPath: each last))]
				ifNotDefined: [self assertIsNil: each last]]!

testInstance
	| subject |
	subject := self newSubjectWithPathString: 'Object'.
	self assert: subject instance identicalTo: subject!

testIsDefined
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self newSubjectWithPath: each first scope: each second.
			self assert: subject isDefined equals: each last notNil]!

testIsLiteral
	| subject |
	subject := self newSubjectWithPath: #(#Core #Object) scope: nil.
	self assert: subject isLiteral.
	self assert: subject private isLiteral!

testIsRelative
	| subject |
	subject := self newSubjectWithPath: #(#Object) scope: Core.
	self assert: subject isRelative.
	subject := self newSubjectWithPath: #('_' #SUnit #TestCase) scope: XProgramming.
	self assert: subject isRelative.
	subject := self newSubjectWithPath: #(#Object) scope: Association.
	self assert: subject isRelative.
	subject := self newSubjectWithPath: #(#Core #Object) scope: nil.
	self deny: subject isRelative.
	"If the path has multiple components, then unless the first component is '_', it is assumed to be an absolute path and the context is ignored"
	subject := self newSubjectWithPath: #(#Core #Object) scope: Association.
	self deny: subject isRelative!

testIsSelfEvaluating
	| subject |
	subject := self newSubjectWithPath: #(#Core #Object) scope: nil.
	self assert: subject isSelfEvaluating.
	self assert: subject private isSelfEvaluating!

testLessOrEqual
	| a a1 b |
	a := self newSubjectWithPathString: 'Core.Object'.
	a1 := self newSubjectWithPathString: 'Core.Object'.
	b := self newSubjectWithPathString: 'Core.object'.
	self assert: a <= a.
	self assert: a <=> a equals: 0.
	self assert: a <==> a equals: 0.
	self assert: a <= a1.
	self assert: a <=> a1 equals: 0.
	self assert: a <==> a1 equals: 0.
	self assert: a1 <= a.
	self assert: a1 <=> a equals: 0.
	self assert: a1 <==> a equals: 0.
	self deny: a <= b.
	self assert: a <=> b equals: 0.
	self assert: a <==> b equals: 1.
	self assert: b <=> a equals: 0.
	self assert: b <==> a equals: -1!

testMeta
	| subject meta |
	subject := self newSubjectWithPathString: #'Core.Object'.
	meta := subject meta.
	self assert: subject meta isMeta.
	self assert: meta value identicalTo: Object class!

testPath
	self pathTestCases do: 
			[:each |
			| subject |
			subject := self newSubjectWithPath: each first scope: each second.
			self assert: subject path equals: each last]!

testPathString
	| subject pathString |
	self bindingTestCases do: 
			[:each |
			| path |
			path := each first.
			pathString := $. join: path.
			subject := self newSubjectWithPathString: pathString.
			self assert: subject path equals: (path copyWithout: '_')].
	subject := self newSubjectWithPathString: ''.
	self assert: subject path equals: #()!

testPathStringScope
	| subject pathString |
	self bindingTestCases do: 
			[:each |
			| path |
			path := each first.
			pathString := $. join: path.
			subject := self newSubjectWithPathString: pathString scope: each second.
			path first = '_'
				ifTrue: 
					[self assert: subject path equals: path allButFirst.
					self assert: subject pathString equals: (pathString copyFrom: 3)]
				ifFalse: 
					[self assert: subject path equals: path.
					self assert: subject pathString equals: pathString]].
	subject := self newSubjectWithPathString: ''.
	self assert: subject path equals: #()!

testPrintString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self newSubjectWithPath: each first scope: self class.
			self assert: subject printString equals: each last.
			subject := self
						newSubjectWithPathString: (each last copyFrom: 3 to: (each last indexOfAnyOf: ' }' startingAt: 3) - 1)
						scope: self class.
			self assert: subject printString equals: each last]!

testPrivate
	| subject private |
	subject := self newSubjectWithPathString: 'Object'.
	self deny: subject isPrivate.
	self deny: subject isRelative.
	private := subject private.
	self assert: private isPrivate.
	self deny: private isRelative.
	self deny: subject equals: private.
	BindingReference pathString: 'Object' scope: Core!

testPrivateRelative
	| subject private |
	subject := BindingReference pathString: 'Object' scope: Core.
	self deny: subject isPrivate.
	self assert: subject isRelative.
	private := subject private.
	self assert: private isPrivate.
	self assert: private isRelative.
	self deny: subject equals: private!

testRefersToLiteralClass
	| method objectRef |
	method := self class lookupMethod: testSelector.
	objectRef := self newSubjectWithPathString: #'Core.Object'.
	self assert: (objectRef refersTo: (self newSubjectWithPath: #(#Core #Object)) asLiteralOf: method).
	".. and the binding to which it would resolve ..."
	self assert: (objectRef refersTo: Object binding asLiteralOf: method).
	"... and the target class."
	self assert: (objectRef refersTo: Object asLiteralOf: method).
	self deny: (objectRef refersTo: nil asLiteralOf: method).
	"Should refer to the Namespace too"
	self assert: (objectRef refersTo: Core asLiteralOf: method).
	"And so on up the namespace hierarchy"
	self assert: (objectRef refersTo: Root asLiteralOf: method)!

testRefersToLiteralNotFound
	| method objectRef |
	method := self class lookupMethod: testSelector.
	objectRef := self newSubjectWithPathString: #'Core.Object2'.
	self deny: (objectRef refersTo: (self newSubjectWithPath: #(#Core #Object)) asLiteralOf: method).
	".. and the binding to which it would resolve ..."
	self deny: (objectRef refersTo: Object binding asLiteralOf: method).
	"... and the target class."
	self deny: (objectRef refersTo: Object asLiteralOf: method).
	self deny: (objectRef refersTo: nil asLiteralOf: method).
	"It doesn't refer to the namespace along the path either. This could perhaps be correct either way, but as the reference itself doesn't resolve it doesn't really refer to anything."
	self deny: (objectRef refersTo: Core asLiteralOf: method)!

testRelativeNoScope
	self should: [self newSubjectWithPath: #('_' 'Object')] raise: Error!

testShortName
	#(#Root #Smalltalk #Core #'Core.Class' #'Kernel.BindingContext') do: 
			[:each |
			| subject |
			subject := self newSubjectWithPathString: each.
			self assert: subject shortName equals: ($. split: each) last , self nameSuffix.
			self assert: subject shortName equals: subject simpleName].
	#('XProgramming.SUnit' 'XProgramming.SUnit.TestRunConsoleLogger') do: 
			[:each |
			| subject |
			subject := self newSubjectWithPathString: each.
			self assert: subject shortName equals: subject pathString , self nameSuffix.
			self deny: subject shortName equals: subject simpleName]!

testStoreString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self newSubjectWithPath: each first scope: Smalltalk.
			self assert: subject storeString equals: each last]!

testUnqualifiedName
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each first.
			subject := self newSubjectWithPath: path scope: each second.
			self assert: subject unqualifiedName equals: path last , self nameSuffix]!

testValue
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each last.
			subject := self newSubjectWithPath: each first scope: each second.
			path
				ifNil: [self should: [subject value] raise: NotFoundError]
				ifNotNil: 
					[| expected actual |
					actual := subject value.
					expected := self valueOfBinding: (Smalltalk resolveBindingPath: path).
					self assert: actual identicalTo: expected]]!

testValueOrNil
	self bindingTestCases do: 
			[:each |
			| path subject expected actual |
			subject := self newSubjectWithPath: each first scope: each second.
			actual := subject valueOrNil.
			path := each last.
			expected := path ifNotNil: [self valueOfBinding: (Smalltalk resolveBindingPath: path)].
			self assert: actual identicalTo: expected]!

valueOfBinding: aVariableBinding
	^aVariableBinding value! !
!Kernel.Tests.BindingReferenceTest categoriesForMethods!
bindingTestCases!constants!private! !
nameSuffix!constants!private! !
newSubjectWithPath:!helpers!private! !
newSubjectWithPath:scope:!helpers!private! !
newSubjectWithPathString:!helpers!private! !
newSubjectWithPathString:scope:!helpers!private! !
pathTestCases!private!unit tests! !
printStringTestCases!constants!private! !
subjectClass!constants!private! !
testAppend!public!unit tests! !
testAsNamespaceImport!public!unit tests! !
testAsQualifiedReference!public!unit tests! !
testAsString!public!unit tests! !
testAsSymbol!public!unit tests! !
testBinding!public!unit tests! !
testBindingOrNil!public!unit tests! !
testBindingScope!public!unit tests! !
testEnvironmentName!public!unit tests! !
testEquals!public!unit tests! !
testHash!public!unit tests! !
testHome!public!unit tests! !
testIfDefined!public!unit tests! !
testIfDefinedIfNotDefined!public!unit tests! !
testInstance!public!unit tests! !
testIsDefined!public!unit tests! !
testIsLiteral!public!unit tests! !
testIsRelative!public!unit tests! !
testIsSelfEvaluating!public!unit tests! !
testLessOrEqual!public!unit tests! !
testMeta!public!unit tests! !
testPath!public!unit tests! !
testPathString!public!unit tests! !
testPathStringScope!public!unit tests! !
testPrintString!public!unit tests! !
testPrivate!public!unit tests! !
testPrivateRelative!public!unit tests! !
testRefersToLiteralClass!public!unit tests! !
testRefersToLiteralNotFound!public!unit tests! !
testRelativeNoScope!public!unit tests! !
testShortName!public!unit tests! !
testStoreString!public!unit tests! !
testUnqualifiedName!public!unit tests! !
testValue!public!unit tests! !
testValueOrNil!public!unit tests! !
valueOfBinding:!helpers!private! !
!

