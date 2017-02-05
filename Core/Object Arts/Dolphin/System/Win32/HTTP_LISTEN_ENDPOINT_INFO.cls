"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_LISTEN_ENDPOINT_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_LISTEN_ENDPOINT_INFO guid: (GUID fromString: '{C96F66FD-B678-4046-9100-ED4B4BC7C9FE}')!
HTTP_LISTEN_ENDPOINT_INFO comment: '<HTTP_LISTEN_ENDPOINT_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_LISTEN_ENDPOINT_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Controls whether IP-based URLs should listen on the specific IP or wildcard."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(C96F66FD-B678-4046-9100-ED4B4BC7C9FE), helpstring("Controls whether IP-based URLs should listen on the specific IP or wildcard.")]
struct tagHTTP_LISTEN_ENDPOINT_INFO {
	HTTP_PROPERTY_FLAGS flags;
	CHAR EnableSharing;
} HTTP_LISTEN_ENDPOINT_INFO;
'!
!HTTP_LISTEN_ENDPOINT_INFO categoriesForClass!Win32-Structs! !
!HTTP_LISTEN_ENDPOINT_INFO methodsFor!

EnableSharing
	"Answer the receiver's EnableSharing field as a Smalltalk object."

	^bytes sbyteAtOffset: ##(self offsetOf: #EnableSharing)!

EnableSharing: anObject
	"Set the receiver's EnableSharing field to the value of anObject."

	bytes sbyteAtOffset: ##(self offsetOf: #EnableSharing) put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!HTTP_LISTEN_ENDPOINT_INFO categoriesFor: #EnableSharing!**compiled accessors**!public! !
!HTTP_LISTEN_ENDPOINT_INFO categoriesFor: #EnableSharing:!**compiled accessors**!public! !
!HTTP_LISTEN_ENDPOINT_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_LISTEN_ENDPOINT_INFO categoriesFor: #flags:!**compiled accessors**!public! !

!HTTP_LISTEN_ENDPOINT_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_LISTEN_ENDPOINT_INFO structure.

	HTTP_LISTEN_ENDPOINT_INFO  compileDefinition

		typedef [uuid(C96F66FD-B678-4046-9100-ED4B4BC7C9FE), helpstring('Controls whether IP-based URLs should listen on the specific IP or wildcard.')]
		struct tagHTTP_LISTEN_ENDPOINT_INFO {
			HTTP_PROPERTY_FLAGS flags;
			CHAR EnableSharing;
		} HTTP_LISTEN_ENDPOINT_INFO;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #EnableSharing type: SBYTEField new offset: 4.
	self byteSize: 8! !
!HTTP_LISTEN_ENDPOINT_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

