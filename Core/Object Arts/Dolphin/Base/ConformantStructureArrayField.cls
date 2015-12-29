"Filed out from Dolphin Smalltalk X6.1"!

StructureArrayField subclass: #ConformantStructureArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ConformantStructureArrayField guid: (GUID fromString: '{87B4C4E2-026E-11D3-9FD7-00A0CC3E4A32}')!
ConformantStructureArrayField comment: 'ConformantStructureArrayField is a class of <AttributeDescriptor> which can be used to describe those fields of <ExternalStructure>s which are themselves embedded arrays of <ExternalStructure>s. For example, give the C++ structure definitions:

	struct PALETTEENTRY {...};
	struct LOGPALETTE {	
		struct LOGPALETTE {
			WORD         palVersion; 
			WORD         palNumEntries; 
			PALETTEENTRY palPalEntry[1]; 
		};

then a template definition for LOGPALETTE might be as follows:

	self
		defineField: #palVersion 	type: WORDField new;
		defineField: #palNumEntries 	type: WORDField new;
		defineField: #palPalEntry 	type: (StructureArrayField type: PALETTEENTRY length: #palNumEntries)

Note: The #byteSize method must be overridden in structures with variable length embedded items, as the base implementation is calculated statically. Furthermore such structures cannot be passed and returned by value because the VM is unable to determine the correct size.

Instance Variables:

None, but we hijack the superclass instance variable ''length'' to hold the selector used to get the length at runtime. This is not terribly clean, but reflects this classes late addition to the design.'!
!ConformantStructureArrayField categoriesForClass!External-Data-Types! !
!ConformantStructureArrayField methodsFor!

isFixedSize
	^false!

length
	"Answer the length of the array at the field described
	by the receiver. We don't know until run time what the length
	is, so claim there is one element."

	^1!

printLengthExpressionOn: aWriteStream 
	aWriteStream
		nextPutAll: 'self ';
		display: length!

readFrom: struct
	"Private -  Answer a <StructureArray> which references the array
	of structures embedded in the <ExternalStructure>, struct, in the
	field described by the receiver.  The result may be sent #at: and #at:put:
	messages to get/set the actual elements in-place."

	^self arrayClass
		fromAddress: struct yourAddress + offset
		length: (struct perform: length)
		elementClass: self elementClass! !
!ConformantStructureArrayField categoriesFor: #isFixedSize!private!testing! !
!ConformantStructureArrayField categoriesFor: #length!accessing!public! !
!ConformantStructureArrayField categoriesFor: #printLengthExpressionOn:!automatic generation!private! !
!ConformantStructureArrayField categoriesFor: #readFrom:!accessing!private! !

