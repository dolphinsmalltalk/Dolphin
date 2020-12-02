"Filed out from Dolphin Smalltalk 7"!

EMREXTTEXTOUT subclass: #EMREXTTEXTOUTW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_text' -> 16r4C
	}!
EMREXTTEXTOUTW guid: (GUID fromString: '{984a2e2c-3699-4a16-9ed7-8f174e2ca081}')!
EMREXTTEXTOUTW comment: ''!
!EMREXTTEXTOUTW categoriesForClass!Win32-Structs! !
!EMREXTTEXTOUTW methodsFor!

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
!EMREXTTEXTOUTW categoriesFor: #text!public! !
!EMREXTTEXTOUTW categoriesFor: #text:!public! !

!EMREXTTEXTOUTW class methodsFor!

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
!EMREXTTEXTOUTW class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMREXTTEXTOUTW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMREXTTEXTOUTW class categoriesFor: #iTypes!constants!public! !

