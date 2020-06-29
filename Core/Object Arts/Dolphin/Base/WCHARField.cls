"Filed out from Dolphin Smalltalk 7"!

AbstractCHARField subclass: #WCHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WCHARField guid: (GUID fromString: '{8ca9be68-ea0d-4658-bddb-fa9ac13c3927}')!
WCHARField comment: '`WCHARField` is a `ScalarField` class to describe `ExternalStructure` fields that are 16-bit character code units.'!
!WCHARField categoriesForClass!External-Data-Types! !
!WCHARField methodsFor!

basicWriteInto: anExternalStructure value: anInteger
	^anExternalStructure bytes wordAtOffset: offset put: anInteger!

readFrom: anExternalStructure
	"Private - Answer a <Character> representing the UTF-16 character at the receiver's offset in the <ExternalStructure> argument."

	^Character utf16Value: (anExternalStructure bytes wordAtOffset: offset)! !
!WCHARField categoriesFor: #basicWriteInto:value:!accessing!private! !
!WCHARField categoriesFor: #readFrom:!indirect accessing!private! !

!WCHARField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^2! !
!WCHARField class categoriesFor: #byteSize!constants!private! !

