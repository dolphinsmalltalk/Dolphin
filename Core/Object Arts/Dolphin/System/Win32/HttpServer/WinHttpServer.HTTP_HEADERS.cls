﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_HEADERS'
	instanceVariableNames: ''
	classVariableNames: 'HeaderToIndexMap'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_pTrailers' -> 16rC.
			'_OffsetOf_pUnknownHeaders' -> 16r4.
			'_OffsetOf_TrailerCount' -> 16r8.
			'_OffsetOf_UnknownHeaderCount' -> 16r0
		}!

WinHttpServer.HTTP_HEADERS guid: (Core.GUID fromString: '{739d04bb-0a15-47ea-8a7d-20b4fd31cc96}')!

WinHttpServer.HTTP_HEADERS isNonInstantiable: true!

WinHttpServer.HTTP_HEADERS comment: '`HTTP_HEADERS` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_HEADERS'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Fields common to HTTP_REQUEST_HEADERS and HTTP_RESPONSE_HEADERS"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(739d04bb-0a15-47ea-8a7d-20b4fd31cc96), helpstring("Fields common to HTTP_REQUEST_HEADERS and HTTP_RESPONSE_HEADERS")]
struct tagHTTP_HEADERS {
	[nonbrowsable, helpstring("The number of entries in the UnknownHeaders array.")] USHORT UnknownHeaderCount;
	[helpstring("The array of unknown HTTP headers."), size_is("UnknownHeaderCount")] PHTTP_UNKNOWN_HEADER pUnknownHeaders;
	[hidden, nonbrowsable, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] USHORT TrailerCount;
	[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0), size_is("TrailerCount")] PHTTP_UNKNOWN_HEADER pTrailers;
} HTTP_HEADERS;
```
'!

!WinHttpServer.HTTP_HEADERS categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_HEADERS methodsFor!

knownHeaderIndex: headerName
	^self class knownHeaderIndex: headerName!

knownHeaderName: anInteger
	^self class knownHeaderName: anInteger!

KnownHeaders
	^self subclassResponsibility!

printFieldsOn: aStream
	| separator |
	self isNull
		ifTrue: 
			[aStream nextPutAll: 'NULL'.
			^self].
	separator := [separator := ', '. ''].
	self KnownHeaders keysAndValuesDo: 
			[:i :each |
			| value |
			value := each pRawValue.
			value isNil
				ifFalse: 
					[
					aStream
						nextPutAll: separator value;
						display: (self knownHeaderName: i - 1);
						nextPutAll: ': ';
						print: value]].
	self pUnknownHeaders do: 
			[:each |
			aStream
				nextPutAll: separator value;
				display: each pName;
				nextPutAll: ': ';
				print: each pRawValue]!

pUnknownHeaders
	"Answer the <StructureArray> value of the receiver's 'pUnknownHeaders' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_pUnknownHeaders)
		length: self UnknownHeaderCount
		elementClass: HTTP_UNKNOWN_HEADER!

pUnknownHeaders: aStructureArray
	"Set the receiver's 'pUnknownHeaders' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: _OffsetOf_pUnknownHeaders put: aStructureArray yourAddress.
	self UnknownHeaderCount: aStructureArray size!

UnknownHeaderCount
	"Private - Answer the <Integer> value of the receiver's 'UnknownHeaderCount' field."

	^bytes uint16AtOffset: _OffsetOf_UnknownHeaderCount!

UnknownHeaderCount: anInteger
	"Set the receiver's 'UnknownHeaderCount' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_UnknownHeaderCount put: anInteger! !

!WinHttpServer.HTTP_HEADERS categoriesForMethods!
knownHeaderIndex:!constants!public! !
knownHeaderName:!constants!public! !
KnownHeaders!accessing!public! !
printFieldsOn:!development!printing!private! !
pUnknownHeaders!**compiled accessors**!public! !
pUnknownHeaders:!**compiled accessors**!public! !
UnknownHeaderCount!**compiled accessors**!private! !
UnknownHeaderCount:!**compiled accessors**!private! !
!

!WinHttpServer.HTTP_HEADERS class methodsFor!

defineFields
	"Define the fields of the HTTP_HEADERS structure.

	HTTP_HEADERS compileDefinition

		typedef [uuid(739d04bb-0a15-47ea-8a7d-20b4fd31cc96), helpstring('Fields common to HTTP_REQUEST_HEADERS and HTTP_RESPONSE_HEADERS')]
		struct tagHTTP_HEADERS {
			[nonbrowsable, helpstring('The number of entries in the UnknownHeaders array.')] USHORT UnknownHeaderCount;
			[helpstring('The array of unknown HTTP headers.'), size_is('UnknownHeaderCount')] PHTTP_UNKNOWN_HEADER pUnknownHeaders;
			[hidden, nonbrowsable, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] USHORT TrailerCount;
			[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0), size_is('TrailerCount')] PHTTP_UNKNOWN_HEADER pTrailers;
		} HTTP_HEADERS;
"

	self
		defineField: #UnknownHeaderCount type: UInt16Field new beNonBrowsable offset: 0;
		defineField: #pUnknownHeaders type: (StructureArrayPointerField type: HTTP_UNKNOWN_HEADER lengthField: #UnknownHeaderCount) offset: 4;
		defineField: #TrailerCount type: UInt16Field new beNonBrowsable beFiller offset: 8;
		defineField: #pTrailers type: (StructureArrayPointerField type: HTTP_UNKNOWN_HEADER lengthField: #TrailerCount) beFiller offset: 12.
	self byteSize: 16!

headerToIndexMap
	"This method is compiled before than its subclasses counterparts so cannot be precompiled."

	HeaderToIndexMap
		ifNil: 
			[HeaderToIndexMap := self subclasses inject: LookupTable new
						into: 
							[:table :class |
							table
								addAll: (class indexToHeaderMap associations collect: [:assoc | assoc value -> assoc key]);
								yourself]].
	^HeaderToIndexMap!

indexToHeaderMap
	^self subclassResponsibility!

knownHeaderIndex: headerName
	^self headerToIndexMap at: headerName!

knownHeaderName: anInteger
	^self indexToHeaderMap at: anInteger! !

!WinHttpServer.HTTP_HEADERS class categoriesForMethods!
defineFields!**auto generated**!private!template definition! !
headerToIndexMap!public! !
indexToHeaderMap!public! !
knownHeaderIndex:!public! !
knownHeaderName:!public! !
!

