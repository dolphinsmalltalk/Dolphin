"Filed out from Dolphin Smalltalk 7"!

External.Tests.GenericExternalArrayTest subclass: #SAFEARRAYTest
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Errors})
	classInstanceVariableNames: ''
	classConstants: {}!
SAFEARRAYTest guid: (Core.GUID fromString: '{f0fcec1b-f6cd-4f59-b5da-115cf8d04805}')!
SAFEARRAYTest comment: ''!
!SAFEARRAYTest categoriesForClass!Unclassified! !
!SAFEARRAYTest methodsFor!

arrayClass
	^SAFEARRAY!

elementClassNames
	^super elementClassNames , #(#IUnknown #IDispatch)!

newArrayOfIntegers: anArray
	^SAFEARRAY withAll: anArray elementClass: SDWORD!

testAXRecords
	"Create a dummy class that is unregistered and which will therefore be represented by an AXRecord"

	| record sa sa2 ordered elem elems |
	record := POINTL basicShallowCopy.
	record setName: 'Dummy' asSymbol environment: Smalltalk.
	record setGuid: GUID newUnique.
	record unregister.
	"Now create an array of those records"
	sa := self threePoints: record.
	"Now attach a SAFEARRAY reference to it that has to deduce the content"
	sa2 := SAFEARRAY fromAddress: sa yourAddress owner: sa.
	self assert: sa2 size equals: 3.
	self assert: sa2 hasRecordInfo.
	self assertIsNil: sa2 recordClass.
	ordered := OrderedCollection new.
	sa2 do: [:each | ordered add: each].
	sa elementClass: nil.
	elems := sa collect: [:each | each].
	self assert: ordered asArray equals: elems.
	1 to: 3
		do: 
			[:i |
			elem := sa2 at: i.
			self assert: elem class identicalTo: AXRecord.
			self assert: elem x equals: i.
			self assert: elem y equals: i]!

testBoolDisplayString
	| subject actual |
	subject := self arrayClass length: 2 elementClass: VARIANT_BOOL.
	subject at: 1 put: false.
	subject at: 2 put: true.
	actual := String streamContents: 
					[:stream |
					stream locale: (Locale named: 'en').
					subject displayOn: stream].
	self assert: actual equals: '(False, True)'.
	actual := String streamContents: 
					[:stream |
					stream locale: (Locale named: 'es').
					subject displayOn: stream].
	self assert: actual equals: '(Falso; Verdadero)'!

testBounds
	| subject |
	subject := SAFEARRAY length: 3 elementClass: SDWORD.
	self assert: (subject lowerBound: 1) equals: 0.
	self assert: (subject upperBound: 1) equals: 2!

testElementAt
	"Test SAFEARRAY>>elementAt:, but only with vectors. Our wrapper doesn't have a way to create multi-dimensioned SAFEARRAYs at present."

	| subject subjectRef invalidIndex |
	invalidIndex := HRESULT fromUnsignedInteger: 16r8002000B.
	subject := self newArrayOfIntegers: #(-123 123).
	self assert: (subject elementAt: {0}) equals: (SDWORD fromInteger: -123).
	self assert: (subject elementAt: {1}) equals: (SDWORD fromInteger: 123).
	self
		should: [subject elementAt: {2}]
		raise: HRESULTError
		matching: [:ex | ex tag = invalidIndex].
	subjectRef := SAFEARRAY fromAddress: subject yourAddress owner: subject.
	"Should be able to deduce the correct element class"
	self assert: subjectRef elementClass identicalTo: SDWORD.
	self assert: (subjectRef elementAt: {0}) equals: (SDWORD fromInteger: -123).
	self assert: (subjectRef elementAt: {1}) equals: (SDWORD fromInteger: 123).
	self
		should: [subjectRef elementAt: {2}]
		raise: HRESULTError
		matching: [:ex | ex tag = invalidIndex]!

testElementClasses
	| array random irand triplets |
	triplets := #(#(#{SWORD} -32768 32767) #(#{SDWORD} -2147483648 2147483647) #(#{FLOAT} -1.25 1.25) #(#{DOUBLE} -1.23456789 1.23456789) #(#{BSTR} '' 'abc') #(#{HRESULT} ##(S_OK) ##(E_NOTIMPL)) #(#{VARIANT_BOOL} false true) #(#{CURRENCY} 99.99s2) #(#{SBYTE} -128 127) #(#{BYTE} 0 255) #(#{WORD} 0 65535) #(#{DWORD} 0 4294967295) #(#{VARIANT} 1 1.0 'abc' nil true 1.2s2 ##(DATE
				now) 0.6) #(#{DECIMAL} 12345.12345s) #(#{LARGE_INTEGER} -9223372036854775808 9223372036854775807)).
	triplets do: 
			[:each |
			| sa2 |
			array := SAFEARRAY length: each size - 1 elementClass: each first value.
			self should: [array at: 1 put: Object new] raise: Error.
			"We also want to test an indirect reference"
			sa2 := SAFEARRAY fromAddress: array yourAddress owner: array.
			1 to: array size
				do: 
					[:i |
					| object |
					object := each at: i + 1.
					array at: i put: object.
					self assert: (array at: i) asObject equals: object.
					self assert: (sa2 at: i) asObject equals: object]].
	self should: [SAFEARRAY length: 1 elementClass: CLSID] raise: Error.

	"Test array containing interface pointer"
	array := SAFEARRAY length: 1 elementClass: IRandomStream.
	random := COMRandomStream new.
	random put_Seed: 12345.
	array at: 1 put: random.
	irand := array at: 1.
	self assert: irand class identicalTo: IRandomStream.
	self assert: array iid equals: IRandomStream iid.
	self assert: irand referenceCount >= 2.
	self assert: irand seed equals: 12345.
	self assert: (irand isSameCOMObject: random interface).

	"Test array containing user defined type"
	array := SAFEARRAY length: 1 elementClass: POINTL.
	array at: 1 put: (3 @ 4) asParameter.
	self assert: (array at: 1) isKindOf: POINTL.
	self assert: (array at: 1) asPoint equals: 3 @ 4.
	self should: [array at: 1 put: 1] raise: Error.
	self assert: array recordInfo getFieldNames equals: #('x' 'y').

	"Some invalid safe array types in the VTClasses map"
	#(#{String} #{Utf16String} #{ExternalAddress}) do: 
			[:each |
			self
				should: [SAFEARRAY length: 1 elementClass: each value]
				raise: MessageNotUnderstood
				matching: [:ex | ex selector == #newSAFEARRAY:]].
	#(#{VOID} #{FILETIME}) do: 
			[:each |
			self
				should: [SAFEARRAY length: 1 elementClass: each value]
				raise: Error
				matching: [:ex | ex messageText = 'Failed to create vector']]

	"	IUnknown ExternalArray )"!

testRecordInfo
	| sa recinfo fieldNames ordered |
	sa := self threePoints: POINTL.
	self assert: sa elementClass equals: POINTL.
	self assert: sa asObject equals: ((1 to: 3) collect: [:each | each @ each]).
	recinfo := sa recordInfo.
	self assert: recinfo name equals: sa elementClass name asString.
	self assert: recinfo byteSize equals: sa elementClass byteSize.
	fieldNames := sa elementClass template keys collect: [:each | each asString].
	self assert: recinfo getFieldNames asSet equals: fieldNames.
	self assert: recinfo guid equals: sa elementClass guid.
	"Make sure enumeration of records is working"
	ordered := OrderedCollection new.
	sa do: [:each | ordered add: each].
	self assert: ordered asArray equals: ((1 to: 3) collect: [:each | (each @ each) asParameter])!

threePoints: recordClass 
	| sa |
	sa := SAFEARRAY length: 3 elementClass: recordClass.
	1 to: sa size
		do: 
			[:each | 
			(sa at: each)
				x: each;
				y: each].
	^sa! !
!SAFEARRAYTest categoriesFor: #arrayClass!constants!private! !
!SAFEARRAYTest categoriesFor: #elementClassNames!constants!private! !
!SAFEARRAYTest categoriesFor: #newArrayOfIntegers:!helpers!private! !
!SAFEARRAYTest categoriesFor: #testAXRecords!public!unit tests! !
!SAFEARRAYTest categoriesFor: #testBoolDisplayString!public! !
!SAFEARRAYTest categoriesFor: #testBounds!public!unit tests! !
!SAFEARRAYTest categoriesFor: #testElementAt!public!unit tests! !
!SAFEARRAYTest categoriesFor: #testElementClasses!public!unit tests! !
!SAFEARRAYTest categoriesFor: #testRecordInfo!public!unit tests! !
!SAFEARRAYTest categoriesFor: #threePoints:!public!unit tests! !

