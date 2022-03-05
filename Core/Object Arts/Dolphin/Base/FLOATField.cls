"Filed out from Dolphin Smalltalk"!

ScalarField subclass: #FLOATField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FLOATField guid: (GUID fromString: '{87b4c4ea-026e-11d3-9fd7-00a0cc3e4a32}')!
FLOATField comment: '<FLOATField> is a <ScalarField> class to represent <ExternalStructure> fields that are 32-bit IEEE single precision floating point numbers.'!
!FLOATField categoriesForClass!External-Data-Types! !
!FLOATField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#floatAtOffset:put:!

fieldClassName
	^Float name!

readFrom: anExternalStructure
	"Private - Answer a <Float> with the same value as the 32-bit single precision floating
	point field at the receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes floatAtOffset: offset!

writeInto: anExternalStructure value: aFloat
	"Private - Write a 32-bit IEEE single precision equivalent value to the <Float> argument,
	aFloat, into the <ExternalStructure>, anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes floatAtOffset: offset put: aFloat! !
!FLOATField categoriesForMethods!
accessorMessage!initializing!private! !
fieldClassName!automatic generation!constants!development!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!FLOATField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^VMConstants.FloatSize! !
!FLOATField class categoriesForMethods!
byteSize!constants!private! !
!

