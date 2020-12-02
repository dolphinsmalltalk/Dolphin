"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #LVFINDINFOW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_flags' -> 16r0.
		'_OffsetOf_lParam' -> 16r8.
		'_OffsetOf_psz' -> 16r4.
		'_OffsetOf_pt' -> 16rC.
		'_OffsetOf_vkDirection' -> 16r14
	}!
LVFINDINFOW guid: (GUID fromString: '{87b4c5fd-026e-11d3-9fd7-00a0cc3e4a32}')!
LVFINDINFOW comment: 'LVFINDINFO is an <ExternalStructure> class which represents the Windows common control structure of the same name.

LVFINDINFO is used to contain information to search for items in a List View.

Instance Variables:
	None'!
!LVFINDINFOW categoriesForClass!External-Data-Structured-Win32! !
!LVFINDINFOW methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_lParam!

maskIn: anInteger
	"OR in to contents' mask member the bit flags represented by anInteger"

	self flags: (self flags bitOr: anInteger)!

param: findId
	"Set the param field of the receiver to findId."

	self lParam: findId.
	self maskIn: LVFI_PARAM!

psz
	"Answer the <Utf16String> value of the receiver's 'psz' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_psz)!

pt
	"Answer the <POINTL> value of the receiver's 'pt' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_pt!

vkDirection
	"Answer the <Integer> value of the receiver's 'vkDirection' field."

	^bytes dwordAtOffset: _OffsetOf_vkDirection! !
!LVFINDINFOW categoriesFor: #flags!**compiled accessors**!public! !
!LVFINDINFOW categoriesFor: #lParam!**compiled accessors**!public! !
!LVFINDINFOW categoriesFor: #maskIn:!accessing!public! !
!LVFINDINFOW categoriesFor: #param:!accessing!public! !
!LVFINDINFOW categoriesFor: #psz!**compiled accessors**!public! !
!LVFINDINFOW categoriesFor: #pt!**compiled accessors**!public! !
!LVFINDINFOW categoriesFor: #vkDirection!**compiled accessors**!public! !

!LVFINDINFOW class methodsFor!

defineFields
	"Define the fields of the Win32 LVFINDINFO structure.
		self compileDefinition
	"

	self
		defineField: #flags type: DWORDField readOnly;
		defineField: #psz type: (PointerField type: Utf16String) beReadOnly;
		defineField: #lParam type: UINT_PTRField readOnly;
		defineField: #pt type: (StructureField type: POINTL) beReadOnly;
		defineField: #vkDirection type: DWORDField readOnly!

getFieldNames
	^#(#flags #psz #lParam #pt #vkDirection)! !
!LVFINDINFOW class categoriesFor: #defineFields!public!template definition! !
!LVFINDINFOW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

