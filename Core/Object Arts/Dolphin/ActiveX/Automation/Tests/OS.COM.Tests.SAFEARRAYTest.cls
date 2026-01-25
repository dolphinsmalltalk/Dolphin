"Filed out from Dolphin Smalltalk"!

External.Tests.GenericExternalArrayTest
	subclass: #'OS.COM.Tests.SAFEARRAYTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Errors} #{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.SAFEARRAYTest guid: (Core.GUID fromString: '{f0fcec1b-f6cd-4f59-b5da-115cf8d04805}')!

OS.COM.Tests.SAFEARRAYTest comment: ''!

!OS.COM.Tests.SAFEARRAYTest methodsFor!

elementClassNames
	^super elementClassNames , #(#IUnknown #IDispatch)!

newTestSubjectOfSize: anInteger
	^SAFEARRAY withAll: (1 to: anInteger) elementClass: self class numericElementClass!

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
			self assert: elem class identicalTo: Record.
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
	subject := SAFEARRAY length: 3 elementClass: Int32.
	self assert: (subject lowerBound: 1) equals: 0.
	self assert: (subject upperBound: 1) equals: 2!

testDoubles
	| floats subject ext |
	floats := DOUBLEArray withAll: { Float negativeInfinity. Float fmin. -0.0. 0.0. 1.25. Float fmax. Float infinity }.
	subject := floats asSAFEARRAY.
	self assert: subject asExternalArray  equals: floats.
	ext := subject asExternalArray.
	self assert: ext isKindOf: DOUBLEArray.
	self assert: ext equals: floats!

testElementAt
	"Test SAFEARRAY>>elementAt:, but only with vectors. Our wrapper doesn't have a way to create multi-dimensioned SAFEARRAYs at present."

	| subject subjectRef invalidIndex |
	invalidIndex := HRESULT fromUnsignedInteger: 16r8002000B.
	subject := SAFEARRAY withAll: #(-123 123) elementClass: Int32.
	self assert: (subject elementAt: #(0)) equals: (Int32 fromInteger: -123).
	self assert: (subject elementAt: #(1)) equals: (Int32 fromInteger: 123).
	self
		should: [subject elementAt: #(2)]
		raise: HRESULTError
		matching: [:ex | ex tag = invalidIndex].
	subjectRef := SAFEARRAY fromAddress: subject yourAddress owner: subject.
	"Should be able to deduce the correct element class"
	self assert: subjectRef elementClass identicalTo: Int32.
	self assert: (subjectRef elementAt: #(0)) equals: (Int32 fromInteger: -123).
	self assert: (subjectRef elementAt: #(1)) equals: (Int32 fromInteger: 123).
	self
		should: [subjectRef elementAt: #(2)]
		raise: HRESULTError
		matching: [:ex | ex tag = invalidIndex]!

testElementClasses
	| array random irand triplets |
	triplets := #(#(#{Int16} -32768 32767) #(#{Int32} -2147483648 2147483647) #(#{FLOAT} -1.25 1.25) #(#{DOUBLE} -1.23456789 1.23456789) #(#{BSTR} '' 'abc') #(#{HRESULT} ##(S_OK) ##(E_NOTIMPL)) #(#{VARIANT_BOOL} false true) #(#{CURRENCY} 99.99s2) #(#{Int8} -128 127) #(#{UInt8} 0 255) #(#{UInt16} 0 65535) #(#{UInt32} 0 4294967295) #(#{VARIANT} 1 1.0 'abc' nil true 1.2s2 ##(DATE
				now) 0.6) #(#{DECIMAL} 12345.12345s) #(#{Int64} -9223372036854775808 9223372036854775807)).
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
	array := SAFEARRAY length: 1 elementClass: Examples.IRandomStream.
	random := Examples.RandomStream new.
	random put_Seed: 12345.
	array at: 1 put: random.
	irand := array at: 1.
	self assert: irand class identicalTo: Examples.IRandomStream.
	self assert: array iid equals: Examples.IRandomStream iid.
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
	#(#{String} #{Utf16String} #{Address}) do: 
			[:each |
			self
				should: [SAFEARRAY length: 1 elementClass: each value]
				raise: MessageNotUnderstood
				matching: [:ex | ex selector == #newSAFEARRAY:]].
	#(#{VOID}) do: 
			[:each |
			self
				should: [SAFEARRAY length: 1 elementClass: each value]
				raise: Error]

	"	IUnknown ExternalArray )"!

testFILETIME
	"FILETIMEs are represented as VT_DATE for compatibility with Win32 APIs such as `InitVariantFromFileTime()`"

	| dt ft subject date |
	dt := DateAndTime fromString: '2026-01-14T08:05:29+00:00'.
	ft := FILETIME fromDateAndTime: dt.
	self assert: ft asDateAndTime equals: dt.
	subject := SAFEARRAY withAll: { ft } elementClass: FILETIME.
	self deny: subject hasRecordInfo.
	self assert: subject hasVarType.
	self assert: subject vartype equals: VT_DATE.
	self assert: subject vt equals: VT_ARRAY | VT_DATE.
	date := subject at: 1.
	self assert: (VARIANT fromFILETIME: ft) value equals: date.
	self assert: date isKindOf: DATE.
	self assert: date asDateAndTime equals: dt.
	"Precision will be lost"
	ft := FILETIME now.
	subject at: 1 put: ft.
	date := subject at: 1.
	self assert: (VARIANT fromFILETIME: ft) value equals: date.
	self assert: (ft asSYSTEMTIME
				wMilliseconds: 0;
				yourself)
		equals: date asSYSTEMTIME!

testFloats
	| floats subject ext |
	floats := FLOATArray withAll: { Float negativeInfinity. Float fmin. -0.0. 0.0. 1.25. Float fmax. Float infinity }.
	subject := floats asSAFEARRAY.
	self assert: subject asExternalArray equals: floats.
	ext := subject asExternalArray.
	self assert: ext isKindOf: FLOATArray.
	self assert: ext equals: floats!

testIDispatch
	"Test array containing IDispatch interface pointer"

	| subject random irand |
	subject := SAFEARRAY length: 1 elementClass: Examples.IRandomStream.
	self assert: subject hasVarType.
	self assert: subject vartype equals: VT_DISPATCH.
	self assert: subject vt equals: VT_ARRAY | VT_DISPATCH.
	random := Examples.RandomStream new.
	random put_Seed: 12345.
	subject at: 1 put: random.
	irand := subject at: 1.
	self assert: irand class identicalTo: Examples.IRandomStream.
	self assert: subject iid equals: Examples.IRandomStream iid.
	self assert: irand referenceCount >= 2.
	self assert: irand seed equals: 12345.
	self assert: (irand isSameCOMObject: random interface)!

testInt16s
	| ints subject ext |
	ints := Int16Array withAll: #(-32768 0 32767).
	subject := ints asSAFEARRAY.
	ext := subject asExternalArray.
	self assert: ext isKindOf: Int16Array.
	self assert: ext equals: ints!

testInt32s
	| ints subject ext |
	ints := Int32Array withAll: #(-16r80000000 0 16r7FFFFFFF).
	subject := ints asSAFEARRAY.
	ext := subject asExternalArray.
	self assert: ext isKindOf: Int32Array.
	self assert: ext equals: ints!

testInt64s
	| ints subject ext |
	ints := Int64Array withAll: #(-16r80000001 0 16r80000000).
	subject := ints asSAFEARRAY.
	ext := subject asExternalArray.
	self assert: ext isKindOf: Int64Array.
	self assert: ext equals: ints!

testInvalidElementClasses
	"Test some invalid safe array types in the VTClasses map"

	#(#{String} #{Utf16String} #{Address} #{CLSID}) do: 
			[:each |
			self
				should: [SAFEARRAY length: 1 elementClass: each value]
				raise: MessageNotUnderstood
				matching: [:ex | ex selector == #newSAFEARRAY:]].
	#(#{VOID} #{LPSTR}) do: 
			[:each |
			self
				should: [SAFEARRAY length: 1 elementClass: each value]
				raise: Error
				matching: [:ex | ex messageText = ('<1p> class should not implement #newSAFEARRAY:' << { each value })]]

	"	ExternalArray )"!

testIUnknown
	"Test array containing IUnknown interface pointer"

	| subject enumRect ienum |
	subject := SAFEARRAY length: 1 elementClass: Examples.IEnumRECT.
	self assert: subject hasVarType.
	self assert: subject vartype equals: VT_UNKNOWN.
	self assert: subject vt equals: VT_ARRAY | VT_UNKNOWN.
	enumRect := Examples.EnumRECT new.
	subject at: 1 put: enumRect.
	self assert: subject iid equals: Examples.IEnumRECT iid.
	ienum := subject at: 1.
	self assert: ienum isKindOf: Examples.IEnumRECT.
	self assert: ienum referenceCount >= 2.
	self assert: (ienum isSameCOMObject: (enumRect queryInterface: IUnknown))!

testMarshal
	| subject |
	subject := self arrayClass marshal: (1 to: 3).
	self assert: subject equals: (self arrayClass withAll: (1 to: 3)).
	self assert: (self arrayClass marshal: subject) identicalTo: subject!

testNew
	"The default element class of SAFEARRAY is VARIANT"

	| subject |
	subject := SAFEARRAY new.
	self assert: subject hasVarType.
	self assert: subject vartype equals: VT_VARIANT.
	self assert: subject elementClass equals: VARIANT.
	self assert: subject vt equals: VT_ARRAY | VT_VARIANT.
	self assert: subject asArray equals: #()!

testNewColon
	"The default element class of SAFEARRAY is VARIANT"

	#(0 1 3) do: 
			[:i |
			| subject |
			subject := SAFEARRAY new: i.
			self assert: subject hasVarType.
			self assert: subject vartype equals: VT_VARIANT.
			self assert: subject elementClass equals: VARIANT.
			self assert: subject vt equals: VT_ARRAY | VT_VARIANT.
			self assert: subject asArray equals: (Array new: i)]!

testRecord
	"Test array containing user defined type"

	| subject |
	subject := SAFEARRAY length: 1 elementClass: POINTL.
	self assert: subject hasRecordInfo.
	self assert: subject vartype equals: VT_RECORD.
	self assert: subject vt equals: VT_ARRAY | VT_RECORD.
	subject at: 1 put: (3 @ 4) asParameter.
	self assert: (subject at: 1) isKindOf: POINTL.
	self assert: (subject at: 1) asPoint equals: 3 @ 4.
	self should: [subject at: 1 put: 1] raise: Error.
	self assert: subject recordInfo getFieldNames equals: #('x' 'y')!

testRecordInfo
	| subject recinfo fieldNames ordered |
	subject := self threePoints: POINTL.
	self assert: subject hasRecordInfo.
	self assert: subject elementClass equals: POINTL.
	self assert: subject asObject equals: ((1 to: 3) collect: [:each | each @ each]).
	recinfo := subject recordInfo.
	self assert: recinfo name equals: subject elementClass name asString.
	self assert: recinfo byteSize equals: subject elementClass byteSize.
	fieldNames := subject elementClass template keys collect: [:each | each asString].
	self assert: recinfo getFieldNames asSet equals: fieldNames.
	self assert: recinfo guid equals: subject elementClass guid.
	"Make sure enumeration of records is working"
	ordered := OrderedCollection new.
	subject do: [:each | ordered add: each].
	self assert: ordered asArray equals: ((1 to: 3) collect: [:each | (each @ each) asParameter])!

testWithAll
	"The default element class of SAFEARRAY is VARIANT"

	| subject objects |
	objects := #(1 1.25 'abc' 1s2).
	subject := SAFEARRAY withAll: objects.
	self assert: subject hasVarType.
	self assert: subject vartype equals: VT_VARIANT.
	self assert: subject elementClass equals: VARIANT.
	self assert: subject vt equals: VT_ARRAY | VT_VARIANT.
	self assert: subject asArray equals: objects!

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

!OS.COM.Tests.SAFEARRAYTest categoriesForMethods!
elementClassNames!constants!private! !
newTestSubjectOfSize:!helpers!private! !
testAXRecords!public!unit tests! !
testBoolDisplayString!public! !
testBounds!public!unit tests! !
testDoubles!public! !
testElementAt!public!unit tests! !
testElementClasses!public!unit tests! !
testFILETIME!public!unit tests! !
testFloats!public! !
testIDispatch!public!unit tests! !
testInt16s!public! !
testInt32s!public! !
testInt64s!public! !
testInvalidElementClasses!public! !
testIUnknown!public!unit tests! !
testMarshal!public!unit tests! !
testNew!public!unit tests! !
testNewColon!public!unit tests! !
testRecord!public!unit tests! !
testRecordInfo!public!unit tests! !
testWithAll!public!unit tests! !
threePoints:!constants!public! !
!

!OS.COM.Tests.SAFEARRAYTest class methodsFor!

arrayClass
	^SAFEARRAY! !

!OS.COM.Tests.SAFEARRAYTest class categoriesForMethods!
arrayClass!constants!private! !
!

