"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.OleVariantTest'
	instanceVariableNames: 'subject'
	classVariableNames: ''
	imports: #(#{OS.COM.OleVariant})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.OleVariantTest guid: (Core.GUID fromString: '{50d16fd8-68c8-447b-8bf8-1ecdc62a30b2}')!

OS.COM.Tests.OleVariantTest isNonInstantiable: true!

OS.COM.Tests.OleVariantTest comment: ''!

!OS.COM.Tests.OleVariantTest methodsFor!

bstrArrayClass
	^self subclassResponsibility!

clsidVt
	^self subclassResponsibility!

elementClassFor: elementClass
	elementClass == BOOL ifTrue: [^VARIANT_BOOL].
	^elementClass!

exampleDates
	^{
		DateAndTime
			rataDie: DATE.EpochRD
			seconds: 0
			offsetSeconds: 0.
		DateAndTime
			rataDie: DATE.MinValue truncated + DATE.EpochRD
			seconds: DATE.MinValue fractionPart negated * 86400
			offsetSeconds: Locale timeZoneInformation offsetSeconds.
		DateAndTime
			year: 100
			month: 1
			day: 1
			offset: 0 seconds.
		DateAndTime
			rataDie: DATE.MaxValue truncated + DATE.EpochRD
			seconds: DATE.MaxValue fractionPart * 86400
			offsetSeconds: Locale timeZoneInformation offsetSeconds.
		DateAndTime
			year: 1899
			month: 12
			day: 30
			offset: 0 seconds.
		DateAndTime
			rataDie: 730179
			seconds: 86399.99995976686
			offsetSeconds: 0.
		DateAndTime
			year: 1601
			month: 1
			day: 1
			offset: 0 seconds
	}!

exampleFileTimes
	^##({
		DateAndTime
			year: 1601
			month: 1
			day: 1
			offset: 0 seconds.
		FILETIME minimum asDateAndTime.
		DateAndTime
			year: 1901
			month: 1
			day: 1
			offset: 0 seconds.
		DateAndTime
			year: 1970
			month: 1
			day: 1
			offset: 0 seconds.
		DateAndTime
			rataDie: 730179
			seconds: 86399.99995976686
			offsetSeconds: 0.
		DateAndTime
			rataDie: 3652059
			seconds: 86399.99995976686
			offsetSeconds: Locale timeZoneInformation offsetSeconds.
		(DateAndTime
			year: 1901
			month: 1
			day: 1
			offset: Locale timeZoneInformation offset) - 100 nanoseconds
	})!

freeSubject
	"Explicitly free the subject variant under test. Note that it is necessary to be careful about ordering if explictly freeing variants containing safearrays. If the safearray has been accessed at the time of attemped VariantClear, and a lock on the array has not yet been cleared, the the explicit free attempt will fail. If the variant and safearray are allowed to finalize, then because any SAFEARRAY read from a VARIANT will have an owner backpointer to the VARIANT from the SAFEARRAY, the freeing order will be correct (array first). If explicitly freeing, you must be sure to free any accessed arrays first. This can only be guaranteed at small scope, e.g. within a method, otherwise it is better to leave the cleanup to finalization."

	subject isNull ifTrue: [^self].
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	subject free.
	self deny: subject needsFree.
	self deny: subject isFinalizable.
	subject := nil!

isValidNullString: aString
	self assert: (aString yourAddress asExternalAddress at: 1) identicalTo: 0.
	self assert: aString equals: ''!

subjectClass
	self subclassResponsibility!

tearDown
	self freeSubject.
	super tearDown!

testAnsiStringArrayEmpty
	self verifyAnsiStringArray: #()!

testAnsiStringArrayMany
	self verifyAnsiStringArray: #('' 'a£b' '?')!

testAnsiStringArrayOne
	self verifyAnsiStringArray: #('a£b')!

testBoolArrayEmpty
	self verifyBoolArray: BOOLArray new!

testBoolArrayMany
	self verifyBoolArray: (BOOLArray withAll: #(true false true))!

testBoolArrayOne
	self verifyBoolArray: (BOOLArray with: true)!

testBSTR
	subject := self subjectClass new.
	subject bstr: 'abc'.
	self assert: subject vt identicalTo: VT_BSTR.
	self assert: subject value equals: 'abc'.
	subject bytes uintPtrAtOffset: _OffsetOf_pbstrVal put: 0.
	self isValidNullString: subject value.
	subject bstr: ''.
	self isValidNullString: subject value.
	subject := (OleAut32 sysAllocString: '') asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_BSTR.
	"Make sure there is a junk value in the free list"
	'abc' copy.
	self isValidNullString: subject value	"yourAddress asExternalAddress at: 1"!

testBstrArrayEmpty
	self verifyBstrArray: #()!

testBstrArrayMany
	self verifyBstrArray: #('' 'a🐬b' '£')!

testBstrArrayOne
	self verifyBstrArray: #('a🐬b')!

testByteArrayEmpty
	self verifyUInt8Array: #[]!

testByteArrayMany
	self verifyUInt8Array: #[0 1 255]!

testByteArrayOne
	self verifyUInt8Array: #[255]!

testCLSID
	{ CLSID null. CLSID fromString: '{0002E005-0000-0000-C000-000000000046}' } do: 
			[:each |
			| copy |
			subject := each asVariant: self subjectClass.
			self assert: subject vt identicalTo: self clsidVt.
			copy := self verifyPointerVar: subject value: each.
			self freeSubject.
			self assert: copy value equals: each.
			copy free]!

testCY
	{ 0s. 1234.456s. 1234.4567s. CY.MaxValue. CY.MinValue } do: 
			[:each |
			subject := self subjectClass new.
			subject cy: each.
			self assert: subject vt identicalTo: VT_CY.
			self assert: subject value equals: each.
			self assert: subject printString
				equals: 'a <1p>(cy: <2p>)' << {self subjectClass. (ScaledDecimal newFromNumber: each scale: 4)}.
			self freeSubject]!

testCyArrayEmpty
	self verifyCyArray: CYArray new!

testCyArrayMany
	self verifyCyArray: (CYArray withAll: {CY.MaxValue. CY.MaxValue negated. CY.MinValue. 0. 1. -1. 1 / 4. 123.456s4})!

testCyArrayOne
	self verifyCyArray: (CYArray withAll: {123.456s4})!

testCYREF
	| cy |
	cy := CY new value: 1234.1234s.
	subject := cy asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_CY | VT_BYREF.
	self assert: subject value equals: cy.
	self assert: subject value yourAddress equals: cy yourAddress.
	subject value value: 5678.5678s.
	self assert: cy value equals: 5678.5678s!

testDATE
	| date |
	subject := self subjectClass new.
	date := DATE new.
	subject date: date.
	self assert: subject vt identicalTo: VT_DATE.
	self assert: subject value equals: date.
	subject date: DATE maximum.
	self assert: subject value equals: DATE maximum.
	subject date: DATE minimum.
	self assert: subject value equals: DATE minimum!

testDateArrayMany
	self verifyDateArray: (DATEArray withAll: self exampleDates)!

testDECIMAL
	| value copy |
	subject := self subjectClass new.
	subject decimal: DECIMAL.MaxValue.
	self assert: subject vt identicalTo: VT_DECIMAL.
	value := subject value.
	self assert: value equals: DECIMAL.MaxValue.
	self assert: value isKindOf: ScaledDecimal.
	self assert: value scale equals: 0.
	self assert: subject displayString equals: DECIMAL.MaxValue displayString.
	self assert: subject printString
		equals: 'a <1p>(decimal: <2p>s)' << { self subjectClass. DECIMAL.MaxValue }.
	subject decimal: DECIMAL.SmallestValue.
	self assert: subject vt identicalTo: VT_DECIMAL.
	value := subject value.
	self assert: value equals: DECIMAL.SmallestValue.
	self assert: value scale equals: DECIMAL.MaxScale.
	self assert: subject displayString equals: (DECIMAL new value: DECIMAL.SmallestValue) displayString.
	self assert: subject printString
		equals: 'a <1p>(decimal: <2p>)' << { self subjectClass. DECIMAL.SmallestValue }.
	self freeSubject.
	subject := (ScaledDecimal newFromNumber: 0 scale: DECIMAL.MaxScale) asVariant: self subjectClass.
	value := subject value.
	self assert: value equals: 0.
	self assert: value scale equals: DECIMAL.MaxScale.
	self assert: subject printString
		equals: 'a <1p>(decimal: 0.<2s>s)' << { self subjectClass. String new: DECIMAL.MaxScale withAll: $0 }.
	self freeSubject.
	subject := 123.456s4 asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_DECIMAL.
	value := subject value.
	self assert: value equals: 123.456.
	self assert: value scale equals: 4.
	self assert: subject displayString equals: '123.456'.
	self assert: subject printString equals: 'a <1p>(decimal: 123.4560s)' << self subjectClass.
	copy := subject copy.
	self assert: copy vt identicalTo: VT_DECIMAL.
	self assert: copy value equals: 123.456s.
	copy free.
	self freeSubject!

testDecimalArrayEmpty
	self verifyDecimalArray: DECIMALArray new!

testDecimalArrayMany
	self verifyDecimalArray: (DECIMALArray
				withAll: { 0s. DECIMAL.MaxValue asScaledDecimal: 0. DECIMAL.SmallestValue. 0s28. 1.375s. -2.125s })!

testDecimalArrayOne
	self verifyDecimalArray: (DECIMALArray withAll: {123.456s4})!

testDECIMALRef
	| decimal value copy |
	decimal := OS.COM.DECIMAL new value: 123.456s4.
	subject := decimal asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_DECIMAL | VT_BYREF.
	value := subject value.
	self assert: value isKindOf: DECIMAL.
	self deny: value needsFree.
	self deny: value isFinalizable.
	self assert: value yourAddress equals: decimal yourAddress.
	self assert: value value equals: 123.456s.
	self assert: subject displayString equals: '123.456'.
	self assert: subject printString equals: 'a <1p>(decimal*: <2p>)' << { self subjectClass. decimal }.
	copy := subject copy.
	self assert: copy vt identicalTo: VT_DECIMAL | VT_BYREF.
	decimal scale: 2.
	self assert: value value equals: 12345.60s.
	self assert: copy value value equals: 12345.60s.
	copy free.
	self freeSubject!

testDISPATCH
	| obj val copy |
	obj := IDispatch createObject: 'StdFont'.
	self assert: obj referenceCount identicalTo: 1.
	subject := self subjectClass fromDispatch: obj.
	self assert: obj referenceCount identicalTo: 2.
	val := subject value.
	self assert: val referenceCount identicalTo: 3.
	self assert: val class identicalTo: IDispatch.
	self assert: (val isSameCOMObject: obj).
	val free.
	copy := subject copy.
	val := copy value.
	self assert: val class identicalTo: IDispatch.
	self assert: (val isSameCOMObject: obj).
	self assert: obj referenceCount identicalTo: 4.
	copy free.
	val free.
	self freeSubject.
	self assert: obj referenceCount equals: 1.
	obj free!

testDISPATCHREF
	| obj val |
	obj := IDispatch createObject: 'Internet.HHCtrl'.
	self assert: obj referenceCount identicalTo: 1.
	subject := self subjectClass new.
	subject vt: VT_DISPATCH | VT_BYREF.
	subject reference: obj bytes basicYourAddress.
	self assert: obj referenceCount identicalTo: 1.
	val := subject value.
	self assert: obj referenceCount identicalTo: 1.
	val free.
	self assert: obj referenceCount identicalTo: 1.
	self assert: subject value value asExternalAddress equals: obj bytes.
	obj free!

testDisplayString
	self subclassResponsibility!

testDoubleArrayEmpty
	self verifyDoubleArray: DOUBLEArray new!

testDoubleArrayMany
	self verifyDoubleArray: (DOUBLEArray withAll: {Float fmin. 0.0. -0.0. Float fmax. Float negativeInfinity. Float infinity})!

testDoubleArrayOne
	self verifyDoubleArray: (DOUBLEArray with: Float fmax)!

testEMPTY
	subject := self subjectClass new.
	subject nil: nil.
	self assert: subject vt identicalTo: VT_EMPTY.
	self assertIsNil: subject value!

testFILETIME
	self subclassResponsibility!

testFloatArrayEmpty
	self verifyFloatArray: FLOATArray new!

testFloatArrayMany
	self verifyFloatArray: (FLOATArray
				withAll: { Float negativeInfinity. -0.0. 0.0. 123456789.987654321. Float fmax })!

testFloatArrayOne
	self verifyFloatArray: (FLOATArray with: 123456789.987654321)!

testFromAddress
	| v2 |
	subject := 'abc' asVariant: self subjectClass.
	v2 := self subjectClass fromAddress: subject yourAddress.
	self assert: v2 value equals: 'abc'.
	self deny: subject isByRef.
	self deny: v2 isFinalizable.
	self deny: v2 needsFree.
	v2 free.
	self assert: subject value equals: 'abc'!

testFromInteger
	#(-16r80000000 -16r7FFFFFFF -2 -1 0 1 2 16r7FFFFFFE 16r7FFFFFFF) do: 
			[:each |
			subject := each asVariant: self subjectClass.
			self assert: subject vt equals: VT_I4.
			self assert: subject value equals: each.
			self freeSubject].
	#(-16r8000000000000000 -16r7FFFFFFFFFFFFFFF -16r80000001 16r80000000 16r7FFFFFFFFFFFFFFF) do: 
			[:each |
			subject := each asVariant: self subjectClass.
			self assert: subject vt equals: VT_I8.
			self assert: subject value equals: each.
			self freeSubject].
	#(16r8000000000000000 16r8000000000000001 16rFFFFFFFFFFFFFFFE 16rFFFFFFFFFFFFFFFF) do: 
			[:each |
			subject := each asVariant: self subjectClass.
			self assert: subject vt equals: VT_UI8.
			self assert: subject value equals: each.
			self freeSubject].
	#(-16r8000000000000001 16r10000000000000001)
		do: [:each | self should: [each asVariant: self subjectClass] raise: Error]!

testFromString
	#('' 'a' 'a£b' 'a🐬b') do: 
			[:each |
			subject := self subjectClass fromString: each.
			self verifyUtf16StringVar: subject equals: each.
			self freeSubject]!

testI1
	subject := self subjectClass new.
	subject int8: 0.
	self assert: subject vt identicalTo: VT_I1.
	self assert: subject value identicalTo: 0.
	subject int8: Int8.MaxValue.
	self assert: subject value identicalTo: Int8.MaxValue.
	self should: [subject int8: Int8.MaxValue + 1] raise: Error.
	subject int8: Int8.MinValue.
	self assert: subject value identicalTo: Int8.MinValue.
	self should: [subject int8: Int8.MinValue - 1] raise: Error!

testI1REF
	| byte |
	byte := Int8 new value: Int8.MaxValue.
	subject := byte asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_I1 | VT_BYREF.
	self assert: subject value equals: byte.
	self assert: subject value yourAddress equals: byte yourAddress.
	subject value value: Int8.MinValue.
	self assert: byte value equals: Int8.MinValue!

testI2
	subject := self subjectClass new.
	subject int16: 0.
	self assert: subject vt identicalTo: VT_I2.
	self assert: subject value identicalTo: 0.
	subject int16: Int16.MaxValue.
	self assert: subject value identicalTo: Int16.MaxValue.
	self should: [subject int16: Int16.MaxValue + 1] raise: Error.
	subject int16: Int16.MinValue.
	self assert: subject value identicalTo: Int16.MinValue.
	self should: [subject int16: Int16.MinValue - 1] raise: Error!

testI2REF
	| sword |
	sword := Int16 new value: Int16.MaxValue.
	subject := sword asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_I2 | VT_BYREF.
	self assert: subject value equals: sword.
	self assert: subject value yourAddress equals: sword yourAddress.
	subject value value: Int16.MinValue.
	self assert: sword value equals: Int16.MinValue!

testI4
	subject := self subjectClass new.
	subject int32: 0.
	self assert: subject vt identicalTo: VT_I4.
	self assert: subject value identicalTo: 0.
	subject int32: Int32.MaxValue.
	self assert: subject value equals: Int32.MaxValue.
	self should: [subject int32: Int32.MaxValue + 1] raise: Error.
	subject int32: Int32.MinValue.
	self assert: subject value equals: Int32.MinValue.
	self should: [subject int32: Int32.MinValue - 1] raise: Error!

testI4REF
	| int32 copy |
	int32 := Int32 new value: Int32.MaxValue.
	subject := int32 asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_I4 | VT_BYREF.
	self assert: subject value equals: int32.
	self assert: subject value yourAddress equals: int32 yourAddress.
	self assert: subject value value equals:  Int32.MaxValue.
	subject value value: Int32.MinValue.
	self assert: int32 value equals: Int32.MinValue.
	copy := subject copy.
	self assert: subject vt identicalTo: VT_I4 | VT_BYREF.
	self assert: subject value equals: int32.
	self assert: subject value yourAddress equals: int32 yourAddress.
	copy free.
	copy := subject deepCopy.
	self assert: copy vt identicalTo: VT_I4.
	self assert: copy value equals: int32.
	int32 value: 123.
	self assert: subject value equals: int32.
	self deny: copy value equals: int32!

testI8
	| copy |
	subject := self subjectClass new.
	subject int64: 0.
	self assert: subject vt identicalTo: VT_I8.
	self assert: subject value identicalTo: 0.
	subject int64: Int64.MaxValue.
	self assert: subject value equals: Int64.MaxValue.
	self should: [subject int64: Int64.MaxValue + 1] raise: Error.
	subject int64: Int64.MinValue.
	self assert: subject value equals: Int64.MinValue.
	self should: [subject int64: Int64.MinValue - 1] raise: Error.
	copy := subject copy.
	self assert: copy vt equals: VT_I8.
	self assert: copy value equals: subject value!

testI8REF
	| int64 copy |
	int64 := Int64 new value: Int64.MaxValue.
	subject := int64 asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_I8 | VT_BYREF.
	self assert: subject value equals: int64.
	self assert: subject value yourAddress equals: int64 yourAddress.
	self assert: subject value value equals:  Int64.MaxValue.
	subject value value: Int64.MinValue.
	self assert: int64 value equals: Int64.MinValue.
	copy := subject copy.
	self assert: subject vt identicalTo: VT_I8 | VT_BYREF.
	self assert: subject value equals: int64.
	self assert: subject value yourAddress equals: int64 yourAddress.
	copy free.
	copy := subject deepCopy.
	self assert: copy vt identicalTo: VT_I8.
	self assert: copy value equals: int64.
	int64 value: Int32.MaxValue + 1.
	self assert: subject value equals: int64.
	self deny: copy value equals: int64!

testINT
	subject := self subjectClass new.
	subject
		int32: 0;
		vt: VT_INT.
	self assert: subject value identicalTo: 0.
	subject
		int32: Int32.MaxValue;
		vt: VT_INT.
	self assert: subject value equals: Int32.MaxValue.
	subject
		int32: Int32.MinValue;
		vt: VT_INT.
	self assert: subject value equals: Int32.MinValue!

testInt16ArrayEmpty
	self verifyInt16Array: Int16Array new!

testInt16ArrayMany
	self verifyInt16Array: (Int16Array withAll: { Int16.MinValue. 0. Int16.MaxValue })!

testInt16ArrayOne
	self verifyInt16Array: (Int16Array with: -32768)!

testInt32ArrayEmpty
	self verifyInt32Array: Int32Array new!

testInt32ArrayMany
	self verifyInt32Array: (Int32Array withAll: #(-16r80000000 0 16r7FFFFFFF))!

testInt32ArrayOne
	self verifyInt32Array: (Int32Array with: -32769)!

testInt64ArrayEmpty
	self verifyInt64Array: Int64Array new!

testInt64ArrayMany
	self verifyInt64Array: (Int64Array withAll: #(-16r80000001 0 16r80000000))!

testInt64ArrayOne
	self verifyInt64Array: (Int64Array with: -16r80000001)!

testInt8ArrayEmpty
	self verifyInt8Array: Int8Array new!

testInt8ArrayMany
	self verifyInt8Array: (Int8Array withAll: #(-128 0 127))!

testInt8ArrayOne
	self verifyInt8Array: (Int8Array with: -128)!

testNULL
	subject := self subjectClass new.
	subject null: nil.
	self assert: subject vt identicalTo: VT_NULL.
	self assertIsNil: subject value!

testR4
	| max min |
	subject := self subjectClass new.
	subject float: 0.0.
	self assert: subject vt identicalTo: VT_R4.
	self assert: subject value equals: 0.0.
	max := FLOAT maximum value.
	subject float: max.
	self assert: (subject value equals: max).
	subject float: -1 * max.
	self assert: (subject value equals: -1 * max).
	min := FLOAT minimum value.
	subject float: min.
	self assert: (subject value equals: min)!

testR4Overflow
	<skipIf: #isNativeDebuggerPresent>
	| max fpeMask |
	subject := self subjectClass new.
	max := FLOAT maximum value.
	fpeMask := Float exceptionMask.
	Float exceptionMask: (fpeMask maskClear: CRTLibrary._EM_OVERFLOW).
	
	[self should: [subject float: max * 10] raise: Error.
	self should: [subject float: -10 * max] raise: Error]
			ensure: [Float exceptionMask: fpeMask]!

testR4REF
	| float |
	float := FLOAT maximum copy.
	subject := float asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_R4 | VT_BYREF.
	self assert: subject value equals: float.
	self assert: subject value yourAddress equals: float yourAddress.
	subject value value: FLOAT minimum value.
	self assert: (float value equals: FLOAT minimum value)!

testR8
	subject := self subjectClass new.
	subject double: 0.0.
	self assert: subject vt identicalTo: VT_R8.
	self assert: subject value equals: 0.0.
	subject double: -1.0.
	self assert: (subject value equals: -1.0).
	subject double: Float fmax.
	self assert: (subject value equals: Float fmax).
	subject double: Float fmin.
	self assert: (subject value equals: Float fmin)!

testR8REF
	| double |
	double := DOUBLE new value: Float fmax.
	subject := double asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_R8 | VT_BYREF.
	self assert: subject value equals: double.
	self assert: subject value yourAddress equals: double yourAddress.
	subject value value: Float fmin.
	self assert: (double value equals: Float fmin)!

testRecord
	| recordInfo anonPoint record copy |
	"We have to wait for the temporary recordInfo points created when assigning the record into the variant to be finalized"
	anonPoint := POINTL newAnonymousSubclass.
	recordInfo := anonPoint recordInfo.
	record := anonPoint x: 101 y: 204.
	self assert: recordInfo referenceCount equals: 1.
	subject := record asVariant.
	self waitForFinalization: [recordInfo referenceCount = 2].
	self assert: subject value equals: record.
	subject value x: 102.
	self deny: subject value equals: record.
	self waitForFinalization: [recordInfo referenceCount = 2].
	copy := subject copy.
	self assert: recordInfo referenceCount equals: 3.
	self assert: copy value equals: subject value.
	copy value y: 205.
	self deny: copy value equals: subject value.
	copy free.
	self waitForFinalization: [recordInfo referenceCount = 2].
	subject free.
	self assert: recordInfo referenceCount equals: 1.
	recordInfo free!

testRecordByRef
	| recordInfo anonPoint record copy |
	"We have to wait for the temporary recordInfo points created when assigning the record into the variant to be finalized"
	anonPoint := POINTL newAnonymousSubclass.
	recordInfo := anonPoint recordInfo.
	record := anonPoint x: 101 y: 204.
	self assert: recordInfo referenceCount equals: 1.
	subject := VARIANT new struct: record; yourself.
	self assert: subject isByRef.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self waitForFinalization: [recordInfo referenceCount = 1].
	self assert: subject value equals: record.
	"As the structure is referenced, we should write through it to the original record"
	subject value x: 102.
	self assert: record x equals: 102.
	self waitForFinalization: [recordInfo referenceCount = 1].
	"VariantCopy behavior is (oddly) that it does not dereference VT_BYREFs to a copy."
	copy := subject copy.
	self waitForFinalization: [recordInfo referenceCount = 1].
	copy value x: 103.
	self assert: record x equals: 103.
	self waitForFinalization: [recordInfo referenceCount = 1].
	copy free.
	self assert: recordInfo referenceCount equals: 1.
	"VariantCopyInd does make a copy"
	copy := subject deepCopy.
	self assert: recordInfo referenceCount equals: 2.
	copy value x: 104.
	self assert: record x equals: 103.
	self assert: subject value x equals: 103.
	self waitForFinalization: [recordInfo referenceCount = 2].
	copy free.
	self assert: recordInfo referenceCount equals: 1.
	subject free.
	self assert: recordInfo referenceCount equals: 1.
	recordInfo free!

testSafeArrayEmpty
	| array |
	subject := #() asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_ARRAY | VT_VARIANT.
	array := subject value.
	self assert: array asArray equals: #().
	array free.
	self freeSubject!

testSafeArrayMany
	| array arrayVal |
	array := #(0 1234 1.234 'abc' 16r7FFFFFFF -16r80000000 16r80000000 16rFFFFFFFF 16rFFFFFFFFFFFFFFFF)
				copy.
	subject := array asVariant: self subjectClass.
	self assert: subject vt equals: VT_ARRAY | VT_VARIANT.
	arrayVal := subject value.
	self assert: arrayVal class equals: SAFEARRAY.
	self deny: arrayVal needsFree.
	self assert: arrayVal asArray equals: array.
	arrayVal free.
	"The array should be a reference into the safearray in the variant, so updating it should update the variant."
	arrayVal := subject value.
	self assert: arrayVal asArray equals: array.
	arrayVal at: 1 put: (array at: 1 put: 'def').
	self assert: arrayVal asArray equals: array.
	arrayVal free.
	arrayVal := subject value.
	self assert: arrayVal asArray equals: array.
	arrayVal free.
	self freeSubject!

testSafeArrayOne
	| arrayVal |
	subject := #(1) asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_ARRAY | VT_VARIANT.
	arrayVal := subject value.
	self assert: arrayVal asArray equals: #(1).
	arrayVal free!

testSafeArrayRefEmpty
	| array |
	subject := self subjectClass new
				arrayRef: #();
				yourself.
	self assert: subject vt identicalTo: VT_BYREF | VT_ARRAY | VT_VARIANT.
	array := subject value.
	self assert: array asArray equals: #().
	"The array object holds a lock that will be released by finalization. As it holds a ref back to the variant it will get finalized first so can release the lock before the underlying array is freed. If free'ing explicitly, we must free it first."
	array free.
	self freeSubject!

testSafeArrayRefMany
	| array val |
	array := (UInt32Array withAll: #(1 2 3 4)) asSAFEARRAY.
	subject := self subjectClass new
				arrayRef: array;
				yourself.
	self assert: subject vt identicalTo: VT_BYREF | VT_ARRAY | VT_UI4.
	val := subject value.
	self assert: val asArray equals: #(1 2 3 4).
	val free.
	1 to: 4 do: [:each | array at: each put: each * each].
	val := subject value.
	self assert: val asArray equals: #(1 4 9 16).
	val free.
	self freeSubject!

testSafeArrayRefOne
	| array |
	array := #(1) asSAFEARRAY.
	subject := self subjectClass new
				arrayRef: array;
				yourself.
	self assert: subject isFinalizable.
	self assert: subject vt identicalTo: VT_BYREF | VT_ARRAY | VT_VARIANT.
	self assert: subject value asArray equals: #(1).
	array at: 1 put: 2.
	self assert: subject value asArray equals: #(2).
	"for this one case don't free the test objects explicitly to check that the finalization order is correct. If not an error will be thrown in the finalization process."
	subject := nil!

testUI1
	subject := self subjectClass new.
	subject uint8: 0.
	self assert: subject vt identicalTo: VT_UI1.
	self assert: subject value identicalTo: 0.
	subject uint8: UInt8.MaxValue.
	self assert: subject value identicalTo: UInt8.MaxValue.
	self should: [subject uint8: UInt8.MaxValue+1] raise: Error.
	self should: [subject uint8: -1] raise: Error.
	self freeSubject!

testUI1REF
	| uint8 |
	uint8 := UInt8 new value: UInt8.MaxValue.
	subject := uint8 asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_UI1 | VT_BYREF.
	self assert: subject value equals: uint8.
	self assert: subject value yourAddress equals: uint8 yourAddress.
	subject value value: Int8.MaxValue+1.
	self assert: uint8 value equals: Int8.MaxValue+1.
	self freeSubject!

testUI2
	subject := self subjectClass new.
	subject uint16: 0.
	self assert: subject vt identicalTo: VT_UI2.
	self assert: subject value identicalTo: 0.
	subject uint16: UInt16.MaxValue.
	self assert: subject value identicalTo: UInt16.MaxValue.
	self should: [subject uint16: UInt16.MaxValue + 1] raise: Error.
	self should: [subject uint16: -1] raise: Error.
	self freeSubject!

testUI2REF
	| uint16 |
	uint16 := UInt16 new value: UInt16.MaxValue.
	subject := uint16 asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_UI2 | VT_BYREF.
	self assert: subject value equals: uint16.
	self assert: subject value yourAddress equals: uint16 yourAddress.
	subject value value: Int16.MaxValue + 1.
	self assert: uint16 value equals: Int16.MaxValue + 1.
	self freeSubject!

testUI4
	subject := self subjectClass new.
	subject uint32: 0.
	self assert: subject vt identicalTo: VT_UI4.
	self assert: subject value identicalTo: 0.
	subject uint32: 0.0.
	self assert: subject vt identicalTo: VT_UI4.
	self assert: subject value identicalTo: 0.
	subject uint32: UInt32.MaxValue.
	self assert: subject value equals: UInt32.MaxValue.
	self should: [subject uint32: UInt32.MaxValue+1] raise: Error.
	"uint32AtOffset:put: accepts negative values"
	subject uint32: -1.
	self assert: subject value equals: UInt32.MaxValue.
	self freeSubject!

testUI4REF
	| uint32 |
	uint32 := UInt32 new value: UInt32.MaxValue.
	subject := uint32 asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_UI4 | VT_BYREF.
	self assert: subject value equals: uint32.
	self assert: subject value yourAddress equals: uint32 yourAddress.
	subject value value: Int32.MaxValue + 1.
	self assert: uint32 value equals: Int32.MaxValue + 1.
	self freeSubject!

testUI8
	subject := self subjectClass new.
	subject uint64: 0.
	self assert: subject vt identicalTo: VT_UI8.
	self assert: subject value identicalTo: 0.
	subject uint64: 0.0.
	self assert: subject vt identicalTo: VT_UI8.
	self assert: subject value identicalTo: 0.
	subject uint64: UInt64.MaxValue.
	self assert: subject value equals: UInt64.MaxValue.
	self should: [subject uint64: UInt64.MaxValue + 1] raise: Error.
	"uint64AtOffset:put: accepts negative values"
	subject uint64: -1.
	self assert: subject value equals: UInt64.MaxValue.
	self freeSubject!

testUI8REF
	| uint64 |
	uint64 := UInt64 new value: UInt64.MaxValue.
	subject := uint64 asVariant: self subjectClass.
	self assert: subject vt identicalTo: VT_UI8 | VT_BYREF.
	self assert: subject value equals: uint64.
	self assert: subject value yourAddress equals: uint64 yourAddress.
	subject value value: UInt32.MaxValue + 1.
	self assert: uint64 value equals: UInt32.MaxValue + 1.
	self freeSubject!

testUInt16ArrayEmpty
	self verifyUInt16Array: UInt16Array new!

testUInt16ArrayMany
	self verifyUInt16Array: (UInt16Array withAll: #(0 32768 65535))!

testUInt16ArrayOne
	self verifyUInt16Array: (UInt16Array with: 32768)!

testUInt32ArrayEmpty
	self verifyUInt32Array: UInt32Array new!

testUInt32ArrayMany
	self
		verifyUInt32Array: (UInt32Array withAll: { 0. Int32.MaxValue. Int32.MaxValue + 1. UInt32.MaxValue })!

testUInt32ArrayOne
	self verifyUInt32Array: (UInt32Array with: 65536)!

testUInt64ArrayEmpty
	self verifyUInt64Array: UInt64Array new!

testUInt64ArrayMany
	self verifyUInt64Array: (UInt64Array withAll: #(0 16r100000000 16rFFFFFFFFFFFFFFFF))!

testUInt64ArrayOne
	self verifyUInt64Array: (UInt64Array with: UInt64.MaxValue)!

testUInt8ArrayEmpty
	self verifyUInt8Array: UInt8Array new!

testUInt8ArrayMany
	self verifyUInt8Array: (UInt8Array withAll: #[0 1 255])!

testUInt8ArrayOne
	self verifyUInt8Array: (UInt8Array with: 128)!

testUtf16StringArrayEmpty
	self verifyUtf16StringArray: #()!

testUtf16StringArrayMany
	self verifyUtf16StringArray: #('' 'a🐬b' '£')!

testUtf16StringArrayOne
	self verifyUtf16StringArray: #('a🐬b')!

testVarBoolArrayEmpty
	self verifyVarBoolArray: VARIANT_BOOLArray new!

testVarBoolArrayMany
	self verifyVarBoolArray: (VARIANT_BOOLArray withAll: #(true false true))!

testVarBoolArrayOne
	self verifyVarBoolArray: (VARIANT_BOOLArray with: true)!

testVARIANTArrayEmpty
	self verifyVARIANTArray: (self subjectClass arrayType new)!

testVARIANTArrayMany
	self verifyVARIANTArray: (self subjectClass arrayType withAll: {'abc'. (100@200). 1.25})!

testVARIANTArrayOne
	self verifyVARIANTArray: (self subjectClass arrayType withAll: #('abc'))!

vectorVtFlag
	^self subclassResponsibility!

verifyAnsiStringArray: anArrayOfStrings
	| strings |
	strings := AnsiStringArray withAll: anArrayOfStrings.
	self verifyExternalArray: strings.
	strings free!

verifyBoolArray: aBOOLArray
	| bools |
	self verifyExternalArray: aBOOLArray.
	bools := subject asExternalArray.
	self assert: bools isKindOf: BOOLArray.
	self deny: bools isPointerStruct.
	self assert: bools equals: aBOOLArray!

verifyBstrArray: anArrayOfStrings
	| value |
	subject := self subjectClass new bstrVector: anArrayOfStrings.
	self assert: subject vt equals: self vectorVtFlag | VT_BSTR.
	value := subject value.
	self assert: value owner equals: subject.
	self deny: value needsFree.
	self assert: value isKindOf: self bstrArrayClass.
	self assert: value elementClass identicalTo: BSTR.
	self assert: value size equals: anArrayOfStrings size.
	self assert: value asArray equals: anArrayOfStrings.
	value free!

verifyCyArray: aCyArray
	self verifyExternalArray: aCyArray.
	self assert: subject cyVector equals: aCyArray!

verifyDateArray: aFILETIMEArray
	self verifyExternalArray: aFILETIMEArray!

verifyDecimalArray: aDECIMALArray
	"Note that there is no VT_VECTOR | VT_DECIMAL support in PROPVARIANT, so this is always represented as a SAFEARRAY of VT_DECIMAL."

	self verifyExternalArray: aDECIMALArray.
	self assert: subject decimalVector equals: aDECIMALArray!

verifyDoubleArray: aDOUBLEArray
	self verifyExternalArray: aDOUBLEArray.
	self assert: subject doubleVector equals: aDOUBLEArray.
	self assert: subject asExternalArray equals: aDOUBLEArray!

verifyExternalArray: anExternalArray
	| value varElementClass |
	subject := anExternalArray asVariant: self subjectClass.
	varElementClass := self elementClassFor: anExternalArray elementClass.
	self assert: subject vt equals: VT_ARRAY | varElementClass vt.
	self assert: subject asExternalArray equals: anExternalArray.
	value := subject value.
	self assert: value isKindOf: SAFEARRAY.
	self assert: value isReferenceStruct.
	self assert: value owner equals: subject.
	self deny: value needsFree.
	self assert: value isFinalizable.
	self assert: value elementClass equals: varElementClass.
	self assert: value size equals: anExternalArray length.
	self assert: value asArray equals: anExternalArray asArray.
	"Since we explicitly free the subject variant in teardown, we must also free the value safearray that will be locked, or at least unlock it."
	value free
!

verifyFileTimeArray: aFILETIMEArray
	self verifyExternalArray: aFILETIMEArray!

verifyFloatArray: aFLOATArray
	self verifyExternalArray: aFLOATArray.
	self assert: subject floatVector equals: aFLOATArray.
	self assert: subject asExternalArray equals: aFLOATArray!

verifyInt16Array: anInt16Array
	self verifyExternalArray: anInt16Array.
	self assert: subject int16Vector equals: anInt16Array!

verifyInt32Array: anInt32Array
	self verifyExternalArray: anInt32Array.
	self assert: subject int32Vector equals: anInt32Array!

verifyInt64Array: anInt64Array
	self verifyExternalArray: anInt64Array.
	self assert: subject asExternalArray equals: anInt64Array.
	self assert: subject int64Vector equals: anInt64Array!

verifyInt8Array: anInt8Array
	self verifyExternalArray: anInt8Array.
	self assert: subject int8Vector equals: anInt8Array!

verifyPointerVar: aVARIANT value: anObject
	| copy |
	self assert: aVARIANT value equals: anObject.
	"The value in the VARIANT must be allocated from COM Task memory"
	self assert: (IMalloc task didAlloc: aVARIANT intptr).
	copy := aVARIANT copy.
	"VarCmp doesn't work for VT_RECORD (it could I think)"
	aVARIANT vt = VT_RECORD
		ifTrue: [
			self assert: copy vt equals: VT_RECORD.
			self assert: copy recordInfo equals: aVARIANT recordInfo]
		ifFalse: [
			self assert: copy equals: aVARIANT].
	self assert: copy value equals: anObject.
	self deny: copy intptr equals: aVARIANT intptr.
	self assert: (IMalloc task didAlloc: copy intptr).
	^copy!

verifyUInt16Array: anUInt16Array
	self verifyExternalArray: anUInt16Array.
	self assert: subject uint16Vector equals: anUInt16Array!

verifyUInt32Array: anUInt32Array
	self verifyExternalArray: anUInt32Array.
	self assert: subject uint32Vector equals: anUInt32Array!

verifyUInt64Array: anUInt64Array
	self verifyExternalArray: anUInt64Array.
	self assert: subject uint64Vector equals: anUInt64Array!

verifyUInt8Array: aUInt8Array
	| value bytes |
	subject := aUInt8Array asVariant: self subjectClass.
	self assert: subject vt equals: self vectorVtFlag | VT_UI1.
	value := subject value.
	self assert: value owner equals: subject.
	self deny: value needsFree.
	self assert: value elementClass equals: UInt8.
	self assert: value size equals: aUInt8Array size.
	self assert: value asByteArray equals: aUInt8Array asByteArray.
	value free.
	bytes := subject asExternalArray.
	self assert: bytes isKindOf: UInt8Array.
	self assert: bytes asByteArray equals: aUInt8Array asByteArray.
	bytes := subject uint8Vector.
	self assert: bytes isKindOf: UInt8Array.
	self assert: bytes asByteArray equals: aUInt8Array asByteArray.
	
	!

verifyUtf16StringArray: anArrayOfStrings
	| strings |
	strings := Utf16StringArray withAll: anArrayOfStrings.
	self verifyExternalArray: strings.
	strings free!

verifyUtf16StringVar: anAbstractVariant equals: aString
	self subclassResponsibility!

verifyVarBoolArray: aVARIANT_BOOLArray
	| bools |
	self verifyExternalArray: aVARIANT_BOOLArray.
	bools := subject varBoolVector.
	self assert: bools isKindOf: VARIANT_BOOLArray.
	self deny: bools isPointerStruct.
	self assert: bools equals: aVARIANT_BOOLArray!

verifyVARIANTArray: aVARIANTArray
	self verifyExternalArray: aVARIANTArray.
	self assert: subject variantVector equals: aVARIANTArray!

waitForFinalization: aNiladicValuable
	| attempts |
	attempts := 0.
	[(attempts := attempts + 1) < 5 and: [aNiladicValuable value not]] whileTrue: 
			[MemoryManager current
				collectGarbage;
				administerLastRites].
	self assert: aNiladicValuable value! !

!OS.COM.Tests.OleVariantTest categoriesForMethods!
bstrArrayClass!helpers!private! !
clsidVt!constants!private! !
elementClassFor:!helpers!private! !
exampleDates!constants!private! !
exampleFileTimes!constants!private! !
freeSubject!private!running! !
isValidNullString:!private!testing! !
subjectClass!constants!private! !
tearDown!private!running! !
testAnsiStringArrayEmpty!public!unit tests! !
testAnsiStringArrayMany!public!unit tests! !
testAnsiStringArrayOne!public!unit tests! !
testBoolArrayEmpty!public!unit tests! !
testBoolArrayMany!public!unit tests! !
testBoolArrayOne!public!unit tests! !
testBSTR!public!unit tests! !
testBstrArrayEmpty!public!unit tests! !
testBstrArrayMany!public!unit tests! !
testBstrArrayOne!public!unit tests! !
testByteArrayEmpty!public!unit tests! !
testByteArrayMany!public!unit tests! !
testByteArrayOne!public!unit tests! !
testCLSID!public!unit tests! !
testCY!public!unit tests! !
testCyArrayEmpty!public!unit tests! !
testCyArrayMany!public!unit tests! !
testCyArrayOne!public!unit tests! !
testCYREF!public!unit tests! !
testDATE!public!unit tests! !
testDateArrayMany!public!unit tests! !
testDECIMAL!public!unit tests! !
testDecimalArrayEmpty!public!unit tests! !
testDecimalArrayMany!public!unit tests! !
testDecimalArrayOne!public!unit tests! !
testDECIMALRef!public!unit tests! !
testDISPATCH!public!unit tests! !
testDISPATCHREF!public!unit tests! !
testDisplayString!public!unit tests! !
testDoubleArrayEmpty!public!unit tests! !
testDoubleArrayMany!public!unit tests! !
testDoubleArrayOne!public!unit tests! !
testEMPTY!public!unit tests! !
testFILETIME!public!unit tests! !
testFloatArrayEmpty!public!unit tests! !
testFloatArrayMany!public!unit tests! !
testFloatArrayOne!public!unit tests! !
testFromAddress!public!unit tests! !
testFromInteger!public!unit tests! !
testFromString!public!unit tests! !
testI1!public!unit tests! !
testI1REF!public!unit tests! !
testI2!public!unit tests! !
testI2REF!public!unit tests! !
testI4!public!unit tests! !
testI4REF!public!unit tests! !
testI8!public!unit tests! !
testI8REF!public!unit tests! !
testINT!public!unit tests! !
testInt16ArrayEmpty!public!unit tests! !
testInt16ArrayMany!public!unit tests! !
testInt16ArrayOne!public!unit tests! !
testInt32ArrayEmpty!public!unit tests! !
testInt32ArrayMany!public!unit tests! !
testInt32ArrayOne!public!unit tests! !
testInt64ArrayEmpty!public!unit tests! !
testInt64ArrayMany!public!unit tests! !
testInt64ArrayOne!public!unit tests! !
testInt8ArrayEmpty!public!unit tests! !
testInt8ArrayMany!public!unit tests! !
testInt8ArrayOne!public!unit tests! !
testNULL!public!unit tests! !
testR4!public!unit tests! !
testR4Overflow!public!unit tests! !
testR4REF!public!unit tests! !
testR8!public!unit tests! !
testR8REF!public!unit tests! !
testRecord!public!unit tests! !
testRecordByRef!public!unit tests! !
testSafeArrayEmpty!public!unit tests! !
testSafeArrayMany!public!unit tests! !
testSafeArrayOne!public!unit tests! !
testSafeArrayRefEmpty!public!unit tests! !
testSafeArrayRefMany!public!unit tests! !
testSafeArrayRefOne!public!unit tests! !
testUI1!public!unit tests! !
testUI1REF!public!unit tests! !
testUI2!public!unit tests! !
testUI2REF!public!unit tests! !
testUI4!public!unit tests! !
testUI4REF!public!unit tests! !
testUI8!public!unit tests! !
testUI8REF!public!unit tests! !
testUInt16ArrayEmpty!public!unit tests! !
testUInt16ArrayMany!public!unit tests! !
testUInt16ArrayOne!public!unit tests! !
testUInt32ArrayEmpty!public!unit tests! !
testUInt32ArrayMany!public!unit tests! !
testUInt32ArrayOne!public!unit tests! !
testUInt64ArrayEmpty!public!unit tests! !
testUInt64ArrayMany!public!unit tests! !
testUInt64ArrayOne!public!unit tests! !
testUInt8ArrayEmpty!public!unit tests! !
testUInt8ArrayMany!public!unit tests! !
testUInt8ArrayOne!public!unit tests! !
testUtf16StringArrayEmpty!public!unit tests! !
testUtf16StringArrayMany!public!unit tests! !
testUtf16StringArrayOne!public!unit tests! !
testVarBoolArrayEmpty!public!unit tests! !
testVarBoolArrayMany!public!unit tests! !
testVarBoolArrayOne!public!unit tests! !
testVARIANTArrayEmpty!public!unit tests! !
testVARIANTArrayMany!public!unit tests! !
testVARIANTArrayOne!public!unit tests! !
vectorVtFlag!constants!private! !
verifyAnsiStringArray:!helpers!private! !
verifyBoolArray:!helpers!private! !
verifyBstrArray:!helpers!private! !
verifyCyArray:!helpers!private! !
verifyDateArray:!helpers!private! !
verifyDecimalArray:!helpers!private! !
verifyDoubleArray:!helpers!private! !
verifyExternalArray:!helpers!private! !
verifyFileTimeArray:!helpers!private! !
verifyFloatArray:!helpers!private! !
verifyInt16Array:!helpers!private! !
verifyInt32Array:!helpers!private! !
verifyInt64Array:!helpers!private! !
verifyInt8Array:!helpers!private! !
verifyPointerVar:value:!helpers!private! !
verifyUInt16Array:!helpers!private! !
verifyUInt32Array:!helpers!private! !
verifyUInt64Array:!helpers!private! !
verifyUInt8Array:!helpers!private! !
verifyUtf16StringArray:!helpers!private! !
verifyUtf16StringVar:equals:!helpers!private! !
verifyVarBoolArray:!helpers!private! !
verifyVARIANTArray:!helpers!private! !
waitForFinalization:!public!unit tests! !
!

