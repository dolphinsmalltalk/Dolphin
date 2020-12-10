"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #'Kernel.IIPDolphin'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.IIPDolphin guid: (IID fromString: '{6d0fa0a9-1a1b-467b-bb99-ad1ccdf513aa}')!
Kernel.IIPDolphin comment: '<IIPDolphin> is a wrapper class for the COM interface ''DolphinIP.IIPDolphin'' generated from type information in the ''Dolphin Smalltalk InProcStub Library 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

IIPDolphin is the interface implemented by the image and used by the Dolphin in-proc COM stub to communicate DllGetClassObject, DllCanUnloadNow, DllRegisterServer and DllUnregisterServer calls from the host process and/or OLE/COM subsystem.'!
!Kernel.IIPDolphin categoriesForClass!IPDolphin-Interfaces! !
!Kernel.IIPDolphin class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'InProcDolphin.IInProcDolphin'
		IInProcDolphin defineTemplate
	"

	self
		defineFunction: #CanUnloadNow;
		defineFunction: #GetClassObject:riid:ppv:
			argumentTypes: 'GUID* GUID* void**';
		defineFunction: #RegisterServer;
		defineFunction: #UnregisterServer;
		defineFunction: #OnInitialize;
		defineFunction: #OnShutdown
! !
!Kernel.IIPDolphin class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

