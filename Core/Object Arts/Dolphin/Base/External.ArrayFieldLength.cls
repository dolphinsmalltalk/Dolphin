"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'External.ArrayFieldLength'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ArrayFieldLength guid: (Core.GUID fromString: '{aaa1c03f-5efe-4d73-8a05-b9ea12144883}')!
External.ArrayFieldLength isNonInstantiable: true!
External.ArrayFieldLength comment: ''!
!External.ArrayFieldLength categoriesForClass!Kernel-Objects! !
!External.ArrayFieldLength methodsFor!

allocationLength
	^1!

getElementCountOf: anExternalField in: anExternalStructure
	"Private - Answer the number of elements in the array field of the <ExternalStructure> argument."

	^self subclassResponsibility!

isFixedSize
	"Private - Answer whether the field described by the receiver is of a fixed size, i.e.
	known statically as opposed to varying dynamically at runtime."

	^false!

printElementCountExpressionFor: anExternalField on: aCodeGenerationContext
	^self subclassResponsibility!

printSetSizeFor: structClass on: aCodeGenerationContext
	"Private - Print a statement to set the length field corresponding to this field."

	^self subclassResponsibility!

setElementCount: anArrayedCollection of: anExternalField in: anExternalStructure
	"Private - Set the length field corresponding to this array field, if any."

	^self subclassResponsibility! !
!External.ArrayFieldLength categoriesFor: #allocationLength!accessing!private! !
!External.ArrayFieldLength categoriesFor: #getElementCountOf:in:!indirect accessing!private! !
!External.ArrayFieldLength categoriesFor: #isFixedSize!private!testing! !
!External.ArrayFieldLength categoriesFor: #printElementCountExpressionFor:on:!automatic generation!private! !
!External.ArrayFieldLength categoriesFor: #printSetSizeFor:on:!automatic generation!development!private! !
!External.ArrayFieldLength categoriesFor: #setElementCount:of:in:!indirect accessing!private! !

