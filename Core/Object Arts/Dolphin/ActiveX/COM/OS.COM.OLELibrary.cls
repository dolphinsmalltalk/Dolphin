"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'OS.COM.OLELibrary'
	instanceVariableNames: 'comOnly'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.OLELibrary guid: (Core.GUID fromString: '{64674066-3a82-101b-8181-00aa003743d3}')!

OS.COM.OLELibrary comment: 'OLELibrary is the <ExternalLibrary> class to represent the Win32 System DLL, OLE32.DLL.
This library contains functions pertaining to the use of OLE and COM.'!

!OS.COM.OLELibrary categoriesForClass!External-Libraries-ActiveX! !

!OS.COM.OLELibrary methodsFor!

basicFree
	"Private - Release the reference the receiver has to Ole32.dll. Answer whether the library was successfully closed. We also free any standard IMalloc instances."

	self uninitialize.
	^super basicFree!

clsidFromProgID: lpszProgID lpclsid: lpclsid
	"Invoke the CLSIDFromProgID() function of the module wrapped by the receiver.
	Helpstring: Looks up a CLSID in the registry, given a ProgID

		HRESULT __stdcall CLSIDFromProgID(
			LPWSTR lpszProgID,
			GUID* lpclsid);"

	<stdcall: hresult CLSIDFromProgID lpwstr guid*>
	^self invalidCall: _failureCode!

coCreateGuid: pguid
	"Invoke the CoCreateGuid() function of the module wrapped by the receiver.
	Helpstring: Creates a GUID, a unique 128-bit integer used for CLSIDs and interface identifiers

		HRESULT __stdcall CoCreateGuid(
			GUID* pguid);"

	<stdcall: hresult CoCreateGuid guid*>
	^self invalidCall: _failureCode!

coCreateInstance: rclsid pUnkOuter: pUnkOuter dwClsContext: dwClsContext riid: riid ppv: ppv
	"Invoke the CoCreateInstance() function of the module wrapped by the receiver.
	Helpstring: Creates a single uninitialized object of the class associated with a specified CLSID

		HRESULT __stdcall CoCreateInstance(
			[in]GUID* rclsid,
			[in]LPVOID pUnkOuter,
			[in]CLSCTX dwClsContext,
			[in]GUID* riid,
			[out, retval]IUnknown** ppv);"

	<stdcall: hresult CoCreateInstance guid* void* int32 guid* IUnknown**>
	^self invalidCall: _failureCode!

coCreateInstanceEx: clsid pUnkOuter: pUnkOuter dwClsContext: dwClsContext pServerInfo: pServerInfo cmq: cmq rgmqResults: rgmqResults
	"Manufacture an object of the COM class whose <CLSID> is, clsid, on the machine
	identified by the <COSERVERINFO> argument, pServerInfo,. querying interfaces
	as specified in the <MULTI_QI> array, rgmqResults..

		HRESULT CoCreateInstanceEx(
			REFCLSID rclsid, 				// CLSID of the object to be created 
			IUnknown * punkOuter,			// If part of an aggregate, the controlling IUnknown 
			DWORD dwClsCtx,				// CLSCTX values 
			COSERVERINFO* pServerInfo,	// Machine on which the object is to be instantiated 
			ULONG cmq, 					// Number of MULTI_QI structures in rgmqResults 
			MULTI_QI rgmqResults 			// Array of MULTI_QI structures 
		); "

	<stdcall: hresult CoCreateInstanceEx guid* IUnknown* uint32 COSERVERINFO* uint32 MULTI_QI*>
	^self invalidCall: _failureCode!

coDisconnectObject: pUnk dwReserved: zero
	"Disconnects all remote process connections being maintained on behalf of 
	all the interface pointers that point to a specified object. Only the process 
	that actually manages the object should call CoDisconnectObject.
	Note that we generally don't care if this call fails, so we map the return
	type to sdword rather than hresult.

		STDAPI CoDisconnectObject(
			IUnknown * pUnk,	//Pointer to the interface on the object
			DWORD dwReserved	//Reserved for future use
		);"

	<stdcall: int32 CoDisconnectObject IUnknown* uint32>
	^self invalidCall: _failureCode!

coFileTimeNow: struct
	"Populate the argument with the current time as a FILETIME."

	<stdcall: bool CoFileTimeNow FILETIME*>
	^self invalidCall: _failureCode!

coGetClassObject: rclsid dwClsContext: dwClsContext pServerInfo: pServerInfo riid: riid ppv: ppv
	"Invoke the CoGetClassObject() function of the module wrapped by the receiver.
	Helpstring: Provides a pointer to an interface on a class object associated with a specified CLSID. CoGetClassObject locates, and if necessary, dynamically loads the executable code required to do this

		HRESULT __stdcall CoGetClassObject(
			[in]GUID* rclsid,
			[in]unsigned long dwClsContext,
			[in]COSERVERINFO* pServerInfo,
			[in]GUID* riid,
			[out, retval]LPVOID* ppv);"

	<stdcall: hresult CoGetClassObject guid* uint32 COSERVERINFO* guid* void**>
	^self invalidCall: _failureCode!

coGetMalloc: dwMemContext ppMalloc: ppMalloc
	"Invoke the CoGetMalloc() function of the module wrapped by the receiver.
	Helpstring: Retrieves the default COM task memory allocator (which implements IMalloc)

		HRESULT __stdcall CoGetMalloc(
			[in]unsigned long dwMemContext,
			[out, retval]IMalloc** ppMalloc);"

	<stdcall: hresult CoGetMalloc uint32 void**>
	^self invalidCall: _failureCode!

coGetObject: aUtf16String pBindOptions: aBIND_OPTS riid: anIID ppv: aCOMInterface
	"Converts a display name into a moniker that identifies the object named, and then binds to the object identified by the moniker. 
		WINOLEAPI CoGetObject(
			LPCWSTR pszName,
			BIND_OPTS * pBindOptions, 
			REFIID riid, 
			void ** ppv); "

	<stdcall: hresult CoGetObject lpwstr void* guid* void**>
	^self invalidCall: _failureCode!

coInitialize
	self comOnly
		ifTrue: [self coInitialize: nil]
		ifFalse: [self oleInitialize: nil]!

coInitialize: pvReserved
	"Invoke the CoInitialize() function of the module wrapped by the receiver.

		HRESULT __stdcall CoInitialize(
			[in]LPVOID pvReserved);"

	<stdcall: hresult CoInitialize void*>
	^self invalidCall: _failureCode!

coInitializeEx: pvReserved dwCoInit: dwCoInit
	"Invoke the CoInitializeEx() function of the module wrapped by the receiver.

		HRESULT __stdcall CoInitializeEx(
			[in]LPVOID pvReserved,
			[in]unsigned long dwCoInit);"

	<stdcall: hresult CoInitializeEx void* uint32>
	^self invalidCall: _failureCode!

comOnly
	"Answer whether COM support only is required."

	^comOnly!

comOnly: aBoolean
	"Private - Set whether COM support only is required. Do not change this one initialized."

	comOnly := aBoolean!

coRegisterClassObject: rclsid pUnk: pUnk dwClsContext: dwClsContext flags: flags lpdwRegister: lpdwRegister
	"Register a class object with OLE so other applications can connect to it.
	Should be called on startup by the OLESessionManager.

	STDAPI CoRegisterClassObject(
		REFCLSID rclsid,			// [in] CLSID
		IUnknown* pUnk,			// [in] IUnknown on class object
		DWORD dwClsContext,		// [in] Context for running executable code
		DWORD flags,				// [in] Connection flags
		LPDWORD* lpdwRegister		// [out]
		);"

	<stdcall: hresult CoRegisterClassObject guid* IUnknown* uint32 uint32 uint32*>
	^self invalidCall: _failureCode!

coRevokeClassObject: anInteger
	"Revoke an oustanding class registration, as identified by the cookie, anInteger

		HRESULT CoRevokeClassObject(unsigned long dwRegister);"

	<stdcall: int32 CoRevokeClassObject uint32>
	^self invalidCall: _failureCode!

coTaskMemAlloc: cb
	"Invoke the CoTaskMemAlloc() function of the module wrapped by the receiver.
	Helpstring: Allocates a block of task memory (in the same way that IMalloc::Alloc does)

		LPVOID __stdcall CoTaskMemAlloc(
			unsigned long cb);"

	<stdcall: void* CoTaskMemAlloc uint32>
	^self invalidCall: _failureCode!

coTaskMemFree: pv
	"Invoke the CoTaskMemFree() function of the module wrapped by the receiver.
	Helpstring: Frees a block of task memory previously allocated through a call to the CoTaskMemAlloc or CoTaskMemRealloc function

		void __stdcall CoTaskMemFree(
			LPVOID pv);"

	<stdcall: void CoTaskMemFree void*>
	^self invalidCall: _failureCode!

coTaskMemRealloc: pv cb: cb
	"Invoke the CoTaskMemRealloc() function of the module wrapped by the receiver.
	Helpstring: Changes the size of a previously allocated block of task memory

		LPVOID __stdcall CoTaskMemRealloc(
			LPVOID pv,
			unsigned long cb);"

	<stdcall: void* CoTaskMemRealloc void* uint32>
	^self invalidCall: _failureCode!

coUninitialize
	"Invoke the CoUninitialize() function of the module wrapped by the receiver.

		void __stdcall CoUninitialize();"

	<stdcall: void CoUninitialize>
	^self invalidCall: _failureCode!

initialize
	#{IMalloc} ifDefined: [:imalloc | imalloc clear].
	comOnly := false.
	self coInitialize!

now
	"Answer the current <FILETIME> in UTC."

	| answer |
	answer := FILETIME new.
	self coFileTimeNow: answer.
	^answer!

oleInitialize: pvReserved
	"Invoke the OleInitialize() function of the module wrapped by the receiver.

		HRESULT __stdcall OleInitialize(
			[in]LPVOID pvReserved);"

	<stdcall: hresult OleInitialize void*>
	^self invalidCall: _failureCode!

oleLockRunning: pUnknown fLock: fLock fLastUnlockCloses: fLastUnlockCloses
	<stdcall: hresult OleLockRunning IUnknown* bool bool>
	^self invalidCall: _failureCode!

oleUninitialize
	"Invoke the OleUninitialize() function of the module wrapped by the receiver.

		void __stdcall OleUninitialize();"

	<stdcall: void OleUninitialize>
	^self invalidCall: _failureCode!

progIDFromCLSID: clsid lplpszProgID: lplpszProgID
	"Invoke the ProgIDFromCLSID() function of the module wrapped by the receiver.
	Helpstring: Retrieves the ProgID for a given CLSID

		HRESULT __stdcall ProgIDFromCLSID(
			GUID* clsid,
			LPWSTR* lplpszProgID);"

	<stdcall: hresult ProgIDFromCLSID guid* lpwstr*>
	^self invalidCall: _failureCode!

uninitialize
	"Private - Reverse the initialize"

	#{IMalloc} ifDefined: [:imalloc | imalloc free].
	self comOnly ifTrue: [self coUninitialize] ifFalse: [self oleUninitialize]! !

!OS.COM.OLELibrary categoriesForMethods!
basicFree!private!realizing/unrealizing! !
clsidFromProgID:lpclsid:!**auto generated**!OLE Functions-GUID!public! !
coCreateGuid:!**auto generated**!OLE Functions-COM!public! !
coCreateInstance:pUnkOuter:dwClsContext:riid:ppv:!**auto generated**!OLE Functions-COM!public! !
coCreateInstanceEx:pUnkOuter:dwClsContext:pServerInfo:cmq:rgmqResults:!**auto generated**!OLE Functions-COM!public! !
coDisconnectObject:dwReserved:!OLE Functions-COM!public! !
coFileTimeNow:!OLE Functions-COM!public! !
coGetClassObject:dwClsContext:pServerInfo:riid:ppv:!**auto generated**!OLE Functions-COM!public! !
coGetMalloc:ppMalloc:!**auto generated**!OLE Functions-COM!public! !
coGetObject:pBindOptions:riid:ppv:!OLE Functions-COM!public! !
coInitialize!initializing!private! !
coInitialize:!**auto generated**!OLE Functions-COM!public! !
coInitializeEx:dwCoInit:!**auto generated**!OLE Functions-COM!public! !
comOnly!accessing!public! !
comOnly:!initializing!private! !
coRegisterClassObject:pUnk:dwClsContext:flags:lpdwRegister:!OLE Functions-COM!public! !
coRevokeClassObject:!OLE Functions-COM!public! !
coTaskMemAlloc:!**auto generated**!OLE Functions-COM!public! !
coTaskMemFree:!**auto generated**!OLE Functions-COM!public! !
coTaskMemRealloc:cb:!**auto generated**!OLE Functions-COM!public! !
coUninitialize!**auto generated**!OLE Functions-COM!public! !
initialize!initializing!private! !
now!enquiries!public! !
oleInitialize:!**auto generated**!OLE Functions-OLE!public! !
oleLockRunning:fLock:fLastUnlockCloses:!OLE Functions-Persistent Objects!primitives!public! !
oleUninitialize!**auto generated**!OLE Functions-OLE!public! !
progIDFromCLSID:lplpszProgID:!**auto generated**!OLE Functions-GUID!public! !
uninitialize!private!realizing/unrealizing! !
!

!OS.COM.OLELibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which
	the receiver represents."

	^'OLE32'!

sharedVariableName
	^#{Ole32}! !

!OS.COM.OLELibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

