"Filed out from Dolphin Smalltalk X6"!

ValueModel subclass: #ValueAdaptor
	instanceVariableNames: 'subject'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ValueAdaptor guid: (GUID fromString: '{87B4C676-026E-11D3-9FD7-00A0CC3E4A32}')!
ValueAdaptor comment: 'An abstract class whose subclasses allow some part of a subject object (typically an aspect or keyed element) to be treated a <valueModel>.

Instance Variables
	subject	<Object> whose content will be adapted to be accessed as a <value>'!
!ValueAdaptor categoriesForClass!MVP-Models! !
!ValueAdaptor methodsFor!

displayOn: aStream 
	"Subclasses must reimplement in order to avoid an infinite recursion in #printOn:"

	^self subclassResponsibility!

printOn: aStream 
	"Append a short textual description of the receiver to, aStream."

	aStream
		basicPrint: self;
		nextPut: $(; display: self; nextPut: $)
!

subject
	"Private - Answers the subject model for the receiver"

	^subject
!

subject: anObject
	"Private - Sets the subject object"

	subject := anObject.
! !
!ValueAdaptor categoriesFor: #displayOn:!displaying!public! !
!ValueAdaptor categoriesFor: #printOn:!printing!public! !
!ValueAdaptor categoriesFor: #subject!accessing!private! !
!ValueAdaptor categoriesFor: #subject:!initializing!private! !

!ValueAdaptor class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

subject: anObject 
	^(self new)
		subject: anObject;
		yourself! !
!ValueAdaptor class categoriesFor: #icon!constants!public! !
!ValueAdaptor class categoriesFor: #subject:!instance creation!public! !

