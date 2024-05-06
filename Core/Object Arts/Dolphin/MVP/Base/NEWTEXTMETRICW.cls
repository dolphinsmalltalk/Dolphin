"Filed out from Dolphin Smalltalk"!

TEXTMETRICW subclass: #NEWTEXTMETRICW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_ntmAvgWidth _OffsetOf_ntmCellHeight _OffsetOf_ntmFlags _OffsetOf_ntmSizeEM'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NEWTEXTMETRICW guid: (GUID fromString: '{5a49e86c-3d79-4c3d-b5be-65a1b21f73ed}')!

NEWTEXTMETRICW addClassConstant: '_OffsetOf_ntmAvgWidth' value: 16r48!
NEWTEXTMETRICW addClassConstant: '_OffsetOf_ntmCellHeight' value: 16r44!
NEWTEXTMETRICW addClassConstant: '_OffsetOf_ntmFlags' value: 16r3C!
NEWTEXTMETRICW addClassConstant: '_OffsetOf_ntmSizeEM' value: 16r40!

NEWTEXTMETRICW comment: '<NEWTEXTMETRIC> is an <ExternalStructure> class to wrap the struct ''Win.NEWTEXTMETRIC'' from type information in the ''Windows API'' library.

IDL definition follows:

typedef 
struct tagNEWTEXTMETRIC {
	// ... TEXTMETRIC fields ...
	DWORD ntmFlags;
	UINT ntmSizeEM;
	UINT ntmCellHeight;
	UINT ntmAvgWidth;
} NEWTEXTMETRIC;
'!

!NEWTEXTMETRICW categoriesForClass!Win-Structs! !

!NEWTEXTMETRICW methodsFor!

ntmAvgWidth
	"Answer the <Integer> value of the receiver's 'ntmAvgWidth' field."

	^bytes dwordAtOffset: _OffsetOf_ntmAvgWidth!

ntmCellHeight
	"Answer the <Integer> value of the receiver's 'ntmCellHeight' field."

	^bytes dwordAtOffset: _OffsetOf_ntmCellHeight!

ntmFlags
	"Answer the <Integer> value of the receiver's 'ntmFlags' field."

	^bytes dwordAtOffset: _OffsetOf_ntmFlags!

ntmSizeEM
	"Answer the <Integer> value of the receiver's 'ntmSizeEM' field."

	^bytes dwordAtOffset: _OffsetOf_ntmSizeEM! !

!NEWTEXTMETRICW categoriesForMethods!
ntmAvgWidth!**compiled accessors**!public! !
ntmCellHeight!**compiled accessors**!public! !
ntmFlags!**compiled accessors**!public! !
ntmSizeEM!**compiled accessors**!public! !
!

!NEWTEXTMETRICW class methodsFor!

defineFields
	"Define the fields of the NEWTEXTMETRIC structure.
		self compileDefinition
	
		typedef 
		struct tagNEWTEXTMETRICW {
			// ... all fields of TEXTMETRIC...
			long ntmFlags;
			int ntmSizeEM;
			int ntmCellHeight;
			int ntmAvgWidth;
		} NEWTEXTMETRICW;
"

	super defineFields.
	self
		defineField: #ntmFlags type: DWORDField readOnly;
		defineField: #ntmSizeEM type: DWORDField readOnly;
		defineField: #ntmCellHeight type: DWORDField readOnly;
		defineField: #ntmAvgWidth type: DWORDField readOnly!

getFieldNames
	^#(#tmHeight #tmAscent #tmDescent #tmInternalLeading #tmExternalLeading #tmAveCharWidth #tmMaxCharWidth #tmWeight #tmOverhang #tmDigitizedAspectX #tmDigitizedAspectY #tmFirstChar #tmLastChar #tmDefaultChar #tmBreakChar #tmItalic #tmUnderlined #tmStruckOut #tmPitchAndFamily #tmCharSet #ntmFlags #ntmSizeEM #ntmCellHeight #ntmAvgWidth)! !

!NEWTEXTMETRICW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

