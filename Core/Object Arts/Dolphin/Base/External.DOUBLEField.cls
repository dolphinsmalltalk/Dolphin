"Filed out from Dolphin Smalltalk"!

External.ScalarField
	subclass: #'External.DOUBLEField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.DOUBLEField guid: (Core.GUID fromString: '{87b4c4e8-026e-11d3-9fd7-00a0cc3e4a32}')!

External.DOUBLEField comment: '<DOUBLEField> is a <ScalarField> class to represent <ExternalStructure> fields that are 64-bit IEEE double precision floating point numbers.'!

!External.DOUBLEField categoriesForClass!External-Data-Types! !

!External.DOUBLEField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#doubleAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer a <Float> with the same value as the 64-bit double precision floating
	point field at the receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes doubleAtOffset: offset!

valueType
	^Float!

writeInto: anExternalStructure value: aFloat
	"Private - Write the 64-bit IEEE double precision value of the <Float> argument, aFloat,
	into the <ExternalStructure>, anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes doubleAtOffset: offset put: aFloat! !

!External.DOUBLEField categoriesForMethods!
accessorMessage!initializing!private! !
readFrom:!indirect accessing!private! !
valueType!automatic generation!constants!development!private! !
writeInto:value:!indirect accessing!private! !
!

!External.DOUBLEField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^VMConstants.DoubleSize! !

!External.DOUBLEField class categoriesForMethods!
byteSize!constants!private! !
!

