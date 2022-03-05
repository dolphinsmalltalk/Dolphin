"Filed out from Dolphin Smalltalk"!

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

	^(bytes byteAtOffset: _OffsetOf_value) asBoolean!

value: aBoolean
	"Set the receiver's 'value' field to the value of the argument, aBoolean"

	bytes byteAtOffset: _OffsetOf_value put: aBoolean asParameter! !
!BOOLEAN categoriesForMethods!
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!BOOLEAN class methodsFor!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: BOOLEANField new beOverride!

fileOutStem
	^super fileOutStem , '_struct'! !
!BOOLEAN class categoriesForMethods!
defineFields!public!template definition! !
fileOutStem!development!private!source filing! !
!

