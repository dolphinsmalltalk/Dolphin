"Filed out from Dolphin Smalltalk X6.1"!

EmbeddedField subclass: #ArrayField
	instanceVariableNames: 'length'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayField guid: (GUID fromString: '{87B4C4DE-026E-11D3-9FD7-00A0CC3E4A32}')!
ArrayField comment: 'ArrayField is an <ExternalField> type to represent <ExternalStructure> members which are arrays whose contents are actually embedded in the structure, as opposed to being merely pointed at from the structure.'!
!ArrayField categoriesForClass!External-Data-Types! !
!ArrayField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	This is the default alignment required for a field of the receiver's type
	when embedded in an array or structure, generally speaking this is the
	same as the byte size."

	^self elementSize!

arrayClass
	"Private - Answer the class of <ExternalArray> that this field type describes."

	^fieldClass!

byteSize
	"Private - Answer the byte size of the embedded array the receiver represents.
	By default we assume that the length of the receiver is specified in bytes."

	"N.B. We use the length variable directly, rather than sending the length message as we need
	the allocation length, not the element count (the latter excludes null-terminators)"

	^length * self elementSize!

elementClass
	"Private - Answer the byte size of the structures/values that constitute
	the elements of the embedded array the receiver represents."

	^self arrayClass elementClass!

elementSize
	"Private - Answer the byte size of the structures/values that constitute
	the elements of the embedded array the receiver represents."

	^self arrayClass elementSize!

elementSizeSelector
	^#elementSize!

length
	"Private - Answer the length of the embedded array represented by the receiver."

	^length!

length: anInteger
	"Private - Set the length (element count) of the embedded array the receiver 
	represents. Answer the receiver."

	length := anInteger!

printAccessorExpressionSuffixOn: aWriteStream 
	"Private - Print any extra messages/statements onto the <puttableStream> argument that are required to
	configure the object being read from the structure instance."

	"We need to set the length of the array"

	aWriteStream
		space;
		display: #length:;
		space.
	self printLengthExpressionOn: aWriteStream!

printElementSizeExpressionBodyOn: stream 
	stream
		display: self arrayClass;
		space;
		display: #elementSize!

printElementSizeExpressionOn: aWriteStream 
	self emitStaticExpression: [:stream | self printElementSizeExpressionBodyOn: stream]
		on: aWriteStream!

printFieldSizeExpressionBodyOn: aWriteStream 
	self printLengthExpressionOn: aWriteStream.
	aWriteStream nextPutAll: ' * '.
	self isFixedSize 
		ifTrue: [self printElementSizeExpressionBodyOn: aWriteStream]
		ifFalse: [self printElementSizeExpressionOn: aWriteStream]!

printFieldSizeExpressionOn: aWriteStream 
	self isFixedSize 
		ifTrue: 
			[self emitStaticExpression: [:stream | self printFieldSizeExpressionBodyOn: stream] on: aWriteStream]
		ifFalse: [self printFieldSizeExpressionBodyOn: aWriteStream]!

printLengthExpressionOn: aWriteStream 
	aWriteStream display: self length!

printMutatorBody: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will write the value of this field into an isntance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	| keywords |
	aWriteStream
		nextPutAll: '| size |';
		crtab;
		nextPutAll: 'size := (anObject byteSize'.
	"Null terminator is included in the reported byteSize, but not the size/basicSize"
	self arrayClass isNullTerminated 
		ifTrue: 
			[aWriteStream nextPutAll: ' - '.
			self printElementSizeExpressionOn: aWriteStream].
	aWriteStream nextPutAll: ') min: ('.
	self printFieldSizeExpressionOn: aWriteStream.
	keywords := #replaceBytesOf:from:to:startingAt: keywords.
	aWriteStream
		nextPutAll: ').';
		crtab;
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
	self offset = 0 
		ifFalse: 
			[self printOffsetExpression: aSymbol on: aWriteStream.
			aWriteStream nextPutAll: ' + '].
	aWriteStream
		nextPutAll: 'size ';
		display: keywords fourth;
		nextPutAll: ' 1'!

readFrom: anExternal
	"Private - Answer the embedded object at the receiver's offset 
	in anExternal. This may be a copy of the original data
	(e.g. if structureClass is a subclass of External) or a
	reference to the original data (e.g. if structureClass is a
	subclass of ExternalStructure)"

	^self arrayClass fromAddress: anExternal yourAddress + offset length: self length!

writeInto: bytes value: anObject
	"Private - Write the bytes of anObject into anExternal."

	| size |
	size := anObject size min: self length * self elementSize.
	bytes replaceFrom: offset+1 to: offset+size with: anObject startingAt: 1! !
!ArrayField categoriesFor: #alignment!constants!public! !
!ArrayField categoriesFor: #arrayClass!constants!private! !
!ArrayField categoriesFor: #byteSize!accessing!private! !
!ArrayField categoriesFor: #elementClass!accessing!private! !
!ArrayField categoriesFor: #elementSize!accessing!private! !
!ArrayField categoriesFor: #elementSizeSelector!automatic generation!constants!private! !
!ArrayField categoriesFor: #length!accessing!private! !
!ArrayField categoriesFor: #length:!accessing!private! !
!ArrayField categoriesFor: #printAccessorExpressionSuffixOn:!automatic generation!development!private! !
!ArrayField categoriesFor: #printElementSizeExpressionBodyOn:!automatic generation!private! !
!ArrayField categoriesFor: #printElementSizeExpressionOn:!automatic generation!private! !
!ArrayField categoriesFor: #printFieldSizeExpressionBodyOn:!automatic generation!private! !
!ArrayField categoriesFor: #printFieldSizeExpressionOn:!automatic generation!private! !
!ArrayField categoriesFor: #printLengthExpressionOn:!automatic generation!private! !
!ArrayField categoriesFor: #printMutatorBody:on:!automatic generation!development!private! !
!ArrayField categoriesFor: #readFrom:!indirect accessing!private! !
!ArrayField categoriesFor: #writeInto:value:!indirect accessing!private! !

!ArrayField class methodsFor!

type: aClass length: anInteger
	"Answer a new instance of the receiver which is used for describing
	embedded arrays of type aClass, with anInteger elements."

	^self basicNew initialize;
		fieldClass: aClass;
		length: anInteger! !
!ArrayField class categoriesFor: #type:length:!instance creation!public! !

