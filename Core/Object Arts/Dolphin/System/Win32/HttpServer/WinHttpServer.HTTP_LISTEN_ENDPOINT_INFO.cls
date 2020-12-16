"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HTTP_PROPERTY_FLAGS subclass: #'WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_EnableSharing' -> 16r4
	}!
WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO guid: (Core.GUID fromString: '{c96f66fd-b678-4046-9100-ed4b4bc7c9fe}')!
WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO comment: '`HTTP_LISTEN_ENDPOINT_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Controls whether IP-based URLs should listen on the specific IP or wildcard."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(c96f66fd-b678-4046-9100-ed4b4bc7c9fe), helpstring("Controls whether IP-based URLs should listen on the specific IP or wildcard.")]
struct tagHTTP_LISTEN_ENDPOINT_INFO {
	HTTP_PROPERTY_FLAGS;
	BOOLEAN EnableSharing;
} HTTP_LISTEN_ENDPOINT_INFO;
```
'!
!WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO categoriesForClass!Win32-Structs! !
!WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO methodsFor!

EnableSharing
	"Answer the <Boolean> value of the receiver's 'EnableSharing' field."

	^(bytes byteAtOffset: _OffsetOf_EnableSharing) asBoolean!

EnableSharing: aBoolean
	"Set the receiver's 'EnableSharing' field to the value of the argument, aBoolean"

	bytes byteAtOffset: _OffsetOf_EnableSharing put: aBoolean asParameter! !
!WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO categoriesFor: #EnableSharing!**compiled accessors**!public! !
!WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO categoriesFor: #EnableSharing:!**compiled accessors**!public! !

!WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO class methodsFor!

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
	self byteSize: 8!

getFieldNames
	^#(#Present #EnableSharing)!

propertyId
	^HttpServerListenEndpointProperty! !
!WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!WinHttpServer.HTTP_LISTEN_ENDPOINT_INFO class categoriesFor: #propertyId!public! !

