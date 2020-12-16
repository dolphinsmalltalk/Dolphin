"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVICE_BINDING_BASE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WinHttpServerConsts'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Type' -> 16r0
	}!
HTTP_SERVICE_BINDING_BASE guid: (GUID fromString: '{80f84f87-9667-42d4-ace4-1004dfe14475}')!
HTTP_SERVICE_BINDING_BASE comment: '<HTTP_SERVICE_BINDING_BASE> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVICE_BINDING_BASE'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Common base for the HTTP_SERVICE_BINDING_A structure and the HTTP_SERVICE_BINDING_W structure."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(80f84f87-9667-42d4-ace4-1004dfe14475), helpstring("Common base for the HTTP_SERVICE_BINDING_A structure and the HTTP_SERVICE_BINDING_W structure.")]
struct tagHTTP_SERVICE_BINDING_BASE {
	[helpstring("Indicates whether the data is in ASCII or Unicode.")] HTTP_SERVICE_BINDING_TYPE Type;
} HTTP_SERVICE_BINDING_BASE;
'!
!HTTP_SERVICE_BINDING_BASE categoriesForClass!WinHttpServer-Structs! !
!HTTP_SERVICE_BINDING_BASE methodsFor!

Type
	"Answer the <Integer> value of the receiver's 'Type' field."

	^bytes sdwordAtOffset: _OffsetOf_Type!

Type: anInteger
	"Set the receiver's 'Type' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_Type put: anInteger! !
!HTTP_SERVICE_BINDING_BASE categoriesFor: #Type!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_BASE categoriesFor: #Type:!**compiled accessors**!public! !

!HTTP_SERVICE_BINDING_BASE class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_BINDING_BASE structure.

	HTTP_SERVICE_BINDING_BASE compileDefinition

		typedef [uuid(80f84f87-9667-42d4-ace4-1004dfe14475), helpstring('Common base for the HTTP_SERVICE_BINDING_A structure and the HTTP_SERVICE_BINDING_W structure.')]
		struct tagHTTP_SERVICE_BINDING_BASE {
			[helpstring('Indicates whether the data is in ASCII or Unicode.')] HTTP_SERVICE_BINDING_TYPE Type;
		} HTTP_SERVICE_BINDING_BASE;
"

	self
		defineField: #Type type: SDWORDField new offset: 0.
	self byteSize: 4!

fromAddress: anAddress
	| ptr |
	anAddress isNull ifTrue: [^nil].
	ptr := anAddress asExternalAddress.
	(##({self. HTTP_SERVICE_BINDING_W. HTTP_SERVICE_BINDING_A}) at: (ptr sdwordAtOffset: 0) + 1)
		basicNew initializeAtAddress: ptr!

getFieldNames
	^#(#Type)! !
!HTTP_SERVICE_BINDING_BASE class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_SERVICE_BINDING_BASE class categoriesFor: #fromAddress:!instance creation!public! !
!HTTP_SERVICE_BINDING_BASE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

