"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_RESPONSE_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_RESPONSE_INFO guid: (GUID fromString: '{CDF58C2C-140F-4611-B847-12837CE3155F}')!
HTTP_RESPONSE_INFO comment: '<HTTP_RESPONSE_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_RESPONSE_INFO'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(CDF58C2C-140F-4611-B847-12837CE3155F)]
struct tagHTTP_RESPONSE_INFO {
	HTTP_RESPONSE_INFO_TYPE Type;
	unsigned long Length;
	void* pInfo;
} HTTP_RESPONSE_INFO;
'!
!HTTP_RESPONSE_INFO categoriesForClass!Win32-Structs! !
!HTTP_RESPONSE_INFO methodsFor!

Length
	"Answer the receiver's Length field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #Length)!

Length: anObject
	"Set the receiver's Length field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #Length) put: anObject!

pInfo
	"Answer the receiver's pInfo field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pInfo)) asExternalAddress!

pInfo: anObject
	"Set the receiver's pInfo field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pInfo) put: anObject!

Type
	"Answer the receiver's Type field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

Type: anObject
	"Set the receiver's Type field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject! !
!HTTP_RESPONSE_INFO categoriesFor: #Length!**compiled accessors**!public! !
!HTTP_RESPONSE_INFO categoriesFor: #Length:!**compiled accessors**!public! !
!HTTP_RESPONSE_INFO categoriesFor: #pInfo!**compiled accessors**!public! !
!HTTP_RESPONSE_INFO categoriesFor: #pInfo:!**compiled accessors**!public! !
!HTTP_RESPONSE_INFO categoriesFor: #Type!**compiled accessors**!public! !
!HTTP_RESPONSE_INFO categoriesFor: #Type:!**compiled accessors**!public! !

!HTTP_RESPONSE_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_RESPONSE_INFO structure.

	HTTP_RESPONSE_INFO  compileDefinition

		typedef [uuid(CDF58C2C-140F-4611-B847-12837CE3155F)]
		struct tagHTTP_RESPONSE_INFO {
			HTTP_RESPONSE_INFO_TYPE Type;
			unsigned long Length;
			void* pInfo;
		} HTTP_RESPONSE_INFO;
"

	self
		defineField: #Type type: SDWORDField new offset: 0;
		defineField: #Length type: DWORDField new offset: 4;
		defineField: #pInfo type: LPVOIDField new offset: 8.
	self byteSize: 12! !
!HTTP_RESPONSE_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

