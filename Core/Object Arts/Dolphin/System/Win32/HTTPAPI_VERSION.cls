"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTPAPI_VERSION
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTPAPI_VERSION guid: (GUID fromString: '{61D915C6-278B-4ED6-942B-DB3B81C86C11}')!
HTTPAPI_VERSION comment: '<HTTPAPI_VERSION> is an <ExternalStructure> class to wrap the struct ''Win32.HTTPAPI_VERSION'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Api Version. This is used to ensure compatibility between applications and httpapi.dll and http.sys. This should not be confused with the HTTP Protocol version."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(61D915C6-278B-4ED6-942B-DB3B81C86C11), helpstring("Api Version. This is used to ensure compatibility between applications and httpapi.dll and http.sys. This should not be confused with the HTTP Protocol version.")]
struct tagHTTPAPI_VERSION {
	unsigned short HttpApiMajorVersion;
	unsigned short HttpApiMinorVersion;
} HTTPAPI_VERSION;
'!
!HTTPAPI_VERSION categoriesForClass!Win32-Structs! !
!HTTPAPI_VERSION methodsFor!

HttpApiMajorVersion
	"Answer the receiver's HttpApiMajorVersion field as a Smalltalk object."

	^bytes wordAtOffset: 0!

HttpApiMajorVersion: anObject
	"Set the receiver's HttpApiMajorVersion field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

HttpApiMinorVersion
	"Answer the receiver's HttpApiMinorVersion field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #HttpApiMinorVersion)!

HttpApiMinorVersion: anObject
	"Set the receiver's HttpApiMinorVersion field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #HttpApiMinorVersion) put: anObject! !
!HTTPAPI_VERSION categoriesFor: #HttpApiMajorVersion!**compiled accessors**!public! !
!HTTPAPI_VERSION categoriesFor: #HttpApiMajorVersion:!**compiled accessors**!public! !
!HTTPAPI_VERSION categoriesFor: #HttpApiMinorVersion!**compiled accessors**!public! !
!HTTPAPI_VERSION categoriesFor: #HttpApiMinorVersion:!**compiled accessors**!public! !

!HTTPAPI_VERSION class methodsFor!

defineFields
	"Define the fields of the HTTPAPI_VERSION structure.

	HTTPAPI_VERSION  compileDefinition

		typedef [uuid(61D915C6-278B-4ED6-942B-DB3B81C86C11), helpstring('Api Version. This is used to ensure compatibility between applications and httpapi.dll and http.sys. This should not be confused with the HTTP Protocol version.')]
		struct tagHTTPAPI_VERSION {
			unsigned short HttpApiMajorVersion;
			unsigned short HttpApiMinorVersion;
		} HTTPAPI_VERSION;
"

	self
		defineField: #HttpApiMajorVersion type: WORDField new offset: 0;
		defineField: #HttpApiMinorVersion type: WORDField new offset: 2.
	self byteSize: 4!

new
	^(self newBuffer)
		HttpApiMajorVersion: 2;
		yourself! !
!HTTPAPI_VERSION class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!HTTPAPI_VERSION class categoriesFor: #new!instance creation!public! !

