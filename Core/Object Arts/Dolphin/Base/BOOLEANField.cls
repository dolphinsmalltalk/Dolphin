"Filed out from Dolphin Smalltalk"!

BOOLField subclass: #BOOLEANField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BOOLEANField guid: (GUID fromString: '{974dbcdb-1a08-4f67-bd4b-6f7283e4d06e}')!

BOOLEANField comment: '<BOOLField> is a <ScalarField> class to represent <ExternalStructure> fields that are boolean values encoded as 8-bit integers, where 0 is False, and any other value is True.'!

!BOOLEANField categoriesForClass!External-Data-Types! !

!BOOLEANField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#byteAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer a <Boolean> of equivalent value to the 8-bit integer field at the
	receiver's offset in the <ExternalStructure> argument, i.e. false if zero, true for 1..255."

	^(anExternalStructure bytes byteAtOffset: offset) asBoolean!

writeInto: anExternalStructure value: aBoolean
	"Private - Write the <Boolean> value into anExternal at the receiver's offset, as the
	integer byte value 1 for true, or 0 for false."

	anExternalStructure bytes byteAtOffset: offset put: aBoolean asParameter! !

!BOOLEANField categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!BOOLEANField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !

!BOOLEANField class categoriesForMethods!
byteSize!constants!private! !
!

