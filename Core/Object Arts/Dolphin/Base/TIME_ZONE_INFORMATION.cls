"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TIME_ZONE_INFORMATION
	instanceVariableNames: 'zoneId'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TIME_ZONE_INFORMATION guid: (GUID fromString: '{ceb846ce-f4db-48fe-9fec-02e637cbc4b4}')!
TIME_ZONE_INFORMATION comment: '<TIME_ZONE_INFORMATION> is an <ExternalStructure> class to wrap the struct ''Win32.TIME_ZONE_INFORMATION'' from type information in the ''Win32 API'' library.

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
!TIME_ZONE_INFORMATION categoriesForClass!Win32-Structs! !
!TIME_ZONE_INFORMATION methodsFor!

bias
	"Answer the <Integer> value of the receiver's 'bias' field."

	^bytes sdwordAtOffset: 0!

currentBias
	"Answer the <Integer> bias current for the time zone when the information was queried from Windows. This accounts for daylight saving, etc."

	zoneId == Win32Constants.TIME_ZONE_ID_STANDARD ifTrue: [^self bias + self standardBias].
	zoneId == Win32Constants.TIME_ZONE_ID_DAYLIGHT ifTrue: [^self bias + self daylightBias].
	^self bias!

daylightBias
	"Answer the <Integer> value of the receiver's 'daylightBias' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #daylightBias)!

daylightDate
	"Answer the <SYSTEMTIME> value of the receiver's 'daylightDate' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + ##(self offsetOf: #daylightDate)!

daylightName
	"Answer the <Utf16String> value of the receiver's 'daylightName' field."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #daylightName)!

printableFields
	| printable |
	printable := super printableFields.
	printable remove: #standardDate; remove: #daylightDate.
	^printable!

standardBias
	"Answer the <Integer> value of the receiver's 'standardBias' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #standardBias)!

standardDate
	"Answer the <SYSTEMTIME> value of the receiver's 'standardDate' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + ##(self offsetOf: #standardDate)!

standardName
	"Answer the <Utf16String> value of the receiver's 'standardName' field."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #standardName)!

zoneId
	"Answer the TIME_ZONE_ID_XXX value that was current when the information was retrieved."

	^zoneId!

zoneId: anInteger
	zoneId := anInteger! !
!TIME_ZONE_INFORMATION categoriesFor: #bias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #currentBias!accessing!public! !
!TIME_ZONE_INFORMATION categoriesFor: #daylightBias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #daylightDate!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #daylightName!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #printableFields!development!printing!private! !
!TIME_ZONE_INFORMATION categoriesFor: #standardBias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #standardDate!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #standardName!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #zoneId!accessing!public! !
!TIME_ZONE_INFORMATION categoriesFor: #zoneId:!accessing!private! !

!TIME_ZONE_INFORMATION class methodsFor!

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
		defineField: #bias type: SDWORDField new beReadOnly offset: 0;
		defineField: #standardName type: (StringField type: Utf16String length: 32) beReadOnly offset: 4;
		defineField: #standardDate type: (StructureField type: SYSTEMTIME) beReadOnly offset: 68;
		defineField: #standardBias type: SDWORDField new beReadOnly offset: 84;
		defineField: #daylightName type: (StringField type: Utf16String length: 32) beReadOnly offset: 88;
		defineField: #daylightDate type: (StructureField type: SYSTEMTIME) beReadOnly offset: 152;
		defineField: #daylightBias type: SDWORDField new beReadOnly offset: 168.
	self byteSize: 172!

getFieldList
	^#(#bias #standardName #standardDate #standardBias #daylightName #daylightDate #daylightBias)! !
!TIME_ZONE_INFORMATION class categoriesFor: #defineFields!initializing!public! !
!TIME_ZONE_INFORMATION class categoriesFor: #getFieldList!**compiled accessors**!constants!private! !

