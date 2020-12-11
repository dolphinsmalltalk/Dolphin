"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'External.Tests.DescriptorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{External.ExtCallArgTypes})
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.DescriptorTest guid: (Core.GUID fromString: '{d809ef14-78cf-4e10-8dc1-0249d46b4b5f}')!
External.Tests.DescriptorTest comment: ''!
!External.Tests.DescriptorTest categoriesForClass!Unclassified! !
!External.Tests.DescriptorTest methodsFor!

externalTypes
	^Descriptor.ValueTypes!

parseStructArg: structClass valueType: typeCodeOrName refType: ptrCodeOrName
	"First pass-by-value"

	| source desc argTypes |
	source := 'cdecl: void ' , structClass name.
	desc := Descriptor newFromString: source environment: Smalltalk.
	argTypes := desc argumentTypes.
	self assert: argTypes size equals: 1.
	desc argumentsDo: 
			[:eachType :eachClass |
			| type |
			type := typeCodeOrName isInteger
						ifTrue: [typeCodeOrName]
						ifFalse: [Descriptor typeFromName: typeCodeOrName].
			self assert: eachType identicalTo: type.
			self assert: eachClass identicalTo: structClass].
	"Now pass-by-ref"
	source := source , '*'.
	desc := Descriptor newFromString: source environment: Smalltalk.
	argTypes := desc argumentTypes.
	self assert: argTypes size equals: 1.
	desc argumentsDo: 
			[:eachType :eachClass |
			| type |
			type := ptrCodeOrName isInteger
						ifTrue: [ptrCodeOrName]
						ifFalse: [Descriptor typeFromName: ptrCodeOrName].
			self assert: eachType identicalTo: type.
			self assert: eachClass identicalTo: structClass]!

testBuiltins
	| typeTable typeNames |
	typeTable := self externalTypes.
	typeNames := Descriptor.TypeNames.
	(typeTable reject: [:each | Descriptor typeHasArgument: each]) keysAndValuesDo: 
			[:eachKey :eachValue |
			| argTypes source desc |
			source := 'cdecl: void ' , eachKey.
			desc := Descriptor newFromString: source environment: External.
			argTypes := desc argumentTypes.
			self assert: argTypes size equals: 1.
			self assert: eachValue isInteger.
			self assert: argTypes first equals: (typeNames at: eachValue + 1).
			source := source , '*'.
			eachKey = 'lppvoid'
				ifTrue: [self should: [Descriptor newFromString: source environment: External] raise: Error]
				ifFalse: 
					[| refType |
					"Single indirection"
					desc := Descriptor newFromString: source environment: Smalltalk.
					argTypes := desc argumentTypes.
					self assert: argTypes size equals: 1.
					refType := Descriptor referenceTypeFor: eachValue.
					refType isInteger
						ifTrue: [self assert: argTypes first equals: (typeNames at: refType + 1)]
						ifFalse: [argTypes first beginsWith: refType].
					"Double indirection"
					source := source , '*'.
					refType == ExtCallArgLPPVOID
						ifTrue: [self should: [Descriptor newFromString: source environment: External] raise: Error]
						ifFalse: 
							[desc := Descriptor newFromString: source environment: External.
							argTypes := desc argumentTypes.
							self assert: argTypes size equals: 1.
							self assert: argTypes first equals: 'lppvoid']]]!

testIndirections
	"Some double indirections"

	| source desc |
	#('lppvoid' 'lpvoid*' 'void**' 'LPVOID*' 'DWORD**' 'POINTL**' 'IUnknown**' 'BSTR*') do: 
			[:each |
			| argTypes |
			source := 'cdecl: void ' , each.
			desc := Descriptor newFromString: source environment: Smalltalk.
			argTypes := desc argumentTypes.
			self assert: argTypes size equals: 1.
			self assert: argTypes first equals: 'lppvoid'].

	"but some cannot be indirected more than once"
	#('lpvoid' 'LPVOID' 'BSTR') do: 
			[:each |
			source := 'cdecl: void ' , each , '**'.
			self should: [Descriptor newFromString: source environment: Smalltalk] raise: Error].

	"lppvoid cannot be further indirected"
	source := 'cdecl: lppvoid*'.
	self should: [Descriptor newFromString: source environment: Smalltalk] raise: Error.

	"Test all classes with an implied level of indirection correctly parsed as lppvoid for <class>*"
	(Smalltalk allClasses select: [:each | each isIndirection]) do: 
			[:each |
			| argTypes |
			source := 'cdecl: void ' , each name , '*'.
			argTypes := desc argumentTypes.
			self assert: argTypes size equals: 1.
			self assert: argTypes first equals: 'lppvoid'.
			source := source , '*'.
			self should: [Descriptor newFromString: source environment: Smalltalk] raise: Error]!

testSharedRegister
	self deny: Descriptor.Shared hasWeakKeys.
	self assert: Descriptor.Shared hasWeakValues!

testSmokeTest
	"Verify that the compiler is parsing the descriptors in the same way as ExternalDescriptor by
	checking the descriptor of every ExternalMethod."

	(ExternalMethod allSubinstances reject: [:each | each isUnbound]) do: 
			[:each |
			| desc text |
			text := each descriptor description.
			desc := Descriptor newFromString: (text copyWithout: $,) environment: each methodClass environment.
			self assert: text equals: desc description]!

testStruct4
	| valueTypes |
	self assert: DWORD byteSize equals: 4.
	valueTypes := Descriptor.ValueTypes.
	
	[Descriptor.ValueTypes := LookupTable with: 'void' -> 0.
	self
		parseStructArg: DWORD
		valueType: ExtCallArgSTRUCT4
		refType: ExtCallArgLP]
			ensure: [Descriptor.ValueTypes := valueTypes]!

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
!External.Tests.DescriptorTest categoriesFor: #externalTypes!accessing!private! !
!External.Tests.DescriptorTest categoriesFor: #parseStructArg:valueType:refType:!private!unit tests! !
!External.Tests.DescriptorTest categoriesFor: #testBuiltins!public!unit tests! !
!External.Tests.DescriptorTest categoriesFor: #testIndirections!public!unit tests! !
!External.Tests.DescriptorTest categoriesFor: #testSharedRegister!public!unit tests! !
!External.Tests.DescriptorTest categoriesFor: #testSmokeTest!public!unit tests! !
!External.Tests.DescriptorTest categoriesFor: #testStruct4!public!unit tests! !
!External.Tests.DescriptorTest categoriesFor: #testStruct8!public!unit tests! !
!External.Tests.DescriptorTest categoriesFor: #testStructs!public!unit tests! !

