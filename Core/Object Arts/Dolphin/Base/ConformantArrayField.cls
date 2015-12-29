"Filed out from Dolphin Smalltalk X6.1"!

ArrayField subclass: #ConformantArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ConformantArrayField guid: (GUID fromString: '{566D946D-0A7E-49CF-93B1-5E39F9C65447}')!
ConformantArrayField comment: 'ConformantArrayField is a class of <AttributeDescriptor> which can be used to describe fields of <ExternalStructure>s which are embedded arrays of scalar types who''s number of elements is not known until runtime.'!
!ConformantArrayField categoriesForClass!External-Data-Types! !
!ConformantArrayField methodsFor!

byteSize
	"Private - Answer the byte size of the embedded array the receiver represents"

	^self length * self elementSize!

isFixedSize
	^false!

length
	"Answer the length of the array at the field described by the receiver. The point of a
	conformant array is that we don't know until run time what the length is, so claim there is
	one element."

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

	^self arrayClass fromAddress: struct yourAddress + offset length: (struct perform: length)! !
!ConformantArrayField categoriesFor: #byteSize!accessing!private! !
!ConformantArrayField categoriesFor: #isFixedSize!private!testing! !
!ConformantArrayField categoriesFor: #length!accessing!public! !
!ConformantArrayField categoriesFor: #printLengthExpressionOn:!automatic generation!private! !
!ConformantArrayField categoriesFor: #readFrom:!accessing!private! !

