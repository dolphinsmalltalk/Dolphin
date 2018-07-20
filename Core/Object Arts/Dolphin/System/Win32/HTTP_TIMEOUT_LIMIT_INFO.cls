"Filed out from Dolphin Smalltalk 7"!

HTTP_PROPERTY_FLAGS subclass: #HTTP_TIMEOUT_LIMIT_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_TIMEOUT_LIMIT_INFO guid: (GUID fromString: '{7dae0007-41d0-4925-b425-a14d837d56d0}')!
HTTP_TIMEOUT_LIMIT_INFO comment: '<HTTP_TIMEOUT_LIMIT_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_TIMEOUT_LIMIT_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"For manipulating application specific timeout settings. These timers run when there''s a request being processed on a connection and HTTPAPI has already associated the request with an application."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

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
'!
!HTTP_TIMEOUT_LIMIT_INFO categoriesForClass!Win32-Structs! !
!HTTP_TIMEOUT_LIMIT_INFO methodsFor!

DrainEntityBody
	"Answer the <Integer> value of the receiver's 'DrainEntityBody' field."

	^bytes wordAtOffset: ##(self offsetOf: #DrainEntityBody)!

DrainEntityBody: anInteger
	"Set the receiver's 'DrainEntityBody' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #DrainEntityBody) put: anInteger!

EntityBody
	"Answer the <Integer> value of the receiver's 'EntityBody' field."

	^bytes wordAtOffset: ##(self offsetOf: #EntityBody)!

EntityBody: anInteger
	"Set the receiver's 'EntityBody' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #EntityBody) put: anInteger!

HeaderWait
	"Answer the <Integer> value of the receiver's 'HeaderWait' field."

	^bytes wordAtOffset: ##(self offsetOf: #HeaderWait)!

HeaderWait: anInteger
	"Set the receiver's 'HeaderWait' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #HeaderWait) put: anInteger!

IdleConnection
	"Answer the <Integer> value of the receiver's 'IdleConnection' field."

	^bytes wordAtOffset: ##(self offsetOf: #IdleConnection)!

IdleConnection: anInteger
	"Set the receiver's 'IdleConnection' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #IdleConnection) put: anInteger!

MinSendRate
	"Answer the <Integer> value of the receiver's 'MinSendRate' field."

	^bytes dwordAtOffset: ##(self offsetOf: #MinSendRate)!

MinSendRate: anInteger
	"Set the receiver's 'MinSendRate' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #MinSendRate) put: anInteger!

RequestQueue
	"Answer the <Integer> value of the receiver's 'RequestQueue' field."

	^bytes wordAtOffset: ##(self offsetOf: #RequestQueue)!

RequestQueue: anInteger
	"Set the receiver's 'RequestQueue' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #RequestQueue) put: anInteger! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #DrainEntityBody!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #DrainEntityBody:!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #EntityBody!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #EntityBody:!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #HeaderWait!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #HeaderWait:!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #IdleConnection!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #IdleConnection:!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #MinSendRate!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #MinSendRate:!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #RequestQueue!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #RequestQueue:!**compiled accessors**!public! !

!HTTP_TIMEOUT_LIMIT_INFO class methodsFor!

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
		defineField: #EntityBody type: WORDField new offset: 4;
		defineField: #DrainEntityBody type: WORDField new offset: 6;
		defineField: #RequestQueue type: WORDField new offset: 8;
		defineField: #IdleConnection type: WORDField new offset: 10;
		defineField: #HeaderWait type: WORDField new offset: 12;
		defineField: #MinSendRate type: DWORDField new offset: 16.
	self byteSize: 20!

propertyId
	^HttpServerTimeoutsProperty! !
!HTTP_TIMEOUT_LIMIT_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!HTTP_TIMEOUT_LIMIT_INFO class categoriesFor: #propertyId!constants!public! !

