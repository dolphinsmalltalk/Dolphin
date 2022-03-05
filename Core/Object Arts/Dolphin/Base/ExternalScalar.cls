"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #ExternalScalar
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_value'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalScalar guid: (GUID fromString: '{704554ca-46f7-49b2-92df-edcbe398040a}')!
ExternalScalar isAbstract: true!
ExternalScalar addClassConstant: '_OffsetOf_value' value: 16r0!
ExternalScalar comment: ''!
!ExternalScalar categoriesForClass!External-Data-Structured! !
!ExternalScalar methodsFor!

= anObject
	"Answer whether the receiver is equivalent to anObject."

	^anObject = self value!

displayOn: target
	"Append a textual representation of the receiver onto the <puttableStream> argument,
	target, in the format that an end-user might want to see it."

	target display: (self isNull ifFalse: [self value])!

value
	"Answer the receiver's value as a Smalltalk object of the appropriate scalar type for the subclass."

	^self subclassResponsibility!

value: anObject
	"Set the receiver's value field to the value of anObject."

	^self subclassResponsibility! !
!ExternalScalar categoriesForMethods!
=!comparing!public! !
displayOn:!printing!private! !
value!converting!public! !
value:!public! !
!

!ExternalScalar class methodsFor!

defineFields
	self defineField: #value type: (FillerField byteSize: 0)!

getFieldNames
	^#(#value)! !
!ExternalScalar class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!constants!private! !
!

