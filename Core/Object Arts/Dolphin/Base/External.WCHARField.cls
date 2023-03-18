"Filed out from Dolphin Smalltalk"!

External.AbstractCHARField subclass: #'External.WCHARField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.WCHARField guid: (Core.GUID fromString: '{8ca9be68-ea0d-4658-bddb-fa9ac13c3927}')!
External.WCHARField comment: '`WCHARField` is a `ScalarField` class to describe `ExternalStructure` fields that are 16-bit character code units.'!
!External.WCHARField categoriesForClass!External-Data-Types! !
!External.WCHARField methodsFor!

basicWriteInto: anExternalStructure value: anInteger
	^anExternalStructure bytes uint16AtOffset: offset put: anInteger!

readFrom: anExternalStructure
	"Private - Answer a <Character> representing the UTF-16 character at the receiver's offset in the <ExternalStructure> argument."

	^Character utf16Value: (anExternalStructure bytes uint16AtOffset: offset)! !
!External.WCHARField categoriesForMethods!
basicWriteInto:value:!accessing!private! !
readFrom:!indirect accessing!private! !
!

!External.WCHARField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^2! !
!External.WCHARField class categoriesForMethods!
byteSize!constants!private! !
!

