"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_VERSION
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_VERSION guid: (GUID fromString: '{F6A0C406-B01A-4701-AA8C-D4C1A0D2B1A5}')!
HTTP_VERSION comment: '<HTTP_VERSION> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_VERSION'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The type for HTTP protocol version numbers."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(F6A0C406-B01A-4701-AA8C-D4C1A0D2B1A5), helpstring("The type for HTTP protocol version numbers.")]
struct tagHTTP_VERSION {
	unsigned short MajorVersion;
	unsigned short MinorVersion;
} HTTP_VERSION;
'!
!HTTP_VERSION categoriesForClass!Win32-Structs! !
!HTTP_VERSION methodsFor!

MajorVersion
	"Answer the receiver's MajorVersion field as a Smalltalk object."

	^bytes wordAtOffset: 0!

MajorVersion: anObject
	"Set the receiver's MajorVersion field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

MinorVersion
	"Answer the receiver's MinorVersion field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #MinorVersion)!

MinorVersion: anObject
	"Set the receiver's MinorVersion field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #MinorVersion) put: anObject! !
!HTTP_VERSION categoriesFor: #MajorVersion!**compiled accessors**!public! !
!HTTP_VERSION categoriesFor: #MajorVersion:!**compiled accessors**!public! !
!HTTP_VERSION categoriesFor: #MinorVersion!**compiled accessors**!public! !
!HTTP_VERSION categoriesFor: #MinorVersion:!**compiled accessors**!public! !

!HTTP_VERSION class methodsFor!

defineFields
	"Define the fields of the HTTP_VERSION structure.

	HTTP_VERSION  compileDefinition

		typedef [uuid(F6A0C406-B01A-4701-AA8C-D4C1A0D2B1A5), helpstring('The type for HTTP protocol version numbers.')]
		struct tagHTTP_VERSION {
			unsigned short MajorVersion;
			unsigned short MinorVersion;
		} HTTP_VERSION;
"

	self
		defineField: #MajorVersion type: WORDField new offset: 0;
		defineField: #MinorVersion type: WORDField new offset: 2.
	self byteSize: 4! !
!HTTP_VERSION class categoriesFor: #defineFields!**auto generated**!initializing!public! !

