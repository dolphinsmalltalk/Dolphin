"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_RESPONSE_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_HTTP_RESPONSE_INFO_Size' -> 16rC.
		'_OffsetOf_Length' -> 16r4.
		'_OffsetOf_pInfo' -> 16r8.
		'_OffsetOf_Type' -> 16r0
	}!
WinHttpServer.HTTP_RESPONSE_INFO guid: (Core.GUID fromString: '{cdf58c2c-140f-4611-b847-12837ce3155f}')!
WinHttpServer.HTTP_RESPONSE_INFO comment: '`HTTP_RESPONSE_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_RESPONSE_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(cdf58c2c-140f-4611-b847-12837ce3155f)]
struct tagHTTP_RESPONSE_INFO {
	[nonbrowsable, helpstring("A member of the HTTP_RESPONSE_INFO_TYPE enumeration specifying the type of information contained in this structure.")] HTTP_RESPONSE_INFO_TYPE Type;
	[nonbrowsable, helpstring("Length in bytes of the data pointed at by pInfo.")] ULONG Length;
	[nonbrowsable, helpstring("Response information data"), size_is("Length")] PVOID pInfo;
} HTTP_RESPONSE_INFO;
```
'!
!WinHttpServer.HTTP_RESPONSE_INFO categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_RESPONSE_INFO methodsFor!

info
	"Answer the appropriate type of struct to represent the information herein"

	"HttpResponseInfoType*"

	| type |
	type := self Type.
	^(##({HTTP_MULTIPLE_KNOWN_HEADERS. nil. HTTP_QOS_SETTING_INFO. HTTP_CHANNEL_BIND_INFO}) at: type + 1)
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_pInfo)	""!

Length
	"Private - Answer the <Integer> value of the receiver's 'Length' field."

	^bytes uint32AtOffset: _OffsetOf_Length!

Length: anInteger
	"Set the receiver's 'Length' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Length put: anInteger!

pInfo
	"Private - Answer the <ExternalArray> value of the receiver's 'pInfo' field."

	^ExternalArray fromAddress: (bytes intPtrAtOffset: _OffsetOf_pInfo) length: self Length!

pInfo: anExternalArray
	"Set the receiver's 'pInfo' field to the value of the argument, anExternalArray"

	bytes uintPtrAtOffset: _OffsetOf_pInfo put: anExternalArray yourAddress.
	self Length: anExternalArray size!

printFields: aCollection on: aStream
	aStream print: self info!

Type
	"Private - Answer the <Integer> value of the receiver's 'Type' field."

	^bytes int32AtOffset: _OffsetOf_Type!

Type: anInteger
	"Set the receiver's 'Type' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_Type put: anInteger! !
!WinHttpServer.HTTP_RESPONSE_INFO categoriesForMethods!
info!accessing!public! !
Length!**compiled accessors**!private! !
Length:!**compiled accessors**!private! !
pInfo!**compiled accessors**!private! !
pInfo:!**compiled accessors**!private! !
printFields:on:!development!printing!private! !
Type!**compiled accessors**!private! !
Type:!**compiled accessors**!private! !
!

!WinHttpServer.HTTP_RESPONSE_INFO class methodsFor!

byteSize
	^_HTTP_RESPONSE_INFO_Size!

defineFields
	"Define the fields of the HTTP_RESPONSE_INFO structure.

	HTTP_RESPONSE_INFO compileDefinition

		typedef [uuid(cdf58c2c-140f-4611-b847-12837ce3155f)]
		struct tagHTTP_RESPONSE_INFO {
			[nonbrowsable, helpstring('A member of the HTTP_RESPONSE_INFO_TYPE enumeration specifying the type of information contained in this structure.')] HTTP_RESPONSE_INFO_TYPE Type;
			[nonbrowsable, helpstring('Length in bytes of the data pointed at by pInfo.')] ULONG Length;
			[nonbrowsable, helpstring('Response information data'), size_is('Length')] PVOID pInfo;
		} HTTP_RESPONSE_INFO;
"

	self
		defineField: #Type type: Int32Field new beNonBrowsable offset: 0;
		defineField: #Length type: UInt32Field new beNonBrowsable offset: 4;
		defineField: #pInfo type: (ArrayPointerField type: ExternalArray lengthField: #Length) beNonBrowsable offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#Type #Length #pInfo)! !
!WinHttpServer.HTTP_RESPONSE_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

