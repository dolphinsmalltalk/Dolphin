"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'OS.RPCLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.RPCLibrary guid: (Core.GUID fromString: '{87b4c584-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.RPCLibrary comment: ''!
!OS.RPCLibrary categoriesForClass!External-Libraries-Win32! !
!OS.RPCLibrary methodsFor!

invalidCall: anInteger
	"Private - An invalid external call was attempted through one of the receiver's methods. The argument is the failure code from the external call primitive, which in the case of the RPCLibrary can be a non-zero RPC_STATUS return code from the function call."

	^anInteger < 0 ifTrue: [super invalidCall: anInteger] ifFalse: [RPCError signalWith: anInteger]!

rpcStringFree: lppstr
	"Free a character string allocated by the RPC library.
		RPC_STATUS RPC_ENTRY RpcStringFree( 
			unsigned char * *  String	
		);"

	<stdcall: sdword RpcStringFreeA char**>
	^self invalidCall: _failureCode!

uuidCompare: uuid1 uuid2: uuid2 status: status
	"Answer an <integer> order between the  <GUID>, uuid1, is equal to the <GUID>, uuid2,
	with error status reported through the <DWORD> argument, status.
		int UuidCompare(
			UUID * Uuid1,
			UUID * Uuid2,
			RPC_STATUS * Status
		);"

	<stdcall: sdword UuidCompare void* void* dword*>
	^self invalidCall: _failureCode!

uuidCreate: uuidBuf
	"Create a new UUID.

		RPC_STATUS RPC_ENTRY UuidCreate( 
			UUID *  Uuid  
		);"

	<stdcall: sdword UuidCreate void*>
	^self invalidCall: _failureCode!

uuidFromString: uuid uuid: lppstr
	"Converts a string to a UUID.

		RPC_STATUS RPC_ENTRY UuidFromString( 
			unsigned char*  StringUuid, 	
			UUID *  Uuid	
		);"

	<stdcall: errno UuidFromStringA char* void*>
	^self invalidCall: _failureCode!

uuidToString: uuid stringUuid: lppstr
	"Converts a UUID to a string.
		RPC_STATUS RPC_ENTRY UuidToString( 
			UUID *  Uuid, 	
			unsigned char **  StringUuid	
		);"

	<stdcall: errno UuidToStringA void* char**>
	^self invalidCall: _failureCode! !
!OS.RPCLibrary categoriesFor: #invalidCall:!exceptions!private! !
!OS.RPCLibrary categoriesFor: #rpcStringFree:!primitives!public!win32 functions-rpc! !
!OS.RPCLibrary categoriesFor: #uuidCompare:uuid2:status:!primitives!public!win32 functions-rpc! !
!OS.RPCLibrary categoriesFor: #uuidCreate:!primitives!public!win32 functions-rpc! !
!OS.RPCLibrary categoriesFor: #uuidFromString:uuid:!primitives!public!win32 functions-rpc! !
!OS.RPCLibrary categoriesFor: #uuidToString:stringUuid:!primitives!public!win32 functions-rpc! !

!OS.RPCLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which the receiver represents"

	^'RPCRT4'! !
!OS.RPCLibrary class categoriesFor: #fileName!constants!public! !

