"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVICE_CONFIG_TIMEOUT_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_KeyDesc' -> 16r0.
		'_OffsetOf_ParamDesc' -> 16r4
	}!
HTTP_SERVICE_CONFIG_TIMEOUT_SET guid: (GUID fromString: '{6f4abcfc-2a59-4996-a958-5de93dc64213}')!
HTTP_SERVICE_CONFIG_TIMEOUT_SET comment: '<HTTP_SERVICE_CONFIG_TIMEOUT_SET> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_TIMEOUT_SET'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"To set a timeout value use the set structure. To query/delete use the key directly. When you query a timeout value the output buffer must be exactly the sizeof param."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(6f4abcfc-2a59-4996-a958-5de93dc64213), helpstring("To set a timeout value use the set structure. To query/delete use the key directly. When you query a timeout value the output buffer must be exactly the sizeof param.")]
struct tagHTTP_SERVICE_CONFIG_TIMEOUT_SET {
	HTTP_SERVICE_CONFIG_TIMEOUT_KEY KeyDesc;
	USHORT ParamDesc;
} HTTP_SERVICE_CONFIG_TIMEOUT_SET;
'!
!HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesForClass!WinHttpServer-Structs! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET methodsFor!

KeyDesc
	"Answer the <Integer> value of the receiver's 'KeyDesc' field."

	^bytes sdwordAtOffset: _OffsetOf_KeyDesc!

KeyDesc: anInteger
	"Set the receiver's 'KeyDesc' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_KeyDesc put: anInteger!

ParamDesc
	"Answer the <Integer> value of the receiver's 'ParamDesc' field."

	^bytes wordAtOffset: _OffsetOf_ParamDesc!

ParamDesc: anInteger
	"Set the receiver's 'ParamDesc' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ParamDesc put: anInteger! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesFor: #ParamDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesFor: #ParamDesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_TIMEOUT_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_TIMEOUT_SET structure.

	HTTP_SERVICE_CONFIG_TIMEOUT_SET compileDefinition

		typedef [uuid(6f4abcfc-2a59-4996-a958-5de93dc64213), helpstring('To set a timeout value use the set structure. To query/delete use the key directly. When you query a timeout value the output buffer must be exactly the sizeof param.')]
		struct tagHTTP_SERVICE_CONFIG_TIMEOUT_SET {
			HTTP_SERVICE_CONFIG_TIMEOUT_KEY KeyDesc;
			USHORT ParamDesc;
		} HTTP_SERVICE_CONFIG_TIMEOUT_SET;
"

	self
		defineField: #KeyDesc type: SDWORDField new offset: 0;
		defineField: #ParamDesc type: WORDField new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#KeyDesc #ParamDesc)! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

