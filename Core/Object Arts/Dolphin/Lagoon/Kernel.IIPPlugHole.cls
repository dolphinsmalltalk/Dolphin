"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'Kernel.IIPPlugHole'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM private})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.IIPPlugHole guid: (OS.COM.IID fromString: '{7dac28a4-28f3-4cc9-8bf1-c17fb4cac8bd}')!
Kernel.IIPPlugHole comment: '<IIPPlugHole> is a wrapper class for the COM interface ''InProcDolphin.IIPPlugHole'' generated from type information in the ''Dolphin Smalltalk InProcStub Library 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

This interface is implemented by the Dolphin in-process DLL peer which forwards the DllGetClassObject, DllCanUnloadNow, DllRegisterServer and DllUnregisterServer calls to the image through the IInProcDolphin registered with it as the Peer property.'!
!Kernel.IIPPlugHole categoriesForClass!COM-Interfaces!IPDolphin-Interfaces! !
!Kernel.IIPPlugHole methodsFor!

get_Peer: get_Peer
	"Callout for the IIPPlugHole::get_Peer() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IIPPlugHole>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 lppvoid>
	^self invalidCall: _failureCode!

put_Peer: put_Peer
	"Callout for the IIPPlugHole::put_Peer() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in IIPPlugHole>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 5 OS.COM.IUnknown*>
	^self invalidCall: _failureCode! !
!Kernel.IIPPlugHole categoriesFor: #get_Peer:!COM Interfaces-IIPPlugHole!public! !
!Kernel.IIPPlugHole categoriesFor: #put_Peer:!COM Interfaces-IIPPlugHole!public! !

!Kernel.IIPPlugHole class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'InProcDolphin.IInProcPlugHole'
		IIPPlugHole compileFunctions
	"

	self
		defineFunction: #get_Peer:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_Peer:
			argumentTypes: 'IUnknown*'
! !
!Kernel.IIPPlugHole class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

