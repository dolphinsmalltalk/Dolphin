"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ExternalDescriptorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ExtCallArgTypes'
	classInstanceVariableNames: ''!
ExternalDescriptorTest guid: (GUID fromString: '{D809EF14-78CF-4E10-8DC1-0249D46B4B5F}')!
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
	self assert: argTypes size = 1.
	desc argumentsDo: 
			[:eachType :eachClass | 
			| type |
			type := typeCodeOrName isInteger 
						ifTrue: [typeCodeOrName]
						ifFalse: [ExternalDescriptor typeFromName: typeCodeOrName].
			self assert: eachType == type.
			self assert: eachClass == structClass].
	"Now pass-by-ref"
	source := source , '*'.
	desc := self newDescriptor: source.
	argTypes := desc argumentTypes.
	self assert: argTypes size = 1.
	desc argumentsDo: 
			[:eachType :eachClass | 
			| type |
			type := ptrCodeOrName isInteger 
						ifTrue: [ptrCodeOrName]
						ifFalse: [ExternalDescriptor typeFromName: ptrCodeOrName].
			self assert: eachType == type.
			self assert: eachClass == structClass]!

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
			self assert: argTypes size = 1.
			self assert: eachValue isInteger.
			self assert: argTypes first = (typeNames at: eachValue + 1).
			source := source , '*'.
			eachKey = 'lppvoid' 
				ifTrue: [self should: [self newDescriptor: source] raise: Error]
				ifFalse: 
					["Single indirection"
					| refType |
					desc := self newDescriptor: source.
					argTypes := desc argumentTypes.
					self assert: argTypes size = 1.
					refType := ExternalDescriptor referenceTypeFor: eachValue.
					refType isInteger 
						ifTrue: [self assert: argTypes first = (typeNames at: refType + 1)]
						ifFalse: [argTypes first beginsWith: refType].
					"Double indirection"
					source := source , '*'.
					refType == ExtCallArgLPPVOID 
						ifTrue: [self should: [self newDescriptor: source] raise: Error]
						ifFalse: 
							[desc := self newDescriptor: source.
							argTypes := desc argumentTypes.
							self assert: argTypes size = 1.
							self assert: argTypes first = 'lppvoid']]]!

testIndirections
	"Some double indirections"

	| source desc |
	#('lppvoid' 'lpvoid*' 'void**' 'LPVOID*' 'DWORD**' 'POINTL**' 'IUnknown**' 'BSTR*') do: 
			[:each | 
			| argTypes |
			source := 'cdecl: void ' , each.
			desc := self newDescriptor: source.
			argTypes := desc argumentTypes.
			self assert: argTypes size = 1.
			self assert: argTypes first = 'lppvoid'].

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
			self assert: argTypes size = 1.
			self assert: argTypes first = 'lppvoid'.
			source := source , '*'.
			self should: [self newDescriptor: source] raise: Error]!

testSmokeTest
	"Verify that the compiler is parsing the descriptors in the same way as ExternalDescriptor by
	checking the descriptor of every ExternalMethod."

	(ExternalMethod allSubinstances reject: [:each | each isUnbound]) do: 
			[:each | 
			| desc text |
			text := each descriptor description.
			desc := self newDescriptor: (text copyWithout: $,).
			self assert: text = desc description]!

testStructs
	self assert: RGBQUAD byteSize = 4.
	self 
		parseStructArg: RGBQUAD
		valueType: ExtCallArgSTRUCT4
		refType: ExtCallArgLP.
	self assert: POINTL byteSize = 8.
	self 
		parseStructArg: POINTL
		valueType: ExtCallArgSTRUCT8
		refType: ExtCallArgLP.
	self assert: _FPIEEE_VALUE byteSize > 8.
	self 
		parseStructArg: _FPIEEE_VALUE
		valueType: ExtCallArgSTRUCT
		refType: ExtCallArgLP.
	self 
		parseStructArg: IUnknown
		valueType: ExtCallArgSTRUCT
		refType: ExtCallArgCOMPTR.
	self 
		parseStructArg: IDispatch
		valueType: ExtCallArgSTRUCT
		refType: ExtCallArgCOMPTR! !
!ExternalDescriptorTest categoriesFor: #externalTypes!accessing!private! !
!ExternalDescriptorTest categoriesFor: #newDescriptor:!private!unit tests! !
!ExternalDescriptorTest categoriesFor: #parseStructArg:valueType:refType:!private!unit tests! !
!ExternalDescriptorTest categoriesFor: #testBuiltins!public!unit tests! !
!ExternalDescriptorTest categoriesFor: #testIndirections!public!unit tests! !
!ExternalDescriptorTest categoriesFor: #testSmokeTest!public!unit tests! !
!ExternalDescriptorTest categoriesFor: #testStructs!public!unit tests! !

