"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.OleVariantTest
	subclass: #'OS.COM.Tests.PROPVARIANTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.PROPVARIANTTest guid: (Core.GUID fromString: '{f23b6a38-e616-4cb9-9e19-5d440c034c80}')!

OS.COM.Tests.PROPVARIANTTest comment: ''!

!OS.COM.Tests.PROPVARIANTTest methodsFor!

bstrArrayClass
	^CABSTR!

clsidVt
	^VT_CLSID!

exampleFileTimes
	^##({
		FILETIME minimum asDateAndTime.
		DateAndTime
			year: 1901
			month: 1
			day: 1.
		DateAndTime
			year: 1970
			month: 1
			day: 1.
		DateAndTime fromString: '2026-01-25T12:58:17.1234567Z'.
		FILETIME maximum asDateAndTime.
		(DateAndTime
			year: 1901
			month: 1
			day: 1) - 100 nanoseconds
	})!

subjectClass
	^PROPVARIANT!

testBlob
	| blob |
	#(#[] #[128] #[0 1 128 255]) do: 
			[:each |
			| copy blobCopy |
			subject := self subjectClass new blob: each.
			self assert: subject vt identicalTo: VT_BLOB.
			blob := subject value.
			self assert: blob isKindOf: BLOB.
			self deny: blob isFinalizable.
			self deny: blob needsFree.
			self assert: blob isReferenceStruct.
			self assert: blob value equals: each.
			"The string must be allocated from COM Task memory"
			self assert: (IMalloc task didAlloc: blob pBlobData).
			copy := subject copy.
			self assert: copy equals: subject.
			blobCopy := copy value.
			self assert: blobCopy equals: blob.
			self deny: blobCopy pBlobData yourAddress equals: blob pBlobData yourAddress.
			self assert: (IMalloc task didAlloc: blobCopy pBlobData).
			copy free.
			"Freeing the copy should have released the copy blob, but not the original"
			self assert: (IMalloc task didAlloc: blob pBlobData).
			self freeSubject]!

testBstrArrayMany
	self verifyBstrArray: #('' 'a🐬b' '£')!

testBstrArrayOne
	self verifyBstrArray: #('a🐬b')!

testConvertClsidToVariant
	| variant clsid |
	clsid := CLSID newUnique.
	subject := clsid asVariant: PROPVARIANT.
	self assert: subject vt equals: VT_CLSID.
	self assert: subject value equals: clsid.
	variant := subject asVariant.
	"PropVariantToVariant converts a VT_CLSID to a string representation of the guid, which is loses that the original was a CLSID. This could have been done using a VT_RECORD, or an object implementing IUnknown/IDispatch, but it is what it is."
	self assert: variant vt equals: VT_BSTR.
	self assert: variant value equals: clsid asString asUppercase!

testConvertFiletimeToVariant
	| variant now |
	now := DateAndTime fromString: ' 2026-02-12T17:25:03.5678943Z'.
	subject := now asVariant: PROPVARIANT.
	self assert: subject vt equals: VT_FILETIME.
	self assert: subject value equals: now.
	variant := subject asVariant.
	"PropVariantToVariant converts a VT_FILETIME to a VT_DATE, discarding sub-second precision and also converting to a local time."
	self assert: variant vt equals: VT_DATE.
	self assert: variant value closeTo: now precision: 1 seconds!

testConvertStringVectorToVariant
	| variant |
	subject := (Utf16StringArray withAll: #('abc' 'def')) asVariant: PROPVARIANT.
	self assert: subject vt equals: VT_VECTOR | VT_LPWSTR.
	variant := subject asVariant.
	self assert: variant vt equals: VT_ARRAY | VT_BSTR.
	self assert: variant value equals: subject value!

testConvertToPropVariant
	| propvar |
	subject := 'abc' asVariant: PROPVARIANT.
	self assert: subject vt equals: VT_LPWSTR.
	"Converting to same type should be a Nop"
	self assert: (subject asVariant: PROPVARIANT) identicalTo: subject.
	"Force initialization of a new PROPVARIANT"
	propvar := PROPVARIANT new.
	propvar value: subject.
	self assert: propvar isKindOf: PROPVARIANT.
	self assert: propvar vt equals: VT_LPWSTR.
	self assert: propvar value equals: 'abc'.
	self assert: propvar isValueStruct.
	self assert: propvar isFinalizable.
	self assert: propvar needsFree.
	self deny: propvar refAddress equals: subject refAddress!

testConvertToVariant
	| variant |
	subject := 'abc' asVariant: PROPVARIANT.
	self assert: subject vt equals: VT_LPWSTR.
	variant := subject asVariant: VARIANT.
	self assert: variant isKindOf: VARIANT.
	self assert: variant vt equals: VT_BSTR.
	self assert: variant value equals: 'abc'.
	self assert: variant isValueStruct.
	self assert: variant isFinalizable.
	self assert: variant needsFree.
	self deny: variant refAddress equals: subject refAddress!

testDisplayString
	"PROPVARIANT string conversions are supposed to be locale invariant, although there is the issue noted in the documentation that the system local decimal separator is used."

	| dateTime |
	dateTime := DateAndTime
				year: 2020
				day: 180
				hour: 17
				minute: 59
				second: 12.34567
				offsetSeconds: 0.
	#('es' 'en') do: 
			[:each |
			| locale |
			locale := Locale standard: each.
			{
				true.
				'True'.
				false.
				'False'.
				1.23.
				'1.23'.
				dateTime.
				'2020/06/28:17:59:12.345'.
				#(true false).
				'(True, False)'
			} pairsDo: 
						[:value :expected |
						| actual strm |
						subject := value asVariant: self subjectClass.
						strm := locale writeStream.
						subject displayOn: strm.
						self freeSubject.
						actual := strm contents.
						self assert: actual equals: expected]]!

testFILETIME
	self exampleFileTimes do: 
			[:each |
			| copy value |
			subject := each asVariant: self subjectClass.
			"Unlike VARIANT, PROPVARIANT has a native representation for FILETIMEs."
			self assert: subject vt identicalTo: VT_FILETIME.
			value := subject value.
			self assert: value equals: each.
			self assert: value equals: each asDateAndTime.
			copy := subject copy.
			self assert: copy equals: subject.
			value := copy value.
			self assert: value equals: each.
			self assert: value equals: each asDateAndTime.
			self freeSubject.
			self assert: copy value equals: each.
			copy free]!

testLPSTR
	#('' 'a' 'a£' 'a🐬b') do: 
			[:each |
			| ansi copy |
			"Extended chars will be substituted by replacement char"
			ansi := each asAnsiString.
			subject := ansi asVariant: self subjectClass.
			self assert: subject vt identicalTo: VT_LPSTR.
			copy := self verifyPointerVar: subject value: ansi.
			self freeSubject.
			self assert: copy value equals: ansi.
			copy free]!

testLPWSTR
	#( '' 'a' 'a£' 'a🐬b' ) do: 
			[:each |
			subject := each asVariant: self subjectClass.
			self verifyUtf16StringVar: subject equals: each.
			self freeSubject]!

testLPWSTRfromBSTR
	| bstr |
	bstr := 'a🐬b' asBSTR.
	subject := self subjectClass new lpwstr: bstr; yourself.
	self deny: subject intptr equals: bstr yourAddress.
	bstr free.
	self verifyUtf16StringVar: subject equals: 'a🐬b'.
	self freeSubject!

vectorVtFlag
	^VT_VECTOR!

verifyAnsiStringArray: anArrayOfStrings
	| strings vector heapPointers copy copyArray |
	strings := AnsiStringArray withAll: anArrayOfStrings.
	vector := self verifyExternalVector: strings.
	self assert: vector needsFree.
	self assert: vector isFinalizable.
	self assert: vector owner isNil.
	heapPointers := (0 to: anArrayOfStrings size - 1 by: VMConstants.IntPtrSize)
				collect: [:offset | vector bytes uintPtrAtOffset: offset].
	heapPointers do: [:psz | self assert: (TaskMemory didAlloc: psz)].
	"Should be able to make a copy - helps verify that we have created and stored the CALPSTR correctly since there is no Propsys initialization API for VT_VECTOR|VT_LPSTRs)."
	copy := subject copy.
	copyArray := copy array.
	self assert: copyArray equals: vector.
	"Free to check strings are deallocated individuall"
	vector free.
	self isNativeDebuggerPresent
		ifFalse: [heapPointers do: [:psz | self deny: (TaskMemory didAlloc: psz)]].
	"Independent copy should be unaffected"
	self assert: copyArray equals: strings.
	copy free.
	strings free!

verifyBoolArray: array
	| bools |
	self verifyExternalArray: array asSAFEARRAY.
	bools := subject asExternalArray.
	self assert: bools isKindOf: BOOLArray.
	self deny: bools isPointerStruct.
	self assert: bools equals: array.
	self assert: subject boolVector equals: array.
	self freeSubject.
	self verifyExternalVector: array.
	bools := subject asExternalArray.
	self assert: bools isKindOf: BOOLArray.
	self deny: bools isPointerStruct.
	self assert: bools equals: array.
	self assert: subject boolVector equals: array!

verifyCLSIDArray: aCLSIDArray
	| value |
	subject := aCLSIDArray asVariant: self subjectClass.
	self assert: subject vt equals: VT_VECTOR | VT_CLSID.
	self assert: subject asExternalArray equals: aCLSIDArray.
	value := subject value.
	self assert: value isKindOf: CACLSID.
	self assert: value owner equals: subject.
	self assert: value isReferenceStruct.
	self deny: value needsFree.
	self deny: value isFinalizable.
	"self assert: value elementClass equals: varElementClass."
	self assert: value size equals: aCLSIDArray length.
	self assert: value asArray equals: aCLSIDArray asArray.
	self assert: subject clsidVector equals: aCLSIDArray!

verifyCyArray: aCYArray
	super verifyCyArray: aCYArray asSAFEARRAY.
	self freeSubject.
	self verifyExternalVector: aCYArray.
	self assert: subject asExternalArray equals: aCYArray.
	self assert: subject cyVector equals: aCYArray!

verifyDateArray: aDATEArray
	super verifyFileTimeArray: aDATEArray asSAFEARRAY.
	self freeSubject.
	self verifyExternalVector: aDATEArray.
	self assert: subject dateVector equals: aDATEArray!

verifyDoubleArray: aDOUBLEArray
	self verifyExternalArray: aDOUBLEArray asSAFEARRAY.
	self assert: subject doubleVector equals: aDOUBLEArray.
	self assert: subject asExternalArray equals: aDOUBLEArray.
	self freeSubject.
	"Repeat as VT_VECTOR"
	self verifyExternalVector: aDOUBLEArray.
	self assert: subject doubleVector equals: aDOUBLEArray.
	self assert: subject asExternalArray equals: aDOUBLEArray.
!

verifyExternalVector: anExternalArray
	| value varElementClass vector copy |
	subject := anExternalArray asVariant: self subjectClass.
	varElementClass := self elementClassFor: anExternalArray elementClass.
	self assert: subject vt equals: VT_VECTOR | varElementClass vt.
	"The value should be a CountedArray reference struct"
	value := subject value.
	self assert: value isReferenceStruct.
	self assert: value owner equals: subject.
	self deny: value needsFree.
	self deny: value isFinalizable.
	self assert: value elementClass equals: varElementClass.
	self assert: value size equals: anExternalArray length.
	self assert: value asArray equals: anExternalArray.
	vector := subject asExternalArray.
	self assert: vector equals: anExternalArray.
	copy := subject copy.
	self deny: copy isReferenceStruct.
	self assert: copy isFinalizable.
	self assert: copy needsFree.
	self assert: copy value equals: value.
	self deny: copy value pElems equals: value pElems.
	copy free.
	^vector!

verifyFileTimeArray: aFILETIMEArray
	self verifyExternalVector: aFILETIMEArray.
	self assert: subject filetimeVector equals: aFILETIMEArray!

verifyFloatArray: aFLOATArray
	super verifyExternalArray: aFLOATArray asSAFEARRAY.
	self assert: subject floatVector equals: aFLOATArray.
	self assert: subject asExternalArray equals: aFLOATArray.
	self freeSubject.
	self verifyExternalVector: aFLOATArray.
	self assert: subject floatVector equals: aFLOATArray.
	self assert: subject asExternalArray equals: aFLOATArray!

verifyHRESULTArray: anHRESULTArray
	| value |
	subject := anHRESULTArray asVariant: self subjectClass.
	self assert: subject vt equals: VT_VECTOR | VT_ERROR.
	self assert: subject asExternalArray equals: anHRESULTArray.
	value := subject value.
	self assert: value owner equals: subject.
	self deny: value needsFree.
	"self assert: value elementClass equals: varElementClass."
	self assert: value size equals: anHRESULTArray length.
	self assert: value asArray equals: anHRESULTArray asArray.
	self assert: subject hresultVector equals: anHRESULTArray!

verifyInt16Array: anInt16Array
	super verifyInt16Array: anInt16Array asSAFEARRAY.
	self verifyExternalVector: anInt16Array.
	self assert: subject int16Vector equals: anInt16Array!

verifyInt32Array: anInt32Array
	super verifyInt32Array: anInt32Array asSAFEARRAY.
	self verifyExternalVector: anInt32Array.
	self assert: subject int32Vector equals: anInt32Array!

verifyInt64Array: anInt64Array
	super verifyInt64Array: anInt64Array asSAFEARRAY.
	self freeSubject.
	self verifyExternalVector: anInt64Array.
	self assert: subject asExternalArray equals: anInt64Array.
	self assert: subject int64Vector equals: anInt64Array!

verifyInt8Array: anInt8Array
	self verifyExternalArray: anInt8Array asSAFEARRAY.
	self verifyExternalVector: anInt8Array!

verifyUInt16Array: anUInt16Array
	self verifyExternalArray: anUInt16Array asSAFEARRAY.
	self verifyExternalVector: anUInt16Array!

verifyUInt32Array: anUInt32Array
	self verifyExternalArray: anUInt32Array asSAFEARRAY.
	self verifyExternalVector: anUInt32Array!

verifyUInt64Array: anUInt64Array
	self verifyExternalArray: anUInt64Array asSAFEARRAY.
	self verifyExternalVector: anUInt64Array!

verifyUtf16StringArray: anArrayOfStrings
	| strings vector heapPointers |
	strings := Utf16StringArray withAll: anArrayOfStrings.
	"	self verifyExternalArray: strings asSAFEARRAY."
	vector := self verifyExternalVector: strings.
	self assert: vector needsFree.
	self assert: vector isFinalizable.
	self assert: vector owner isNil.
	heapPointers := (0 to: anArrayOfStrings size - 1 by: VMConstants.IntPtrSize)
				collect: [:offset | vector bytes uintPtrAtOffset: offset].
	heapPointers do: [:psz | self assert: (TaskMemory didAlloc: psz)].
	vector free.
	self isNativeDebuggerPresent
		ifFalse: [heapPointers do: [:psz | self deny: (TaskMemory didAlloc: psz)]].
	strings free!

verifyUtf16StringVar: aPROPVARIANT equals: each
	| copy |
	self assert: aPROPVARIANT vt identicalTo: VT_LPWSTR.
	copy := self verifyPointerVar: aPROPVARIANT value: each.
	copy free!

verifyVarBoolArray: aVARIANT_BOOLArray
	self verifyExternalArray: aVARIANT_BOOLArray asSAFEARRAY.
	self verifyExternalVector: aVARIANT_BOOLArray!

verifyVARIANTArray: aVariantArray 
	(self verifyExternalVector: aVariantArray) free.
	self assert: subject variantVector equals: aVariantArray! !

!OS.COM.Tests.PROPVARIANTTest categoriesForMethods!
bstrArrayClass!helpers!private! !
clsidVt!constants!private! !
exampleFileTimes!constants!private! !
subjectClass!constants!private! !
testBlob!public!unit tests! !
testBstrArrayMany!public!unit tests! !
testBstrArrayOne!public!unit tests! !
testConvertClsidToVariant!public!unit tests! !
testConvertFiletimeToVariant!public!unit tests! !
testConvertStringVectorToVariant!public!unit tests! !
testConvertToPropVariant!public!unit tests! !
testConvertToVariant!public!unit tests! !
testDisplayString!public!unit tests! !
testFILETIME!public!unit tests! !
testLPSTR!public!unit tests! !
testLPWSTR!public!unit tests! !
testLPWSTRfromBSTR!public!unit tests! !
vectorVtFlag!constants!private! !
verifyAnsiStringArray:!helpers!private! !
verifyBoolArray:!helpers!private! !
verifyCLSIDArray:!helpers!private! !
verifyCyArray:!helpers!private! !
verifyDateArray:!helpers!private! !
verifyDoubleArray:!helpers!private! !
verifyExternalVector:!helpers!private! !
verifyFileTimeArray:!helpers!private! !
verifyFloatArray:!helpers!private! !
verifyHRESULTArray:!helpers!private! !
verifyInt16Array:!helpers!private! !
verifyInt32Array:!helpers!private! !
verifyInt64Array:!helpers!private! !
verifyInt8Array:!helpers!private! !
verifyUInt16Array:!helpers!private! !
verifyUInt32Array:!helpers!private! !
verifyUInt64Array:!helpers!private! !
verifyUtf16StringArray:!helpers!private! !
verifyUtf16StringVar:equals:!helpers!private! !
verifyVarBoolArray:!helpers!private! !
verifyVARIANTArray:!private! !
!

