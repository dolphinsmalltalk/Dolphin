"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ExternalDescriptorTest
	instanceVariableNames: 'savedShared'
	classVariableNames: ''
	poolDictionaries: 'ExtCallArgTypes'
	classInstanceVariableNames: ''!
ExternalDescriptorTest guid: (GUID fromString: '{d809ef14-78cf-4e10-8dc1-0249d46b4b5f}')!
ExternalDescriptorTest comment: ''!
!ExternalDescriptorTest categoriesForClass!Unclassified! !
!ExternalDescriptorTest methodsFor!

externalTypes
	| typeTable |
	typeTable := ExternalDescriptor classPool at: 'ExternalValueTypes'.
	^typeTable!

newDescriptor: source 
	^ExternalDescriptor newFromString: source!

parseStructArg: structClass valueType: typeCodeOrName refType: ptrCodeOrName
	"First pass-by-value"

	| source desc argTypes |
	source := 'cdecl: void ' , structClass name.
	desc := self newDescriptor: source.
	argTypes := desc argumentTypes.
	self assert: argTypes size equals: 1.
	desc argumentsDo: 
			[:eachType :eachClass |
			| type |
			type := typeCodeOrName isInteger
						ifTrue: [typeCodeOrName]
						ifFalse: [ExternalDescriptor typeFromName: typeCodeOrName].
			self assert: eachType identicalTo: type.
			self assert: eachClass identicalTo: structClass].
	"Now pass-by-ref"
	source := source , '*'.
	desc := self newDescriptor: source.
	argTypes := desc argumentTypes.
	self assert: argTypes size equals: 1.
	desc argumentsDo: 
			[:eachType :eachClass |
			| type |
			type := ptrCodeOrName isInteger
						ifTrue: [ptrCodeOrName]
						ifFalse: [ExternalDescriptor typeFromName: ptrCodeOrName].
			self assert: eachType identicalTo: type.
			self assert: eachClass identicalTo: structClass]!

setUp
	savedShared := ExternalDescriptor.Shared.
	ExternalDescriptor.Shared := nil!

subjectClass
	^ExternalDescriptor!

tearDown
	ExternalDescriptor.Shared := savedShared!

testBuiltins
	| typeTable typeNames |
	typeTable := self externalTypes.
	typeNames := ExternalDescriptor.TypeNames.
	(typeTable reject: [:each | self subjectClass typeHasArgument: each]) keysAndValuesDo: 
			[:eachKey :eachValue |
			| argTypes source desc |
			source := 'cdecl: void ' , eachKey.
			desc := self newDescriptor: source.
			argTypes := desc argumentTypes.
			self assert: eachValue isInteger.
			self assert: argTypes single equals: (typeNames at: eachValue + 1).
			source := source , '*'.
			eachKey = 'lppvoid'
				ifTrue: [self should: [self newDescriptor: source] raise: Error]
				ifFalse: 
					[| refType |
					"Single indirection"
					desc := self newDescriptor: source.
					argTypes := desc argumentTypes.
					refType := self subjectClass referenceTypeFor: eachValue.
					refType isInteger
						ifTrue: [self assert: argTypes single equals: (typeNames at: refType + 1)]
						ifFalse: [argTypes single beginsWith: refType].
					"Double indirection"
					source := source , '*'.
					desc := self subjectClass fromString: source.
					argTypes := desc argumentTypes.
					self assert: argTypes single equals: 'lppvoid']]!

testIndirections
	"Some double indirections"

	#('lppvoid' 'lpvoid*' 'void**' 'LPVOID*' 'DWORD**' 'POINTL**' 'IUnknown**' 'BSTR*') do: 
			[:each |
			| desc |
			desc := self subjectClass fromString: 'cdecl: void ' , each.
			self assert: desc argumentTypes single equals: 'lppvoid'].

	"but some cannot be indirected more than once"
	#('lpvoid' 'LPVOID' 'BSTR') do: 
			[:each |
			| desc |
			desc := [self subjectClass fromString: 'cdecl: void ' , each , '**'] on: Notification
						do: [:ex | ex resume].
			self assert: desc argumentTypes single equals: 'lppvoid'].

	"lppvoid cannot be further indirected"
	self should: [self subjectClass fromString: 'cdecl: lppvoid*'] raise: Error.

	"Test all classes with an implied level of indirection correctly parsed as lppvoid for <class>*"
	(Smalltalk allClasses select: [:each | each isIndirection]) do: 
			[:each |
			| source desc |
			source := 'cdecl: void ' , each name , '*'.
			desc := self subjectClass fromString: source.
			self assert: desc argumentTypes single equals: 'lppvoid'.
			source := source , '*'.
			self should: [desc := self subjectClass fromString: source] raise: Notification]!

testSharedRegister
	self deny: savedShared hasWeakKeys.
	self assert: savedShared hasWeakValues!

testSmokeTest
	"Verify that the compiler is parsing the descriptors in the same way as ExternalDescriptor by
	checking the descriptor of every ExternalMethod."

	(ExternalMethod allSubinstances reject: [:each | each isUnbound]) do: 
			[:each |
			| desc text |
			text := each descriptor description.
			desc := self newDescriptor: (text copyWithout: $,).
			self assert: text equals: desc description]!

testStruct4
	| valueTypes |
	self assert: DWORD byteSize equals: 4.
	valueTypes := ExternalDescriptor.ExternalValueTypes.
	
	[ExternalDescriptor.ExternalValueTypes := LookupTable with: 'void' -> 0.
	self
		parseStructArg: DWORD
		valueType: ExtCallArgSTRUCT4
		refType: ExtCallArgLP]
			ensure: [ExternalDescriptor.ExternalValueTypes := valueTypes]!

testStruct8
	self assert: FILETIME byteSize equals: 8.
	self
		parseStructArg: FILETIME
		valueType: ExtCallArgSTRUCT8
		refType: ExtCallArgLP!

testStructs
	self assert: _FPIEEE_VALUE byteSize > 8.
	self
		parseStructArg: _FPIEEE_VALUE
		valueType: ExtCallArgSTRUCT
		refType: ExtCallArgLP! !
!ExternalDescriptorTest categoriesForMethods!
externalTypes!accessing!private! !
newDescriptor:!private!unit tests! !
parseStructArg:valueType:refType:!private!unit tests! !
setUp!public! !
subjectClass!public!unit tests! !
tearDown!public! !
testBuiltins!public!unit tests! !
testIndirections!public!unit tests! !
testSharedRegister!public!unit tests! !
testSmokeTest!public!unit tests! !
testStruct4!public!unit tests! !
testStruct8!public!unit tests! !
testStructs!public!unit tests! !
!

