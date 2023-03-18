"Filed out from Dolphin Smalltalk"!

External.AbstractCHARField subclass: #'External.CHARField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.CHARField guid: (Core.GUID fromString: '{a70daacf-9954-43db-943f-1f8f245fcf07}')!
External.CHARField comment: '`CHARField` is a `ScalarField` class to describe `ExternalStructure` fields that are 8-bit character code units.'!
!External.CHARField categoriesForClass!External-Data-Types! !
!External.CHARField methodsFor!

basicWriteInto: anExternalStructure value: anInteger
	^anExternalStructure bytes uint8AtOffset: offset put: anInteger!

readFrom: anExternalStructure
	"Private - Answer a <Character> for the 8-bit code unit at the receiver's offset in the
	<ExternalStructure> argument."

	^Character ansiValue: (anExternalStructure bytes uint8AtOffset: offset)! !
!External.CHARField categoriesForMethods!
basicWriteInto:value:!accessing!private! !
readFrom:!indirect accessing!private! !
!

!External.CHARField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !
!External.CHARField class categoriesForMethods!
byteSize!constants!private! !
!

