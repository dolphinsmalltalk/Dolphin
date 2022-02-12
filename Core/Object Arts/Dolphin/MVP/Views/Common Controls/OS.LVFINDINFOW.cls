"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.LVFINDINFOW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ListViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_LVFINDINFOW_Size' -> 16r18.
		'_OffsetOf_flags' -> 16r0.
		'_OffsetOf_lParam' -> 16r8.
		'_OffsetOf_psz' -> 16r4.
		'_OffsetOf_pt' -> 16rC.
		'_OffsetOf_vkDirection' -> 16r14
	}!
OS.LVFINDINFOW guid: (Core.GUID fromString: '{87b4c5fd-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.LVFINDINFOW comment: 'LVFINDINFO is an <ExternalStructure> class which represents the Windows common control structure of the same name.

LVFINDINFO is used to contain information to search for items in a List View.

Instance Variables:
	None'!
!OS.LVFINDINFOW categoriesForClass!External-Data-Structured-Win32! !
!OS.LVFINDINFOW methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_lParam!

psz
	"Answer the <Utf16String> value of the receiver's 'psz' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_psz)!

pt
	"Answer the <POINTL> value of the receiver's 'pt' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_pt!

vkDirection
	"Answer the <Integer> value of the receiver's 'vkDirection' field."

	^bytes dwordAtOffset: _OffsetOf_vkDirection! !
!OS.LVFINDINFOW categoriesForMethods!
flags!**compiled accessors**!public! !
lParam!**compiled accessors**!public! !
psz!**compiled accessors**!public! !
pt!**compiled accessors**!public! !
vkDirection!**compiled accessors**!public! !
!

!OS.LVFINDINFOW class methodsFor!

byteSize
	^_LVFINDINFOW_Size!

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
!OS.LVFINDINFOW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

