"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IIPPlugHole
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IIPPlugHole guid: (IID fromString: '{7dac28a4-28f3-4cc9-8bf1-c17fb4cac8bd}')!
IIPPlugHole comment: '<IIPPlugHole> is a wrapper class for the COM interface ''InProcDolphin.IIPPlugHole'' generated from type information in the ''Dolphin Smalltalk InProcStub Library 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

This interface is implemented by the Dolphin in-process DLL peer which forwards the DllGetClassObject, DllCanUnloadNow, DllRegisterServer and DllUnregisterServer calls to the image through the IInProcDolphin registered with it as the Peer property.'!
!IIPPlugHole categoriesForClass!COM-Interfaces!IPDolphin-Interfaces! !
!IIPPlugHole methodsFor!

get_Peer: pVal
	"Private - Get the value of the 'Peer' property of the receiver.
	Helpstring: 'Corresponding peer object in the Dolphin image.'

		HRESULT __stdcall Peer(
			[out, retval] IUnknown** pVal);
	"

	<virtual stdcall: hresult 4 IUnknown**>
	^self invalidCall: _failureCode!

put_Peer: pVal
	"Private - Set the value of the 'Peer' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, pVal.
	Helpstring: 'Corresponding peer object in the Dolphin image.'

		HRESULT __stdcall Peer(
			[in] IUnknown* pVal);
	"

	<virtual stdcall: hresult 5 IUnknown*>
	^self invalidCall: _failureCode! !
!IIPPlugHole categoriesFor: #get_Peer:!**auto generated**!COM Interfaces-IInProcPlugHole!private! !
!IIPPlugHole categoriesFor: #put_Peer:!**auto generated**!COM Interfaces-IInProcPlugHole!private! !

!IIPPlugHole class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'InProcDolphin.IInProcPlugHole'
		IInProcPlugHole defineTemplate
	"

	self
		defineFunction: #get_Peer:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_Peer:
			argumentTypes: 'IUnknown*'
! !
!IIPPlugHole class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

