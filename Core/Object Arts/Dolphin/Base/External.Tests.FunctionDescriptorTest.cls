"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'External.Tests.FunctionDescriptorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{External.ExtCallArgTypes})
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.FunctionDescriptorTest guid: (Core.GUID fromString: '{d809ef14-78cf-4e10-8dc1-0249d46b4b5f}')!
External.Tests.FunctionDescriptorTest comment: ''!
!External.Tests.FunctionDescriptorTest categoriesForClass!Unclassified! !
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
			self assert: argTypes size equals: 1.
			self assert: eachValue isInteger.
			self assert: argTypes first equals: (typeNames at: eachValue + 1).
			source := source , '*'.
			eachKey = 'lppvoid'
				ifTrue: [self should: [self subjectClass fromString: source environment: External] raise: Error]
				ifFalse: 
					[| refType |
					"Single indirection"
					desc := self subjectClass fromString: source environment: Smalltalk.
					argTypes := desc argumentTypes.
					self assert: argTypes size equals: 1.
					refType := self subjectClass referenceTypeFor: eachValue.
					refType isInteger
						ifTrue: [self assert: argTypes first equals: (typeNames at: refType + 1)]
						ifFalse: [argTypes first beginsWith: refType].
					"Double indirection"
					source := source , '*'.
					refType == ExtCallArgLPPVOID
						ifTrue: [self should: [self subjectClass fromString: source environment: External] raise: Error]
						ifFalse: 
							[desc := self subjectClass fromString: source environment: External.
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
			desc := self subjectClass fromString: source environment: Smalltalk.
			argTypes := desc argumentTypes.
			self assert: argTypes size equals: 1.
			self assert: argTypes first equals: 'lppvoid'].

	"but some cannot be indirected more than once"
	#('lpvoid' 'LPVOID' 'BSTR') do: 
			[:each |
			source := 'cdecl: void ' , each , '**'.
			self should: [self subjectClass fromString: source environment: Smalltalk] raise: Error].

	"lppvoid cannot be further indirected"
	source := 'cdecl: lppvoid*'.
	self should: [self subjectClass fromString: source environment: Smalltalk] raise: Error.

	"Test all classes with an implied level of indirection correctly parsed as lppvoid for <class>*"
	(Smalltalk allClasses select: [:each | each isIndirection]) do: 
			[:each |
			| argTypes |
			source := 'cdecl: void ' , each name , '*'.
			argTypes := desc argumentTypes.
			self assert: argTypes size equals: 1.
			self assert: argTypes first equals: 'lppvoid'.
			source := source , '*'.
			self should: [self subjectClass fromString: source environment: Smalltalk] raise: Error]!

testSmokeTest
	"Verify that the compiler is parsing the descriptors in the same way as FunctionDescriptor by
	checking the descriptor of every ExternalMethod."

	(ExternalMethod allSubinstances reject: [:each | each isUnbound]) do: 
			[:each |
			| desc text |
			text := each descriptor description.
			desc := self subjectClass fromString: (text copyWithout: $,)
						environment: each methodClass environment.
			self assert: text equals: desc description]!

testStruct4
	| valueTypes |
	self assert: DWORD byteSize equals: 4.
	valueTypes := self externalTypes.
	
	[FunctionDescriptor.ValueTypes := LookupTable with: 'void' -> 0.
	self
		parseStructArg: DWORD
		valueType: ExtCallArgSTRUCT4
		refType: ExtCallArgLP]
			ensure: [FunctionDescriptor.ValueTypes := valueTypes]!

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
!External.Tests.FunctionDescriptorTest categoriesFor: #externalTypes!accessing!private! !
!External.Tests.FunctionDescriptorTest categoriesFor: #parseStructArg:valueType:refType:!private!unit tests! !
!External.Tests.FunctionDescriptorTest categoriesFor: #subjectClass!constants!private! !
!External.Tests.FunctionDescriptorTest categoriesFor: #testBuiltins!public!unit tests! !
!External.Tests.FunctionDescriptorTest categoriesFor: #testIndirections!public!unit tests! !
!External.Tests.FunctionDescriptorTest categoriesFor: #testSmokeTest!public!unit tests! !
!External.Tests.FunctionDescriptorTest categoriesFor: #testStruct4!public!unit tests! !
!External.Tests.FunctionDescriptorTest categoriesFor: #testStruct8!public!unit tests! !
!External.Tests.FunctionDescriptorTest categoriesFor: #testStructs!public!unit tests! !

