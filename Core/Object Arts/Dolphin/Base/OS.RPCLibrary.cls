﻿"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.RPCLibrary'
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

	^anInteger < 0
		ifTrue: [self invalidCall: anInteger fromFrame: Processor activeProcess topFrame sender]
		ifFalse: [RPCError signalWith: anInteger]!

rpcStringFree: lppstr
	"Free a character string allocated by the RPC library.
		RPC_STATUS RPC_ENTRY RpcStringFree( 
			unsigned char * *  String	
		);"

	<stdcall: int32 RpcStringFreeA char**>
	^self invalidCall: _failureCode!

uuidCompare: uuid1 uuid2: uuid2 status: status
	"Answer an <integer> order between the  <GUID>, uuid1, is equal to the <GUID>, uuid2,
	with error status reported through the <UInt32> argument, status.
		int UuidCompare(
			UUID * Uuid1,
			UUID * Uuid2,
			RPC_STATUS * Status
		);"

	<stdcall: int32 UuidCompare void* void* uint32*>
	^self invalidCall: _failureCode!

uuidCreate: uuidBuf
	"Create a new UUID.

		RPC_STATUS RPC_ENTRY UuidCreate( 
			UUID *  Uuid  
		);"

	<stdcall: int32 UuidCreate void*>
	^self invalidCall: _failureCode!

uuidFromString: uuid uuid: lppstr
	"Converts a string to a UUID.

		RPC_STATUS RPC_ENTRY UuidFromString( 
			unsigned char*  StringUuid, 	
			UUID *  Uuid	
		);"

	<stdcall: errno UuidFromStringA char* void*>
	^self invalidCall: _failureCode!

uuidHash: uuid status: status
	"
		unsigned short RPC_ENTRY UuidHash( 
			UUID *  Uuid, 	
			RPC_STATUS *  Status	
		);"

	<stdcall: word UuidHash void* uint32*>
	^self invalidCall: _failureCode!

uuidToString: uuid stringUuid: lppstr
	"Converts a UUID to a string.
		RPC_STATUS RPC_ENTRY UuidToString( 
			UUID *  Uuid, 	
			unsigned char **  StringUuid	
		);"

	<stdcall: errno UuidToStringA void* char**>
	^self invalidCall: _failureCode! !

!OS.RPCLibrary categoriesForMethods!
invalidCall:!exceptions!private! !
rpcStringFree:!primitives!public!win32 functions-rpc! !
uuidCompare:uuid2:status:!primitives!public!win32 functions-rpc! !
uuidCreate:!primitives!public!win32 functions-rpc! !
uuidFromString:uuid:!primitives!public!win32 functions-rpc! !
uuidHash:status:!primitives!public!win32 functions-rpc! !
uuidToString:stringUuid:!primitives!public!win32 functions-rpc! !
!

!OS.RPCLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which the receiver represents"

	^'rpcrt4'!

sharedVariableName
	^#{OS.Rpcrt4}! !

!OS.RPCLibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

