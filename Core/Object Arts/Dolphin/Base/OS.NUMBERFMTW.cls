"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.NUMBERFMTW'
	instanceVariableNames: 'decimalSeparator numberGrouping groupSeparator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_NUMBERFMTW_Size' -> 16r18.
			'_OffsetOf_Grouping' -> 16r8.
			'_OffsetOf_LeadingZero' -> 16r4.
			'_OffsetOf_lpDecimalSep' -> 16rC.
			'_OffsetOf_lpThousandSep' -> 16r10.
			'_OffsetOf_NegativeOrder' -> 16r14.
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
	^self NumDigits!

decimalPlaces: anInteger 
	(anInteger between: 0 and: 9) ifFalse: [self error: 'Number of decimal places must be between 0 and 9 inclusive'].
	self NumDigits: anInteger!

decimalSeparator
	^decimalSeparator ifNil: [decimalSeparator := self lpDecimalSep]!

decimalSeparator: aString
	decimalSeparator := aString asUtf16String.
	self lpDecimalSep: decimalSeparator!

grouping
	"Answer the <Integer> value of the receiver's grouping format - see #grouping: and #numberGrouping."

	^self Grouping!

Grouping
	"Private - Answer the <Integer> value of the receiver's 'Grouping' field."

	^bytes uint32AtOffset: _OffsetOf_Grouping!

grouping: anInteger
	"Set the number of digits in each group of numbers to the left of the decimal separator.
	Examples:
	0 - no grouping
	3 - groups of 3 (thousands)
	32 - groups of 2 except for the last group of 3"

	(anInteger between: 0 and: 9999)
		ifFalse: [self error: 'Invalid grouping specification ' , anInteger printString].
	self Grouping: anInteger!

Grouping: anInteger
	"Private - Set the receiver's 'Grouping' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Grouping put: anInteger!

groupSeparator
	^groupSeparator ifNil: [groupSeparator := self lpThousandSep]!

groupSeparator: aString
	groupSeparator := aString asUtf16String.
	self lpThousandSep: groupSeparator!

hasLeadingZero
	^self LeadingZero ~~ 0!

hasLeadingZero: aBoolean
	self LeadingZero: aBoolean asParameter!

LeadingZero
	"Private - Answer the <Integer> value of the receiver's 'LeadingZero' field."

	^bytes uint32AtOffset: _OffsetOf_LeadingZero!

LeadingZero: anInteger
	"Private - Set the receiver's 'LeadingZero' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_LeadingZero put: anInteger!

lpDecimalSep
	"Private - Answer the <Utf16String> value of the receiver's 'lpDecimalSep' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpDecimalSep)!

lpDecimalSep: anUtf16String
	"Private - Set the receiver's 'lpDecimalSep' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpDecimalSep put: anUtf16String yourAddress!

lpThousandSep
	"Private - Answer the <Utf16String> value of the receiver's 'lpThousandSep' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpThousandSep)!

lpThousandSep: anUtf16String
	"Private - Set the receiver's 'lpThousandSep' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpThousandSep put: anUtf16String yourAddress!

negativeNumberMode 
	^self NegativeOrder!

negativeNumberMode: anInteger
	(anInteger between: 0 and: 4)
		ifFalse: [self error: 'Invalid negative number mode ' , anInteger printString].
	self NegativeOrder: anInteger!

NegativeOrder
	"Private - Answer the <Integer> value of the receiver's 'NegativeOrder' field."

	^bytes uint32AtOffset: _OffsetOf_NegativeOrder!

NegativeOrder: anInteger
	"Private - Set the receiver's 'NegativeOrder' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_NegativeOrder put: anInteger!

numberGrouping
	^numberGrouping
		ifNil: 
			[| stream digits |
			stream := String writeStream.
			digits := self Grouping printString.
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
					grouping * 10 + group])!

NumDigits
	"Private - Answer the <Integer> value of the receiver's 'NumDigits' field."

	^bytes uint32AtOffset: _OffsetOf_NumDigits!

NumDigits: anInteger
	"Private - Set the receiver's 'NumDigits' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_NumDigits put: anInteger! !
!OS.NUMBERFMTW categoriesForMethods!
decimalPlaces!accessing!public! !
decimalPlaces:!accessing!public! !
decimalSeparator!accessing!public! !
decimalSeparator:!accessing!public! !
grouping!accessing!public! !
Grouping!**compiled accessors**!private! !
grouping:!accessing!public! !
Grouping:!**compiled accessors**!private! !
groupSeparator!accessing!public! !
groupSeparator:!accessing!public! !
hasLeadingZero!accessing!public! !
hasLeadingZero:!accessing!public! !
LeadingZero!**compiled accessors**!private! !
LeadingZero:!**compiled accessors**!private! !
lpDecimalSep!**compiled accessors**!private! !
lpDecimalSep:!**compiled accessors**!private! !
lpThousandSep!**compiled accessors**!private! !
lpThousandSep:!**compiled accessors**!private! !
negativeNumberMode!accessing!public! !
negativeNumberMode:!accessing!public! !
NegativeOrder!**compiled accessors**!private! !
NegativeOrder:!**compiled accessors**!private! !
numberGrouping!accessing!public! !
numberGrouping:!accessing!public! !
NumDigits!**compiled accessors**!private! !
NumDigits:!**compiled accessors**!private! !
!

!OS.NUMBERFMTW class methodsFor!

byteSize
	^_NUMBERFMTW_Size!

defineFields
	"Define the fields of the NUMBERFMTW structure.

	Win32NUMBERFMTW compileDefinition

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
		defineField: #NumDigits type: UInt32Field new offset: 0;
		defineField: #LeadingZero type: UInt32Field new offset: 4;
		defineField: #Grouping type: UInt32Field new offset: 8;
		defineField: #lpDecimalSep type: (PointerField type: Utf16String) offset: 12;
		defineField: #lpThousandSep type: (PointerField type: Utf16String) offset: 16;
		defineField: #NegativeOrder type: UInt32Field new offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#NumDigits #LeadingZero #Grouping #lpDecimalSep #lpThousandSep #NegativeOrder)! !
!OS.NUMBERFMTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

