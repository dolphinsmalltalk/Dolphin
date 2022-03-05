"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #ENLINK
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_chrg _OffsetOf_lParam _OffsetOf_msg _OffsetOf_wParam'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ENLINK guid: (GUID fromString: '{af755b00-4b08-4d23-991b-a340afd83bc2}')!
ENLINK addClassConstant: '_OffsetOf_chrg' value: 16r18!
ENLINK addClassConstant: '_OffsetOf_lParam' value: 16r14!
ENLINK addClassConstant: '_OffsetOf_msg' value: 16rC!
ENLINK addClassConstant: '_OffsetOf_wParam' value: 16r10!
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
!ENLINK categoriesForMethods!
chrg!**compiled accessors**!public! !
lParam!**compiled accessors**!public! !
msg!**compiled accessors**!public! !
wParam!**compiled accessors**!public! !
!

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
!ENLINK class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

