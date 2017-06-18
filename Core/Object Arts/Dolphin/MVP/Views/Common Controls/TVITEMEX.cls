"Filed out from Dolphin Smalltalk 7"!

TVITEM subclass: #TVITEMEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TVITEMEX guid: (GUID fromString: '{c16270cd-a6d2-4391-a566-9d56ebf6edc0}')!
TVITEMEX comment: ''!
!TVITEMEX categoriesForClass!External-Data-Structured-Win32! !
!TVITEMEX methodsFor!

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
!TVITEMEX categoriesFor: #iExpandedImage!**compiled accessors**!public! !
!TVITEMEX categoriesFor: #iExpandedImage:!**compiled accessors**!public! !
!TVITEMEX categoriesFor: #uStateEx!**compiled accessors**!public! !
!TVITEMEX categoriesFor: #uStateEx:!**compiled accessors**!public! !

!TVITEMEX class methodsFor!

defineFields
	"Define the fields of the Win32 TVITEMEX structure

		TVITEMEX compileDefinition
	"

	super defineFields.
	self
		defineField: #iIntegral type: SDWORDField uncompiled;
		defineField: #uStateEx type: DWORDField new;
		defineField: #hwnd type: HANDLEField uncompiled;
		defineField: #iExpandedImage type: SDWORDField new! !
!TVITEMEX class categoriesFor: #defineFields!initializing!public! !

