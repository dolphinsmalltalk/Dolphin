"Filed out from Dolphin Smalltalk X6.1"!

AttributeDescriptor subclass: #ExternalField
	instanceVariableNames: 'offset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalField guid: (GUID fromString: '{87B4C4D8-026E-11D3-9FD7-00A0CC3E4A32}')!
ExternalField comment: ''!
!ExternalField categoriesForClass!External-Data-Types! !
!ExternalField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	This is the default alignment required for a field of the receiver's type
	when embedded in an array or structure, generally speaking this is the
	same as the byte size."

	^self byteSize!

beFiller
	"Set the receiver's flag to specify that it is a filler field.
	The field will be largely ignored being neither readable nor writeable.
	Answer the receiver."

	self beInaccessible!

byteSize
	"Private - Answer the byteSize of the field the receiver represents."

	^self subclassResponsibility!

emitStaticExpression: operation on: aWriteStream 
	aWriteStream nextPutAll: '##('.
	operation value: aWriteStream.
	aWriteStream nextPut: $)!

isFiller
	"Private - Answer whether the receiver is a filler field."

	^self isInaccessible
!

isFixedSize
	^true!

offset
	"Private - Answer the offset of the receiver's field in its structure template."

	^offset!

offset: anInteger
	"Private - Set the offset of the receiver's field in a structure template to be anInteger."

	offset := anInteger.
	!

printAccessorBody: aSymbol on: aWriteStream 
	"Private - Answer suitable method text for compiling a read-accessor method
	to substitute for the receiver (does not include the selector)"

	aWriteStream nextPut: $^.
	self printAccessorExpression: aSymbol on: aWriteStream.
	self printAccessorExpressionSuffixOn: aWriteStream!

printAccessorExpression: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will read the value of this field from an instance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	^self subclassResponsibility!

printAccessorExpressionSuffixOn: aWriteStream 
	"Private - Print any extra messages/statements onto the <puttableStream> argument that are required to
	configure the object being read from the structure instance."

	"By default, nothing is needed."

	!

printMutatorBody: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will write the value of this field into an isntance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	^self subclassResponsibility!

printOffsetExpression: aSymbol on: aWriteStream 
	self 
		printOffsetExpression: aSymbol
		on: aWriteStream
		extra: 0!

printOffsetExpression: aSymbol on: aWriteStream extra: anObject 
	self offset = 0 
		ifTrue: 
			[anObject isInteger 
				ifTrue: [aWriteStream display: anObject]
				ifFalse: [self emitStaticExpression: [:stream | stream display: anObject] on: aWriteStream]]
		ifFalse: 
			[self emitStaticExpression: 
					[:stream | 
					stream
						nextPutAll: '(self ';
						display: #offsetOf:;
						space;
						print: aSymbol;
						nextPut: $).
					anObject ~= 0 
						ifTrue: 
							[aWriteStream
								nextPutAll: ' + ';
								display: anObject]]
				on: aWriteStream]!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; print: self offset; nextPut: $)! !
!ExternalField categoriesFor: #alignment!constants!public! !
!ExternalField categoriesFor: #beFiller!modes!public! !
!ExternalField categoriesFor: #byteSize!accessing!private! !
!ExternalField categoriesFor: #emitStaticExpression:on:!automatic generation!private! !
!ExternalField categoriesFor: #isFiller!private!testing! !
!ExternalField categoriesFor: #isFixedSize!private!testing! !
!ExternalField categoriesFor: #offset!accessing!private! !
!ExternalField categoriesFor: #offset:!accessing!private! !
!ExternalField categoriesFor: #printAccessorBody:on:!automatic generation!development!private! !
!ExternalField categoriesFor: #printAccessorExpression:on:!automatic generation!development!private! !
!ExternalField categoriesFor: #printAccessorExpressionSuffixOn:!automatic generation!development!private! !
!ExternalField categoriesFor: #printMutatorBody:on:!automatic generation!development!private! !
!ExternalField categoriesFor: #printOffsetExpression:on:!automatic generation!development!private! !
!ExternalField categoriesFor: #printOffsetExpression:on:extra:!automatic generation!development!private! !
!ExternalField categoriesFor: #printOn:!printing!public! !

!ExternalField class methodsFor!

filler
	"Answer an instance of the receiver which describes a field which will not be used
	(it cannot be read or written)."

	^self new beFiller! !
!ExternalField class categoriesFor: #filler!instance creation!public! !

