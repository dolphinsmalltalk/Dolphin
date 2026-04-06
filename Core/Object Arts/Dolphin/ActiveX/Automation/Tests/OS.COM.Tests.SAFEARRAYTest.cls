"Filed out from Dolphin Smalltalk"!

External.Tests.GenericExternalArrayTest
	subclass: #'OS.COM.Tests.SAFEARRAYTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Error} #{OS.COM.OleVariant})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.SAFEARRAYTest guid: (Core.GUID fromString: '{f0fcec1b-f6cd-4f59-b5da-115cf8d04805}')!

OS.COM.Tests.SAFEARRAYTest comment: ''!

!OS.COM.Tests.SAFEARRAYTest methodsFor!

elementClassNames
	^super elementClassNames , #(#IUnknown #IDispatch)!

newTestSubjectWithElements: anArray
	^SAFEARRAY withAll: anArray keys elementClass: self class numericElementClass!

testBoolDisplayString
	| subject |
	subject := self arrayClass withAll: #(false true) elementClass: VARIANT_BOOL.
	self assert: subject vartype equals: VT_BOOL.
	self assert: subject vt equals: VT_ARRAY | VT_BOOL.
	#('en' '(False, True)' 'es' '(Falso; Verdadero)') pairsDo: 
			[:localeId :expected |
			| actual stream |
			stream := (Locale named: localeId) writeStream.
			subject displayOn: stream.
			actual := stream contents.
			self assert: actual equals: expected]!

testBounds
	| subject |
	subject := SAFEARRAY length: 3 elementClass: Int32.
	self assert: subject vartype equals: VT_I4.
	self assert: (subject lowerBound: 1) equals: 0.
	self assert: (subject upperBound: 1) equals: 2!

testDoubles
	| floats subject ext |
	floats := DOUBLEArray withAll: { Float negativeInfinity. Float fmin. -0.0. 0.0. 1.25. Float fmax. Float infinity }.
	subject := floats asSAFEARRAY.
	self assert: subject vartype equals: VT_R8.
	self assert: subject asExternalArray  equals: floats.
	ext := subject value.
	self assert: ext isKindOf: DOUBLEArray.
	self assert: ext equals: floats!

testElementAt
	"Test SAFEARRAY>>elementAt:, but only with vectors. Our wrapper doesn't have a way to create multi-dimensioned SAFEARRAYs at present."

	| subject subjectRef invalidIndex |
	invalidIndex := HRESULT fromUnsignedInteger: 16r8002000B.
	subject := SAFEARRAY withAll: #(-123 123) elementClass: Int32.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self assert: (subject elementAt: #(0)) equals: (Int32 fromInteger: -123).
	self assert: (subject elementAt: #(1)) equals: (Int32 fromInteger: 123).
	self
		should: [subject elementAt: #(2)]
		raise: HRESULTError
		matching: [:ex | ex tag = invalidIndex].
	subjectRef := SAFEARRAY fromAddress: subject yourAddress owner: subject.
	self assert: subjectRef isReferenceStruct.
	self assert: subjectRef isFinalizable.
	self deny: subjectRef needsFree.
	"Should be able to deduce the correct element class"
	self assert: subject vartype equals: VT_I4.
	self assert: subjectRef elementClass identicalTo: Int32.
	self assert: (subjectRef elementAt: #(0)) equals: (Int32 fromInteger: -123).
	self assert: (subjectRef elementAt: #(1)) equals: (Int32 fromInteger: 123).
	self
		should: [subjectRef elementAt: #(2)]
		raise: HRESULTError
		matching: [:ex | ex tag = invalidIndex].
	subjectRef free.
	subject free!

testFILETIME
	"FILETIMEs are represented as VT_DATE for compatibility with Win32 APIs such as `InitVariantFromFileTime()`"

	| dt ft subject date copy dateref |
	dt := DateAndTime fromString: '2026-01-14T08:05:29+00:00'.
	ft := FILETIME fromDateAndTime: dt.
	self assert: ft asDateAndTime equals: dt.
	subject := SAFEARRAY withAll: { ft } elementClass: FILETIME.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self deny: subject hasRecordInfo.
	self assert: subject hasVarType.
	self assert: subject vartype equals: VT_DATE.
	self assert: subject vt equals: VT_ARRAY | VT_DATE.
	dateref := subject at: 1.
	self assert: dateref isReferenceStruct.
	self assert: dateref isKindOf: DATE.
	self assert: dateref equals: ft asDATE.
	date := dateref copy.
	self assert: date isValueStruct.
	copy := subject copy.
	self assert: copy vartype equals: VT_DATE.
	self assert: copy value equals: { date }.
	"Precision will be lost"
	ft := FILETIME fromInteger: 13414160038639999.
	subject at: 1 put: ft.
	self assert: dateref equals: ft asDATE.
	self assert: (subject at: 1) equals: ft asDATE.
	self assert: (ft asDateAndTime - dateref asDateAndTime) closeTo: 0 seconds precision: 1 microseconds.
	self assert: copy value equals: { date }.
	subject free.
	self assert: copy value equals: { date }.
	copy free!

testFinalizable
	| subject pSubject |
	subject := self newTestSubjectOfSize: 6.
	self assertIsNil: subject owner.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	pSubject := self class arrayClass fromAddress: subject yourAddress length: subject size.
	self assert: pSubject isReferenceStruct.
	self assert: pSubject owner equals: subject yourAddress.
	"Even ref structs require finalization to release any lock on the safearray memory"
	self assert: pSubject isFinalizable.
	self deny: pSubject needsFree.!

testFloats
	| floats subject ext |
	floats := FLOATArray
				withAll: { Float negativeInfinity. Float fmin. -0.0. 0.0. 1.25. Float fmax. Float infinity }.
	subject := floats asSAFEARRAY.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self assert: subject vartype equals: VT_R4.
	self assert: subject asExternalArray equals: floats.
	ext := subject value.
	self assert: ext isKindOf: FLOATArray.
	self assert: ext equals: floats.
	subject free.
	self assert: ext equals: floats.
!

testIDispatch
	"Test array containing IDispatch interface pointer"

	| subject random irand |
	subject := SAFEARRAY length: 1 elementClass: Examples.IRandomStream.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
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
	ints := Int16Array withAll: {Int16.MinValue. 0. 1. Int16.MaxValue}.
	subject := ints asSAFEARRAY.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self assert: subject vartype equals: VT_I2.
	ext := subject asExternalArray.
	self assert: ext isKindOf: Int16Array.
	self assert: ext equals: ints!

testInt32s
	| ints subject ext |
	ints := Int32Array withAll: #(-16r80000000 0 16r7FFFFFFF).
	subject := ints asSAFEARRAY.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self assert: subject vartype equals: VT_I4.
	ext := subject asExternalArray.
	self assert: ext isKindOf: Int32Array.
	self assert: ext equals: ints!

testInt64s
	| ints subject ext |
	ints := Int64Array withAll: #(-16r80000001 0 16r80000000).
	subject := ints asSAFEARRAY.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self assert: subject vartype equals: VT_I8.
	ext := subject asExternalArray.
	self assert: ext isKindOf: Int64Array.
	self assert: ext equals: ints!

testInvalidElementClasses
	"Test some invalid safe array types in the VTClasses map"

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
				raise: Error
				matching: [:ex | ex messageText = ('<1p> class should not implement #newSAFEARRAY:' << { each value })]]

	"	ExternalArray )"!

testIUnknown
	"Test array containing IUnknown interface pointer"

	| subject enumRect ienum |
	subject := SAFEARRAY length: 1 elementClass: Examples.IEnumRECT.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
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
	self assert: subject vartype equals: VT_VARIANT.
	self assert: subject equals: (self arrayClass withAll: (1 to: 3)).
	self assert: (self arrayClass marshal: subject) identicalTo: subject!

testNew
	"The default element class of SAFEARRAY is VARIANT"

	| subject |
	subject := SAFEARRAY new.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
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
			self assert: subject isReferenceStruct.
			self assert: subject isFinalizable.
			self assert: subject needsFree.
			self assert: subject hasVarType.
			self assert: subject vartype equals: VT_VARIANT.
			self assert: subject elementClass equals: VARIANT.
			self assert: subject vt equals: VT_ARRAY | VT_VARIANT.
			self assert: subject asArray equals: (Array new: i)]!

testRecord
	"Test array containing user defined type"

	| subject point |
	subject := SAFEARRAY length: 1 elementClass: POINTL.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self assert: subject hasRecordInfo.
	self assert: subject vartype equals: VT_RECORD.
	self assert: subject vt equals: VT_ARRAY | VT_RECORD.
	subject at: 1 put: (3 @ 4) asParameter.
	"Accessing the SAFEARRAY returns reference structs pointing at the data in the SAFEARRAY itself"
	point := subject at: 1.
	self assert: point isReferenceStruct.
	self assert: point owner equals: subject.
	self deny: point needsFree.
	self deny: point isFinalizable.
	self assert: point class equals: POINTL.
	self assert: point equals: 3 @ 4.
	self should: [subject at: 1 put: 1] raise: Error.
	self assert: subject recordInfo getFieldNames equals: #('x' 'y')!

testRecordInfo
	| subject recinfo fieldNames ordered |
	subject := self threePoints: POINTL.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self assert: subject hasRecordInfo.
	self assert: subject elementClass equals: POINTL.
	self assert: subject vartype equals: VT_RECORD.
	self assert: subject vt equals: VT_ARRAY | VT_RECORD.
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

testRecordsGeneric
	"Test case of SAFEARRAY holding generic OS.COM.Record instances."

	| pointl2 sa sa2 sa2elems elems recordClass |
	"Create a dummy structure class that is unregistered to force use of OS.COM.Record."
	pointl2 := POINTL newAnonymousSubclass.
	pointl2 setName: #POINTL2 environment: pointl2 environment.
	pointl2 unregister.
	"Now create an array of those records"
	sa := self threePoints: pointl2.
	"SAFEARRAYs are always reference structs as the data is allocated externally."
	self assert: sa isReferenceStruct.
	self assert: sa needsFree.
	self assert: sa isFinalizable.
	self assertIsNil: sa owner.
	self assert: sa vartype equals: VT_RECORD.
	self assert: sa vt equals: VT_RECORD | VT_ARRAY.
	"Now attach a SAFEARRAY reference to it that has to deduce the content"
	sa2 := SAFEARRAY fromAddress: sa yourAddress owner: sa.
	"A reference to the actual SA, so must not free the data."
	self assert: sa2 isReferenceStruct.
	self deny: sa2 needsFree.
	self assert: sa2 owner equals: sa.
	"SAFEARRAYs always require finalization to release any lock on the data, even if they don't own the data."
	self assert: sa2 isFinalizable.
	self assert: sa2 size equals: 3.
	self assert: sa2 hasRecordInfo.
	self assert: sa2 vartype equals: VT_RECORD.
	self assert: sa2 vt equals: VT_RECORD | VT_ARRAY.
	recordClass := sa2 recordClass.
	self assert: recordClass guid equals: pointl2 guid.
	self assert: recordClass name equals: pointl2 name.
	sa2elems := sa2 asArray.
	"Reset the element clas so that the SA has to work it out too"
	sa elementClass: nil.
	elems := sa asArray.
	self assert: sa recordClass equals: recordClass.
	self assert: sa vartype equals: VT_RECORD.
	self assert: sa vt equals: VT_RECORD | VT_ARRAY.
	"Elements should be equal because they reference the same underlying data"
	self assert: sa2elems equals: elems.
	1 to: 3
		do: 
			[:i |
			| elem |
			elem := sa2 at: i.
			self assert: elem class identicalTo: Record.
			self assert: elem recordClass equals: recordClass.
			self assert: elem x equals: i.
			self assert: elem y equals: i]!

testVarTypes
	{
		#(#{BSTR} '' 'a' 'abc' 'a🐬b').
		#(#{VARIANT_BOOL} false true).
		#(#{Int8} -128 -1 0 1 127).
		#(#{UInt8} 0 1 255).
		#(#{Int16} -16r8000 -1 0 1 16r7FFF).
		#(#{UInt16} 0 1 65535).
		#(#{Int32} -16r80000000 -16r7FFFFFFF -16r40000001 -16r40000000 -1 0 1 16r3FFFFFFF 16r40000000 16r7FFFFFFF).
		#(#{UInt32} 0 1 16r3FFFFFFF 16r40000000 16r7FFFFFFF 16r80000000 16rFFFFFFFF).
		#(#{Int64} -16r8000000000000000 -16r7FFFFFFFFFFFFFF -16r80000000 -16r7FFFFFFF -16r40000001 -16r40000000 -1 0 1 16r3FFFFFFF 16r40000000 16r7FFFFFFF 16r3FFFFFFFFFFFFFFF 16r4000000000000000 16r7FFFFFFFFFFFFFFF).
		#(#{UInt64} 16r8000000000000001 0 1 16r3FFFFFFF 16r40000000 16r3FFFFFFFFFFFFFFF 16r4000000000000000 16r7FFFFFFFFFFFFFF 16rFFFFFFFFFFFFFFFF).
		{ #{DOUBLE}. Float negativeInfinity. -1.23456789. -0.0. 0.0. 1.23456789. Float infinity }.
		#(#{FLOAT} -1.25 -0.0 0.0 1.25).
		{ #{HRESULT}. S_OK. E_NOTIMPL }.
		#(#{CY} -922337203685477.5808s 0.0001s 0s 99.99s2 922337203685477.5807s).
		#(#{DECIMAL} 0.0000000000000000000000000001s 0s 12345.12345s 16rFFFFFFFFFFFFFFFFFFFFFFFF).
		{ #{DATE}. DateAndTime fromString: '2026-01-14T08:05:29+00:00' }.
		{ #{VARIANT}. 1. 1.0. 'abc'. nil. true. 1.2s2. DATE now. 0.6 }
	} do: 
				[:each |
				| subjectRef elementClass subject |
				elementClass := each first value.
				subject := SAFEARRAY length: each size - 1 elementClass: elementClass.
				self assert: subject isReferenceStruct.
				self assert: subject isFinalizable.
				self assert: subject needsFree.
				self deny: subject hasRecordInfo.
				self assert: subject hasVarType.
				self assert: subject vartype equals: elementClass vt.
				self should: [subject at: 1 put: Object new] raise: Error.
				"We also want to test an indirect reference"
				subjectRef := SAFEARRAY fromAddress: subject yourAddress owner: subject.
				self assert: subjectRef isReferenceStruct.
				self deny: subjectRef needsFree.
				self assert: subject hasVarType.
				self assert: subject vartype equals: elementClass vt.
				"Even ref instances require finalization to unlock the safe array."
				self assert: subjectRef isFinalizable.
				self assert: subjectRef size equals: subject size.
				1 to: subject size
					do: 
						[:i |
						| object |
						object := each at: i + 1.
						subject at: i put: object.
						self assert: (subject at: i) asObject equals: object.
						self assert: (subjectRef at: i) asObject equals: object]]!

testWithAll
	"The default element class of SAFEARRAY is VARIANT"

	| subject objects |
	objects := #(1 1.25 'abc' 1s2).
	subject := SAFEARRAY withAll: objects.
	self assert: subject isReferenceStruct.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self assert: subject hasVarType.
	self assert: subject vartype equals: VT_VARIANT.
	self assert: subject elementClass equals: VARIANT.
	self assert: subject vt equals: VT_ARRAY | VT_VARIANT.
	self assert: subject asArray equals: objects.
	subject at: 2 put: 2.5.
	self assert: subject asArray equals: (objects copyReplacing: 1.25 withObject: 2.5)!

threePoints: recordClass
	| sa |
	sa := SAFEARRAY length: 3 elementClass: recordClass.
	1 to: sa size
		do: 
			[:each |
			| element |
			element := sa at: each.
			self assert: element class equals: recordClass.
			self assert: element isReferenceStruct.
			self deny: element isFinalizable.
			self deny: element needsFree.
			self assert: element owner equals: sa.
			element
				x: each;
				y: each].
	^sa!

verifyCopy: anArray
	| copy |
	copy := super verifyCopy: Array new.
	self assert: copy isReferenceStruct.
	self assertIsNil: copy owner.
	self assert: copy isFinalizable.
	self assert: copy needsFree.
	copy free! !

!OS.COM.Tests.SAFEARRAYTest categoriesForMethods!
elementClassNames!constants!private! !
newTestSubjectWithElements:!helpers!private! !
testBoolDisplayString!public!unit tests! !
testBounds!public!unit tests! !
testDoubles!public!unit tests! !
testElementAt!public!unit tests! !
testFILETIME!public!unit tests! !
testFinalizable!public!unit tests! !
testFloats!public!unit tests! !
testIDispatch!public!unit tests! !
testInt16s!public!unit tests! !
testInt32s!public!unit tests! !
testInt64s!public!unit tests! !
testInvalidElementClasses!public!unit tests! !
testIUnknown!public!unit tests! !
testMarshal!public!unit tests! !
testNew!public!unit tests! !
testNewColon!public!unit tests! !
testRecord!public!unit tests! !
testRecordInfo!public!unit tests! !
testRecordsGeneric!public!unit tests! !
testVarTypes!public!unit tests! !
testWithAll!public!unit tests! !
threePoints:!private!test fixtures! !
verifyCopy:!helpers!private!unit tests! !
!

!OS.COM.Tests.SAFEARRAYTest class methodsFor!

arrayClass
	^SAFEARRAY! !

!OS.COM.Tests.SAFEARRAYTest class categoriesForMethods!
arrayClass!constants!private! !
!

