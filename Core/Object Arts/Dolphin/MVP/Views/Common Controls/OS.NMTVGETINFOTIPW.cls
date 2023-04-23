"Filed out from Dolphin Smalltalk"!

OS.NMGETINFOTIP
	subclass: #'OS.NMTVGETINFOTIPW'
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

	^bytes int32AtOffset: _OffsetOf_cchTextMax!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cchTextMax put: anInteger!

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
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszText)!

pszText: anUtf16String
	"Set the receiver's 'pszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszText put: anUtf16String yourAddress!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^_OffsetOf_pszText! !
!OS.NMTVGETINFOTIPW categoriesForMethods!
cchTextMax!**compiled accessors**!public! !
cchTextMax:!**compiled accessors**!public! !
hItem!**compiled accessors**!public! !
itemHandle!accessing!public! !
lParam!**compiled accessors**!public! !
pszText!**compiled accessors**!public! !
pszText:!**compiled accessors**!public! !
textPointerOffset!constants!private! !
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
		defineField: #pszText type: (PointerField type: Utf16String);
		defineField: #cchTextMax type: Int32Field new;
		defineField: #hItem type: UIntPtrField readOnly;
		defineField: #lParam type: UIntPtrField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #pszText #cchTextMax #hItem #lParam)! !
!OS.NMTVGETINFOTIPW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

