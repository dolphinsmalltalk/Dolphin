"Filed out from Dolphin Smalltalk 2002 release 5.00"!

IUnknown subclass: #IX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IX guid: (IID fromString: '{E0E7B192-F8BD-11D1-AA69-7CCD00000000}')!
IX comment: ''!
!IX categoriesForClass!No category! !
!IX methodsFor!

Fx
	"Callout for the IX::Fx() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IX>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: void 4 >
	^self invalidCall! !
!IX categoriesFor: #Fx!COM Interfaces-IX!private! !

!IX class methodsFor!

defineFunctions
	"Declare the virtual functions supported by the receiver.
		IX compileFunctions
	"

	self
		defineFunction: #Fx returnType: 'void'!

initialize
	"Private - Initialize the receiver.
	Generate the IID from its string representation.
		IX initialize
	"

	self iidString: '{E0E7B192-F8BD-11D1-AA69-7CCD00000000}'! !
!IX class categoriesFor: #defineFunctions!initializing!private! !
!IX class categoriesFor: #initialize!initializing!private! !

