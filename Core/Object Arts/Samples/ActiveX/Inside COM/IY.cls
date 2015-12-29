"Filed out from Dolphin Smalltalk 2002 release 5.00"!

IUnknown subclass: #IY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IY guid: (IID fromString: '{E0E7B193-F8BD-11D1-AA69-7CCD00000000}')!
IY comment: ''!
!IY categoriesForClass!No category! !
!IY methodsFor!

Fy
	"Callout for the IY::Fy() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IY>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: void 4 >
	^self invalidCall! !
!IY categoriesFor: #Fy!COM Interfaces-IY!private! !

!IY class methodsFor!

defineFunctions
	"Declare the virtual functions supported by the receiver.
		IY compileFunctions
	"

	self
		defineFunction: #Fy returnType: 'void'!

initialize
	"Private - Initialize the receiver.
	Generate the IID from its string representation.
		IY initialize
	"

	self iidString: '{E0E7B193-F8BD-11D1-AA69-7CCD00000000}'! !
!IY class categoriesFor: #defineFunctions!initializing!private! !
!IY class categoriesFor: #initialize!initializing!private! !

