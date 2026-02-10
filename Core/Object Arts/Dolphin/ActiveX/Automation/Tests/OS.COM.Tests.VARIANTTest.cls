"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.OleVariantTest
	subclass: #'OS.COM.Tests.VARIANTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.VARIANTTest guid: (Core.GUID fromString: '{f436bdf8-12ff-47e4-ad1a-c96795760912}')!

OS.COM.Tests.VARIANTTest comment: ''!

!OS.COM.Tests.VARIANTTest methodsFor!

bstrArrayClass
	^SAFEARRAY!

clsidVt
	^VT_RECORD!

elementClassFor: elementClass
	elementClass == FILETIME ifTrue: [^DATE].
	elementClass == LPWSTR ifTrue: [^BSTR].
	elementClass == LPSTR ifTrue: [^BSTR].
	^super elementClassFor: elementClass!

subjectClass
	^VARIANT!

testBlob
	| blob |
	#(#[] #[128] #[0 1 128 255]) do: 
			[:each |
			subject := self subjectClass new blob: each.
			self assert: subject vt identicalTo: VT_ARRAY|VT_UI1.
			blob := subject value.
			self assert: blob isKindOf: SAFEARRAY.
			self assert: blob isFinalizable.
			self deny: blob needsFree.
			self assert: blob isReferenceStruct.
			self assert: blob value equals: (UInt8Array withAll: each).
			blob free.
			self freeSubject]!

testConvertToVariant
	| variant |
	subject := 'abc' asVariant.
	self assert: subject asVariant identicalTo: subject.
	variant := VARIANT new.
	variant value: subject.
	self assert: variant isKindOf: VARIANT.
	self assert: variant value equals: 'abc'.
	self assert: variant isValueStruct.
	self assert: variant isFinalizable.
	self assert: variant needsFree.
	self deny: variant refAddress equals: subject refAddress!

testDISPATCHChangeType
	| obj var2 str unk |
	obj := IDispatch createObject: 'StdFont'.
	self assert: obj referenceCount equals: 1.
	subject := self subjectClass fromDispatch: obj.
	self assert: obj referenceCount equals: 2.
	var2 := subject changeType: VT_UNKNOWN.
	self assert: obj referenceCount equals: 3.
	unk := var2 value.
	self assert: obj referenceCount equals: 4.
	self assert: (unk isSameCOMObject: obj).
	unk free.
	var2 free.
	self assert: obj referenceCount equals: 2.
	str := subject changeType: VT_BSTR.
	self assert: obj referenceCount equals: 2.
	self assert: str value equals: 'MS Sans Serif'.
	str free.
	self freeSubject.
	self assert: obj referenceCount equals: 1.
	obj free!

testDisplayString
	| dateTime |
	dateTime := DateAndTime
				year: 2020
				day: 180
				hour: 17
				minute: 59
				second: 01.5678.
	{
		{
			'es'.
			{
				true.
				'Verdadero'.
				false.
				'Falso'.
				1.23.
				'1,23'.
				dateTime.
				'28/06/2020 17:59:02'.
				#(true false).
				'(Verdadero; Falso)'
			}
		}.
		{
			'en'.
			{
				true.
				'True'.
				false.
				'False'.
				1.23.
				'1.23'.
				dateTime.
				'6/28/2020 5:59:02 PM'.
				#(true false).
				'(True, False)'
			}
		}
	} do: 
				[:each |
				| locale |
				"Use a locale without user overrides so that the date ordering and decimal separator follow standard conventions for the locale and match the test expectation"
				locale := Locale standard: each first.
				each second pairsDo: 
						[:value :expected |
						| actual strm var |
						strm := locale writeStream.
						var := value asVariant.
						var displayOn: strm.
						var free.
						actual := strm contents.
						self assert: actual equals: expected]]!

testFILETIME
	self exampleFileTimes do: 
			[:each |
			| copy expectedDate |
			subject := each asVariant.
			self assert: subject vt identicalTo: VT_DATE.
			"Note the conversion is lossy since DATE cannot represent the 100nS interval FILETIMEs with the same precision, and nor does it have the same range."
			expectedDate := each asDateAndTime.
			self assert: subject value closeTo: expectedDate precision: 1 microseconds.
			copy := subject copy.
			self assert: copy equals: subject.
			self assert: copy value closeTo: expectedDate precision: 1 microseconds.
			self freeSubject.
			self assert: copy value closeTo: expectedDate precision: 1 microseconds.
			copy free]!

vectorVtFlag
	^VT_ARRAY!

verifyUtf16StringVar: aVARIANT equals: aString
	self assert: aVARIANT vt identicalTo: VT_BSTR.
	self assert: aVARIANT value equals: aString! !

!OS.COM.Tests.VARIANTTest categoriesForMethods!
bstrArrayClass!helpers!private! !
clsidVt!constants!private! !
elementClassFor:!helpers!private! !
subjectClass!constants!private! !
testBlob!public!unit tests! !
testConvertToVariant!public!unit tests! !
testDISPATCHChangeType!public!unit tests! !
testDisplayString!public!unit tests! !
testFILETIME!public!unit tests! !
vectorVtFlag!constants!private! !
verifyUtf16StringVar:equals:!helpers!private! !
!

