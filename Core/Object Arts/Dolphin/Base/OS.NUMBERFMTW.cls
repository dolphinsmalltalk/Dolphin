"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.NUMBERFMTW'
	instanceVariableNames: 'decimalSeparator numberGrouping groupSeparator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_NUMBERFMTW_Size' -> 16r18.
			'_OffsetOf_grouping' -> 16r8.
			'_OffsetOf_LeadingZero' -> 16r4.
			'_OffsetOf_lpDecimalSep' -> 16rC.
			'_OffsetOf_lpThousandSep' -> 16r10.
			'_OffsetOf_negativeOrder' -> 16r14.
			'_OffsetOf_NumDigits' -> 16r0
		}!
OS.NUMBERFMTW guid: (Core.GUID fromString: '{0a4bf3f8-997a-4704-98b0-05a904564613}')!
OS.NUMBERFMTW comment: '`NUMBERFMTW` is an `ExternalStructure` class to wrap the struct NUMBERFMTW from type information in the ''Win32 API'' library.

NUMBERFMTW is used in conjunction with the GetNumberFormat API to produce localised representations of printed decimal numbers.

IDL definition follows:
```
typedef [uuid(0a4bf3f8-997a-4704-98b0-05a904564613)]
struct tagNUMBERFMTW {
	[helpstring("number of decimal digits")] unsigned int NumDigits;
	[helpstring("if leading zero in decimal fields")] unsigned int LeadingZero;
	[helpstring("group size left of decimal")] unsigned int Grouping;
	[helpstring("ptr to decimal separator string")] LPWSTR lpDecimalSep;
	[helpstring("ptr to thousand separator string")] LPWSTR lpThousandSep;
	[helpstring("negative number ordering")] unsigned int NegativeOrder;
} NUMBERFMTW;
```'!
!OS.NUMBERFMTW categoriesForClass!Win32-Structs! !
!OS.NUMBERFMTW methodsFor!

decimalPlaces
	^bytes uint32AtOffset: _OffsetOf_NumDigits!

decimalPlaces: anInteger
	(anInteger between: 0 and: 9)
		ifFalse: [self error: 'Number of decimal places must be between 0 and 9 inclusive'].
	bytes uint32AtOffset: _OffsetOf_NumDigits put: anInteger!

decimalSeparator
	^decimalSeparator
		ifNil: [decimalSeparator := Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpDecimalSep)]!

decimalSeparator: aString
	decimalSeparator := aString asUtf16String.
	bytes uintPtrAtOffset: _OffsetOf_lpDecimalSep put: decimalSeparator yourAddress!

grouping
	"Answer the <Integer> value of the receiver's 'grouping' field."

	^bytes uint32AtOffset: _OffsetOf_grouping!

grouping: anInteger
	"Set the number of digits in each group of numbers to the left of the decimal separator.
	Examples:
	0 - no grouping
	3 - groups of 3 (thousands)
	32 - groups of 2 except for the last group of 3"

	(anInteger between: 0 and: 9999)
		ifFalse: [self error: 'Invalid grouping specification ' , anInteger printString].
	bytes uint32AtOffset: _OffsetOf_grouping put: anInteger!

groupSeparator
	^groupSeparator
		ifNil: [groupSeparator := Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpThousandSep)]!

groupSeparator: aString
	groupSeparator := aString asUtf16String.
	bytes uintPtrAtOffset: _OffsetOf_lpThousandSep put: groupSeparator yourAddress!

hasLeadingZero
	^(bytes uint32AtOffset: _OffsetOf_LeadingZero) ~~ 0!

hasLeadingZero: aBoolean
	bytes uint32AtOffset: _OffsetOf_LeadingZero put: aBoolean asParameter!

negativeOrder
	"Answer the <Integer> value of the receiver's 'negativeOrder' field."

	^bytes uint32AtOffset: _OffsetOf_negativeOrder!

negativeOrder: anInteger
	(anInteger between: 0 and: 4)
		ifFalse: [self error: 'Invalid negative number mode ' , anInteger printString].
	bytes uint32AtOffset: _OffsetOf_negativeOrder put: anInteger!

numberGrouping
	^numberGrouping
		ifNil: 
			[| stream digits |
			stream := String writeStream.
			digits := self grouping printString.
			digits do: [:each | stream nextPut: each] separatedBy: [stream nextPut: $;].
			(digits size > 1 and: [digits last = $0]) ifTrue: [stream nextPutAll: ';0'].
			numberGrouping := stream contents]!

numberGrouping: aString
	| groups |
	numberGrouping := nil.
	groups := $; split: aString.
	groups last = '0' ifTrue: [groups := groups resize: groups size - 1].
	self grouping: (groups inject: 0
				into: 
					[:grouping :each |
					| group |
					group := Ucrt atoi: each.
					grouping * 10 + group])! !
!OS.NUMBERFMTW categoriesForMethods!
decimalPlaces!accessing!public! !
decimalPlaces:!accessing!public! !
decimalSeparator!accessing!public! !
decimalSeparator:!accessing!public! !
grouping!**compiled accessors**!public! !
grouping:!accessing!public! !
groupSeparator!accessing!public! !
groupSeparator:!accessing!public! !
hasLeadingZero!accessing!public! !
hasLeadingZero:!accessing!public! !
negativeOrder!**compiled accessors**!public! !
negativeOrder:!accessing!public! !
numberGrouping!accessing!public! !
numberGrouping:!accessing!public! !
!

!OS.NUMBERFMTW class methodsFor!

byteSize
	^_NUMBERFMTW_Size!

defineFields
	"Define the fields of the NUMBERFMTW structure.

	NUMBERFMTW compileDefinition

		typedef [uuid(0a4bf3f8-997a-4704-98b0-05a904564613)]
		struct tagNUMBERFMTW {
			[helpstring('number of decimal digits')] unsigned int NumDigits;
			[helpstring('if leading zero in decimal fields')] unsigned int LeadingZero;
			[helpstring('group size left of decimal')] unsigned int Grouping;
			[helpstring('ptr to decimal separator string')] LPWSTR lpDecimalSep;
			[helpstring('ptr to thousand separator string')] LPWSTR lpThousandSep;
			[helpstring('negative number ordering')] unsigned int NegativeOrder;
		} NUMBERFMTW;
"

	self
		defineField: #NumDigits type: UInt32Field filler offset: 0;
		defineField: #LeadingZero type: UInt32Field filler offset: 4;
		defineField: #grouping type: UInt32Field new offset: 8;
		defineField: #lpDecimalSep type: (PointerField type: Utf16String) beFiller offset: 12;
		defineField: #lpThousandSep type: (PointerField type: Utf16String) beFiller offset: 16;
		defineField: #negativeOrder type: UInt32Field new offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#grouping #negativeOrder)! !
!OS.NUMBERFMTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

