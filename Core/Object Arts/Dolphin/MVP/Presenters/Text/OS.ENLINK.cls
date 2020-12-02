"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #ENLINK
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_chrg' -> 16r18.
		'_OffsetOf_lParam' -> 16r14.
		'_OffsetOf_msg' -> 16rC.
		'_OffsetOf_wParam' -> 16r10
	}!
ENLINK guid: (GUID fromString: '{af755b00-4b08-4d23-991b-a340afd83bc2}')!
ENLINK comment: '<ENLINK> is an <ExternalStructure> class to wrap the struct ''Win32.ENLINK'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(AF755B00-4B08-4D23-991B-A340AFD83BC2)]
struct tagENLINK {
	NMHDR NMHDR;
	UINT Msg;
	WPARAM WPARAM;
	LPARAM LPARAM;
	CHARRANGE chrg;
} ENLINK;
'!
!ENLINK categoriesForClass!Win32-Structs! !
!ENLINK methodsFor!

chrg
	"Answer the <CHARRANGE> value of the receiver's 'chrg' field."

	^CHARRANGE fromAddress: bytes yourAddress + _OffsetOf_chrg!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes intPtrAtOffset: _OffsetOf_lParam!

msg
	"Answer the <Integer> value of the receiver's 'msg' field."

	^bytes dwordAtOffset: _OffsetOf_msg!

wParam
	"Answer the <Integer> value of the receiver's 'wParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_wParam! !
!ENLINK categoriesFor: #chrg!**compiled accessors**!public! !
!ENLINK categoriesFor: #lParam!**compiled accessors**!public! !
!ENLINK categoriesFor: #msg!**compiled accessors**!public! !
!ENLINK categoriesFor: #wParam!**compiled accessors**!public! !

!ENLINK class methodsFor!

defineFields
	"Define the fields of the ENLINK structure.

	ENLINK  compileDefinition

		typedef [uuid(AF755B00-4B08-4D23-991B-A340AFD83BC2)]
		struct tagENLINK {
			NMHDR NMHDR;
			UINT Msg;
			WPARAM WPARAM;
			LPARAM LPARAM;
			CHARRANGE chrg;
		} ENLINK;
"

	super defineFields.
	self
		defineField: #msg type: DWORDField readOnly;
		defineField: #wParam type: UINT_PTRField readOnly;
		defineField: #lParam type: INT_PTRField readOnly;
		defineField: #chrg type: (StructureField type: CHARRANGE) beReadOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #msg #wParam #lParam #chrg)! !
!ENLINK class categoriesFor: #defineFields!public!template definition! !
!ENLINK class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

