"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ArrayFieldLength
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArrayFieldLength guid: (GUID fromString: '{aaa1c03f-5efe-4d73-8a05-b9ea12144883}')!
ArrayFieldLength isAbstract: true!
ArrayFieldLength comment: ''!
!ArrayFieldLength categoriesForClass!Kernel-Objects! !
!ArrayFieldLength methodsFor!

allocationLength
	^1!

getElementCountOf: anExternalField in: anExternalStructure
	"Private - Answer the number of elements in the array field of the <ExternalStructure> argument."

	^self subclassResponsibility!

isFixedSize
	"Private - Answer whether the field described by the receiver is of a fixed size, i.e.
	known statically as opposed to varying dynamically at runtime."

	^false!

printElementCountExpressionFor: anExternalField on: aWriteStream
	^self subclassResponsibility!

printSetSizeFor: structClass on: aWriteStream
	"Private - Print a statement to set the length field corresponding to this field."

	^self subclassResponsibility!

setElementCount: anArrayedCollection of: anExternalField in: anExternalStructure
	"Private - Set the length field corresponding to this array field, if any."

	^self subclassResponsibility! !
!ArrayFieldLength categoriesFor: #allocationLength!accessing!private! !
!ArrayFieldLength categoriesFor: #getElementCountOf:in:!indirect accessing!private! !
!ArrayFieldLength categoriesFor: #isFixedSize!private!testing! !
!ArrayFieldLength categoriesFor: #printElementCountExpressionFor:on:!automatic generation!private! !
!ArrayFieldLength categoriesFor: #printSetSizeFor:on:!automatic generation!development!private! !
!ArrayFieldLength categoriesFor: #setElementCount:of:in:!indirect accessing!private! !

