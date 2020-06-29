"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #NUMBERFMTW
	instanceVariableNames: 'decimalSeparator numberGrouping groupSeparator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Grouping' -> 16r8.
		'_OffsetOf_LeadingZero' -> 16r4.
		'_OffsetOf_lpDecimalSep' -> 16rC.
		'_OffsetOf_lpThousandSep' -> 16r10.
		'_OffsetOf_NegativeOrder' -> 16r14.
		'_OffsetOf_NumDigits' -> 16r0
	}!
NUMBERFMTW guid: (GUID fromString: '{0a4bf3f8-997a-4704-98b0-05a904564613}')!
NUMBERFMTW comment: '`NUMBERFMTW` is an `ExternalStructure` class to wrap the struct NUMBERFMTW from type information in the ''Win32 API'' library.

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
!NUMBERFMTW categoriesForClass!Win32-Structs! !
!NUMBERFMTW methodsFor!

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

	^bytes dwordAtOffset: _OffsetOf_Grouping!

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

	bytes dwordAtOffset: _OffsetOf_Grouping put: anInteger!

groupSeparator
	^groupSeparator ifNil: [groupSeparator := self lpThousandSep]!

groupSeparator: aString
	groupSeparator := aString asUtf16String.
	self lpThousandSep: groupSeparator!

hasLeadingZero
	^self LeadingZero asBoolean!

hasLeadingZero: aBoolean
	self LeadingZero: aBoolean asParameter!

LeadingZero
	"Private - Answer the <Integer> value of the receiver's 'LeadingZero' field."

	^bytes dwordAtOffset: _OffsetOf_LeadingZero!

LeadingZero: anInteger
	"Private - Set the receiver's 'LeadingZero' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_LeadingZero put: anInteger!

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
	self NegativeOrder: anInteger!

NegativeOrder
	"Private - Answer the <Integer> value of the receiver's 'NegativeOrder' field."

	^bytes dwordAtOffset: _OffsetOf_NegativeOrder!

NegativeOrder: anInteger
	"Private - Set the receiver's 'NegativeOrder' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_NegativeOrder put: anInteger!

numberGrouping
	^numberGrouping
		ifNil: 
			[numberGrouping := AnsiString streamContents: 
							[:stream |
							| digits |
							digits := self Grouping printString.
							digits do: [:each | stream nextPut: each] separatedBy: [stream nextPut: $;].
							"Rather perversely the meaning of a trailing zero is inverted vs the meaning in the string format"
							(digits size > 1 and: [digits last = $0]) ifTrue: [stream nextPutAll: ';0']]]!

numberGrouping: aString
	| groups |
	numberGrouping := nil.
	groups := $; split: aString.
	groups last = '0' ifTrue: [groups := groups resize: groups size - 1].
	self grouping: (groups inject: 0
				into: 
					[:grouping :each |
					| group |
					group := Integer fromString: each.
					grouping * 10 + group])!

NumDigits
	"Private - Answer the <Integer> value of the receiver's 'NumDigits' field."

	^bytes dwordAtOffset: _OffsetOf_NumDigits!

NumDigits: anInteger
	"Private - Set the receiver's 'NumDigits' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_NumDigits put: anInteger!

thousandSeparator
	"This should really be called groupSeparator, and will be deprecated in the next release."

	^self groupSeparator!

thousandSeparator: aString
	self groupSeparator: aString! !
!NUMBERFMTW categoriesFor: #decimalPlaces!accessing!public! !
!NUMBERFMTW categoriesFor: #decimalPlaces:!accessing!public! !
!NUMBERFMTW categoriesFor: #decimalSeparator!accessing!public! !
!NUMBERFMTW categoriesFor: #decimalSeparator:!accessing!public! !
!NUMBERFMTW categoriesFor: #grouping!accessing!public! !
!NUMBERFMTW categoriesFor: #Grouping!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #grouping:!accessing!public! !
!NUMBERFMTW categoriesFor: #Grouping:!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #groupSeparator!accessing!public! !
!NUMBERFMTW categoriesFor: #groupSeparator:!accessing!public! !
!NUMBERFMTW categoriesFor: #hasLeadingZero!accessing!public! !
!NUMBERFMTW categoriesFor: #hasLeadingZero:!accessing!public! !
!NUMBERFMTW categoriesFor: #LeadingZero!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #LeadingZero:!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #lpDecimalSep!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #lpDecimalSep:!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #lpThousandSep!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #lpThousandSep:!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #negativeNumberMode!accessing!public! !
!NUMBERFMTW categoriesFor: #negativeNumberMode:!accessing!public! !
!NUMBERFMTW categoriesFor: #NegativeOrder!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #NegativeOrder:!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #numberGrouping!accessing!public! !
!NUMBERFMTW categoriesFor: #numberGrouping:!accessing!public! !
!NUMBERFMTW categoriesFor: #NumDigits!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #NumDigits:!**compiled accessors**!private! !
!NUMBERFMTW categoriesFor: #thousandSeparator!accessing!public! !
!NUMBERFMTW categoriesFor: #thousandSeparator:!accessing!public! !

!NUMBERFMTW class methodsFor!

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
		defineField: #NumDigits type: DWORDField new offset: 0;
		defineField: #LeadingZero type: DWORDField new offset: 4;
		defineField: #Grouping type: DWORDField new offset: 8;
		defineField: #lpDecimalSep type: (PointerField type: Utf16String) offset: 12;
		defineField: #lpThousandSep type: (PointerField type: Utf16String) offset: 16;
		defineField: #NegativeOrder type: DWORDField new offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#NumDigits #LeadingZero #Grouping #lpDecimalSep #lpThousandSep #NegativeOrder)! !
!NUMBERFMTW class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!NUMBERFMTW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

