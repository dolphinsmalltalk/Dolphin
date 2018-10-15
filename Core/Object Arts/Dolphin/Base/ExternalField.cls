"Filed out from Dolphin Smalltalk 7"!

AttributeDescriptor subclass: #ExternalField
	instanceVariableNames: 'offset structClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalField guid: (GUID fromString: '{87b4c4d8-026e-11d3-9fd7-00a0cc3e4a32}')!
ExternalField isAbstract: true!
ExternalField comment: 'ExternalField is the abstract class of metadata objects that describe the fields of <ExternalStructure>s, including such attributes as the byte offset of the field, the type of the field, and potentially the size of the field.

Instance Variables:
	offset		<SmallInteger>. Fixed offset, in bytes, of the field described in any instance of structClass.
	structClass	<ExternalStructure class> of which the instance is describing a field.

'!
!ExternalField categoriesForClass!External-Data-Types! !
!ExternalField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	This is the default alignment required for a field of the receiver's type
	when embedded in an array or structure, generally speaking this is the
	same as the byte size."

	^self byteSize!

autoGenCategories
	^{ExternalStructure autoGenCategory. self isNonBrowsable ifTrue: ['private'] ifFalse: ['public']}!

autoGenComment
	"Private - Answer a suitable piece of comment to warn the user that a
	method is automatically generated and should not be modified.
	Implementation Note: As of v2.2 this is empty by default as otherwise
	it tends to lead to rather bloated source files."

	^''!

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

fieldClassName
	^Object name!

isFiller
	"Private - Answer whether the receiver is a filler field."

	^self isInaccessible
!

isFixedSize
	"Private - Answer whether the field described by the receiver is of a fixed size, i.e.
	known statically as opposed to varying dynamically at runtime."

	^true!

makeInstanceName: className
	^(className first isVowel ifTrue: ['an'] ifFalse: ['a']) , className!

offset
	"Private - Answer the offset of the receiver's field in its structure template."

	^offset!

offset: anInteger
	"Private - Set the offset of the receiver's field in a structure template to be anInteger."

	offset := anInteger.
	!

printAccessor: aSymbol on: aPuttableStream
	| remark |
	aPuttableStream
		nextPutAll: aSymbol;
		crtab;
		nextPut: $".
	self isNonBrowsable ifTrue: [aPuttableStream nextPutAll: 'Private - '].
	aPuttableStream
		nextPutAll: 'Answer the <';
		nextPutAll: self fieldClassName;
		nextPutAll: '> value of the receiver''s ''';
		display: aSymbol;
		nextPutAll: ''' field.'.
	remark := self autoGenComment.
	remark notEmpty
		ifTrue: 
			[aPuttableStream
				crtab;
				nextPutAll: remark].
	aPuttableStream
		nextPut: $";
		cr;
		crtab.
	self printAccessorBody: aSymbol on: aPuttableStream!

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

printMutator: aSymbol on: aPuttableStream
	| fieldName remark paramName |
	fieldName := aSymbol allButLast asSymbol.
	paramName := self valueParameterName.
	aPuttableStream
		nextPutAll: aSymbol;
		space;
		nextPutAll: paramName;
		crtab;
		nextPutAll: '"Set the receiver''s ''';
		display: fieldName;
		nextPutAll: ''' field to the value of the argument, ';
		nextPutAll: paramName.
	remark := self autoGenComment.
	remark notEmpty
		ifTrue: 
			[aPuttableStream
				crtab;
				nextPutAll: remark].
	aPuttableStream
		nextPut: $";
		cr;
		crtab.
	self printMutatorBody: fieldName on: aPuttableStream!

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
		nextPut: $(; print: self offset; nextPut: $)!

structClass
	"Private - Answer the <ExternalStructure> class of which the receiver describes a field."

	^structClass!

structClass: anExternalStructureClass
	structClass := anExternalStructureClass!

valueParameterName
	"Private - Answer the name to use for the value parameter of a setter method generated for
	the field described by the receiver."

	^self makeInstanceName: self fieldClassName! !
!ExternalField categoriesFor: #alignment!constants!public! !
!ExternalField categoriesFor: #autoGenCategories!development!private! !
!ExternalField categoriesFor: #autoGenComment!constants!development!private! !
!ExternalField categoriesFor: #beFiller!modes!public! !
!ExternalField categoriesFor: #byteSize!accessing!private! !
!ExternalField categoriesFor: #emitStaticExpression:on:!automatic generation!private! !
!ExternalField categoriesFor: #fieldClassName!automatic generation!constants!development!private! !
!ExternalField categoriesFor: #isFiller!private!testing! !
!ExternalField categoriesFor: #isFixedSize!private!testing! !
!ExternalField categoriesFor: #makeInstanceName:!automatic generation!development!private! !
!ExternalField categoriesFor: #offset!accessing!private! !
!ExternalField categoriesFor: #offset:!accessing!private! !
!ExternalField categoriesFor: #printAccessor:on:!development!private! !
!ExternalField categoriesFor: #printAccessorBody:on:!automatic generation!development!private! !
!ExternalField categoriesFor: #printAccessorExpression:on:!automatic generation!development!private! !
!ExternalField categoriesFor: #printAccessorExpressionSuffixOn:!automatic generation!development!private! !
!ExternalField categoriesFor: #printMutator:on:!development!private! !
!ExternalField categoriesFor: #printMutatorBody:on:!automatic generation!development!private! !
!ExternalField categoriesFor: #printOffsetExpression:on:!automatic generation!development!private! !
!ExternalField categoriesFor: #printOffsetExpression:on:extra:!automatic generation!development!private! !
!ExternalField categoriesFor: #printOn:!printing!public! !
!ExternalField categoriesFor: #structClass!accessing!private! !
!ExternalField categoriesFor: #structClass:!accessing!private! !
!ExternalField categoriesFor: #valueParameterName!automatic generation!constants!development!private! !

!ExternalField class methodsFor!

filler
	"Answer an instance of the receiver which describes a field which will not be used
	(it cannot be read or written)."

	^self new beFiller! !
!ExternalField class categoriesFor: #filler!instance creation!public! !

