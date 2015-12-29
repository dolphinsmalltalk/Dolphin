"Filed out from Dolphin Smalltalk X6.1"!

EmbeddedField subclass: #StructureField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StructureField guid: (GUID fromString: '{87B4C4DF-026E-11D3-9FD7-00A0CC3E4A32}')!
StructureField comment: 'ExternalField Type for embedded structures'!
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
		nextPutAll: 'anObject ';
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
				display: self fieldClass;
				space;
				display: #basicByteSize;
				contents).
	aWriteStream
		space;
		display: keywords fourth;
		space;
		display: 1!

readFrom: anExternal
	"Private - Answer the embedded object at the receiver's offset 
	in anExternal. This may be a copy of the original data
	(e.g. if structureClass is a subclass of External) or a
	reference to the original data (e.g. if structureClass is a
	subclass of ExternalStructure)"

	^self fieldClass fromAddress: anExternal yourAddress + offset!

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

