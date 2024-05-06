"Filed out from Dolphin Smalltalk"!

TVITEMW subclass: #TVITEMEXW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_hwnd _OffsetOf_iExpandedImage _OffsetOf_iIntegral _OffsetOf_uStateEx'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TVITEMEXW guid: (GUID fromString: '{f1c35f1c-58a2-4d7f-9fd9-3184f8aa1c31}')!

TVITEMEXW addClassConstant: '_OffsetOf_hwnd' value: 16r30!
TVITEMEXW addClassConstant: '_OffsetOf_iExpandedImage' value: 16r34!
TVITEMEXW addClassConstant: '_OffsetOf_iIntegral' value: 16r28!
TVITEMEXW addClassConstant: '_OffsetOf_uStateEx' value: 16r2C!

TVITEMEXW comment: ''!

!TVITEMEXW categoriesForClass!External-Data-Structured-Win32! !

!TVITEMEXW methodsFor!

iExpandedImage
	"Answer the <Integer> value of the receiver's 'iExpandedImage' field."

	^bytes sdwordAtOffset: _OffsetOf_iExpandedImage!

iExpandedImage: anInteger
	"Set the receiver's 'iExpandedImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iExpandedImage put: anInteger!

uStateEx
	"Answer the <Integer> value of the receiver's 'uStateEx' field."

	^bytes dwordAtOffset: _OffsetOf_uStateEx!

uStateEx: anInteger
	"Set the receiver's 'uStateEx' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_uStateEx put: anInteger! !

!TVITEMEXW categoriesForMethods!
iExpandedImage!**compiled accessors**!public! !
iExpandedImage:!**compiled accessors**!public! !
uStateEx!**compiled accessors**!public! !
uStateEx:!**compiled accessors**!public! !
!

!TVITEMEXW class methodsFor!

defineFields
	"Define the fields of the Win32 TVITEMEXW structure

		self compileDefinition
	"

	super defineFields.
	self
		defineField: #iIntegral type: SDWORDField uncompiled offset: 40;
		defineField: #uStateEx type: DWORDField new offset: 44;
		defineField: #hwnd type: HANDLEField uncompiled offset: 48;
		defineField: #iExpandedImage type: SDWORDField new offset: 52!

getFieldNames
	^#(#mask #hItem #dwState #stateMask #pszText #cchTextMax #iImage #iSelectedImage #cChildren #lParam #iIntegral #uStateEx #hwnd #iExpandedImage)! !

!TVITEMEXW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

