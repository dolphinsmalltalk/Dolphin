"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'OS.COM.Tests.VARIANTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.VARIANTTest guid: (Core.GUID fromString: '{f436bdf8-12ff-47e4-ad1a-c96795760912}')!
OS.COM.Tests.VARIANTTest comment: ''!
!OS.COM.Tests.VARIANTTest methodsFor!

isValidNullString: aString
	self assert: (aString yourAddress asExternalAddress at: 1) identicalTo: 0.
	self assert: aString equals: ''!

testARRAY
	| var |
	var := #() asVariant.
	self assert: var vt identicalTo: VT_ARRAY | VT_VARIANT.
	self assert: var value asArray equals: #().
	var := #(1) asVariant.
	self assert: var vt identicalTo: VT_ARRAY | VT_VARIANT.
	self assert: var value asArray equals: #(1).
	var := #(1 2 3 4) asVariant.
	self assert: var vt identicalTo: VT_ARRAY | VT_VARIANT.
	self assert: var value asArray equals: #(1 2 3 4)!

testARRAYREF
	"#1136"

	| var array |
	var := VARIANT new
				arrayRef: #();
				yourself.
	self assert: var vt identicalTo: VT_BYREF | VT_ARRAY | VT_VARIANT.
	self assert: var value asArray equals: #().
	array := #(1) asSAFEARRAY.
	var := VARIANT new
				arrayRef: array;
				yourself.
	self assert: var vt identicalTo: VT_BYREF | VT_ARRAY | VT_VARIANT.
	self assert: var value asArray equals: #(1).
	array at: 1 put: 2.
	self assert: var value asArray equals: #(2).
	array := (UInt32Array withAll: #(1 2 3 4)) asSAFEARRAY.
	var := VARIANT new
				arrayRef: array;
				yourself.
	self assert: var vt identicalTo: VT_BYREF | VT_ARRAY | VT_UI4.
	self assert: var value asArray equals: #(1 2 3 4).
	1 to: 4 do: [:each | array at: each put: each * each].
	self assert: var value asArray equals: #(1 4 9 16)!

testBSTR
	| var |
	var := VARIANT new.
	var bstr: 'abc'.
	self assert: var vt identicalTo: VT_BSTR.
	self assert: var value equals: 'abc'.
	var bytes uintPtrAtOffset: VARIANT._OffsetOf_pbstrVal put: 0.
	self isValidNullString: var value.
	var bstr: ''.
	self isValidNullString: var value.
	var := (OleAut32 sysAllocString: '') asVariant.
	"Make sure there is a junk value in the free list"
	'abc' copy.
	self isValidNullString: var value	"yourAddress asExternalAddress at: 1"!

testCollectionConversions
	| bytes var array sa |
	array := #(0 1234 1.234 'abc' 16r7FFFFFFF -16r80000000 16r80000000 16rFFFFFFFF 16rFFFFFFFFFFFFFFFF).
	var := array asVariant.
	self assert: var vt equals: VT_ARRAY | VT_VARIANT.
	sa := var value.
	self assert: sa asArray equals: array.
	"Test ByteArray converts to VT_ARRAY|VT_UI1"
	bytes := #[1 2 3].
	var := bytes asVariant.
	self assert: var vt equals: VT_ARRAY | VT_UI1.
	self assert: var value asArray asByteArray equals: bytes.
	"External array types"
	#(#{DOUBLEArray} #{FLOATArray} #{UInt32Array} #{Int32Array} #{UInt16Array} #{Int16Array}) do: 
			[:each |
			| class |
			class := each value.
			array := class withAll: #(1 2 3).
			var := array asVariant.
			self assert: var vt equals: VT_ARRAY | array elementClass vt.
			self assert: var value asArray equals: array]!

testCY
	{0s. 1234.456s. 1234.4567s. CURRENCY.MaxValue. CURRENCY.MinValue} do: 
			[:each |
			| var |
			var := VARIANT new.
			var cy: each.
			self assert: var vt identicalTo: VT_CY.
			self assert: var value equals: each.
			self assert: var printString
				equals: 'a VARIANT(cy: <1p>)' << (ScaledDecimal newFromNumber: each scale: 4).
			self assert: var displayString equals: each displayString]!

testCYREF
	| var cy |
	var := VARIANT new.
	cy := CURRENCY new value: 1234.1234s.
	var := cy asVariant.
	self assert: var vt identicalTo: VT_CY | VT_BYREF.
	self assert: var value equals: cy.
	self assert: var value yourAddress equals: cy yourAddress.
	var value value: 5678.5678s.
	self assert: cy value equals: 5678.5678s!

testDATE
	| var date |
	var := VARIANT new.
	date := DATE new.
	var := var date: date.
	self assert: var vt identicalTo: VT_DATE.
	self assert: var value equals: date.
	var date: DATE maximum.
	self assert: var value equals: DATE maximum.
	var date: DATE minimum.
	self assert: var value equals: DATE minimum!

testDECIMAL
	| var value |
	var := VARIANT new.
	var decimal: DECIMAL.MaxValue.
	self assert: var vt identicalTo: VT_DECIMAL.
	value := var value.
	self assert: value equals: DECIMAL.MaxValue.
	self assert: value isKindOf: ScaledDecimal.
	self assert: value scale equals: 0.
	self assert: var displayString equals: DECIMAL.MaxValue displayString.
	self assert: var printString equals: 'a VARIANT(decimal: <1p>s)' << DECIMAL.MaxValue.
	var decimal: DECIMAL.SmallestValue.
	self assert: var vt identicalTo: VT_DECIMAL.
	value := var value.
	self assert: value equals: DECIMAL.SmallestValue.
	self assert: value scale equals: DECIMAL.MaxScale.
	self assert: var displayString equals: DECIMAL.SmallestValue displayString.
	self assert: var printString equals: 'a VARIANT(decimal: <1p>)' << DECIMAL.SmallestValue.
	var decimal: (ScaledDecimal newFromNumber: 0 scale: DECIMAL.MaxScale).
	value := var value.
	self assert: value equals: 0.
	self assert: value scale equals: DECIMAL.MaxScale.
	self assert: var printString
		equals: 'a VARIANT(decimal: 0.<1s>s)' << (String new: DECIMAL.MaxScale withAll: $0).
	var decimal: 123.456s4.
	self assert: var vt identicalTo: VT_DECIMAL.
	value := var value.
	self assert: value equals: 123.456.
	self assert: value scale equals: 4.
	self assert: var displayString equals: '123.456'.
	self assert: var printString equals: 'a VARIANT(decimal: 123.4560s)'!

testDISPATCH
	| var obj val |
	obj := IDispatch createObject: 'Internet.HHCtrl'.
	self assert: obj referenceCount identicalTo: 1.
	var := VARIANT new.
	var dispatch: obj.
	self assert: obj referenceCount identicalTo: 2.
	val := var value.
	self assert: val referenceCount identicalTo: 3.
	val free.
	self assert: var value referenceCount identicalTo: 3.
	self assert: var value class identicalTo: IDispatch.
	self assert: (var value isSameCOMObject: obj)!

testDISPATCHREF
	| var obj val |
	obj := IDispatch createObject: 'Internet.HHCtrl'.
	self assert: obj referenceCount identicalTo: 1.
	var := VARIANT new.
	var vt: VT_DISPATCH | VT_BYREF.
	var reference: obj bytes basicYourAddress.
	self assert: obj referenceCount identicalTo: 1.
	val := var value.
	self assert: obj referenceCount identicalTo: 1.
	val free.
	self assert: obj referenceCount identicalTo: 1.
	self assert: var value value asExternalAddress equals: obj bytes.
	obj free!

testDisplayString
	| dateTime |
	dateTime := DateAndTime
				year: 2020
				day: 180
				hour: 17
				minute: 59
				second: 01.
	{{'es'. {true. 'Verdadero'. false. 'Falso'. 1.23. '1,23'. dateTime. '28/06/2020 17:59:01'. #(true false). '(Verdadero; Falso)'}}.
		{'en'. {true. 'True'. false. 'False'. 1.23. '1.23'. dateTime. '6/28/2020 5:59:01 PM'. #(true false). '(True, False)'}}} do: 
				[:each |
				| locale |
				"Use a locale without user overrides so that the date ordering and decimal separator follow standard conventions for the locale and match the test expectation"
				locale := Locale standard: each first.
				each second pairsDo: 
						[:value :expected |
						| actual |
						actual := String streamContents: [:strm | strm locale: locale. value asVariant displayOn: strm].
						self assert: actual equals: expected]]!

testEMPTY
	| var |
	var := VARIANT new.
	var nil: nil.
	self assert: var vt identicalTo: VT_EMPTY.
	self assertIsNil: var value!

testFromAddress
	| v1 v2 |
	v1 := 'abc' asVariant.
	v2 := VARIANT fromAddress: v1 yourAddress.
	self assert: v2 value equals: 'abc'.
	self deny: v1 isByRef.
	self deny: v2 isFinalizable.
	self deny: v2 needsFree.
	v2 free.
	self assert: v1 value equals: 'abc'!

testFromInteger
	| var |
	#(-16r80000000 -16r7FFFFFFF -2 -1 0 1 2 16r7FFFFFFE 16r7FFFFFFF) do: 
			[:each |
			var := each asVariant.
			self assert: var vt equals: VT_I4.
			self assert: var value equals: each].
	#(-16r8000000000000000 -16r7FFFFFFFFFFFFFFF -16r80000001 16r80000000 16r7FFFFFFFFFFFFFFF) do: 
			[:each |
			var := each asVariant.
			self assert: var vt equals: VT_I8.
			self assert: var value equals: each].
	#(16r8000000000000000 16r8000000000000001 16rFFFFFFFFFFFFFFFE 16rFFFFFFFFFFFFFFFF) do: 
			[:each |
			var := each asVariant.
			self assert: var vt equals: VT_UI8.
			self assert: var value equals: each].
	#(-16r8000000000000001 16r10000000000000001)
		do: [:each | self should: [each asVariant] raise: Error]!

testI1
	| var |
	var := VARIANT new.
	var int8: 0.
	self assert: var vt identicalTo: VT_I1.
	self assert: var value identicalTo: 0.
	var int8: 127.
	self assert: var value identicalTo: 127.
	self should: [var int8: 128] raise: Error.
	var int8: -128.
	self assert: var value identicalTo: -128.
	self should: [var int8: 129] raise: Error!

testI1REF
	| var byte |
	byte := Int8 new value: 127.
	var := byte asVariant.
	self assert: var vt identicalTo: VT_I1 | VT_BYREF.
	self assert: var value equals: byte.
	self assert: var value yourAddress equals: byte yourAddress.
	var value value: -128.
	self assert: byte value equals: -128!

testI2
	| var |
	var := VARIANT new.
	var int16: 0.
	self assert: var vt identicalTo: VT_I2.
	self assert: var value identicalTo: 0.
	var int16: 32767.
	self assert: var value identicalTo: 32767.
	self should: [var int16: 32768] raise: Error.
	var int16: -32768.
	self assert: var value identicalTo: -32768.
	self should: [var int16: -32769] raise: Error!

testI2REF
	| var sword |
	sword := Int16 new value: 32767.
	var := sword asVariant.
	self assert: var vt identicalTo: VT_I2 | VT_BYREF.
	self assert: var value equals: sword.
	self assert: var value yourAddress equals: sword yourAddress.
	var value value: -32768.
	self assert: sword value equals: -32768!

testI4
	| var |
	var := VARIANT new.
	var int32: 0.
	self assert: var vt identicalTo: VT_I4.
	self assert: var value identicalTo: 0.
	var int32: 2147483647.
	self assert: var value equals: 2147483647.
	self should: [var int32: 2147483648] raise: Error.
	var int32: -2147483648.
	self assert: var value equals: -2147483648.
	self should: [var int32: -2147483649] raise: Error!

testI4REF
	| var sdword |
	sdword := Int32 new value: 2147483647.
	var := sdword asVariant.
	self assert: var vt identicalTo: VT_I4 | VT_BYREF.
	self assert: var value equals: sdword.
	self assert: var value yourAddress equals: sdword yourAddress.
	var value value: -2147483648.
	self assert: sdword value equals: -2147483648!

testI8
	| var copy |
	var := VARIANT new.
	var int64: 0.
	self assert: var vt identicalTo: VT_I8.
	self assert: var value identicalTo: 0.
	var int64: 2 ** 63 - 1.
	self assert: var value equals: 2 ** 63 - 1.
	self should: [var int64: 2 ** 63] raise: Error.
	var int64: -2 ** 63.
	self assert: var value equals: -2 ** 63.
	self should: [var int64: -2 ** 63 - 1] raise: Error.
	copy := var copy.
	self assert: copy vt equals: VT_I8.
	self assert: copy value equals: var value!

testINT
	| var |
	var := VARIANT new.
	var
		int32: 0;
		vt: VT_INT.
	self assert: var value identicalTo: 0.
	var
		int32: 2147483647;
		vt: VT_INT.
	self assert: var value equals: 2147483647.
	var
		int32: -2147483648;
		vt: VT_INT.
	self assert: var value equals: -2147483648!

testNULL
	| var |
	var := VARIANT new.
	var null: nil.
	self assert: var vt identicalTo: VT_NULL.
	self assertIsNil: var value!

testR4
	| var max min fpeMask |
	var := VARIANT new.
	var float: 0.0.
	self assert: var vt identicalTo: VT_R4.
	self assert: var value equals: 0.0.
	max := FLOAT maximum value.
	var float: max.
	self assert: (var value equals: max).
	fpeMask := Float exceptionMask.
	Float exceptionMask: (fpeMask maskClear: CRTConstants._EM_OVERFLOW).
	
	[self should: [var float: max * 10] raise: Error.
	self should: [var float: -10 * max] raise: Error]
			ensure: [Float exceptionMask: fpeMask].
	var float: -1 * max.
	self assert: (var value equals: -1 * max).
	min := FLOAT minimum value.
	var float: min.
	self assert: (var value equals: min)!

testR4REF
	| var float |
	float := FLOAT maximum copy.
	var := float asVariant.
	self assert: var vt identicalTo: VT_R4 | VT_BYREF.
	self assert: var value equals: float.
	self assert: var value yourAddress equals: float yourAddress.
	var value value: FLOAT minimum value.
	self assert: (float value equals: FLOAT minimum value)!

testR8
	| var |
	var := VARIANT new.
	var double: 0.0.
	self assert: var vt identicalTo: VT_R8.
	self assert: var value equals: 0.0.
	var double: -1.0.
	self assert: (var value equals: -1.0).
	var double: Float fmax.
	self assert: (var value equals: Float fmax).
	var double: Float fmin.
	self assert: (var value equals: Float fmin)!

testR8REF
	| var double |
	double := DOUBLE new value: Float fmax.
	var := double asVariant.
	self assert: var vt identicalTo: VT_R8 | VT_BYREF.
	self assert: var value equals: double.
	self assert: var value yourAddress equals: double yourAddress.
	var value value: Float fmin.
	self assert: (double value equals: Float fmin)!

testUI1
	| var |
	var := VARIANT new.
	var uint8: 0.
	self assert: var vt identicalTo: VT_UI1.
	self assert: var value identicalTo: 0.
	var uint8: 255.
	self assert: var value identicalTo: 255.
	self should: [var uint8: 256] raise: Error.
	self should: [var uint8: -1] raise: Error!

testUI1REF
	| var byte |
	byte := UInt8 new value: 255.
	var := byte asVariant.
	self assert: var vt identicalTo: VT_UI1 | VT_BYREF.
	self assert: var value equals: byte.
	self assert: var value yourAddress equals: byte yourAddress.
	var value value: 128.
	self assert: byte value equals: 128!

testUI2
	| var |
	var := VARIANT new.
	var uint16: 0.
	self assert: var vt identicalTo: VT_UI2.
	self assert: var value identicalTo: 0.
	var uint16: 65535.
	self assert: var value identicalTo: 65535.
	self should: [var uint16: 65536] raise: Error.
	self should: [var uint16: -1] raise: Error!

testUI2REF
	| var word |
	word := UInt16 new value: 65535.
	var := word asVariant.
	self assert: var vt identicalTo: VT_UI2 | VT_BYREF.
	self assert: var value equals: word.
	self assert: var value yourAddress equals: word yourAddress.
	var value value: 32768.
	self assert: word value equals: 32768!

testUI4
	| var |
	var := VARIANT new.
	var uint32: 0.
	self assert: var vt identicalTo: VT_UI4.
	self assert: var value identicalTo: 0.
	var uint32: 0.0.
	self assert: var vt identicalTo: VT_UI4.
	self assert: var value identicalTo: 0.
	var uint32: 4294967295.
	self assert: var value equals: 4294967295.
	self should: [var uint32: 4294967296] raise: Error.
	"dwordAtOffset:put: is unusual in accepting negative values"
	var uint32: -1.
	self assert: var value equals: 4294967295!

testUI4REF
	| var dword |
	dword := UInt32 new value: 4294967295.
	var := dword asVariant.
	self assert: var vt identicalTo: VT_UI4 | VT_BYREF.
	self assert: var value equals: dword.
	self assert: var value yourAddress equals: dword yourAddress.
	var value value: 2147483648.
	self assert: dword value equals: 2147483648!

testUI8
	| var |
	var := VARIANT new.
	var uint64: 0.
	self assert: var vt identicalTo: VT_UI8.
	self assert: var value identicalTo: 0.
	var uint64: 0.0.
	self assert: var vt identicalTo: VT_UI8.
	self assert: var value identicalTo: 0.
	var uint64: 2 ** 63.
	self assert: var value equals: 2 ** 63.
	var uint64: 2 ** 64 - 1.
	self assert: var value equals: 2 ** 64 - 1.
	self should: [var uint64: 2 ** 64] raise: Error.
	"dwordAtOffset:put: is unusual in accepting negative values"
	var uint64: -1.
	self assert: var value equals: 2 ** 64 - 1! !
!OS.COM.Tests.VARIANTTest categoriesForMethods!
isValidNullString:!private!testing! !
testARRAY!public!unit tests! !
testARRAYREF!public!unit tests! !
testBSTR!public!unit tests! !
testCollectionConversions!public!unit tests! !
testCY!public!unit tests! !
testCYREF!public!unit tests! !
testDATE!public!unit tests! !
testDECIMAL!public!unit tests! !
testDISPATCH!public!unit tests! !
testDISPATCHREF!public!unit tests! !
testDisplayString!public!unit tests! !
testEMPTY!public!unit tests! !
testFromAddress!public!unit tests! !
testFromInteger!public!unit tests! !
testI1!public!unit tests! !
testI1REF!public!unit tests! !
testI2!public!unit tests! !
testI2REF!public!unit tests! !
testI4!public!unit tests! !
testI4REF!public!unit tests! !
testI8!public!unit tests! !
testINT!public!unit tests! !
testNULL!public!unit tests! !
testR4!public!unit tests! !
testR4REF!public!unit tests! !
testR8!public!unit tests! !
testR8REF!public!unit tests! !
testUI1!public!unit tests! !
testUI1REF!public!unit tests! !
testUI2!public!unit tests! !
testUI2REF!public!unit tests! !
testUI4!public!unit tests! !
testUI4REF!public!unit tests! !
testUI8!public!unit tests! !
!

