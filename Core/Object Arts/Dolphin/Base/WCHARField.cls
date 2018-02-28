"Filed out from Dolphin Smalltalk 7"!

CHARField subclass: #WCHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WCHARField guid: (GUID fromString: '{8ca9be68-ea0d-4658-bddb-fa9ac13c3927}')!
WCHARField comment: '<WCHARField> is a <ScalarField> class to represent <ExternalStructure> fields that are 16-bit character code units.'!
!WCHARField categoriesForClass!External-Data-Types! !
!WCHARField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#wordAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer a <Boolean> of equivalent value to the 8-bit integer field at the
	receiver's offset in the <ExternalStructure> argument, i.e. false if zero, true for 1..255."

	^Character value: (anExternalStructure bytes wordAtOffset: offset)!

writeInto: anExternalStructure value: aCharacter
	"Private - Write the <Charater's> 16-bit code unit value into anExternal at the receiver's offset."

	anExternalStructure bytes wordAtOffset: offset put: aCharacter codePoint! !
!WCHARField categoriesFor: #accessorMessage!automatic generation!private! !
!WCHARField categoriesFor: #readFrom:!indirect accessing!private! !
!WCHARField categoriesFor: #writeInto:value:!indirect accessing!private! !

!WCHARField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^2! !
!WCHARField class categoriesFor: #byteSize!constants!private! !

