﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HTTP_PROPERTY_FLAGS
	subclass: #'WinHttpServer.HTTP_TIMEOUT_LIMIT_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_TIMEOUT_LIMIT_INFO_Size' -> 16r14.
			'_OffsetOf_DrainEntityBody' -> 16r6.
			'_OffsetOf_EntityBody' -> 16r4.
			'_OffsetOf_HeaderWait' -> 16rC.
			'_OffsetOf_IdleConnection' -> 16rA.
			'_OffsetOf_MinSendRate' -> 16r10.
			'_OffsetOf_RequestQueue' -> 16r8
		}!

WinHttpServer.HTTP_TIMEOUT_LIMIT_INFO guid: (Core.GUID fromString: '{7dae0007-41d0-4925-b425-a14d837d56d0}')!

WinHttpServer.HTTP_TIMEOUT_LIMIT_INFO comment: '`HTTP_TIMEOUT_LIMIT_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_TIMEOUT_LIMIT_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"For manipulating application specific timeout settings. These timers run when there''s a request being processed on a connection and HTTPAPI has already associated the request with an application."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(7dae0007-41d0-4925-b425-a14d837d56d0), helpstring("For manipulating application specific timeout settings. These timers run when there''s a request being processed on a connection and HTTPAPI has already associated the request with an application.")]
struct tagHTTP_TIMEOUT_LIMIT_INFO {
	[helpstring("Flags specifying which properties are present.")] HTTP_PROPERTY_FLAGS;
	[helpstring("The time, in seconds, allowed for the request entity body to arrive.")] USHORT EntityBody;
	[helpstring("The time, in seconds, allowed for the HTTP Server API to drain the entity body on a Keep-Alive connection.")] USHORT DrainEntityBody;
	[helpstring("The time, in seconds, allowed for the request to remain in the request queue before the application picks it up.")] USHORT RequestQueue;
	[helpstring("The time, in seconds, allowed for an idle connection.")] USHORT IdleConnection;
	[helpstring("The time, in seconds, allowed for the HTTP Server API to parse the request header.")] USHORT HeaderWait;
	[helpstring("The minimum send rate, in bytes-per-second, for the response. The default response send rate is 150 bytes-per-second.")] ULONG MinSendRate;
} HTTP_TIMEOUT_LIMIT_INFO;
```
'!

!WinHttpServer.HTTP_TIMEOUT_LIMIT_INFO categoriesForClass!Win32-Structs! !

!WinHttpServer.HTTP_TIMEOUT_LIMIT_INFO methodsFor!

DrainEntityBody
	"Answer the <Integer> value of the receiver's 'DrainEntityBody' field."

	^bytes uint16AtOffset: _OffsetOf_DrainEntityBody!

DrainEntityBody: anInteger
	"Set the receiver's 'DrainEntityBody' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_DrainEntityBody put: anInteger!

EntityBody
	"Answer the <Integer> value of the receiver's 'EntityBody' field."

	^bytes uint16AtOffset: _OffsetOf_EntityBody!

EntityBody: anInteger
	"Set the receiver's 'EntityBody' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_EntityBody put: anInteger!

HeaderWait
	"Answer the <Integer> value of the receiver's 'HeaderWait' field."

	^bytes uint16AtOffset: _OffsetOf_HeaderWait!

HeaderWait: anInteger
	"Set the receiver's 'HeaderWait' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_HeaderWait put: anInteger!

IdleConnection
	"Answer the <Integer> value of the receiver's 'IdleConnection' field."

	^bytes uint16AtOffset: _OffsetOf_IdleConnection!

IdleConnection: anInteger
	"Set the receiver's 'IdleConnection' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_IdleConnection put: anInteger!

MinSendRate
	"Answer the <Integer> value of the receiver's 'MinSendRate' field."

	^bytes uint32AtOffset: _OffsetOf_MinSendRate!

MinSendRate: anInteger
	"Set the receiver's 'MinSendRate' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_MinSendRate put: anInteger!

RequestQueue
	"Answer the <Integer> value of the receiver's 'RequestQueue' field."

	^bytes uint16AtOffset: _OffsetOf_RequestQueue!

RequestQueue: anInteger
	"Set the receiver's 'RequestQueue' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_RequestQueue put: anInteger! !

!WinHttpServer.HTTP_TIMEOUT_LIMIT_INFO categoriesForMethods!
DrainEntityBody!**compiled accessors**!public! !
DrainEntityBody:!**compiled accessors**!public! !
EntityBody!**compiled accessors**!public! !
EntityBody:!**compiled accessors**!public! !
HeaderWait!**compiled accessors**!public! !
HeaderWait:!**compiled accessors**!public! !
IdleConnection!**compiled accessors**!public! !
IdleConnection:!**compiled accessors**!public! !
MinSendRate!**compiled accessors**!public! !
MinSendRate:!**compiled accessors**!public! !
RequestQueue!**compiled accessors**!public! !
RequestQueue:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_TIMEOUT_LIMIT_INFO class methodsFor!

byteSize
	^_HTTP_TIMEOUT_LIMIT_INFO_Size!

defineFields
	"Define the fields of the HTTP_TIMEOUT_LIMIT_INFO structure.

	HTTP_TIMEOUT_LIMIT_INFO compileDefinition

		typedef [uuid(7dae0007-41d0-4925-b425-a14d837d56d0), helpstring('For manipulating application specific timeout settings. These timers run when there's a request being processed on a connection and HTTPAPI has already associated the request with an application.')]
		struct tagHTTP_TIMEOUT_LIMIT_INFO {
			[helpstring('Flags specifying which properties are present.')] HTTP_PROPERTY_FLAGS;
			[helpstring('The time, in seconds, allowed for the request entity body to arrive.')] USHORT EntityBody;
			[helpstring('The time, in seconds, allowed for the HTTP Server API to drain the entity body on a Keep-Alive connection.')] USHORT DrainEntityBody;
			[helpstring('The time, in seconds, allowed for the request to remain in the request queue before the application picks it up.')] USHORT RequestQueue;
			[helpstring('The time, in seconds, allowed for an idle connection.')] USHORT IdleConnection;
			[helpstring('The time, in seconds, allowed for the HTTP Server API to parse the request header.')] USHORT HeaderWait;
			[helpstring('The minimum send rate, in bytes-per-second, for the response. The default response send rate is 150 bytes-per-second.')] ULONG MinSendRate;
		} HTTP_TIMEOUT_LIMIT_INFO;
"

	super defineFields.
	self
		defineField: #EntityBody type: UInt16Field new offset: 4;
		defineField: #DrainEntityBody type: UInt16Field new offset: 6;
		defineField: #RequestQueue type: UInt16Field new offset: 8;
		defineField: #IdleConnection type: UInt16Field new offset: 10;
		defineField: #HeaderWait type: UInt16Field new offset: 12;
		defineField: #MinSendRate type: UInt32Field new offset: 16.
	self byteSize: 20!

getFieldNames
	^#(#Present #EntityBody #DrainEntityBody #RequestQueue #IdleConnection #HeaderWait #MinSendRate)!

propertyId
	^HttpServerTimeoutsProperty! !

!WinHttpServer.HTTP_TIMEOUT_LIMIT_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
propertyId!constants!public! !
!

