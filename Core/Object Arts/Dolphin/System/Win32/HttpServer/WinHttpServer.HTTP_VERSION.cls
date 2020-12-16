"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_VERSION'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_MajorVersion' -> 16r0.
		'_OffsetOf_MinorVersion' -> 16r2
	}!
WinHttpServer.HTTP_VERSION guid: (Core.GUID fromString: '{f6a0c406-b01a-4701-aa8c-d4c1a0d2b1a5}')!
WinHttpServer.HTTP_VERSION comment: '`HTTP_VERSION` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_VERSION'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"defines a version of the HTTP protocol that a request requires or a response provides."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(f6a0c406-b01a-4701-aa8c-d4c1a0d2b1a5), helpstring("defines a version of the HTTP protocol that a request requires or a response provides.")]
struct tagHTTP_VERSION {
	[readonly, helpstring("Major version of the HTTP protocol.")] USHORT MajorVersion;
	[readonly, helpstring("Minor version of the HTTP protocol.")] USHORT MinorVersion;
} HTTP_VERSION;
```
'!
!WinHttpServer.HTTP_VERSION categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_VERSION methodsFor!

MajorVersion
	"Answer the <Integer> value of the receiver's 'MajorVersion' field."

	^bytes wordAtOffset: _OffsetOf_MajorVersion!

MinorVersion
	"Answer the <Integer> value of the receiver's 'MinorVersion' field."

	^bytes wordAtOffset: _OffsetOf_MinorVersion!

printFields: aCollection on: aStream
	aStream
		print: self MajorVersion;
		nextPut: $.;
		print: self MinorVersion! !
!WinHttpServer.HTTP_VERSION categoriesFor: #MajorVersion!**compiled accessors**!public! !
!WinHttpServer.HTTP_VERSION categoriesFor: #MinorVersion!**compiled accessors**!public! !
!WinHttpServer.HTTP_VERSION categoriesFor: #printFields:on:!development!printing!private! !

!WinHttpServer.HTTP_VERSION class methodsFor!

defineFields
	"Define the fields of the HTTP_VERSION structure.

	HTTP_VERSION compileDefinition

		typedef [uuid(f6a0c406-b01a-4701-aa8c-d4c1a0d2b1a5), helpstring('defines a version of the HTTP protocol that a request requires or a response provides.')]
		struct tagHTTP_VERSION {
			[readonly, helpstring('Major version of the HTTP protocol.')] USHORT MajorVersion;
			[readonly, helpstring('Minor version of the HTTP protocol.')] USHORT MinorVersion;
		} HTTP_VERSION;
"

	self
		defineField: #MajorVersion type: WORDField new beReadOnly offset: 0;
		defineField: #MinorVersion type: WORDField new beReadOnly offset: 2.
	self byteSize: 4!

getFieldNames
	^#(#MajorVersion #MinorVersion)! !
!WinHttpServer.HTTP_VERSION class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_VERSION class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

