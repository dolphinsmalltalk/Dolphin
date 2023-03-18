"Filed out from Dolphin Smalltalk"!

External.BOOLField subclass: #'External.BOOLEANField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.BOOLEANField guid: (Core.GUID fromString: '{974dbcdb-1a08-4f67-bd4b-6f7283e4d06e}')!
External.BOOLEANField comment: '<BOOLField> is a <ScalarField> class to represent <ExternalStructure> fields that are boolean values encoded as 8-bit integers, where 0 is False, and any other value is True.'!
!External.BOOLEANField categoriesForClass!External-Data-Types! !
!External.BOOLEANField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#uint8AtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer a <Boolean> of equivalent value to the 8-bit integer field at the
	receiver's offset in the <ExternalStructure> argument, i.e. false if zero, true for 1..255."

	^(anExternalStructure bytes uint8AtOffset: offset) asBoolean!

writeInto: anExternalStructure value: aBoolean
	"Private - Write the <Boolean> value into anExternal at the receiver's offset, as the
	integer byte value 1 for true, or 0 for false."

	anExternalStructure bytes uint8AtOffset: offset put: aBoolean asParameter! !
!External.BOOLEANField categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.BOOLEANField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !
!External.BOOLEANField class categoriesForMethods!
byteSize!constants!private! !
!

