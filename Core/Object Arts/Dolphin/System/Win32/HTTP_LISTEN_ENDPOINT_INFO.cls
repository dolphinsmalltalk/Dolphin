"Filed out from Dolphin Smalltalk 7"!

HTTP_PROPERTY_FLAGS subclass: #HTTP_LISTEN_ENDPOINT_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_LISTEN_ENDPOINT_INFO guid: (GUID fromString: '{c96f66fd-b678-4046-9100-ed4b4bc7c9fe}')!
HTTP_LISTEN_ENDPOINT_INFO comment: '<HTTP_LISTEN_ENDPOINT_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Controls whether IP-based URLs should listen on the specific IP or wildcard."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(c96f66fd-b678-4046-9100-ed4b4bc7c9fe), helpstring("Controls whether IP-based URLs should listen on the specific IP or wildcard.")]
struct tagHTTP_LISTEN_ENDPOINT_INFO {
	HTTP_PROPERTY_FLAGS;
	BOOLEAN EnableSharing;
} HTTP_LISTEN_ENDPOINT_INFO;
'!
!HTTP_LISTEN_ENDPOINT_INFO categoriesForClass!Win32-Structs! !
!HTTP_LISTEN_ENDPOINT_INFO methodsFor!

EnableSharing
	"Answer the <Boolean> value of the receiver's 'EnableSharing' field."

	^(bytes byteAtOffset: ##(self offsetOf: #EnableSharing)) asBoolean!

EnableSharing: aBoolean
	"Set the receiver's 'EnableSharing' field to the value of the argument, aBoolean"

	bytes byteAtOffset: ##(self offsetOf: #EnableSharing) put: aBoolean asParameter! !
!HTTP_LISTEN_ENDPOINT_INFO categoriesFor: #EnableSharing!**compiled accessors**!public! !
!HTTP_LISTEN_ENDPOINT_INFO categoriesFor: #EnableSharing:!**compiled accessors**!public! !

!HTTP_LISTEN_ENDPOINT_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_LISTEN_ENDPOINT_INFO structure.

	HTTP_LISTEN_ENDPOINT_INFO compileDefinition

		typedef [uuid(c96f66fd-b678-4046-9100-ed4b4bc7c9fe), helpstring('Controls whether IP-based URLs should listen on the specific IP or wildcard.')]
		struct tagHTTP_LISTEN_ENDPOINT_INFO {
			HTTP_PROPERTY_FLAGS;
			BOOLEAN EnableSharing;
		} HTTP_LISTEN_ENDPOINT_INFO;
"

	super defineFields.
	self
		defineField: #EnableSharing type: BOOLEANField new offset: 4.
	self byteSize: 8! !
!HTTP_LISTEN_ENDPOINT_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

