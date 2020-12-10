"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #OLELibrary
	instanceVariableNames: 'comOnly'
	classVariableNames: 'DefaultIMalloc'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OLELibrary guid: (Core.GUID fromString: '{64674066-3a82-101b-8181-00aa003743d3}')!
OLELibrary comment: 'OLELibrary is the <ExternalLibrary> class to represent the Win32 System DLL, OLE32.DLL.
This library contains functions pertaining to the use of OLE and COM.'!
!OLELibrary categoriesForClass!External-Libraries-ActiveX! !
!OLELibrary methodsFor!

close
	"Release the reference the receiver has to the External Library	it represents. This may
	not cause the library to be unloaded, so it may still function. Answer whether the
	library was successfully closed. We also free any standard IMalloc instances."

	self uninitialize.
	^super close!

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

	<stdcall: hresult CoCreateInstance guid* void* sdword guid* IUnknown**>
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

	<stdcall: hresult CoCreateInstanceEx guid* IUnknown* dword COSERVERINFO* dword MULTI_QI*>
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

	<stdcall: sdword CoDisconnectObject IUnknown* dword>
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

	<stdcall: hresult CoGetClassObject guid* dword COSERVERINFO* guid* void**>
	^self invalidCall: _failureCode!

coGetMalloc: dwMemContext ppMalloc: ppMalloc
	"Invoke the CoGetMalloc() function of the module wrapped by the receiver.
	Helpstring: Retrieves the default COM task memory allocator (which implements IMalloc)

		HRESULT __stdcall CoGetMalloc(
			[in]unsigned long dwMemContext,
			[out, retval]IMalloc** ppMalloc);"

	<stdcall: hresult CoGetMalloc dword IMalloc**>
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

	<stdcall: hresult CoInitializeEx void* dword>
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

	<stdcall: hresult CoRegisterClassObject guid* IUnknown* dword dword dword*>
	^self invalidCall: _failureCode!

coRevokeClassObject: anInteger
	"Revoke an oustanding class registration, as identified by the cookie, anInteger

		HRESULT CoRevokeClassObject(unsigned long dwRegister);"

	<stdcall: sdword CoRevokeClassObject dword>
	^self invalidCall: _failureCode!

coTaskMemAlloc: cb
	"Invoke the CoTaskMemAlloc() function of the module wrapped by the receiver.
	Helpstring: Allocates a block of task memory (in the same way that IMalloc::Alloc does)

		LPVOID __stdcall CoTaskMemAlloc(
			unsigned long cb);"

	<stdcall: void* CoTaskMemAlloc dword>
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

	<stdcall: void* CoTaskMemRealloc void* dword>
	^self invalidCall: _failureCode!

coUninitialize
	"Invoke the CoUninitialize() function of the module wrapped by the receiver.

		void __stdcall CoUninitialize();"

	<stdcall: void CoUninitialize>
	^self invalidCall: _failureCode!

initialize
	"Private - Initialize the receiver using the specified default task
	allocator (usually nil). This initialization will be automatically
	run if you make any references to 'OLELibrary default', and therefore
	you must either set up the DefaultIMalloc BEFORE any calls to OLELibrary,
	OR set the default library using #default:, OR perform a subsequent
	initialize passing the IMalloc you want to use."

	IMalloc clear.
	comOnly := false.
	self initialize: DefaultIMalloc!

initialize: anIMallocOrNil
	"Private - Initialize the receiver using the specified default task
	allocator (usually nil). This initialization will be automatically
	run if you make any references to 'OLELibrary default', and therefore
	you must either set up the DefaultIMalloc BEFORE any calls to OLELibrary,
	OR set the default library using #default:, OR perform a subsequent
	initialize passing the IMalloc you want to use."

	self comOnly
		ifTrue: [self coInitialize: anIMallocOrNil asParameter]
		ifFalse: [self oleInitialize: anIMallocOrNil asParameter]!

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

supportsDCOM
	"Answer whether the host OS supports DCOM (i.e. remote servers).
	This is the officially recognised test!!"

	^(KernelLibrary default getProcAddress: self asParameter lpProcName: 'CoInitializeEx') notNull!

uninitialize
	"Private - Reverse the initialize"

	IMalloc free.
	self comOnly
		ifTrue: [self coUninitialize]
		ifFalse: [self oleUninitialize]! !
!OLELibrary categoriesFor: #close!public!realizing/unrealizing! !
!OLELibrary categoriesFor: #clsidFromProgID:lpclsid:!**auto generated**!OLE Functions-GUID!public! !
!OLELibrary categoriesFor: #coCreateGuid:!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coCreateInstance:pUnkOuter:dwClsContext:riid:ppv:!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coCreateInstanceEx:pUnkOuter:dwClsContext:pServerInfo:cmq:rgmqResults:!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coDisconnectObject:dwReserved:!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coFileTimeNow:!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coGetClassObject:dwClsContext:pServerInfo:riid:ppv:!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coGetMalloc:ppMalloc:!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coGetObject:pBindOptions:riid:ppv:!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coInitialize:!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coInitializeEx:dwCoInit:!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #comOnly!accessing!public! !
!OLELibrary categoriesFor: #comOnly:!initializing!private! !
!OLELibrary categoriesFor: #coRegisterClassObject:pUnk:dwClsContext:flags:lpdwRegister:!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coRevokeClassObject:!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coTaskMemAlloc:!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coTaskMemFree:!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coTaskMemRealloc:cb:!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #coUninitialize!**auto generated**!OLE Functions-COM!public! !
!OLELibrary categoriesFor: #initialize!initializing!private! !
!OLELibrary categoriesFor: #initialize:!initializing!private! !
!OLELibrary categoriesFor: #now!enquiries!public! !
!OLELibrary categoriesFor: #oleInitialize:!**auto generated**!OLE Functions-OLE!public! !
!OLELibrary categoriesFor: #oleLockRunning:fLock:fLastUnlockCloses:!OLE Functions-Persistent Objects!primitives!public! !
!OLELibrary categoriesFor: #oleUninitialize!**auto generated**!OLE Functions-OLE!public! !
!OLELibrary categoriesFor: #progIDFromCLSID:lplpszProgID:!**auto generated**!OLE Functions-GUID!public! !
!OLELibrary categoriesFor: #supportsDCOM!public!testing! !
!OLELibrary categoriesFor: #uninitialize!private!realizing/unrealizing! !

!OLELibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which
	the receiver represents."

	^'OLE32'! !
!OLELibrary class categoriesFor: #fileName!constants!public! !

