"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HTTP_REQUEST_V1 subclass: #'WinHttpServer.HTTP_REQUEST_V2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_pRequestInfo' -> 16r1D4.
		'_OffsetOf_RequestInfoCount' -> 16r1D0
	}!
WinHttpServer.HTTP_REQUEST_V2 guid: (Core.GUID fromString: '{5f3f936f-b824-47af-a69e-62dc4730010c}')!
WinHttpServer.HTTP_REQUEST_V2 comment: '`HTTP_REQUEST_V2` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_REQUEST_V2'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Represents an incoming HTTP request (N.B. this is the V2, Vista and later, structure)"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(5f3f936f-b824-47af-a69e-62dc4730010c), helpstring("Represents an incoming HTTP request (N.B. this is the V2, Vista and later, structure)")]
struct tagHTTP_REQUEST_V2 {
	HTTP_REQUEST_V1;
	[nonbrowsable, helpstring("The number of HTTP_REQUEST_INFO structures in the array pointed to by pRequestInfo.")] USHORT RequestInfoCount;
	[helpstring("A pointer to an array of HTTP_REQUEST_INFO structures that contains additional information about the request."), size_is("RequestInfoCount")] PHTTP_REQUEST_INFO pRequestInfo;
} HTTP_REQUEST_V2;
```
'!
!WinHttpServer.HTTP_REQUEST_V2 categoriesForClass!Win32-Structs! !
!WinHttpServer.HTTP_REQUEST_V2 methodsFor!

pRequestInfo
	"Answer the <StructureArray> value of the receiver's 'pRequestInfo' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_pRequestInfo)
		length: self RequestInfoCount
		elementClass: HTTP_REQUEST_INFO!

pRequestInfo: aStructureArray
	"Set the receiver's 'pRequestInfo' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: _OffsetOf_pRequestInfo put: aStructureArray yourAddress.
	self RequestInfoCount: aStructureArray size!

printableFields
	| printable |
	printable := super printableFields.
	self RequestInfoCount == 0 ifTrue: [printable remove: #pRequestInfo].
	^printable!

RequestInfoCount
	"Private - Answer the <Integer> value of the receiver's 'RequestInfoCount' field."

	^bytes wordAtOffset: _OffsetOf_RequestInfoCount!

RequestInfoCount: anInteger
	"Set the receiver's 'RequestInfoCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_RequestInfoCount put: anInteger! !
!WinHttpServer.HTTP_REQUEST_V2 categoriesFor: #pRequestInfo!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_V2 categoriesFor: #pRequestInfo:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_V2 categoriesFor: #printableFields!development!printing!private! !
!WinHttpServer.HTTP_REQUEST_V2 categoriesFor: #RequestInfoCount!**compiled accessors**!private! !
!WinHttpServer.HTTP_REQUEST_V2 categoriesFor: #RequestInfoCount:!**compiled accessors**!private! !

!WinHttpServer.HTTP_REQUEST_V2 class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_V2 structure.

	HTTP_REQUEST_V2 compileDefinition

		typedef [uuid(5f3f936f-b824-47af-a69e-62dc4730010c), helpstring('Represents an incoming HTTP request (N.B. this is the V2, Vista and later, structure)')]
		struct tagHTTP_REQUEST_V2 {
			HTTP_REQUEST_V1;
			[nonbrowsable, helpstring('The number of HTTP_REQUEST_INFO structures in the array pointed to by pRequestInfo.')] USHORT RequestInfoCount;
			[helpstring('A pointer to an array of HTTP_REQUEST_INFO structures that contains additional information about the request.'), size_is('RequestInfoCount')] PHTTP_REQUEST_INFO pRequestInfo;
		} HTTP_REQUEST_V2;
"

	super defineFields.
	self
		defineField: #RequestInfoCount type: WORDField new beNonBrowsable offset: 464;
		defineField: #pRequestInfo type: (StructureArrayPointerField type: HTTP_REQUEST_INFO lengthField: #RequestInfoCount) offset: 468.
	self byteSize: 472!

getFieldNames
	^#(#Flags #ConnectionId #RequestId #UrlContext #Version #Verb #UnknownVerbLength #RawUrlLength #pUnknownVerb #pRawUrl #CookedUrl #Address #Headers #BytesReceived #EntityChunkCount #pEntityChunks #RawConnectionId #pSslInfo #RequestInfoCount #pRequestInfo)! !
!WinHttpServer.HTTP_REQUEST_V2 class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_REQUEST_V2 class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

