"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'External.Tests.FunctionDescriptorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{External.ExtCallArgTypes})
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.FunctionDescriptorTest guid: (Core.GUID fromString: '{d809ef14-78cf-4e10-8dc1-0249d46b4b5f}')!
External.Tests.FunctionDescriptorTest comment: ''!
!External.Tests.FunctionDescriptorTest methodsFor!

externalTypes
	^FunctionDescriptor.ValueTypes!

parseStructArg: structClass valueType: typeCodeOrName refType: ptrCodeOrName
	"First pass-by-value"

	| source desc argTypes |
	source := 'cdecl: void ' , structClass name.
	desc := self subjectClass fromString: source environment: Smalltalk.
	argTypes := desc argumentTypes.
	self assert: argTypes size equals: 1.
	desc argumentsDo: 
			[:eachType :eachClass |
			| type |
			type := typeCodeOrName isInteger
						ifTrue: [typeCodeOrName]
						ifFalse: [self subjectClass typeFromName: typeCodeOrName].
			self assert: eachType identicalTo: type.
			self assert: eachClass identicalTo: structClass].
	"Now pass-by-ref"
	source := source , '*'.
	desc := self subjectClass fromString: source environment: Smalltalk.
	argTypes := desc argumentTypes.
	self assert: argTypes size equals: 1.
	desc argumentsDo: 
			[:eachType :eachClass |
			| type |
			type := ptrCodeOrName isInteger
						ifTrue: [ptrCodeOrName]
						ifFalse: [self subjectClass typeFromName: ptrCodeOrName].
			self assert: eachType identicalTo: type.
			self assert: eachClass identicalTo: structClass]!

subjectClass
	^FunctionDescriptor!

testBuiltins
	| typeTable typeNames |
	typeTable := self externalTypes.
	typeNames := FunctionDescriptor.TypeNames.
	(typeTable reject: [:each | self subjectClass typeHasArgument: each]) keysAndValuesDo: 
			[:eachKey :eachValue |
			| argTypes source desc |
			source := 'cdecl: void ' , eachKey.
			desc := self subjectClass fromString: source environment: External.
			argTypes := desc argumentTypes.
			self assert: eachValue isInteger.
			self assert: argTypes single equals: (typeNames at: eachValue + 1).
			source := source , '*'.
			eachKey = 'lppvoid'
				ifTrue: [self should: [self subjectClass fromString: source environment: External] raise: Error]
				ifFalse: 
					[| refType |
					"Single indirection"
					desc := self subjectClass fromString: source environment: Smalltalk.
					argTypes := desc argumentTypes.
					refType := self subjectClass referenceTypeFor: eachValue.
					refType isInteger
						ifTrue: [self assert: argTypes single equals: (typeNames at: refType + 1)]
						ifFalse: [argTypes single beginsWith: refType].
					"Double indirection"
					source := source , '*'.
					desc := self subjectClass fromString: source environment: External.
					argTypes := desc argumentTypes.
					self assert: argTypes single equals: 'lppvoid']]!

testIndirections
	"Some double indirections"

	#('lppvoid' 'lpvoid*' 'void**' 'LPVOID*' 'UInt32**' 'POINTL**' 'IUnknown**' 'BSTR*') do: 
			[:each |
			| desc |
			desc := self subjectClass fromString: 'cdecl: void ' , each environment: Smalltalk.
			self assert: desc argumentTypes single equals: 'lppvoid'].

	"but some cannot be indirected more than once"
	#('lpvoid' 'LPVOID' 'BSTR') do: 
			[:each |
			| desc notification |
			desc := [self subjectClass fromString: 'cdecl: void ' , each , '**' environment: Smalltalk]
						on: Notification
						do: 
							[:ex |
							notification := ex.
							ex resume].
			self assert: desc argumentTypes single equals: 'lppvoid'].

	"lppvoid cannot be further indirected"
	self should: [self subjectClass fromString: 'cdecl: lppvoid*' environment: Smalltalk] raise: Error.

	"Test all classes with an implied level of indirection correctly parsed as lppvoid for <class>*"
	(Smalltalk allClasses select: [:each | each isIndirection]) do: 
			[:each |
			| source desc |
			source := 'cdecl: void ' , each name , '*'.
			desc := self subjectClass fromString: source environment: each environment.
			self assert: desc argumentTypes single equals: 'lppvoid'.
			source := source , '*'.
			self should: [desc := self subjectClass fromString: source environment: each environment]
				raise: Notification]!

testSmokeTest
	"Verify that the compiler is parsing the descriptors in the same way as FunctionDescriptor by
	checking the descriptor of every ExternalMethod."

	(ExternalMethod allSubinstances reject: [:each | each isUnbound]) do: 
			[:each |
			| desc text |
			text := each descriptor printDescription.
			desc := self subjectClass fromString: (text copyWithout: $,)
						environment: each methodClass environment.
			self assert: text equals: desc printDescription]!

testStruct4
	| valueTypes |
	self assert: UInt32 byteSize equals: 4.
	self assert: UInt32 basicByteSize equals: 4.
	valueTypes := self externalTypes.
	
	[#{FunctionDescriptor.ValueTypes} binding setValue: (LookupTable with: 'void' -> 0).
	self
		parseStructArg: UInt32
		valueType: ExtCallArgSTRUCT4
		refType: ExtCallArgLP]
			ensure: [#{FunctionDescriptor.ValueTypes} binding setValue: valueTypes]!

testStruct8
	self assert: FILETIME byteSize equals: 8.
	self assert: FILETIME basicByteSize equals: 8.
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
!External.Tests.FunctionDescriptorTest categoriesForMethods!
externalTypes!accessing!private! !
parseStructArg:valueType:refType:!private!unit tests! !
subjectClass!constants!private! !
testBuiltins!public!unit tests! !
testIndirections!public!unit tests! !
testSmokeTest!public!unit tests! !
testStruct4!public!unit tests! !
testStruct8!public!unit tests! !
testStructs!public!unit tests! !
!

