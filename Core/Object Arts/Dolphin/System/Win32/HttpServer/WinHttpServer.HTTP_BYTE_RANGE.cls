"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_BYTE_RANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Length' -> 16r8.
		'_OffsetOf_StartingOffset' -> 16r0
	}!
WinHttpServer.HTTP_BYTE_RANGE guid: (Core.GUID fromString: '{3426318c-022f-4dd9-9e4e-a04febf70a10}')!
WinHttpServer.HTTP_BYTE_RANGE comment: '`HTTP_BYTE_RANGE` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_BYTE_RANGE'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This structure defines a file byte range. If the Length field is HTTP_BYTE_RANGE_TO_EOF then the remainder of the file (everything after StartingOffset) is sent."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(3426318c-022f-4dd9-9e4e-a04febf70a10), helpstring("This structure defines a file byte range. If the Length field is HTTP_BYTE_RANGE_TO_EOF then the remainder of the file (everything after StartingOffset) is sent.")]
struct tagHTTP_BYTE_RANGE {
	[helpstring("Starting offset of the byte range.")] ULARGE_INTEGER StartingOffset;
	[helpstring("Size, in bytes, of the range. If this member is HTTP_BYTE_RANGE_TO_EOF, the range extends from the starting offset to the end of the file or data block.")] ULARGE_INTEGER Length;
} HTTP_BYTE_RANGE;
```
'!
!WinHttpServer.HTTP_BYTE_RANGE categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_BYTE_RANGE methodsFor!

Length
	"Answer the <Integer> value of the receiver's 'Length' field."

	^bytes qwordAtOffset: _OffsetOf_Length!

Length: anInteger
	"Set the receiver's 'Length' field to the value of the argument, anInteger"

	bytes qwordAtOffset: _OffsetOf_Length put: anInteger!

StartingOffset
	"Answer the <Integer> value of the receiver's 'StartingOffset' field."

	^bytes qwordAtOffset: _OffsetOf_StartingOffset!

StartingOffset: anInteger
	"Set the receiver's 'StartingOffset' field to the value of the argument, anInteger"

	bytes qwordAtOffset: _OffsetOf_StartingOffset put: anInteger! !
!WinHttpServer.HTTP_BYTE_RANGE categoriesFor: #Length!**compiled accessors**!public! !
!WinHttpServer.HTTP_BYTE_RANGE categoriesFor: #Length:!**compiled accessors**!public! !
!WinHttpServer.HTTP_BYTE_RANGE categoriesFor: #StartingOffset!**compiled accessors**!public! !
!WinHttpServer.HTTP_BYTE_RANGE categoriesFor: #StartingOffset:!**compiled accessors**!public! !

!WinHttpServer.HTTP_BYTE_RANGE class methodsFor!

defineFields
	"Define the fields of the HTTP_BYTE_RANGE structure.

	HTTP_BYTE_RANGE compileDefinition

		typedef [uuid(3426318c-022f-4dd9-9e4e-a04febf70a10), helpstring('This structure defines a file byte range. If the Length field is HTTP_BYTE_RANGE_TO_EOF then the remainder of the file (everything after StartingOffset) is sent.')]
		struct tagHTTP_BYTE_RANGE {
			[helpstring('Starting offset of the byte range.')] ULARGE_INTEGER StartingOffset;
			[helpstring('Size, in bytes, of the range. If this member is HTTP_BYTE_RANGE_TO_EOF, the range extends from the starting offset to the end of the file or data block.')] ULARGE_INTEGER Length;
		} HTTP_BYTE_RANGE;
"

	self
		defineField: #StartingOffset type: QWORDField new offset: 0;
		defineField: #Length type: QWORDField new offset: 8.
	self byteSize: 16!

getFieldNames
	^#(#StartingOffset #Length)! !
!WinHttpServer.HTTP_BYTE_RANGE class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_BYTE_RANGE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

