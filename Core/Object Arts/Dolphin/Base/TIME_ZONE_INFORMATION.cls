"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TIME_ZONE_INFORMATION
	instanceVariableNames: ''
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

Bias
	"Answer the <Integer> value of the receiver's 'Bias' field."

	^bytes sdwordAtOffset: 0!

DaylightBias
	"Answer the <Integer> value of the receiver's 'DaylightBias' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #DaylightBias)!

DaylightDate
	"Answer the <SYSTEMTIME> value of the receiver's 'DaylightDate' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + ##(self offsetOf: #DaylightDate)!

DaylightName
	"Answer the <Utf16String> value of the receiver's 'DaylightName' field."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #DaylightName)!

printableFields
	| printable |
	printable := super printableFields.
	printable remove: #StandardDate; remove: #DaylightDate.
	^printable!

StandardBias
	"Answer the <Integer> value of the receiver's 'StandardBias' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #StandardBias)!

StandardDate
	"Answer the <SYSTEMTIME> value of the receiver's 'StandardDate' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + ##(self offsetOf: #StandardDate)!

StandardName
	"Answer the <Utf16String> value of the receiver's 'StandardName' field."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #StandardName)! !
!TIME_ZONE_INFORMATION categoriesFor: #Bias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #DaylightBias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #DaylightDate!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #DaylightName!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #printableFields!development!printing!private! !
!TIME_ZONE_INFORMATION categoriesFor: #StandardBias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #StandardDate!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #StandardName!**compiled accessors**!public! !

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
		defineField: #Bias type: SDWORDField new beReadOnly offset: 0;
		defineField: #StandardName type: (StringField type: Utf16String length: 32) beReadOnly offset: 4;
		defineField: #StandardDate type: (StructureField type: SYSTEMTIME) beReadOnly offset: 68;
		defineField: #StandardBias type: SDWORDField new beReadOnly offset: 84;
		defineField: #DaylightName type: (StringField type: Utf16String length: 32) beReadOnly offset: 88;
		defineField: #DaylightDate type: (StructureField type: SYSTEMTIME) beReadOnly offset: 152;
		defineField: #DaylightBias type: SDWORDField new beReadOnly offset: 168.
	self byteSize: 172! !
!TIME_ZONE_INFORMATION class categoriesFor: #defineFields!**auto generated**!initializing!public! !

