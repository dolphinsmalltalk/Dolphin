"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IClassFactory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IClassFactory guid: (IID fromString: '{00000001-0000-0000-c000-000000000046}')!
IClassFactory comment: '<IClassFactory> is a wrapper class for the custom interface ''UNKNWN.IClassFactory'' from type information in the ''IUnknown Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IClassFactory categoriesForClass!COM-Interfaces! !
!IClassFactory methodsFor!

createInstance: pUnkOuter iid: iid
	"Create and a new instance of the class represented by the receiver, aggregating
	it with the object whose <IUnknown> is specified by the argument, pUnkOuter, and
	answering an instance of the interface class identified by the <IID>, iid.
	If aggregation is not required, then pUnkOuter can be nil."

	| ifClass answer hr |
	ifClass := COMInterface classForIID: iid.
	answer := ifClass newPointer.
	hr := self CreateInstance: pUnkOuter riid: iid ppvObject: answer.
	^hr < 0 
		ifTrue: [HRESULTError signalWith: hr]
		ifFalse: [answer]!

CreateInstance: pUnkOuter riid: riid ppvObject: ppvObject
	"Invoke the CreateInstance() method of the object wrapped by the receiver.
	
		HRESULT __stdcall CreateInstance(
			[in] IUnknown* pUnkOuter,
			[in] GUID* riid,
			[out] IUnknown** ppvObject);

	"

	<virtual stdcall: sdword 4 IUnknown* guid* IUnknown**>
	^self invalidCall: _failureCode!

LockServer: fLock
	"Invoke the LockServer() method of the object wrapped by the receiver.
	
		HRESULT __stdcall LockServer(
			[in] long fLock);

	"

	<virtual stdcall: hresult 5 sdword>
	^self invalidCall: _failureCode! !
!IClassFactory categoriesFor: #createInstance:iid:!instance creation!public! !
!IClassFactory categoriesFor: #CreateInstance:riid:ppvObject:!COM Interfaces-IClassFactory!public! !
!IClassFactory categoriesFor: #LockServer:!**auto generated**!public! !

!IClassFactory class methodsFor!

ctxAll
	"Answer the flags to be used to specify instance creation from any source.
	N.B. This varies depending on whether the operating system supports remote
	servers, and so is not strictly a constant (thanks guys)."

	^self ctxServer | CLSCTX_INPROC_HANDLER!

ctxServer
	"Answer the flags to be used to specify instance creation from any type of server.
	N.B. This varies depending on whether the operating system supports remote
	servers, and so is not strictly a constant (thanks guys)."

	^CLSCTX_INPROC_SERVER | CLSCTX_LOCAL_SERVER |
		(OLELibrary default supportsDCOM ifTrue: [CLSCTX_REMOTE_SERVER] ifFalse: [0])!

defineFunctions
	"Declare the virtual function table for the COM interface 'UNKNWN.IClassFactory'
		IClassFactory defineTemplate
	"

	self
		defineFunction: #CreateInstance:riid:ppvObject:
			returnType: 'sdword'
			argumentTypes: 'IUnknown* GUID* IUnknown**';
		defineFunction: #LockServer:
			argumentTypes: 'bool'! !
!IClassFactory class categoriesFor: #ctxAll!constants!public! !
!IClassFactory class categoriesFor: #ctxServer!constants!public! !
!IClassFactory class categoriesFor: #defineFunctions!initializing!public! !

