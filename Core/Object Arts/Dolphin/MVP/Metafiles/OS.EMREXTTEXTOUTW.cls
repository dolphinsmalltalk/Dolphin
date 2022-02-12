"Filed out from Dolphin Smalltalk"!

OS.EMREXTTEXTOUT subclass: #'OS.EMREXTTEXTOUTW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMREXTTEXTOUTW_Size' -> 16r50.
		'_OffsetOf_text' -> 16r4C
	}!
OS.EMREXTTEXTOUTW guid: (Core.GUID fromString: '{984a2e2c-3699-4a16-9ed7-8f174e2ca081}')!
OS.EMREXTTEXTOUTW comment: ''!
!OS.EMREXTTEXTOUTW categoriesForClass!Win32-Structs! !
!OS.EMREXTTEXTOUTW methodsFor!

text
	"Answer the receiver's text field as a Smalltalk object."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_text length: self EMRTEXT nChars!

text: anObject 
	"Set the receiver's text field to the value of anObject."

	| size |
	size := anObject byteSize - 2 min: self EMRTEXT nChars * 2.
	anObject 
		replaceBytesOf: bytes
		from: ##(_OffsetOf_text + 1)
		to: _OffsetOf_text + size
		startingAt: 1.
	bytes wordAtOffset: _OffsetOf_text + size put: 0! !
!OS.EMREXTTEXTOUTW categoriesForMethods!
text!public! !
text:!public! !
!

!OS.EMREXTTEXTOUTW class methodsFor!

byteSize
	^_EMREXTTEXTOUTW_Size!

defineFields
	"Define the fields of the EMREXTTEXTOUTA structure.

	EMREXTTEXTOUTW  compileDefinition
	"

	super defineFields.
	self defineField: #text type: (StringField type: Utf16String length: 1)!

getFieldNames
	^#(#iType #nSize #rclBounds #iGraphicsMode #exScale #eyScale #EMRTEXT #text)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_EXTTEXTOUTW}! !
!OS.EMREXTTEXTOUTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

