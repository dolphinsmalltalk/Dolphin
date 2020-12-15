"Filed out from Dolphin Smalltalk 7"!

External.ArrayField subclass: #'External.StringField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.StringField guid: (Core.GUID fromString: '{87b4c4e0-026e-11d3-9fd7-00a0cc3e4a32}')!
External.StringField comment: '<StringField> is an <ExternalField> class which can be used to represent embedded null-terminated string fields in <ExternalStructure>s.

StringField can be used for both <String>s and <UnicodeString>s.'!
!External.StringField categoriesForClass!External-Data-Types! !
!External.StringField methodsFor!

allocationLength
	"Private - Answer the size of object of the receivers fieldClass required to hold the
	number of elements in the field."

	^super allocationLength - 1!

readFrom: anExternalStructure
	"Private - Answer a <String> which is a copy of the null-terminated string embedded in the
	<ExternalStructure> argument at the receiver's offset."

	^self arrayClass fromAddress: anExternalStructure yourAddress + offset!

writeInto: bytes value: anObject
	"Private - Write the bytes of anObject into anExternal. Don't forget the Null Terminator"

	| size elemSize |
	elemSize := self elementSize.
	size := anObject byteSize - elemSize min: self allocationLength * elemSize.
	bytes
		replaceFrom: offset + 1
		to: offset + size
		with: anObject
		startingAt: 1.
	"We need 2 null-terminator bytes for a wide-char string of course"
	1 to: elemSize do: [:i | bytes at: offset + size + i put: 0]! !
!External.StringField categoriesFor: #allocationLength!accessing!private! !
!External.StringField categoriesFor: #readFrom:!indirect accessing!private! !
!External.StringField categoriesFor: #writeInto:value:!indirect accessing!private! !

!External.StringField class methodsFor!

length: anInteger
	"Answer a new instance of the receiver which is used for describing
	embedded arrays of type aClass, and of byte size anInteger"

	^self type: AnsiString length: anInteger! !
!External.StringField class categoriesFor: #length:!instance creation!public! !

