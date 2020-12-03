"Filed out from Dolphin Smalltalk 7"!

External.ScalarField subclass: #'External.SBYTEField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SBYTEField guid: (Core.GUID fromString: '{d9145096-c1d5-4c8d-b640-605d284b0c42}')!
External.SBYTEField comment: ''!
!External.SBYTEField categoriesForClass!External-Data-Types! !
!External.SBYTEField methodsFor!

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
!External.SBYTEField categoriesFor: #accessorMessage!initializing!private! !
!External.SBYTEField categoriesFor: #readFrom:!indirect accessing!private! !
!External.SBYTEField categoriesFor: #writeInto:value:!indirect accessing!private! !

!External.SBYTEField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !
!External.SBYTEField class categoriesFor: #byteSize!constants!private! !

