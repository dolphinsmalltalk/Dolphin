"Filed out from Dolphin Smalltalk"!

External.Field
	subclass: #'External.EmbeddedField'
	instanceVariableNames: 'fieldClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.EmbeddedField guid: (Core.GUID fromString: '{87b4c4da-026e-11d3-9fd7-00a0cc3e4a32}')!
External.EmbeddedField comment: 'EmbeddedField is the abstract class of <ExternalField>s that describe fields of <ExternalStructure>s that are directly embedded in the structure itself, as opposed to being pointers to external memory where the data resides.

Instance Variables:
	fieldClass		<Class> of Smalltalk object that can be used to represent the data stored in the field.'!
!External.EmbeddedField categoriesForClass!External-Data-Types! !
!External.EmbeddedField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	This is the default alignment required for a field of the receiver's type
	when embedded in an array or structure, generally speaking this is the
	same as the byte size."

	^self fieldClass alignment!

byteSize
	"Private - Answer the byte size of the embedded ExternalStructure the
	receiver represents"

	^self fieldClass byteSize!

fieldClass
	"Private - Answer the class of <ExternalStructure> used to represent the 
	type of this field."

	^fieldClass!

fieldClass: aClass
	"Private - Set the class of object to be used to represent the ExternalField in
	Smalltalk. Answer the receiver."

	fieldClass := aClass!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self offset;
		nextPutAll: ': ';
		display: self valueType;
		nextPut: $)!

valueType
	^self fieldClass! !
!External.EmbeddedField categoriesForMethods!
alignment!constants!public! !
byteSize!accessing!private! !
fieldClass!accessing!private! !
fieldClass:!accessing!private! !
printOn:!printing!public! !
valueType!accessing!private! !
!

!External.EmbeddedField class methodsFor!

new
	"Private - Answer an instance of the receiver which describes an embedded attribute.
	This is an error because embedded attributes must include a type, and possibly
	a length."

	^self shouldNotImplement! !
!External.EmbeddedField class categoriesForMethods!
new!instance creation!private! !
!

