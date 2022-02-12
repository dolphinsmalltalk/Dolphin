"Filed out from Dolphin Smalltalk"!

OS.NMGETINFOTIP subclass: #'OS.NMTVGETINFOTIPW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_NMTVGETINFOTIPW_Size' -> 16r1C.
		'_OffsetOf_cchTextMax' -> 16r10.
		'_OffsetOf_hItem' -> 16r14.
		'_OffsetOf_lParam' -> 16r18.
		'_OffsetOf_pszText' -> 16rC
	}!
OS.NMTVGETINFOTIPW guid: (Core.GUID fromString: '{092d2532-2e9c-415e-9373-cf213741fa81}')!
OS.NMTVGETINFOTIPW comment: ''!
!OS.NMTVGETINFOTIPW categoriesForClass!External-Data-Structured-Win32! !
!OS.NMTVGETINFOTIPW methodsFor!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes sdwordAtOffset: _OffsetOf_cchTextMax!

hItem
	"Answer the <Integer> value of the receiver's 'hItem' field."

	^bytes uintPtrAtOffset: _OffsetOf_hItem!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self hItem!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_lParam!

pszText
	"Answer the <ExternalAddress> value of the receiver's 'pszText' field."

	^(bytes uintPtrAtOffset: _OffsetOf_pszText) asExternalAddress! !
!OS.NMTVGETINFOTIPW categoriesForMethods!
cchTextMax!**compiled accessors**!public! !
hItem!**compiled accessors**!public! !
itemHandle!accessing!public! !
lParam!**compiled accessors**!public! !
pszText!**compiled accessors**!public! !
!

!OS.NMTVGETINFOTIPW class methodsFor!

byteSize
	^_NMTVGETINFOTIPW_Size!

defineFields
	"Define the fields of the Win32 NMTVGETINFOTIPW structure.
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #pszText type: LPVOIDField readOnly;
		defineField: #cchTextMax type: SDWORDField readOnly;
		defineField: #hItem type: UINT_PTRField readOnly;
		defineField: #lParam type: UINT_PTRField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #pszText #cchTextMax #hItem #lParam)! !
!OS.NMTVGETINFOTIPW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

