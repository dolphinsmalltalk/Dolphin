"Filed out from Dolphin Smalltalk"!

ScalarField subclass: #BYTEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BYTEField guid: (GUID fromString: '{87b4c4e7-026e-11d3-9fd7-00a0cc3e4a32}')!

BYTEField comment: '<BYTEField> is a <ScalarField> class to represent <ExternalStructure> fields that are 8-bit unsigned integers.'!

!BYTEField categoriesForClass!External-Data-Types! !

!BYTEField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#byteAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned 8-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes byteAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 8-bit unsigned <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes byteAtOffset: offset put: anInteger! !

!BYTEField categoriesForMethods!
accessorMessage!initializing!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!BYTEField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !

!BYTEField class categoriesForMethods!
byteSize!constants!private! !
!

