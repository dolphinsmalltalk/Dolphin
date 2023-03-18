"Filed out from Dolphin Smalltalk"!

UI.ValueModel
	subclass: #'UI.ValueAdaptor'
	instanceVariableNames: 'subject'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ValueAdaptor guid: (Core.GUID fromString: '{87b4c676-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ValueAdaptor isNonInstantiable: true!
UI.ValueAdaptor comment: 'An abstract class whose subclasses allow some part of a subject object (typically an aspect or keyed element) to be treated a <valueModel>.

Instance Variables
	subject	<Object> whose content will be adapted to be accessed as a <value>'!
!UI.ValueAdaptor categoriesForClass!MVP-Models! !
!UI.ValueAdaptor methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	Subclasses must reimplement in order to avoid an infinite recursion in #printOn:"

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
!UI.ValueAdaptor categoriesForMethods!
displayOn:!displaying!public! !
printOn:!printing!public! !
subject!accessing!private! !
subject:!initializing!private! !
!

!UI.ValueAdaptor class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

subject: anObject 
	^(self new)
		subject: anObject;
		yourself! !
!UI.ValueAdaptor class categoriesForMethods!
icon!constants!public! !
subject:!instance creation!public! !
!

