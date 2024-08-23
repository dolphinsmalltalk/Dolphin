"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IClassFactory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IClassFactory guid: (OS.COM.IID fromString: '{00000001-0000-0000-c000-000000000046}')!

OS.COM.IClassFactory comment: '`OS.COM.IClassFactory` is a wrapper class for the custom interface ''UNKNWN.IClassFactory'' from type information in the ''IUnknown Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!

!OS.COM.IClassFactory categoriesForClass!COM-Interfaces! !

!OS.COM.IClassFactory methodsFor!

createInstance: pUnkOuter iid: iid
	"Create and a new instance of the class represented by the receiver, aggregating
	it with the object whose <IUnknown> is specified by the argument, pUnkOuter, and
	answering an instance of the interface class identified by the <IID>, iid.
	If aggregation is not required, then pUnkOuter can be nil."

	| ifClass answer hr |
	ifClass := Interface classForIID: iid.
	answer := ifClass newPointer.
	hr := self
				CreateInstance: pUnkOuter
				riid: iid
				ppvObject: answer.
	^hr < 0 ifTrue: [HRESULTError signalWith: hr] ifFalse: [answer]!

CreateInstance: pUnkOuter riid: riid ppvObject: ppvObject
	"Invoke the CreateInstance() method of the object wrapped by the receiver.
	
		HRESULT __stdcall CreateInstance(
			[in] IUnknown* pUnkOuter,
			[in] GUID* riid,
			[out] IUnknown** ppvObject);

	"

	<virtual stdcall: int32 4 IUnknown* guid* IUnknown**>
	^self invalidCall: _failureCode!

LockServer: fLock
	"Invoke the LockServer() method of the object wrapped by the receiver.
	
		HRESULT __stdcall LockServer(
			[in] long fLock);

	"

	<virtual stdcall: hresult 5 int32>
	^self invalidCall: _failureCode! !

!OS.COM.IClassFactory categoriesForMethods!
createInstance:iid:!instance creation!public! !
CreateInstance:riid:ppvObject:!COM Interfaces-IClassFactory!public! !
LockServer:!**auto generated**!public! !
!

!OS.COM.IClassFactory class methodsFor!

ctxAll
	"Answer the flags to be used to specify instance creation from any source.
	N.B. This varies depending on whether the operating system supports remote
	servers, and so is not strictly a constant (thanks guys)."

	^self ctxServer | CLSCTX_INPROC_HANDLER!

ctxServer
	"Answer the flags to be used to specify instance creation from any type of server."

	^##(CLSCTX_INPROC_SERVER | CLSCTX_LOCAL_SERVER | CLSCTX_REMOTE_SERVER)!

defineFunctions
	"Declare the virtual function table for the COM interface 'UNKNWN.IClassFactory'
		IClassFactory defineTemplate
	"

	self
		defineFunction: #CreateInstance:riid:ppvObject:
			returnType: 'int32'
			argumentTypes: 'IUnknown* GUID* IUnknown**';
		defineFunction: #LockServer:
			argumentTypes: 'bool'!

onCLSID: aCLSID
	| pFactory |
	pFactory := self newPointer.
	Ole32
		coGetClassObject: aCLSID
		dwClsContext: self ctxServer
		pServerInfo: nil
		riid: self iid
		ppv: pFactory.
	^pFactory!

onCLSID: aCLSID hostName: aString
	| pServerInfo pFactory dwClsContext |
	dwClsContext := self ctxServer.
	(aString notNil and: [aString notEmpty])
		ifTrue: 
			[pServerInfo := COSERVERINFO new.
			pServerInfo hostName: aString.
			dwClsContext := dwClsContext bitOr: CLSCTX_REMOTE_SERVER].
	pFactory := self newPointer.
	Ole32
		coGetClassObject: aCLSID
		dwClsContext: dwClsContext
		pServerInfo: pServerInfo
		riid: self iid
		ppv: pFactory.
	^pFactory! !

!OS.COM.IClassFactory class categoriesForMethods!
ctxAll!constants!public! !
ctxServer!constants!public! !
defineFunctions!initializing!public!template definition! !
onCLSID:!instance creation!public! !
onCLSID:hostName:!instance creation!public! !
!

