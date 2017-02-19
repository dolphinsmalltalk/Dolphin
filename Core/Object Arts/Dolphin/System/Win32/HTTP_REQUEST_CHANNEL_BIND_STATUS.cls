"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_REQUEST_CHANNEL_BIND_STATUS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_REQUEST_CHANNEL_BIND_STATUS guid: (GUID fromString: '{2fc21c2a-e0c8-4c4c-a68f-e8270f8fbd2a}')!
HTTP_REQUEST_CHANNEL_BIND_STATUS comment: '<HTTP_REQUEST_CHANNEL_BIND_STATUS> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_REQUEST_CHANNEL_BIND_STATUS'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(2fc21c2a-e0c8-4c4c-a68f-e8270f8fbd2a)]
struct tagHTTP_REQUEST_CHANNEL_BIND_STATUS {
	[helpstring("The service name from the client. This is populated if the request''s Channel Binding Token (CBT) is not configured to retrieve service names.")] HTTP_SERVICE_BINDING_BASE* ServiceName;
	[helpstring("A pointer to a buffer that contains the secure channel endpoint binding."), size_is("ChannelTokenSize")] UCHAR* ChannelToken;
	[nonbrowsable, helpstring("The length of the ChannelToken buffer in bytes.")] ULONG ChannelTokenSize;
	[hidden, helpstring("Reserved.")] ULONG flags;
} HTTP_REQUEST_CHANNEL_BIND_STATUS;
'!
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesForClass!Win32-Structs! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS methodsFor!

ChannelToken
	"Answer the <ExternalArray> value of the receiver's 'ChannelToken' field."

	^ExternalArray fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #ChannelToken))
		length: self ChannelTokenSize!

ChannelToken: anExternalArray
	"Set the receiver's 'ChannelToken' field to the value of the argument, anExternalArray"

	bytes uintPtrAtOffset: ##(self offsetOf: #ChannelToken) put: anExternalArray yourAddress.
	self ChannelTokenSize: anExternalArray size!

ChannelTokenSize
	"Private - Answer the <Integer> value of the receiver's 'ChannelTokenSize' field."

	^bytes dwordAtOffset: ##(self offsetOf: #ChannelTokenSize)!

ChannelTokenSize: anInteger
	"Set the receiver's 'ChannelTokenSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #ChannelTokenSize) put: anInteger!

ServiceName
	"Answer the <HTTP_SERVICE_BINDING_BASE> value of the receiver's 'ServiceName' field."

	^HTTP_SERVICE_BINDING_BASE fromAddress: (bytes intPtrAtOffset: 0)!

ServiceName: aHTTP_SERVICE_BINDING_BASE
	"Set the receiver's 'ServiceName' field to the value of the argument, aHTTP_SERVICE_BINDING_BASE"

	bytes uintPtrAtOffset: 0 put: aHTTP_SERVICE_BINDING_BASE yourAddress! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelToken!**compiled accessors**!public! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelToken:!**compiled accessors**!public! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelTokenSize!**compiled accessors**!private! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelTokenSize:!**compiled accessors**!private! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ServiceName!**compiled accessors**!public! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ServiceName:!**compiled accessors**!public! !

!HTTP_REQUEST_CHANNEL_BIND_STATUS class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_CHANNEL_BIND_STATUS structure.

	HTTP_REQUEST_CHANNEL_BIND_STATUS compileDefinition

		typedef [uuid(2fc21c2a-e0c8-4c4c-a68f-e8270f8fbd2a)]
		struct tagHTTP_REQUEST_CHANNEL_BIND_STATUS {
			[helpstring('The service name from the client. This is populated if the request's Channel Binding Token (CBT) is not configured to retrieve service names.')] HTTP_SERVICE_BINDING_BASE* ServiceName;
			[helpstring('A pointer to a buffer that contains the secure channel endpoint binding.'), size_is('ChannelTokenSize')] UCHAR* ChannelToken;
			[nonbrowsable, helpstring('The length of the ChannelToken buffer in bytes.')] ULONG ChannelTokenSize;
			[hidden, helpstring('Reserved.')] ULONG flags;
		} HTTP_REQUEST_CHANNEL_BIND_STATUS;
"

	self
		defineField: #ServiceName type: (PointerField type: HTTP_SERVICE_BINDING_BASE) offset: 0;
		defineField: #ChannelToken type: (ArrayPointerField type: ExternalArray lengthField: #ChannelTokenSize) offset: 4;
		defineField: #ChannelTokenSize type: DWORDField new beNonBrowsable offset: 8;
		defineField: #flags type: DWORDField new beFiller offset: 12.
	self byteSize: 16! !
!HTTP_REQUEST_CHANNEL_BIND_STATUS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

