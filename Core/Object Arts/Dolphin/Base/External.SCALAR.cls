"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #ExternalScalar
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_value' -> 16r0
	}!
ExternalScalar guid: (GUID fromString: '{704554ca-46f7-49b2-92df-edcbe398040a}')!
ExternalScalar isAbstract: true!
ExternalScalar comment: ''!
!ExternalScalar categoriesForClass!External-Data-Structured! !
!ExternalScalar methodsFor!

= anObject
	"Answer whether the receiver is equivalent to anObject."

	^anObject = self value!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	(self isNull ifFalse: [self value]) displayOn: aPuttableStream!

value
	"Answer the receiver's value as a Smalltalk object of the appropriate scalar type for the subclass."

	^self subclassResponsibility!

value: anObject
	"Set the receiver's value field to the value of anObject."

	^self subclassResponsibility! !
!ExternalScalar categoriesFor: #=!comparing!public! !
!ExternalScalar categoriesFor: #displayOn:!printing!public! !
!ExternalScalar categoriesFor: #value!converting!public! !
!ExternalScalar categoriesFor: #value:!public! !

!ExternalScalar class methodsFor!

defineFields
	self defineField: #value type: (FillerField byteSize: 0)!

getFieldNames
	^#(#value)! !
!ExternalScalar class categoriesFor: #defineFields!public!template definition! !
!ExternalScalar class categoriesFor: #getFieldNames!constants!private! !

