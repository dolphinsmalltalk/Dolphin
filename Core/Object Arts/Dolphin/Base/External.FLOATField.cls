"Filed out from Dolphin Smalltalk 7"!

External.ScalarField subclass: #'External.FLOATField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.FLOATField guid: (Core.GUID fromString: '{87b4c4ea-026e-11d3-9fd7-00a0cc3e4a32}')!
External.FLOATField comment: '<FLOATField> is a <ScalarField> class to represent <ExternalStructure> fields that are 32-bit IEEE single precision floating point numbers.'!
!External.FLOATField categoriesForClass!External-Data-Types! !
!External.FLOATField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#floatAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer a <Float> with the same value as the 32-bit single precision floating
	point field at the receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes floatAtOffset: offset!

valueType
	^Float!

writeInto: anExternalStructure value: aFloat
	"Private - Write a 32-bit IEEE single precision equivalent value to the <Float> argument,
	aFloat, into the <ExternalStructure>, anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes floatAtOffset: offset put: aFloat! !
!External.FLOATField categoriesFor: #accessorMessage!initializing!private! !
!External.FLOATField categoriesFor: #readFrom:!indirect accessing!private! !
!External.FLOATField categoriesFor: #valueType!automatic generation!constants!development!private! !
!External.FLOATField categoriesFor: #writeInto:value:!indirect accessing!private! !

!External.FLOATField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^VMConstants.FloatSize! !
!External.FLOATField class categoriesFor: #byteSize!constants!private! !

