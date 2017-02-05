"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_TIMEOUT_LIMIT_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_TIMEOUT_LIMIT_INFO guid: (GUID fromString: '{7DAE0007-41D0-4925-B425-A14D837D56D0}')!
HTTP_TIMEOUT_LIMIT_INFO comment: '<HTTP_TIMEOUT_LIMIT_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_TIMEOUT_LIMIT_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"For manipulating application specific timeout settings. These timers run when there''s a request being processed on a connection and HTTPAPI has already associated the request with an application."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7DAE0007-41D0-4925-B425-A14D837D56D0), helpstring("For manipulating application specific timeout settings. These timers run when there''s a request being processed on a connection and HTTPAPI has already associated the request with an application.")]
struct tagHTTP_TIMEOUT_LIMIT_INFO {
	[helpstring("Flags specifying which properties are present.")] HTTP_PROPERTY_FLAGS flags;
	[helpstring("The time, in seconds, allowed for the request entity body to arrive.")] unsigned short EntityBody;
	[helpstring("The time, in seconds, allowed for the HTTP Server API to drain the entity body on a Keep-Alive connection.")] unsigned short DrainEntityBody;
	[helpstring("The time, in seconds, allowed for the request to remain in the request queue before the application picks it up.")] unsigned short RequestQueue;
	[helpstring("The time, in seconds, allowed for an idle connection.")] unsigned short IdleConnection;
	[helpstring("The time, in seconds, allowed for the HTTP Server API to parse the request header.")] unsigned short HeaderWait;
	[helpstring("The minimum send rate, in bytes-per-second, for the response. The default response send rate is 150 bytes-per-second.")] unsigned long MinSendRate;
} HTTP_TIMEOUT_LIMIT_INFO;
'!
!HTTP_TIMEOUT_LIMIT_INFO categoriesForClass!Win32-Structs! !
!HTTP_TIMEOUT_LIMIT_INFO methodsFor!

DrainEntityBody
	"Answer the receiver's DrainEntityBody field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #DrainEntityBody)!

DrainEntityBody: anObject
	"Set the receiver's DrainEntityBody field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #DrainEntityBody) put: anObject!

EntityBody
	"Answer the receiver's EntityBody field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #EntityBody)!

EntityBody: anObject
	"Set the receiver's EntityBody field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #EntityBody) put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

HeaderWait
	"Answer the receiver's HeaderWait field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #HeaderWait)!

HeaderWait: anObject
	"Set the receiver's HeaderWait field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #HeaderWait) put: anObject!

IdleConnection
	"Answer the receiver's IdleConnection field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #IdleConnection)!

IdleConnection: anObject
	"Set the receiver's IdleConnection field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #IdleConnection) put: anObject!

MinSendRate
	"Answer the receiver's MinSendRate field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #MinSendRate)!

MinSendRate: anObject
	"Set the receiver's MinSendRate field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #MinSendRate) put: anObject!

RequestQueue
	"Answer the receiver's RequestQueue field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #RequestQueue)!

RequestQueue: anObject
	"Set the receiver's RequestQueue field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #RequestQueue) put: anObject! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #DrainEntityBody!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #DrainEntityBody:!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #EntityBody!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #EntityBody:!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_TIMEOUT_LIMIT_INFO categoriesFor: #flags:!**compiled accessors**!public! !
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

	HTTP_TIMEOUT_LIMIT_INFO  compileDefinition

		typedef [uuid(7DAE0007-41D0-4925-B425-A14D837D56D0), helpstring('For manipulating application specific timeout settings. These timers run when there's a request being processed on a connection and HTTPAPI has already associated the request with an application.')]
		struct tagHTTP_TIMEOUT_LIMIT_INFO {
			[helpstring('Flags specifying which properties are present.')] HTTP_PROPERTY_FLAGS flags;
			[helpstring('The time, in seconds, allowed for the request entity body to arrive.')] unsigned short EntityBody;
			[helpstring('The time, in seconds, allowed for the HTTP Server API to drain the entity body on a Keep-Alive connection.')] unsigned short DrainEntityBody;
			[helpstring('The time, in seconds, allowed for the request to remain in the request queue before the application picks it up.')] unsigned short RequestQueue;
			[helpstring('The time, in seconds, allowed for an idle connection.')] unsigned short IdleConnection;
			[helpstring('The time, in seconds, allowed for the HTTP Server API to parse the request header.')] unsigned short HeaderWait;
			[helpstring('The minimum send rate, in bytes-per-second, for the response. The default response send rate is 150 bytes-per-second.')] unsigned long MinSendRate;
		} HTTP_TIMEOUT_LIMIT_INFO;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #EntityBody type: WORDField new offset: 4;
		defineField: #DrainEntityBody type: WORDField new offset: 6;
		defineField: #RequestQueue type: WORDField new offset: 8;
		defineField: #IdleConnection type: WORDField new offset: 10;
		defineField: #HeaderWait type: WORDField new offset: 12;
		defineField: #MinSendRate type: DWORDField new offset: 16.
	self byteSize: 20! !
!HTTP_TIMEOUT_LIMIT_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

