"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HTTP_SERVICE_BINDING_BASE subclass: #'WinHttpServer.HTTP_SERVICE_BINDING_W'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Buffer' -> 16r4.
		'_OffsetOf_BufferSize' -> 16r8
	}!
WinHttpServer.HTTP_SERVICE_BINDING_W guid: (Core.GUID fromString: '{9cd42842-29b3-4e02-b9dc-306b51f0166d}')!
WinHttpServer.HTTP_SERVICE_BINDING_W comment: '`HTTP_SERVICE_BINDING_W` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_BINDING_W'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Provides Service Principle Name (SPN) in Unicode."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(9cd42842-29b3-4e02-b9dc-306b51f0166d), helpstring("Provides Service Principle Name (SPN) in Unicode.")]
struct tagHTTP_SERVICE_BINDING_W {
	HTTP_SERVICE_BINDING_BASE;
	[helpstring("A pointer to a buffer that represents the SPN."), size_is("BufferSize"), string] PWCHAR Buffer;
	[nonbrowsable, helpstring("The length, in bytes, of the string in Buffer.")] ULONG BufferSize;
} HTTP_SERVICE_BINDING_W;
```
'!
!WinHttpServer.HTTP_SERVICE_BINDING_W categoriesForClass!Win32-Structs! !
!WinHttpServer.HTTP_SERVICE_BINDING_W methodsFor!

Buffer
	"Answer the <Utf16String> value of the receiver's 'Buffer' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_Buffer) length: self BufferSize!

Buffer: anUtf16String
	"Set the receiver's 'Buffer' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_Buffer put: anUtf16String yourAddress.
	self BufferSize: anUtf16String size!

BufferSize
	"Private - Answer the <Integer> value of the receiver's 'BufferSize' field."

	^bytes dwordAtOffset: _OffsetOf_BufferSize!

BufferSize: anInteger
	"Set the receiver's 'BufferSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_BufferSize put: anInteger! !
!WinHttpServer.HTTP_SERVICE_BINDING_W categoriesFor: #Buffer!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_BINDING_W categoriesFor: #Buffer:!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_BINDING_W categoriesFor: #BufferSize!**compiled accessors**!private! !
!WinHttpServer.HTTP_SERVICE_BINDING_W categoriesFor: #BufferSize:!**compiled accessors**!private! !

!WinHttpServer.HTTP_SERVICE_BINDING_W class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_BINDING_W structure.

	HTTP_SERVICE_BINDING_W compileDefinition

		typedef [uuid(9cd42842-29b3-4e02-b9dc-306b51f0166d), helpstring('Provides Service Principle Name (SPN) in Unicode.')]
		struct tagHTTP_SERVICE_BINDING_W {
			HTTP_SERVICE_BINDING_BASE;
			[helpstring('A pointer to a buffer that represents the SPN.'), size_is('BufferSize'), string] PWCHAR Buffer;
			[nonbrowsable, helpstring('The length, in bytes, of the string in Buffer.')] ULONG BufferSize;
		} HTTP_SERVICE_BINDING_W;
"

	super defineFields.
	self
		defineField: #Buffer type: (ArrayPointerField type: Utf16String lengthField: #BufferSize) offset: 4;
		defineField: #BufferSize type: DWORDField new beNonBrowsable offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#Type #Buffer #BufferSize)! !
!WinHttpServer.HTTP_SERVICE_BINDING_W class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_SERVICE_BINDING_W class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

