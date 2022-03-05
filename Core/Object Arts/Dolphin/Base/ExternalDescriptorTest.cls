"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ExternalDescriptorTest
	instanceVariableNames: ''
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

testBuiltins
	| typeTable typeNames |
	typeTable := self externalTypes.
	typeNames := ExternalDescriptor classPool at: 'TypeNames'.
	(typeTable reject: [:each | ExternalDescriptor typeHasArgument: each]) keysAndValuesDo: 
			[:eachKey :eachValue |
			| argTypes source desc |
			source := 'cdecl: void ' , eachKey.
			desc := self newDescriptor: source.
			argTypes := desc argumentTypes.
			self assert: argTypes size equals: 1.
			self assert: eachValue isInteger.
			self assert: argTypes first equals: (typeNames at: eachValue + 1).
			source := source , '*'.
			eachKey = 'lppvoid'
				ifTrue: [self should: [self newDescriptor: source] raise: Error]
				ifFalse: 
					[| refType |
					"Single indirection"
					desc := self newDescriptor: source.
					argTypes := desc argumentTypes.
					self assert: argTypes size equals: 1.
					refType := ExternalDescriptor referenceTypeFor: eachValue.
					refType isInteger
						ifTrue: [self assert: argTypes first equals: (typeNames at: refType + 1)]
						ifFalse: [argTypes first beginsWith: refType].
					"Double indirection"
					source := source , '*'.
					refType == ExtCallArgLPPVOID
						ifTrue: [self should: [self newDescriptor: source] raise: Error]
						ifFalse: 
							[desc := self newDescriptor: source.
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
			desc := self newDescriptor: source.
			argTypes := desc argumentTypes.
			self assert: argTypes size equals: 1.
			self assert: argTypes first equals: 'lppvoid'].

	"but some cannot be indirected more than once"
	#('lpvoid' 'LPVOID' 'BSTR') do: 
			[:each |
			source := 'cdecl: void ' , each , '**'.
			self should: [self newDescriptor: source] raise: Error].

	"lppvoid cannot be further indirected"
	source := 'cdecl: lppvoid*'.
	self should: [self newDescriptor: source] raise: Error.

	"Test all classes with an implied level of indirection correctly parsed as lppvoid for <class>*"
	(Smalltalk allClasses select: [:each | each isIndirection]) do: 
			[:each |
			| argTypes |
			source := 'cdecl: void ' , each name , '*'.
			argTypes := desc argumentTypes.
			self assert: argTypes size equals: 1.
			self assert: argTypes first equals: 'lppvoid'.
			source := source , '*'.
			self should: [self newDescriptor: source] raise: Error]!

testSharedRegister
	self deny: ExternalDescriptor.Shared hasWeakKeys.
	self assert: ExternalDescriptor.Shared hasWeakValues!

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
testBuiltins!public!unit tests! !
testIndirections!public!unit tests! !
testSharedRegister!public!unit tests! !
testSmokeTest!public!unit tests! !
testStruct4!public!unit tests! !
testStruct8!public!unit tests! !
testStructs!public!unit tests! !
!

