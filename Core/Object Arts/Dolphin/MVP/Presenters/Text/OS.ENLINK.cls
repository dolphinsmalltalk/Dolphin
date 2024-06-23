"Filed out from Dolphin Smalltalk"!

OS.NMHDR
	subclass: #'OS.ENLINK'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ENLINK_Size' -> 16r20.
			'_OffsetOf_chrg' -> 16r18.
			'_OffsetOf_lParam' -> 16r14.
			'_OffsetOf_msg' -> 16rC.
			'_OffsetOf_wParam' -> 16r10
		}!

OS.ENLINK guid: (Core.GUID fromString: '{af755b00-4b08-4d23-991b-a340afd83bc2}')!

OS.ENLINK comment: '<ENLINK> is an <ExternalStructure> class to wrap the struct ''Win32.ENLINK'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!OS.ENLINK categoriesForClass!Win32-Structs! !

!OS.ENLINK methodsFor!

chrg
	"Answer the <CHARRANGE> value of the receiver's 'chrg' field."

	^CHARRANGE fromAddress: bytes yourAddress + _OffsetOf_chrg!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes intPtrAtOffset: _OffsetOf_lParam!

msg
	"Answer the <Integer> value of the receiver's 'msg' field."

	^bytes uint32AtOffset: _OffsetOf_msg!

wParam
	"Answer the <Integer> value of the receiver's 'wParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_wParam! !

!OS.ENLINK categoriesForMethods!
chrg!**compiled accessors**!public! !
lParam!**compiled accessors**!public! !
msg!**compiled accessors**!public! !
wParam!**compiled accessors**!public! !
!

!OS.ENLINK class methodsFor!

byteSize
	^_ENLINK_Size!

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
		defineField: #msg type: UInt32Field readOnly;
		defineField: #wParam type: UIntPtrField readOnly;
		defineField: #lParam type: IntPtrField readOnly;
		defineField: #chrg type: (StructureField type: CHARRANGE) beReadOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #msg #wParam #lParam #chrg)! !

!OS.ENLINK class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

