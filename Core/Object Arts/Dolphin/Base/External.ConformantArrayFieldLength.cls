"Filed out from Dolphin Smalltalk 7"!

External.ArrayFieldLength subclass: #'External.ConformantArrayFieldLength'
	instanceVariableNames: 'lengthField'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ConformantArrayFieldLength guid: (Core.GUID fromString: '{6158a44a-0df9-4478-8ac1-0112fed71ca1}')!
External.ConformantArrayFieldLength comment: '<ConformantArrayFieldLength> is a type of <ArrayFieldLength> that can be used to describe conformant array fields where the array element count is stored directly as another field in the described structure. For example, give the C++ structure definitions:

	struct PALETTEENTRY {...};
	struct LOGPALETTE {	
		struct LOGPALETTE {
			WORD         palVersion; 
			WORD         palNumEntries; 
			PALETTEENTRY palPalEntry[1]; 
		};

then a template definition for LOGPALETTE might be as follows:

	self
		defineField: #palVersion 		type: WORDField new;
		defineField: #palNumEntries 	type: WORDField new;
		defineField: #palPalEntry 		type: (StructureArrayField type: PALETTEENTRY arrayLength: (ConformantArrayFieldLength lengthField: #palNumEntries))

Note: The ExternalStructure>>byteSize method should be overridden in structures with variable length embedded items, as the base implementation is calculated statically. Furthermore such structures cannot be passed and returned by value because the VM is unable to determine the correct size.

Instance Variables:
	lengthField	<Symbol>. Name of the length field in the ExternalStructure for which this object is providing meta-information.

'!
!External.ConformantArrayFieldLength categoriesForClass!Kernel-Objects! !
!External.ConformantArrayFieldLength methodsFor!

getElementCountOf: anExternalField in: anExternalStructure
	"Private - Answer the number of elements in the array field of the <ExternalStructure> argument."

	^(anExternalStructure template at: lengthField) readFrom: anExternalStructure!

lengthField: aSymbol
	lengthField := aSymbol!

printElementCountExpressionFor: anExternalField on: aCodeGenerationContext
	aCodeGenerationContext writeStream
		nextPutAll: 'self ';
		display: lengthField!

printSetSizeFor: anExternalField on: aCodeGenerationContext
	"Private - Print a statement to set the length field corresponding to this field."

	| structClass setter |
	structClass := anExternalField structClass.
	setter := self setLengthSelector.
	((structClass template includesKey: lengthField) or: [structClass canUnderstand: setter])
		ifTrue: 
			[aCodeGenerationContext writeStream
				nextPutAll: 'self ';
				display: setter;
				space;
				nextPutAll: anExternalField valueParameterName;
				space;
				display: #size;
				nextPut: $.;
				crtab]!

setElementCount: anArrayedCollection of: anExternalField in: anExternalStructure
	"Private - Set the length field corresponding to this array field, if any."

	(anExternalStructure template lookup: lengthField)
		ifNotNil: 
			[:sizeField |
			sizeField isWriteable
				ifTrue: [sizeField writeInto: anExternalStructure value: anArrayedCollection size]]!

setLengthSelector
	^(lengthField copyWith: $:) asSymbol! !
!External.ConformantArrayFieldLength categoriesFor: #getElementCountOf:in:!indirect accessing!private! !
!External.ConformantArrayFieldLength categoriesFor: #lengthField:!accessing!private! !
!External.ConformantArrayFieldLength categoriesFor: #printElementCountExpressionFor:on:!automatic generation!private! !
!External.ConformantArrayFieldLength categoriesFor: #printSetSizeFor:on:!automatic generation!development!private! !
!External.ConformantArrayFieldLength categoriesFor: #setElementCount:of:in:!indirect accessing!private! !
!External.ConformantArrayFieldLength categoriesFor: #setLengthSelector!accessing!private! !

!External.ConformantArrayFieldLength class methodsFor!

lengthField: aSymbol
	"Answer a new instance of the receiver to describe a conformant (sized) array length stored
	in the named field of the <ExternalStructure> of which the owning <ExternalField> is a field."

	^self new lengthField: aSymbol! !
!External.ConformantArrayFieldLength class categoriesFor: #lengthField:!instance creation!public! !

