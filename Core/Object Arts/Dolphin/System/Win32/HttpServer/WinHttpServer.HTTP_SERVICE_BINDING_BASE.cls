"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_SERVICE_BINDING_BASE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_HTTP_SERVICE_BINDING_BASE_Size' -> 16r4. '_OffsetOf_Type' -> 16r0 }!

WinHttpServer.HTTP_SERVICE_BINDING_BASE guid: (Core.GUID fromString: '{80f84f87-9667-42d4-ace4-1004dfe14475}')!

WinHttpServer.HTTP_SERVICE_BINDING_BASE comment: '`HTTP_SERVICE_BINDING_BASE` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_BINDING_BASE'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Common base for the HTTP_SERVICE_BINDING_A structure and the HTTP_SERVICE_BINDING_W structure."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(80f84f87-9667-42d4-ace4-1004dfe14475), helpstring("Common base for the HTTP_SERVICE_BINDING_A structure and the HTTP_SERVICE_BINDING_W structure.")]
struct tagHTTP_SERVICE_BINDING_BASE {
	[helpstring("Indicates whether the data is in ASCII or Unicode.")] HTTP_SERVICE_BINDING_TYPE Type;
} HTTP_SERVICE_BINDING_BASE;
```
'!

!WinHttpServer.HTTP_SERVICE_BINDING_BASE categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_SERVICE_BINDING_BASE methodsFor!

Type
	"Answer the <Integer> value of the receiver's 'Type' field."

	^bytes int32AtOffset: _OffsetOf_Type!

Type: anInteger
	"Set the receiver's 'Type' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_Type put: anInteger! !

!WinHttpServer.HTTP_SERVICE_BINDING_BASE categoriesForMethods!
Type!**compiled accessors**!public! !
Type:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_SERVICE_BINDING_BASE class methodsFor!

byteSize
	^_HTTP_SERVICE_BINDING_BASE_Size!

defineFields
	"Define the fields of the HTTP_SERVICE_BINDING_BASE structure.

	HTTP_SERVICE_BINDING_BASE compileDefinition

		typedef [uuid(80f84f87-9667-42d4-ace4-1004dfe14475), helpstring('Common base for the HTTP_SERVICE_BINDING_A structure and the HTTP_SERVICE_BINDING_W structure.')]
		struct tagHTTP_SERVICE_BINDING_BASE {
			[helpstring('Indicates whether the data is in ASCII or Unicode.')] HTTP_SERVICE_BINDING_TYPE Type;
		} HTTP_SERVICE_BINDING_BASE;
"

	self
		defineField: #Type type: Int32Field new offset: 0.
	self byteSize: 4!

fromAddress: anAddress
	| ptr |
	anAddress isNull ifTrue: [^nil].
	ptr := anAddress asExternalAddress.
	(##({self. HTTP_SERVICE_BINDING_W. HTTP_SERVICE_BINDING_A}) at: (ptr int32AtOffset: 0) + 1)
		basicNew initializeAtAddress: ptr!

getFieldNames
	^#(#Type)! !

!WinHttpServer.HTTP_SERVICE_BINDING_BASE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
fromAddress:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

