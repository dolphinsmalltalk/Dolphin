"Filed out from Dolphin Smalltalk"!

ScalarField subclass: #SBYTEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SBYTEField guid: (GUID fromString: '{d9145096-c1d5-4c8d-b640-605d284b0c42}')!
SBYTEField comment: ''!
!SBYTEField categoriesForClass!External-Data-Types! !
!SBYTEField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#sbyteAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the signed 8-bit signed field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes sbyteAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 8-bit signed <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes sbyteAtOffset: offset put: anInteger! !
!SBYTEField categoriesForMethods!
accessorMessage!initializing!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!SBYTEField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !
!SBYTEField class categoriesForMethods!
byteSize!constants!private! !
!

