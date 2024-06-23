"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_CHANNEL_BIND_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_CHANNEL_BIND_INFO_Size' -> 16r10.
			'_OffsetOf_Flags' -> 16r4.
			'_OffsetOf_Hardening' -> 16r0.
			'_OffsetOf_NumberOfServiceNames' -> 16rC.
			'_OffsetOf_ServiceNames' -> 16r8
		}!

WinHttpServer.HTTP_CHANNEL_BIND_INFO guid: (Core.GUID fromString: '{84ea1900-0bc6-4ac8-9025-7f74436d5dc9}')!

WinHttpServer.HTTP_CHANNEL_BIND_INFO comment: '`HTTP_CHANNEL_BIND_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_CHANNEL_BIND_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"The HTTP_CHANNEL_BIND_INFO structure is used to set or query channel bind authentication."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(84ea1900-0bc6-4ac8-9025-7f74436d5dc9), helpstring("The HTTP_CHANNEL_BIND_INFO structure is used to set or query channel bind authentication.")]
struct tagHTTP_CHANNEL_BIND_INFO {
	[helpstring(" HTTP_AUTHENTICATION_HARDENING_LEVELS value indicating the hardening level levels to be set or queried per server session or URL group.")] HTTP_AUTHENTICATION_HARDENING_LEVELS Hardening;
	[helpstring("Flags from the HTTP_CHANNEL_BIND_* enumeration that determine the behaviour of authentication.")] ULONG Flags;
	[helpstring("Pointer to a buffer holding an array of 1 or more service names. Each service name is represented by either an HTTP_SERVICE_BINDING_A structure or an HTTP_SERVICE_BINDING_W structure, dependent upon whether the name is ASCII or Unicode."), size_is("NumberOfServiceNames")] HTTP_SERVICE_BINDING_BASE* ServiceNames;
	[nonbrowsable, helpstring("The number of names in ServiceNames.")] ULONG NumberOfServiceNames;
} HTTP_CHANNEL_BIND_INFO;
```
'!

!WinHttpServer.HTTP_CHANNEL_BIND_INFO categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_CHANNEL_BIND_INFO methodsFor!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes uint32AtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Flags put: anInteger!

Hardening
	"Answer the <Integer> value of the receiver's 'Hardening' field."

	^bytes int32AtOffset: _OffsetOf_Hardening!

Hardening: anInteger
	"Set the receiver's 'Hardening' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_Hardening put: anInteger!

NumberOfServiceNames
	"Private - Answer the <Integer> value of the receiver's 'NumberOfServiceNames' field."

	^bytes uint32AtOffset: _OffsetOf_NumberOfServiceNames!

NumberOfServiceNames: anInteger
	"Set the receiver's 'NumberOfServiceNames' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_NumberOfServiceNames put: anInteger!

ServiceNames
	"Answer the <StructureArray> value of the receiver's 'ServiceNames' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_ServiceNames)
		length: self NumberOfServiceNames
		elementClass: HTTP_SERVICE_BINDING_BASE!

ServiceNames: aStructureArray
	"Set the receiver's 'ServiceNames' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: _OffsetOf_ServiceNames put: aStructureArray yourAddress.
	self NumberOfServiceNames: aStructureArray size! !

!WinHttpServer.HTTP_CHANNEL_BIND_INFO categoriesForMethods!
Flags!**compiled accessors**!public! !
Flags:!**compiled accessors**!public! !
Hardening!**compiled accessors**!public! !
Hardening:!**compiled accessors**!public! !
NumberOfServiceNames!**compiled accessors**!private! !
NumberOfServiceNames:!**compiled accessors**!private! !
ServiceNames!**compiled accessors**!public! !
ServiceNames:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_CHANNEL_BIND_INFO class methodsFor!

byteSize
	^_HTTP_CHANNEL_BIND_INFO_Size!

defineFields
	"Define the fields of the HTTP_CHANNEL_BIND_INFO structure.

	HTTP_CHANNEL_BIND_INFO compileDefinition

		typedef [uuid(84ea1900-0bc6-4ac8-9025-7f74436d5dc9), helpstring('The HTTP_CHANNEL_BIND_INFO structure is used to set or query channel bind authentication.')]
		struct tagHTTP_CHANNEL_BIND_INFO {
			[helpstring(' HTTP_AUTHENTICATION_HARDENING_LEVELS value indicating the hardening level levels to be set or queried per server session or URL group.')] HTTP_AUTHENTICATION_HARDENING_LEVELS Hardening;
			[helpstring('Flags from the HTTP_CHANNEL_BIND_* enumeration that determine the behaviour of authentication.')] ULONG Flags;
			[helpstring('Pointer to a buffer holding an array of 1 or more service names. Each service name is represented by either an HTTP_SERVICE_BINDING_A structure or an HTTP_SERVICE_BINDING_W structure, dependent upon whether the name is ASCII or Unicode.'), size_is('NumberOfServiceNames')] HTTP_SERVICE_BINDING_BASE* ServiceNames;
			[nonbrowsable, helpstring('The number of names in ServiceNames.')] ULONG NumberOfServiceNames;
		} HTTP_CHANNEL_BIND_INFO;
"

	self
		defineField: #Hardening type: Int32Field new offset: 0;
		defineField: #Flags type: UInt32Field new offset: 4;
		defineField: #ServiceNames type: (StructureArrayPointerField type: HTTP_SERVICE_BINDING_BASE lengthField: #NumberOfServiceNames) offset: 8;
		defineField: #NumberOfServiceNames type: UInt32Field new beNonBrowsable offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#Hardening #Flags #ServiceNames #NumberOfServiceNames)! !

!WinHttpServer.HTTP_CHANNEL_BIND_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

