"Filed out from Dolphin Smalltalk"!

NMGETINFOTIP subclass: #NMTVGETINFOTIPW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cchTextMax _OffsetOf_hItem _OffsetOf_lParam _OffsetOf_pszText'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NMTVGETINFOTIPW guid: (GUID fromString: '{092d2532-2e9c-415e-9373-cf213741fa81}')!

NMTVGETINFOTIPW addClassConstant: '_OffsetOf_cchTextMax' value: 16r10!
NMTVGETINFOTIPW addClassConstant: '_OffsetOf_hItem' value: 16r14!
NMTVGETINFOTIPW addClassConstant: '_OffsetOf_lParam' value: 16r18!
NMTVGETINFOTIPW addClassConstant: '_OffsetOf_pszText' value: 16rC!

NMTVGETINFOTIPW comment: ''!

!NMTVGETINFOTIPW categoriesForClass!External-Data-Structured-Win32! !

!NMTVGETINFOTIPW methodsFor!

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

!NMTVGETINFOTIPW categoriesForMethods!
cchTextMax!**compiled accessors**!public! !
hItem!**compiled accessors**!public! !
itemHandle!accessing!public! !
lParam!**compiled accessors**!public! !
pszText!**compiled accessors**!public! !
!

!NMTVGETINFOTIPW class methodsFor!

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

!NMTVGETINFOTIPW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

