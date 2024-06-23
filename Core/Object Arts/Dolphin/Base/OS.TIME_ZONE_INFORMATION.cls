"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.TIME_ZONE_INFORMATION'
	instanceVariableNames: 'zoneId offset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_bias' -> 16r0.
			'_OffsetOf_daylightBias' -> 16rA8.
			'_OffsetOf_daylightDate' -> 16r98.
			'_OffsetOf_daylightName' -> 16r58.
			'_OffsetOf_standardBias' -> 16r54.
			'_OffsetOf_standardDate' -> 16r44.
			'_OffsetOf_standardName' -> 16r4.
			'_TIME_ZONE_INFORMATION_Size' -> 16rAC.
			'TIME_ZONE_ID_DAYLIGHT' -> 16r2.
			'TIME_ZONE_ID_STANDARD' -> 16r1.
			'TIME_ZONE_ID_UNKNOWN' -> 16r0
		}!

OS.TIME_ZONE_INFORMATION guid: (Core.GUID fromString: '{ceb846ce-f4db-48fe-9fec-02e637cbc4b4}')!

OS.TIME_ZONE_INFORMATION comment: '<TIME_ZONE_INFORMATION> is an <ExternalStructure> class to wrap the struct ''Win32.TIME_ZONE_INFORMATION'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(ceb846ce-f4db-48fe-9fec-02e637cbc4b4)]
struct tagTIME_ZONE_INFORMATION {
	[readonly] long Bias;
	[readonly, string] unsigned short StandardName[32];
	[readonly] SYSTEMTIME StandardDate;
	[readonly] long StandardBias;
	[readonly, string] unsigned short DaylightName[32];
	[readonly] SYSTEMTIME DaylightDate;
	[readonly] long DaylightBias;
} TIME_ZONE_INFORMATION;
'!

!OS.TIME_ZONE_INFORMATION categoriesForClass!Win32-Structs! !

!OS.TIME_ZONE_INFORMATION methodsFor!

bias
	"Answer the <Integer> value of the receiver's 'bias' field."

	^bytes int32AtOffset: _OffsetOf_bias!

currentBias
	"Answer the <Integer> bias current for the time zone when the information was queried from Windows. This accounts for daylight saving, etc."

	zoneId == TIME_ZONE_ID_STANDARD ifTrue: [^self bias + self standardBias].
	zoneId == TIME_ZONE_ID_DAYLIGHT ifTrue: [^self bias + self daylightBias].
	^self bias!

currentName
	"Answer the <readableString> name of the timezone when the information was queried from Windows. This accounts for daylight saving, etc."

	zoneId == TIME_ZONE_ID_DAYLIGHT ifTrue: [^self daylightName].
	^self standardName!

daylightBias
	"Answer the <Integer> value of the receiver's 'daylightBias' field."

	^bytes int32AtOffset: _OffsetOf_daylightBias!

daylightDate
	"Answer the <SYSTEMTIME> value of the receiver's 'daylightDate' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + _OffsetOf_daylightDate!

daylightName
	"Answer the <Utf16String> value of the receiver's 'daylightName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_daylightName!

offset
	^self offsetSeconds seconds!

offsetSeconds
	^offset ifNil: [offset := self currentBias negated * 60]!

printableFields
	^super printableFields copyWithoutAll: #(#standardDate #daylightDate)!

standardBias
	"Answer the <Integer> value of the receiver's 'standardBias' field."

	^bytes int32AtOffset: _OffsetOf_standardBias!

standardDate
	"Answer the <SYSTEMTIME> value of the receiver's 'standardDate' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + _OffsetOf_standardDate!

standardName
	"Answer the <Utf16String> value of the receiver's 'standardName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_standardName!

zoneId
	"Answer the TIME_ZONE_ID_XXX value that was current when the information was retrieved."

	^zoneId!

zoneId: anInteger
	zoneId := anInteger! !

!OS.TIME_ZONE_INFORMATION categoriesForMethods!
bias!**compiled accessors**!public! !
currentBias!accessing!public! !
currentName!accessing!public! !
daylightBias!**compiled accessors**!public! !
daylightDate!**compiled accessors**!public! !
daylightName!**compiled accessors**!public! !
offset!enquiries!public! !
offsetSeconds!enquiries!public! !
printableFields!development!printing!private! !
standardBias!**compiled accessors**!public! !
standardDate!**compiled accessors**!public! !
standardName!**compiled accessors**!public! !
zoneId!accessing!public! !
zoneId:!accessing!private! !
!

!OS.TIME_ZONE_INFORMATION class methodsFor!

byteSize
	^_TIME_ZONE_INFORMATION_Size!

defineFields
	"Define the fields of the TIME_ZONE_INFORMATION structure.

	TIME_ZONE_INFORMATION compileDefinition

		typedef [uuid(ceb846ce-f4db-48fe-9fec-02e637cbc4b4)]
		struct tagTIME_ZONE_INFORMATION {
			[readonly] long Bias;
			[readonly, string] unsigned short StandardName[32];
			[readonly] SYSTEMTIME StandardDate;
			[readonly] long StandardBias;
			[readonly, string] unsigned short DaylightName[32];
			[readonly] SYSTEMTIME DaylightDate;
			[readonly] long DaylightBias;
		} TIME_ZONE_INFORMATION;
"

	self
		defineField: #bias
			type: Int32Field new beReadOnly
			offset: 0;
		defineField: #standardName
			type: (StringField type: Utf16String length: 32) beReadOnly
			offset: 4;
		defineField: #standardDate
			type: (StructureField type: SYSTEMTIME) beReadOnly
			offset: 68;
		defineField: #standardBias
			type: Int32Field new beReadOnly
			offset: 84;
		defineField: #daylightName
			type: (StringField type: Utf16String length: 32) beReadOnly
			offset: 88;
		defineField: #daylightDate
			type: (StructureField type: SYSTEMTIME) beReadOnly
			offset: 152;
		defineField: #daylightBias
			type: Int32Field new beReadOnly
			offset: 168.
	self byteSize: 172!

getFieldNames
	^#(#bias #standardName #standardDate #standardBias #daylightName #daylightDate #daylightBias)! !

!OS.TIME_ZONE_INFORMATION class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

