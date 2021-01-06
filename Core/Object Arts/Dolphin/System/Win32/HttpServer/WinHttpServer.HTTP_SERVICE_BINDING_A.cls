"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HTTP_SERVICE_BINDING_BASE subclass: #'WinHttpServer.HTTP_SERVICE_BINDING_A'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Buffer' -> 16r4.
		'_OffsetOf_BufferSize' -> 16r8
	}!
WinHttpServer.HTTP_SERVICE_BINDING_A guid: (Core.GUID fromString: '{88ca7833-a66a-4e2f-98bc-cd2313254b15}')!
WinHttpServer.HTTP_SERVICE_BINDING_A comment: '`HTTP_SERVICE_BINDING_A` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_BINDING_A'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Provides Service Principle Name (SPN) in ASCII."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(88ca7833-a66a-4e2f-98bc-cd2313254b15), helpstring("Provides Service Principle Name (SPN) in ASCII.")]
struct tagHTTP_SERVICE_BINDING_A {
	HTTP_SERVICE_BINDING_BASE;
	[helpstring("A pointer to a buffer that represents the SPN."), size_is("BufferSize"), string] PCHAR Buffer;
	[nonbrowsable, helpstring("The length, in bytes, of the string in Buffer.")] ULONG BufferSize;
} HTTP_SERVICE_BINDING_A;
```
'!
!WinHttpServer.HTTP_SERVICE_BINDING_A categoriesForClass!Win32-Structs! !
!WinHttpServer.HTTP_SERVICE_BINDING_A methodsFor!

Buffer
	"Answer the <AnsiString> value of the receiver's 'Buffer' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_Buffer) length: self BufferSize!

Buffer: anAnsiString
	"Set the receiver's 'Buffer' field to the value of the argument, anAnsiString"

	bytes uintPtrAtOffset: _OffsetOf_Buffer put: anAnsiString yourAddress.
	self BufferSize: anAnsiString size!

BufferSize
	"Private - Answer the <Integer> value of the receiver's 'BufferSize' field."

	^bytes dwordAtOffset: _OffsetOf_BufferSize!

BufferSize: anInteger
	"Set the receiver's 'BufferSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_BufferSize put: anInteger! !
!WinHttpServer.HTTP_SERVICE_BINDING_A categoriesFor: #Buffer!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_BINDING_A categoriesFor: #Buffer:!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_BINDING_A categoriesFor: #BufferSize!**compiled accessors**!private! !
!WinHttpServer.HTTP_SERVICE_BINDING_A categoriesFor: #BufferSize:!**compiled accessors**!private! !

!WinHttpServer.HTTP_SERVICE_BINDING_A class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_BINDING_A structure.

	HTTP_SERVICE_BINDING_A compileDefinition

		typedef [uuid(88ca7833-a66a-4e2f-98bc-cd2313254b15), helpstring('Provides Service Principle Name (SPN) in ASCII.')]
		struct tagHTTP_SERVICE_BINDING_A {
			HTTP_SERVICE_BINDING_BASE;
			[helpstring('A pointer to a buffer that represents the SPN.'), size_is('BufferSize'), string] PCHAR Buffer;
			[nonbrowsable, helpstring('The length, in bytes, of the string in Buffer.')] ULONG BufferSize;
		} HTTP_SERVICE_BINDING_A;
"

	super defineFields.
	self
		defineField: #Buffer type: (ArrayPointerField type: AnsiString lengthField: #BufferSize) offset: 4;
		defineField: #BufferSize type: DWORDField new beNonBrowsable offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#Type #Buffer #BufferSize)! !
!WinHttpServer.HTTP_SERVICE_BINDING_A class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_SERVICE_BINDING_A class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

