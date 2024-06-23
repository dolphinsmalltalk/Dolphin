"Filed out from Dolphin Smalltalk"!

External.ArrayFieldLength
	subclass: #'External.FixedArrayFieldLength'
	instanceVariableNames: 'elementCount'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.FixedArrayFieldLength guid: (Core.GUID fromString: '{f257b54a-a33a-4696-b457-e7e6d4dc0509}')!

External.FixedArrayFieldLength comment: ''!

!External.FixedArrayFieldLength categoriesForClass!Kernel-Objects! !

!External.FixedArrayFieldLength methodsFor!

allocationLength
	^elementCount!

elementCount
	^elementCount!

elementCount: anInteger
	elementCount := anInteger!

getElementCountOf: anExternalField in: anExternalStructure
	"Private - Answer the number of elements in the array field of the <ExternalStructure> argument."

	"The length is fixed, and doesn't depend on the structure instance."

	^elementCount!

isFixedSize
	"Private - Answer whether the field described by the receiver is of a fixed size, i.e.
	known statically as opposed to varying dynamically at runtime."

	^true!

printElementCountExpressionFor: anExternalField on: aCodeGenerationContext
	aCodeGenerationContext writeStream print: elementCount!

printSetSizeFor: structClass on: aCodeGenerationContext
	"Private - Print a statement to set the length field corresponding to this field."

	"Only relevant to conformant/sized subclasses."

	!

setElementCount: anArrayedCollection of: anExternalField in: anExternalStructure
	"Private - Set the length field corresponding to this array field, if any."

	"anExternalField describes a fixed length array - nothing to do here"! !

!External.FixedArrayFieldLength categoriesForMethods!
allocationLength!accessing!private! !
elementCount!accessing!private! !
elementCount:!accessing!private! !
getElementCountOf:in:!indirect accessing!private! !
isFixedSize!private!testing! !
printElementCountExpressionFor:on:!automatic generation!private! !
printSetSizeFor:on:!automatic generation!development!private! !
setElementCount:of:in:!indirect accessing!private! !
!

!External.FixedArrayFieldLength class methodsFor!

elementCount: anInteger
	"Answer a new instance of the receiver to describe a fixed array length of the specified
	number of elements on behalf of some kind of <ArrayField>."

	^self new elementCount: anInteger! !

!External.FixedArrayFieldLength class categoriesForMethods!
elementCount:!instance creation!public! !
!

