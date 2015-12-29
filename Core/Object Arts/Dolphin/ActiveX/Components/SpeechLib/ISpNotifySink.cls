"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #ISpNotifySink
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpNotifySink guid: (IID fromString: '{259684DC-37C3-11D2-9603-00C04F8EE628}')!
ISpNotifySink comment: '<ISpNotifySink> is a wrapper class for the COM interface ''SpeechLib.ISpNotifySink'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpNotifySink Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(259684DC-37C3-11D2-9603-00C04F8EE628), 
	helpstring("ISpNotifySink Interface"), 
	restricted
]
interface ISpNotifySink : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall Notify();
};
'!
!ISpNotifySink categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpNotifySink methodsFor!

notify
	"Invoke the Notify() method of the COM object."

	^self Notify
!

Notify
	"Private - Invoke the Notify() method of the COM object.

		HRESULT __stdcall Notify();"

	<virtual stdcall: hresult 4>
	^self invalidCall
! !
!ISpNotifySink categoriesFor: #notify!**auto generated**!methods!public! !
!ISpNotifySink categoriesFor: #Notify!**auto generated**!COM Interfaces-ISpNotifySink!private! !

!ISpNotifySink class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpNotifySink'
		ISpNotifySink defineTemplate"

	self
		defineFunction: #Notify
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpNotifySink initializeTypeLib"

	typeLib := SpeechLib! !
!ISpNotifySink class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpNotifySink class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

