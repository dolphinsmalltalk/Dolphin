"Filed out from Dolphin Smalltalk"!

AbstractCHARField subclass: #CHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CHARField guid: (GUID fromString: '{a70daacf-9954-43db-943f-1f8f245fcf07}')!

CHARField comment: '`CHARField` is a `ScalarField` class to describe `ExternalStructure` fields that are 8-bit character code units.'!

!CHARField categoriesForClass!External-Data-Types! !

!CHARField methodsFor!

basicWriteInto: anExternalStructure value: anInteger
	^anExternalStructure bytes byteAtOffset: offset put: anInteger!

readFrom: anExternalStructure
	"Private - Answer a <Character> for the 8-bit code unit at the receiver's offset in the
	<ExternalStructure> argument."

	^(Character ansiValue: (anExternalStructure bytes byteAtOffset: offset))! !

!CHARField categoriesForMethods!
basicWriteInto:value:!accessing!private! !
readFrom:!indirect accessing!private! !
!

!CHARField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !

!CHARField class categoriesForMethods!
byteSize!constants!private! !
!

