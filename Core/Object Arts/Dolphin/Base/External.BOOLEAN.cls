"Filed out from Dolphin Smalltalk 7"!

External.BYTE subclass: #'External.BOOLEAN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.BOOLEAN guid: (Core.GUID fromString: '{35efc105-16f9-425a-94d7-298ebbb17d36}')!
External.BOOLEAN comment: ''!
!External.BOOLEAN categoriesForClass!Unclassified! !
!External.BOOLEAN methodsFor!

value
	"Answer the <Boolean> value of the receiver's 'value' field."

	^(bytes byteAtOffset: _OffsetOf_value) asBoolean!

value: aBoolean
	"Set the receiver's 'value' field to the value of the argument, aBoolean"

	bytes byteAtOffset: _OffsetOf_value put: aBoolean asParameter! !
!External.BOOLEAN categoriesFor: #value!**compiled accessors**!public! !
!External.BOOLEAN categoriesFor: #value:!**compiled accessors**!public! !

!External.BOOLEAN class methodsFor!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: BOOLEANField new beOverride! !
!External.BOOLEAN class categoriesFor: #defineFields!public!template definition! !

