"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ChannelToken' -> 16r4.
		'_OffsetOf_ChannelTokenSize' -> 16r8.
		'_OffsetOf_Flags' -> 16rC.
		'_OffsetOf_ServiceName' -> 16r0
	}!
WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS guid: (Core.GUID fromString: '{2fc21c2a-e0c8-4c4c-a68f-e8270f8fbd2a}')!
WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS comment: '`HTTP_REQUEST_CHANNEL_BIND_STATUS` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(2fc21c2a-e0c8-4c4c-a68f-e8270f8fbd2a)]
struct tagHTTP_REQUEST_CHANNEL_BIND_STATUS {
	[helpstring("The service name from the client. This is populated if the request''s Channel Binding Token (CBT) is not configured to retrieve service names.")] HTTP_SERVICE_BINDING_BASE* ServiceName;
	[helpstring("A pointer to a buffer that contains the secure channel endpoint binding."), size_is("ChannelTokenSize")] UCHAR* ChannelToken;
	[nonbrowsable, helpstring("The length of the ChannelToken buffer in bytes.")] ULONG ChannelTokenSize;
	[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] ULONG Flags;
} HTTP_REQUEST_CHANNEL_BIND_STATUS;
```
'!
!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS methodsFor!

ChannelToken
	"Answer the <ExternalArray> value of the receiver's 'ChannelToken' field."

	^ExternalArray fromAddress: (bytes intPtrAtOffset: _OffsetOf_ChannelToken)
		length: self ChannelTokenSize!

ChannelToken: anExternalArray
	"Set the receiver's 'ChannelToken' field to the value of the argument, anExternalArray"

	bytes uintPtrAtOffset: _OffsetOf_ChannelToken put: anExternalArray yourAddress.
	self ChannelTokenSize: anExternalArray size!

ChannelTokenSize
	"Private - Answer the <Integer> value of the receiver's 'ChannelTokenSize' field."

	^bytes dwordAtOffset: _OffsetOf_ChannelTokenSize!

ChannelTokenSize: anInteger
	"Set the receiver's 'ChannelTokenSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ChannelTokenSize put: anInteger!

ServiceName
	"Answer the <HTTP_SERVICE_BINDING_BASE> value of the receiver's 'ServiceName' field."

	^HTTP_SERVICE_BINDING_BASE fromAddress: (bytes intPtrAtOffset: _OffsetOf_ServiceName)!

ServiceName: aHTTP_SERVICE_BINDING_BASE
	"Set the receiver's 'ServiceName' field to the value of the argument, aHTTP_SERVICE_BINDING_BASE"

	bytes uintPtrAtOffset: _OffsetOf_ServiceName put: aHTTP_SERVICE_BINDING_BASE yourAddress! !
!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelToken!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelToken:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelTokenSize!**compiled accessors**!private! !
!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ChannelTokenSize:!**compiled accessors**!private! !
!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ServiceName!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS categoriesFor: #ServiceName:!**compiled accessors**!public! !

!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_CHANNEL_BIND_STATUS structure.

	HTTP_REQUEST_CHANNEL_BIND_STATUS compileDefinition

		typedef [uuid(2fc21c2a-e0c8-4c4c-a68f-e8270f8fbd2a)]
		struct tagHTTP_REQUEST_CHANNEL_BIND_STATUS {
			[helpstring('The service name from the client. This is populated if the request's Channel Binding Token (CBT) is not configured to retrieve service names.')] HTTP_SERVICE_BINDING_BASE* ServiceName;
			[helpstring('A pointer to a buffer that contains the secure channel endpoint binding.'), size_is('ChannelTokenSize')] UCHAR* ChannelToken;
			[nonbrowsable, helpstring('The length of the ChannelToken buffer in bytes.')] ULONG ChannelTokenSize;
			[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] ULONG Flags;
		} HTTP_REQUEST_CHANNEL_BIND_STATUS;
"

	self
		defineField: #ServiceName type: (PointerField type: HTTP_SERVICE_BINDING_BASE) offset: 0;
		defineField: #ChannelToken type: (ArrayPointerField type: ExternalArray lengthField: #ChannelTokenSize) offset: 4;
		defineField: #ChannelTokenSize type: DWORDField new beNonBrowsable offset: 8;
		defineField: #Flags type: DWORDField new beFiller offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#ServiceName #ChannelToken #ChannelTokenSize)! !
!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_REQUEST_CHANNEL_BIND_STATUS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

