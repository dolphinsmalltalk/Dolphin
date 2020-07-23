"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_HEADERS
	instanceVariableNames: ''
	classVariableNames: 'HeaderToIndexMap'
	poolDictionaries: 'WinHttpServerConsts'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_pTrailers' -> 16rC.
		'_OffsetOf_pUnknownHeaders' -> 16r4.
		'_OffsetOf_TrailerCount' -> 16r8.
		'_OffsetOf_UnknownHeaderCount' -> 16r0
	}!
HTTP_HEADERS guid: (GUID fromString: '{739d04bb-0a15-47ea-8a7d-20b4fd31cc96}')!
HTTP_HEADERS isAbstract: true!
HTTP_HEADERS comment: '<HTTP_HEADERS> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_HEADERS'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Fields common to HTTP_REQUEST_HEADERS and HTTP_RESPONSE_HEADERS"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(739d04bb-0a15-47ea-8a7d-20b4fd31cc96), helpstring("Fields common to HTTP_REQUEST_HEADERS and HTTP_RESPONSE_HEADERS")]
struct tagHTTP_HEADERS {
	[nonbrowsable, helpstring("The number of entries in the UnknownHeaders array.")] USHORT UnknownHeaderCount;
	[helpstring("The array of unknown HTTP headers."), size_is("UnknownHeaderCount")] PHTTP_UNKNOWN_HEADER pUnknownHeaders;
	[hidden, nonbrowsable, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] USHORT TrailerCount;
	[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0), size_is("TrailerCount")] PHTTP_UNKNOWN_HEADER pTrailers;
} HTTP_HEADERS;
'!
!HTTP_HEADERS categoriesForClass!WinHttpServer-Structs! !
!HTTP_HEADERS methodsFor!

knownHeaderIndex: headerName
	^self class knownHeaderIndex: headerName!

knownHeaderName: anInteger
	^self class knownHeaderName: anInteger!

KnownHeaders
	^self subclassResponsibility!

printFieldsOn: aStream
	| first |
	self isNull
		ifTrue: 
			[aStream nextPutAll: 'NULL'.
			^self].
	first := true.
	self KnownHeaders keysAndValuesDo: 
			[:i :each |
			| value |
			value := each pRawValue.
			value isNil
				ifFalse: 
					[first ifTrue: [first := false] ifFalse: [aStream nextPutAll: ', '].
					aStream
						display: (self knownHeaderName: i - 1);
						nextPutAll: ': ';
						print: value]].
	self pUnknownHeaders do: 
			[:each |
			first ifTrue: [first := false] ifFalse: [aStream nextPutAll: ', '].
			aStream
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

	^bytes wordAtOffset: _OffsetOf_UnknownHeaderCount!

UnknownHeaderCount: anInteger
	"Set the receiver's 'UnknownHeaderCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_UnknownHeaderCount put: anInteger! !
!HTTP_HEADERS categoriesFor: #knownHeaderIndex:!constants!public! !
!HTTP_HEADERS categoriesFor: #knownHeaderName:!constants!public! !
!HTTP_HEADERS categoriesFor: #KnownHeaders!accessing!public! !
!HTTP_HEADERS categoriesFor: #printFieldsOn:!development!printing!private! !
!HTTP_HEADERS categoriesFor: #pUnknownHeaders!**compiled accessors**!public! !
!HTTP_HEADERS categoriesFor: #pUnknownHeaders:!**compiled accessors**!public! !
!HTTP_HEADERS categoriesFor: #UnknownHeaderCount!**compiled accessors**!private! !
!HTTP_HEADERS categoriesFor: #UnknownHeaderCount:!**compiled accessors**!private! !

!HTTP_HEADERS class methodsFor!

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
		defineField: #UnknownHeaderCount type: WORDField new beNonBrowsable offset: 0;
		defineField: #pUnknownHeaders type: (StructureArrayPointerField type: HTTP_UNKNOWN_HEADER lengthField: #UnknownHeaderCount) offset: 4;
		defineField: #TrailerCount type: WORDField new beNonBrowsable beFiller offset: 8;
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
!HTTP_HEADERS class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_HEADERS class categoriesFor: #headerToIndexMap!public! !
!HTTP_HEADERS class categoriesFor: #indexToHeaderMap!public! !
!HTTP_HEADERS class categoriesFor: #knownHeaderIndex:!public! !
!HTTP_HEADERS class categoriesFor: #knownHeaderName:!public! !

