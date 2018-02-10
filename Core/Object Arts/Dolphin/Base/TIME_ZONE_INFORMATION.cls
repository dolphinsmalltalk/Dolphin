"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TIME_ZONE_INFORMATION
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TIME_ZONE_INFORMATION guid: (GUID fromString: '{ceb846ce-f4db-48fe-9fec-02e637cbc4b4}')!
TIME_ZONE_INFORMATION comment: ''!
!TIME_ZONE_INFORMATION categoriesForClass!Unclassified! !
!TIME_ZONE_INFORMATION methodsFor!

bias
	"Answer the <Integer> value of the receiver's 'bias' field."

	^bytes sdwordAtOffset: 0!

daylightBias
	"Answer the <Integer> value of the receiver's 'daylightBias' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #daylightBias)!

daylightDate
	"Answer the <SYSTEMTIME> value of the receiver's 'daylightDate' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + ##(self offsetOf: #daylightDate)!

daylightName
	"Answer the <Utf16String> value of the receiver's 'daylightName' field."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #daylightName) length: 32!

standardBias
	"Answer the <Integer> value of the receiver's 'standardBias' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #standardBias)!

standardDate
	"Answer the <SYSTEMTIME> value of the receiver's 'standardDate' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + ##(self offsetOf: #standardDate)!

standardName
	"Answer the <Utf16String> value of the receiver's 'standardName' field."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #standardName) length: 32! !
!TIME_ZONE_INFORMATION categoriesFor: #bias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #daylightBias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #daylightDate!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #daylightName!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #standardBias!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #standardDate!**compiled accessors**!public! !
!TIME_ZONE_INFORMATION categoriesFor: #standardName!**compiled accessors**!public! !

!TIME_ZONE_INFORMATION class methodsFor!

defineFields
	"Define the fields of the Win32 TIME_ZONE_INFORMATION structure
		self compileDefinition

	typedef struct _TIME_ZONE_INFORMATION
	{
		LONG Bias;
		WCHAR StandardName[ 32 ];
		SYSTEMTIME StandardDate;
		LONG StandardBias;
		WCHAR DaylightName[ 32 ];
		SYSTEMTIME DaylightDate;
		LONG DaylightBias;
	} TIME_ZONE_INFORMATION;"


	self 
		defineField: #bias type: SDWORDField readOnly;
		defineField: #standardName type: (ArrayField type: Utf16String length: 32) beReadOnly;
		defineField: #standardDate type: (StructureField type: SYSTEMTIME) beReadOnly;
		defineField: #standardBias type: SDWORDField readOnly;
		defineField: #daylightName type: (ArrayField type: Utf16String length: 32) beReadOnly;
		defineField: #daylightDate type: (StructureField type: SYSTEMTIME) beReadOnly;
		defineField: #daylightBias type: SDWORDField readOnly! !
!TIME_ZONE_INFORMATION class categoriesFor: #defineFields!automatic generation!public! !

