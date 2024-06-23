"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'External.SCALAR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_value' -> 16r0 }!

External.SCALAR guid: (Core.GUID fromString: '{704554ca-46f7-49b2-92df-edcbe398040a}')!

External.SCALAR isNonInstantiable: true!

External.SCALAR comment: ''!

!External.SCALAR categoriesForClass!External-Data-Structured! !

!External.SCALAR methodsFor!

= anObject
	"Answer whether the receiver is equivalent to anObject."

	^anObject = self value!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	(self isNull ifFalse: [self value]) displayOn: aPuttableStream!

value
	"Answer the receiver's value as a Smalltalk object of the appropriate scalar type for the subclass."

	^self subclassResponsibility!

value: anObject
	"Set the receiver's value field to the value of anObject."

	^self subclassResponsibility! !

!External.SCALAR categoriesForMethods!
=!comparing!public! !
displayOn:!printing!public! !
value!converting!public! !
value:!public! !
!

!External.SCALAR class methodsFor!

defineFields
	self defineField: #value type: (FillerField byteSize: 0)!

getFieldNames
	^#(#value)! !

!External.SCALAR class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!constants!private! !
!

