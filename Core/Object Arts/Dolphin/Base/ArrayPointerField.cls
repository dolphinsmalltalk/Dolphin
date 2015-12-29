"Filed out from Dolphin Smalltalk X6.1"!

PointerField subclass: #ArrayPointerField
	instanceVariableNames: 'length'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayPointerField guid: (GUID fromString: '{87B4C4E3-026E-11D3-9FD7-00A0CC3E4A32}')!
ArrayPointerField comment: 'ArrayPointerField is an <ExternalField> type to represent <ExternalStructure> members which are pointers to arrays.'!
!ArrayPointerField categoriesForClass!External-Data-Types! !
!ArrayPointerField methodsFor!

length
	"Answer the <integer> length of the array pointed at by the field described
	by the receiver. If this is a dynamic value which will vary at runtime depending
	on the structure in which the field is embedded, then answer one."

	^length!

length: elementCountOrSelector
	"Private - Set the length of the array pointed at by the field described
	by the receiver."

	length := elementCountOrSelector!

printAccessorExpressionSuffixOn: aWriteStream 
	"Private - Print any extra messages/statements onto the <puttableStream> argument that are required to
	configure the object being read from the structure instance."

	"We need to set the length of the array"

	aWriteStream
		space;
		display: #length:;
		space.
	self printLengthExpressionOn: aWriteStream!

printLengthExpressionOn: aWriteStream 
	aWriteStream display: self length!

readFrom: anExternal
	"Private - Answer an object of the type pointed at by the receiver in 
	anExternal. WARNING: May be a copy or a reference depending on 
	the behavior of pointerClass (which can be any Behavior which
	has the instance creation method #fromAddress:)"

	^self pointerClass fromAddress: (anExternal sdwordAtOffset: offset) length: self length! !
!ArrayPointerField categoriesFor: #length!accessing!public! !
!ArrayPointerField categoriesFor: #length:!accessing!private! !
!ArrayPointerField categoriesFor: #printAccessorExpressionSuffixOn:!automatic generation!development!private! !
!ArrayPointerField categoriesFor: #printLengthExpressionOn:!automatic generation!private! !
!ArrayPointerField categoriesFor: #readFrom:!accessing!private! !

!ArrayPointerField class methodsFor!

type: aClass length: length
	"Answer a new instance of the receiver which is used for dereferencing
	pointers to arrays objects of type aClass, of the specified fixed <integer> length."

	^(super type: aClass) length: length! !
!ArrayPointerField class categoriesFor: #type:length:!instance creation!public! !

