"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #StructurePointer
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StructurePointer guid: (GUID fromString: '{e3b2fb6a-4ea0-48f6-bd97-5f65c176fb00}')!
StructurePointer comment: ''!
!StructurePointer categoriesForClass!External-Data-Structured! !
!StructurePointer methodsFor!

elementClass
	"Private - Answer the value of the receiver's ''elementClass'' instance variable."

	^elementClass!

elementClass: anObject
	"Private - Set the value of the receiver's ''elementClass'' instance variable to the argument, anObject."

	elementClass := anObject!

value
	"Answer the receiver's value field as a Smalltalk object."

	^self elementClass fromAddress: bytes! !
!StructurePointer categoriesFor: #elementClass!accessing!private! !
!StructurePointer categoriesFor: #elementClass:!accessing!private! !
!StructurePointer categoriesFor: #value!accessing!public! !

!StructurePointer class methodsFor!

byteSize
	^VMConstants.IntPtrSize!

elementClass: elementClass
	"Answer a new instance of the receiver that will contain a pointer to
	an <ExternalStructure> or the specified type."

	^self new
		elementClass: elementClass;
		yourself!

fromAddress: anAddress elementClass: elementClass
	"Answer a new instance of the receiver that contains a pointer to
	an <ExternalStructure> of the specified type."

	^anAddress isNull ifFalse: [
		self basicNew
			initializeAtAddress: anAddress;
			elementClass: elementClass;
			yourself]!

getFieldNames
	^#(#value)!

newNull: pointerClass elementClass: elementClass
	"Answer a new instance of the receiver that contains an
	initially null memory pointer of the specified class pointer to 
	an <ExternalStructure> of the specified type."

	^self basicNew
		initializeAtAddress: pointerClass new;
		elementClass: elementClass;
		yourself! !
!StructurePointer class categoriesFor: #byteSize!accessing!public! !
!StructurePointer class categoriesFor: #elementClass:!instance creation!public! !
!StructurePointer class categoriesFor: #fromAddress:elementClass:!instance creation!public! !
!StructurePointer class categoriesFor: #getFieldNames!constants!private! !
!StructurePointer class categoriesFor: #newNull:elementClass:!instance creation!public! !

