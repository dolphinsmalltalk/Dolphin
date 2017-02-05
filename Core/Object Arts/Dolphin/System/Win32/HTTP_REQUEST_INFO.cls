"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_REQUEST_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_REQUEST_INFO guid: (GUID fromString: '{8C37D370-DA00-4186-B515-EBE6B57D8CC6}')!
HTTP_REQUEST_INFO comment: '<HTTP_REQUEST_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_REQUEST_INFO'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(8C37D370-DA00-4186-B515-EBE6B57D8CC6)]
struct tagHTTP_REQUEST_INFO {
	HTTP_REQUEST_INFO_TYPE InfoType;
	unsigned long InfoLength;
	void* pInfo;
} HTTP_REQUEST_INFO;
'!
!HTTP_REQUEST_INFO categoriesForClass!Win32-Structs! !
!HTTP_REQUEST_INFO methodsFor!

InfoLength
	"Answer the receiver's InfoLength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #InfoLength)!

InfoLength: anObject
	"Set the receiver's InfoLength field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #InfoLength) put: anObject!

InfoType
	"Answer the receiver's InfoType field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

InfoType: anObject
	"Set the receiver's InfoType field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

pInfo
	"Answer the receiver's pInfo field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pInfo)) asExternalAddress!

pInfo: anObject
	"Set the receiver's pInfo field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pInfo) put: anObject! !
!HTTP_REQUEST_INFO categoriesFor: #InfoLength!**compiled accessors**!public! !
!HTTP_REQUEST_INFO categoriesFor: #InfoLength:!**compiled accessors**!public! !
!HTTP_REQUEST_INFO categoriesFor: #InfoType!**compiled accessors**!public! !
!HTTP_REQUEST_INFO categoriesFor: #InfoType:!**compiled accessors**!public! !
!HTTP_REQUEST_INFO categoriesFor: #pInfo!**compiled accessors**!public! !
!HTTP_REQUEST_INFO categoriesFor: #pInfo:!**compiled accessors**!public! !

!HTTP_REQUEST_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_INFO structure.

	HTTP_REQUEST_INFO  compileDefinition

		typedef [uuid(8C37D370-DA00-4186-B515-EBE6B57D8CC6)]
		struct tagHTTP_REQUEST_INFO {
			HTTP_REQUEST_INFO_TYPE InfoType;
			unsigned long InfoLength;
			void* pInfo;
		} HTTP_REQUEST_INFO;
"

	self
		defineField: #InfoType type: SDWORDField new offset: 0;
		defineField: #InfoLength type: DWORDField new offset: 4;
		defineField: #pInfo type: LPVOIDField new offset: 8.
	self byteSize: 12! !
!HTTP_REQUEST_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

