"Filed out from Dolphin Smalltalk 7"!

TVITEMW subclass: #TVITEMEXW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TVITEMEXW guid: (GUID fromString: '{f1c35f1c-58a2-4d7f-9fd9-3184f8aa1c31}')!
TVITEMEXW comment: ''!
!TVITEMEXW categoriesForClass!External-Data-Structured-Win32! !
!TVITEMEXW methodsFor!

iExpandedImage
	"Answer the <Integer> value of the receiver's 'iExpandedImage' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iExpandedImage)!

iExpandedImage: anInteger
	"Set the receiver's 'iExpandedImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #iExpandedImage) put: anInteger!

uStateEx
	"Answer the <Integer> value of the receiver's 'uStateEx' field."

	^bytes dwordAtOffset: ##(self offsetOf: #uStateEx)!

uStateEx: anInteger
	"Set the receiver's 'uStateEx' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #uStateEx) put: anInteger! !
!TVITEMEXW categoriesFor: #iExpandedImage!**compiled accessors**!public! !
!TVITEMEXW categoriesFor: #iExpandedImage:!**compiled accessors**!public! !
!TVITEMEXW categoriesFor: #uStateEx!**compiled accessors**!public! !
!TVITEMEXW categoriesFor: #uStateEx:!**compiled accessors**!public! !

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
!TVITEMEXW class categoriesFor: #defineFields!initializing!public! !
!TVITEMEXW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

