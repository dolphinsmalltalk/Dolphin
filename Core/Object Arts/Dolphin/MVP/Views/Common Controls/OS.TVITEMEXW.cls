"Filed out from Dolphin Smalltalk 7"!

OS.TVITEMW subclass: #'OS.TVITEMEXW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hwnd' -> 16r30.
		'_OffsetOf_iExpandedImage' -> 16r34.
		'_OffsetOf_iIntegral' -> 16r28.
		'_OffsetOf_uStateEx' -> 16r2C
	}!
OS.TVITEMEXW guid: (Core.GUID fromString: '{f1c35f1c-58a2-4d7f-9fd9-3184f8aa1c31}')!
OS.TVITEMEXW comment: ''!
!OS.TVITEMEXW categoriesForClass!External-Data-Structured-Win32! !
!OS.TVITEMEXW methodsFor!

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
!OS.TVITEMEXW categoriesFor: #iExpandedImage!**compiled accessors**!public! !
!OS.TVITEMEXW categoriesFor: #iExpandedImage:!**compiled accessors**!public! !
!OS.TVITEMEXW categoriesFor: #uStateEx!**compiled accessors**!public! !
!OS.TVITEMEXW categoriesFor: #uStateEx:!**compiled accessors**!public! !

!OS.TVITEMEXW class methodsFor!

defineFields
	"Define the fields of the Win32 TVITEMEXW structure

		self compileDefinition
	"

	super defineFields.
	self
		defineField: #iIntegral
			type: SDWORDField uncompiled
			offset: 40;
		defineField: #uStateEx
			type: DWORDField new
			offset: 44;
		defineField: #hwnd
			type: HANDLEField uncompiled
			offset: 48;
		defineField: #iExpandedImage
			type: SDWORDField new
			offset: 52!

getFieldNames
	^#(#mask #hItem #dwState #stateMask #pszText #cchTextMax #iImage #iSelectedImage #cChildren #lParam #iIntegral #uStateEx #hwnd #iExpandedImage)! !
!OS.TVITEMEXW class categoriesFor: #defineFields!public!template definition! !
!OS.TVITEMEXW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

