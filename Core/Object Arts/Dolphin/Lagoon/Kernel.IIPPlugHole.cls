"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #'Kernel.IIPPlugHole'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.IIPPlugHole guid: (IID fromString: '{7dac28a4-28f3-4cc9-8bf1-c17fb4cac8bd}')!
Kernel.IIPPlugHole comment: '<IIPPlugHole> is a wrapper class for the COM interface ''InProcDolphin.IIPPlugHole'' generated from type information in the ''Dolphin Smalltalk InProcStub Library 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

This interface is implemented by the Dolphin in-process DLL peer which forwards the DllGetClassObject, DllCanUnloadNow, DllRegisterServer and DllUnregisterServer calls to the image through the IInProcDolphin registered with it as the Peer property.'!
!Kernel.IIPPlugHole categoriesForClass!COM-Interfaces!IPDolphin-Interfaces! !
!Kernel.IIPPlugHole methodsFor!

get_Peer: pVal
	"Private - Get the value of the 'Peer' property of the receiver.
	Helpstring: 'Corresponding peer object in the Dolphin image.'

		HRESULT __stdcall Peer(
			[out, retval] IUnknown** pVal);
	"

	<virtual stdcall: hresult 4 Smalltalk.IUnknown**>
	^self invalidCall: _failureCode!

put_Peer: pVal
	"Private - Set the value of the 'Peer' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, pVal.
	Helpstring: 'Corresponding peer object in the Dolphin image.'

		HRESULT __stdcall Peer(
			[in] IUnknown* pVal);
	"

	<virtual stdcall: hresult 5 Smalltalk.IUnknown*>
	^self invalidCall: _failureCode! !
!Kernel.IIPPlugHole categoriesFor: #get_Peer:!**auto generated**!COM Interfaces-IInProcPlugHole!private! !
!Kernel.IIPPlugHole categoriesFor: #put_Peer:!**auto generated**!COM Interfaces-IInProcPlugHole!private! !

!Kernel.IIPPlugHole class methodsFor!

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
!Kernel.IIPPlugHole class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

