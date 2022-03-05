"Filed out from Dolphin Smalltalk"!

ScalarField subclass: #DOUBLEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DOUBLEField guid: (GUID fromString: '{87b4c4e8-026e-11d3-9fd7-00a0cc3e4a32}')!
DOUBLEField comment: '<DOUBLEField> is a <ScalarField> class to represent <ExternalStructure> fields that are 64-bit IEEE double precision floating point numbers.'!
!DOUBLEField categoriesForClass!External-Data-Types! !
!DOUBLEField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#doubleAtOffset:put:!

fieldClassName
	^Float name!

readFrom: anExternalStructure
	"Private - Answer a <Float> with the same value as the 64-bit double precision floating
	point field at the receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes doubleAtOffset: offset!

writeInto: anExternalStructure value: aFloat
	"Private - Write the 64-bit IEEE double precision value of the <Float> argument, aFloat,
	into the <ExternalStructure>, anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes doubleAtOffset: offset put: aFloat! !
!DOUBLEField categoriesForMethods!
accessorMessage!initializing!private! !
fieldClassName!automatic generation!constants!development!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!DOUBLEField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^VMConstants.DoubleSize! !
!DOUBLEField class categoriesForMethods!
byteSize!constants!private! !
!

