﻿"Filed out from Dolphin Smalltalk"!

OS.TVITEMW
	subclass: #'OS.TVITEMEXW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_hwnd' -> 16r30.
			'_OffsetOf_iExpandedImage' -> 16r34.
			'_OffsetOf_iIntegral' -> 16r28.
			'_OffsetOf_iReserved' -> 16r38.
			'_OffsetOf_uStateEx' -> 16r2C.
			'_TVITEMEXW_Size' -> 16r3C
		}!

OS.TVITEMEXW guid: (Core.GUID fromString: '{f1c35f1c-58a2-4d7f-9fd9-3184f8aa1c31}')!

OS.TVITEMEXW comment: ''!

!OS.TVITEMEXW categoriesForClass!External-Data-Structured-Win32! !

!OS.TVITEMEXW methodsFor!

iExpandedImage
	"Answer the <Integer> value of the receiver's 'iExpandedImage' field."

	^bytes int32AtOffset: _OffsetOf_iExpandedImage!

iExpandedImage: anInteger
	"Set the receiver's 'iExpandedImage' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iExpandedImage put: anInteger!

maskSelectableFields
	^super maskSelectableFields , #(#iIntegral #uStateEx #iExpandedImage)!

uStateEx
	"Answer the <Integer> value of the receiver's 'uStateEx' field."

	^bytes uint32AtOffset: _OffsetOf_uStateEx!

uStateEx: anInteger
	"Set the receiver's 'uStateEx' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_uStateEx put: anInteger! !

!OS.TVITEMEXW categoriesForMethods!
iExpandedImage!**compiled accessors**!public! !
iExpandedImage:!**compiled accessors**!public! !
maskSelectableFields!constants!private! !
uStateEx!**compiled accessors**!public! !
uStateEx:!**compiled accessors**!public! !
!

!OS.TVITEMEXW class methodsFor!

byteSize
	^_TVITEMEXW_Size!

defineFields
	"Define the fields of the Win32 TVITEMEXW structure

		self compileDefinition
	"

	super defineFields.
	self
		defineField: #iIntegral type: Int32Field uncompiled;
		defineField: #uStateEx type: UInt32Field new;
		defineField: #hwnd type: HANDLEField uncompiled;
		defineField: #iExpandedImage type: Int32Field new;
		defineField: #iReserved type: Int32Field filler!

getFieldNames
	^#(#mask #hItem #dwState #stateMask #pszText #cchTextMax #iImage #iSelectedImage #cChildren #lParam #iIntegral #uStateEx #hwnd #iExpandedImage)!

initialize
	self initializeCallbackPrototype! !

!OS.TVITEMEXW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!class initialization!public! !
!

