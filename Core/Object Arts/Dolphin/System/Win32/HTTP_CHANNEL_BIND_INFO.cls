"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_CHANNEL_BIND_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Flags' -> 16r4.
		'_OffsetOf_Hardening' -> 16r0.
		'_OffsetOf_NumberOfServiceNames' -> 16rC.
		'_OffsetOf_ServiceNames' -> 16r8
	}!
HTTP_CHANNEL_BIND_INFO guid: (GUID fromString: '{84ea1900-0bc6-4ac8-9025-7f74436d5dc9}')!
HTTP_CHANNEL_BIND_INFO comment: '<HTTP_CHANNEL_BIND_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_CHANNEL_BIND_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"The HTTP_CHANNEL_BIND_INFO structure is used to set or query channel bind authentication."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(84ea1900-0bc6-4ac8-9025-7f74436d5dc9), helpstring("The HTTP_CHANNEL_BIND_INFO structure is used to set or query channel bind authentication.")]
struct tagHTTP_CHANNEL_BIND_INFO {
	[helpstring(" HTTP_AUTHENTICATION_HARDENING_LEVELS value indicating the hardening level levels to be set or queried per server session or URL group.")] HTTP_AUTHENTICATION_HARDENING_LEVELS Hardening;
	[helpstring("Flags from the HTTP_CHANNEL_BIND_* enumeration that determine the behaviour of authentication.")] ULONG Flags;
	[helpstring("Pointer to a buffer holding an array of 1 or more service names. Each service name is represented by either an HTTP_SERVICE_BINDING_A structure or an HTTP_SERVICE_BINDING_W structure, dependent upon whether the name is ASCII or Unicode."), size_is("NumberOfServiceNames")] HTTP_SERVICE_BINDING_BASE* ServiceNames;
	[nonbrowsable, helpstring("The number of names in ServiceNames.")] ULONG NumberOfServiceNames;
} HTTP_CHANNEL_BIND_INFO;
'!
!HTTP_CHANNEL_BIND_INFO categoriesForClass!WinHttpServer-Structs! !
!HTTP_CHANNEL_BIND_INFO methodsFor!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes dwordAtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Flags put: anInteger!

Hardening
	"Answer the <Integer> value of the receiver's 'Hardening' field."

	^bytes sdwordAtOffset: _OffsetOf_Hardening!

Hardening: anInteger
	"Set the receiver's 'Hardening' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_Hardening put: anInteger!

NumberOfServiceNames
	"Private - Answer the <Integer> value of the receiver's 'NumberOfServiceNames' field."

	^bytes dwordAtOffset: _OffsetOf_NumberOfServiceNames!

NumberOfServiceNames: anInteger
	"Set the receiver's 'NumberOfServiceNames' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_NumberOfServiceNames put: anInteger!

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
!HTTP_CHANNEL_BIND_INFO categoriesFor: #Flags!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #Flags:!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #Hardening!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #Hardening:!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #NumberOfServiceNames!**compiled accessors**!private! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #NumberOfServiceNames:!**compiled accessors**!private! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #ServiceNames!**compiled accessors**!public! !
!HTTP_CHANNEL_BIND_INFO categoriesFor: #ServiceNames:!**compiled accessors**!public! !

!HTTP_CHANNEL_BIND_INFO class methodsFor!

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
		defineField: #Hardening type: SDWORDField new offset: 0;
		defineField: #Flags type: DWORDField new offset: 4;
		defineField: #ServiceNames type: (StructureArrayPointerField type: HTTP_SERVICE_BINDING_BASE lengthField: #NumberOfServiceNames) offset: 8;
		defineField: #NumberOfServiceNames type: DWORDField new beNonBrowsable offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#Hardening #Flags #ServiceNames #NumberOfServiceNames)! !
!HTTP_CHANNEL_BIND_INFO class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_CHANNEL_BIND_INFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

