"Filed out from Dolphin Smalltalk 7"!

BYTE subclass: #BOOLEAN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BOOLEAN guid: (GUID fromString: '{35efc105-16f9-425a-94d7-298ebbb17d36}')!
BOOLEAN comment: ''!
!BOOLEAN categoriesForClass!Unclassified! !
!BOOLEAN methodsFor!

value
	"Answer the <Boolean> value of the receiver's 'value' field."

	^(bytes byteAtOffset: 0) asBoolean!

value: aBoolean
	"Set the receiver's 'value' field to the value of the argument, aBoolean"

	bytes byteAtOffset: 0 put: aBoolean asParameter! !
!BOOLEAN categoriesFor: #value!**compiled accessors**!public! !
!BOOLEAN categoriesFor: #value:!**compiled accessors**!public! !

!BOOLEAN class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in other
	structures."

	^BOOLEANField!

fileOutStem
	^super fileOutStem , '_struct'! !
!BOOLEAN class categoriesFor: #fieldType!constants!development!private! !
!BOOLEAN class categoriesFor: #fileOutStem!development!private!source filing! !

