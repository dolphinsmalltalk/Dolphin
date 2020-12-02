"Filed out from Dolphin Smalltalk 7"!

TEXTMETRICW subclass: #NEWTEXTMETRICW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ntmAvgWidth' -> 16r48.
		'_OffsetOf_ntmCellHeight' -> 16r44.
		'_OffsetOf_ntmFlags' -> 16r3C.
		'_OffsetOf_ntmSizeEM' -> 16r40
	}!
NEWTEXTMETRICW guid: (GUID fromString: '{5a49e86c-3d79-4c3d-b5be-65a1b21f73ed}')!
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
!NEWTEXTMETRICW categoriesFor: #ntmAvgWidth!**compiled accessors**!public! !
!NEWTEXTMETRICW categoriesFor: #ntmCellHeight!**compiled accessors**!public! !
!NEWTEXTMETRICW categoriesFor: #ntmFlags!**compiled accessors**!public! !
!NEWTEXTMETRICW categoriesFor: #ntmSizeEM!**compiled accessors**!public! !

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
!NEWTEXTMETRICW class categoriesFor: #defineFields!public!template definition! !
!NEWTEXTMETRICW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

