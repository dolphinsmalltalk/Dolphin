"Filed out from Dolphin Smalltalk 7"!

EmbeddedField subclass: #StructureField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StructureField guid: (GUID fromString: '{87b4c4df-026e-11d3-9fd7-00a0cc3e4a32}')!
StructureField comment: 'StructureField is an <ExternalField> type  for described <ExternalStructure> fields that are themselves instances of <ExternalStructure>s.'!
!StructureField categoriesForClass!External-Data-Types! !
!StructureField methodsFor!

printMutatorBody: aSymbol on: aWriteStream
	"Private - Answer suitable method text for compiling a write-accessor method
	to substitute for the receiver (does not include the selector).
	N.B. In this case we overwrite the entire embedded structure with
	a new one"

	| keywords |
	keywords := #replaceBytesOf:from:to:startingAt: keywords.
	aWriteStream
		nextPutAll: self valueParameterName;
		space;
		display: keywords first;
		nextPutAll: ' bytes ';
		display: keywords second;
		space.
	self
		printOffsetExpression: aSymbol
		on: aWriteStream
		extra: 1.
	aWriteStream
		space;
		display: keywords third;
		space.
	self
		printOffsetExpression: aSymbol
		on: aWriteStream
		extra: ((String writeStream)
				display: self fieldClassName;
				space;
				display: #basicByteSize;
				contents).
	aWriteStream
		space;
		display: keywords fourth;
		space;
		display: 1!

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
!StructureField categoriesFor: #printMutatorBody:on:!automatic generation!development!private! !
!StructureField categoriesFor: #readFrom:!indirect accessing!private! !
!StructureField categoriesFor: #writeInto:value:!indirect accessing!private! !

!StructureField class methodsFor!

type: aClass
	"Answer a new instance of the receiver which is used for describing
	embedded structures of type aClass."

	^self basicNew
		initialize;
		fieldClass: aClass! !
!StructureField class categoriesFor: #type:!instance creation!public! !

