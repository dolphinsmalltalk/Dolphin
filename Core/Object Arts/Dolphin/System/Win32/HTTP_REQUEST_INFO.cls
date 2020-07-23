"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_REQUEST_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_InfoLength' -> 16r4.
		'_OffsetOf_InfoType' -> 16r0.
		'_OffsetOf_pInfo' -> 16r8
	}!
HTTP_REQUEST_INFO guid: (GUID fromString: '{8c37d370-da00-4186-b515-ebe6b57d8cc6}')!
HTTP_REQUEST_INFO comment: '<HTTP_REQUEST_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_REQUEST_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(8c37d370-da00-4186-b515-ebe6b57d8cc6)]
struct tagHTTP_REQUEST_INFO {
	[nonbrowsable, helpstring("A member of the HTTP_REQUEST_INFO_TYPE enumeration specifying the type of information contained in this structure.")] HTTP_REQUEST_INFO_TYPE InfoType;
	[nonbrowsable, helpstring("The length, in bytes, of the pInfo member.")] ULONG InfoLength;
	[nonbrowsable, helpstring("The request info data"), size_is("InfoLength")] void* pInfo;
} HTTP_REQUEST_INFO;
'!
!HTTP_REQUEST_INFO categoriesForClass!WinHttpServer-Structs! !
!HTTP_REQUEST_INFO methodsFor!

info
	"Answer the appropriate type of struct to represent the information herein"

	| type |
	type := self InfoType.
	^(##({HTTP_REQUEST_AUTH_INFO.
		HTTP_REQUEST_CHANNEL_BIND_STATUS.
		HTTP_SSL_PROTOCOL_INFO.
		HTTP_REQUEST_TOKEN_BINDING_INFO}) at: type + 1)
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_pInfo)!

InfoLength
	"Private - Answer the <Integer> value of the receiver's 'InfoLength' field."

	^bytes dwordAtOffset: _OffsetOf_InfoLength!

InfoLength: anInteger
	"Set the receiver's 'InfoLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_InfoLength put: anInteger!

InfoType
	"Private - Answer the <Integer> value of the receiver's 'InfoType' field."

	^bytes sdwordAtOffset: _OffsetOf_InfoType!

InfoType: anInteger
	"Set the receiver's 'InfoType' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_InfoType put: anInteger!

pInfo
	"Private - Answer the <ExternalArray> value of the receiver's 'pInfo' field."

	^ExternalArray fromAddress: (bytes intPtrAtOffset: _OffsetOf_pInfo) length: self InfoLength!

pInfo: anExternalArray
	"Set the receiver's 'pInfo' field to the value of the argument, anExternalArray"

	bytes uintPtrAtOffset: _OffsetOf_pInfo put: anExternalArray yourAddress.
	self InfoLength: anExternalArray size!

printFields: aCollection on: aStream
	aStream print: self info! !
!HTTP_REQUEST_INFO categoriesFor: #info!accessing!public! !
!HTTP_REQUEST_INFO categoriesFor: #InfoLength!**compiled accessors**!private! !
!HTTP_REQUEST_INFO categoriesFor: #InfoLength:!**compiled accessors**!private! !
!HTTP_REQUEST_INFO categoriesFor: #InfoType!**compiled accessors**!private! !
!HTTP_REQUEST_INFO categoriesFor: #InfoType:!**compiled accessors**!private! !
!HTTP_REQUEST_INFO categoriesFor: #pInfo!**compiled accessors**!private! !
!HTTP_REQUEST_INFO categoriesFor: #pInfo:!**compiled accessors**!private! !
!HTTP_REQUEST_INFO categoriesFor: #printFields:on:!development!printing!private! !

!HTTP_REQUEST_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_INFO structure.

	HTTP_REQUEST_INFO compileDefinition

		typedef [uuid(8c37d370-da00-4186-b515-ebe6b57d8cc6)]
		struct tagHTTP_REQUEST_INFO {
			[nonbrowsable, helpstring('A member of the HTTP_REQUEST_INFO_TYPE enumeration specifying the type of information contained in this structure.')] HTTP_REQUEST_INFO_TYPE InfoType;
			[nonbrowsable, helpstring('The length, in bytes, of the pInfo member.')] ULONG InfoLength;
			[nonbrowsable, helpstring('The request info data'), size_is('InfoLength')] void* pInfo;
		} HTTP_REQUEST_INFO;
"

	self
		defineField: #InfoType type: SDWORDField new beNonBrowsable offset: 0;
		defineField: #InfoLength type: DWORDField new beNonBrowsable offset: 4;
		defineField: #pInfo type: (ArrayPointerField type: ExternalArray lengthField: #InfoLength) beNonBrowsable offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#InfoType #InfoLength #pInfo)! !
!HTTP_REQUEST_INFO class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_REQUEST_INFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

