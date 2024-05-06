"Filed out from Dolphin Smalltalk"!

EmbeddedField subclass: #StructureField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StructureField guid: (GUID fromString: '{87b4c4df-026e-11d3-9fd7-00a0cc3e4a32}')!

StructureField comment: 'StructureField is an <ExternalField> type  for described <ExternalStructure> fields that are themselves instances of <ExternalStructure>s.'!

!StructureField categoriesForClass!External-Data-Types! !

!StructureField methodsFor!

readFrom: anExternalStructure
	"Private - Answer an <ExternalStructure> of the receiver's field class that is a reference
	to the data in the <ExternalStructure> argument at the receiver's offset."

	^self fieldClass fromAddress: anExternalStructure yourAddress + offset!

writeInto: anExternal value: anExternalStructure
	"Private - Write the bytes of anExternalStructure into anExternal."

	anExternalStructure
		replaceBytesOf: anExternal
		from: offset+1
		to: offset+self byteSize
		startingAt: 1! !

!StructureField categoriesForMethods!
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!StructureField class methodsFor!

type: aClass
	"Answer a new instance of the receiver which is used for describing
	embedded structures of type aClass."

	^self basicNew
		initialize;
		fieldClass: aClass! !

!StructureField class categoriesForMethods!
type:!instance creation!public! !
!

