"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_LOGGING_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_LOGGING_INFO guid: (GUID fromString: '{41C67887-C529-4196-9C0F-5BB698324D32}')!
HTTP_LOGGING_INFO comment: '<HTTP_LOGGING_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_LOGGING_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Configuration structure used for setting the logging property."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(41C67887-C529-4196-9C0F-5BB698324D32), helpstring("Configuration structure used for setting the logging property.")]
struct tagHTTP_LOGGING_INFO {
	[helpstring("Specifies whether this property exists or not.")] HTTP_PROPERTY_FLAGS flags;
	[helpstring("Optional logging flags.")] unsigned long LoggingFlags;
	[helpstring("Optional informational software directive string for W3C type logging. Not used for other types of logging. If nothing is provided here HTTPAPI will log a default string. Any arbitrary string could be used here to identify the application.")] LPCWSTR SoftwareName;
	[helpstring("Lengh of SoftwareName in number of bytes. Cannot be greater than MAX_PATH.")] unsigned short SoftwareNameLength;
	[helpstring("Lengh of DirectoryName in number of bytes. Cannot be greater than MAX_PATH.")] unsigned short DirectoryNameLength;
	[helpstring("Log file directory must be a fully qualified path.")] LPCWSTR DirectoryName;
	[helpstring("Specifies the format for the log files.")] HTTP_LOGGING_TYPE Format;
	[helpstring("Bitmask value indicates which fields to be logged if the log format is set to W3C.This must be the ''bitwise or'' of the HTTP_LOG_FIELD_... values.")] unsigned long Fields;
	[helpstring("Reserved must be NULL.")] void* pExtFields;
	[helpstring("Reserved must be zero.")] unsigned short NumOfExtFields;
	[helpstring("Reserved must be zero.")] unsigned short MaxRecordSize;
	[helpstring("Defines the rollover type for the log files.")] HTTP_LOGGING_ROLLOVER_TYPE RolloverType;
	[helpstring("Indicates the maximum size (in bytes) after which the log files should be rolled over.A value of HTTP_LIMIT_INFINITE (-1) indicates an unlimited size. This value is discarded if rollover type is not set to HttpLoggingRolloverSize.")] unsigned long RolloverSize;
	[helpstring("Specifies the security descriptor to be applied to the log files and the sub - directories. If null we will inherit the system default. This security descriptor must be self-relative.")] void* pSecurityDescriptor;
} HTTP_LOGGING_INFO;
'!
!HTTP_LOGGING_INFO categoriesForClass!Win32-Structs! !
!HTTP_LOGGING_INFO methodsFor!

DirectoryName
	"Answer the receiver's DirectoryName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #DirectoryName))!

DirectoryName: anObject
	"Set the receiver's DirectoryName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #DirectoryName) put: anObject yourAddress!

DirectoryNameLength
	"Answer the receiver's DirectoryNameLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #DirectoryNameLength)!

DirectoryNameLength: anObject
	"Set the receiver's DirectoryNameLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #DirectoryNameLength) put: anObject!

Fields
	"Answer the receiver's Fields field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #Fields)!

Fields: anObject
	"Set the receiver's Fields field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #Fields) put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

Format
	"Answer the receiver's Format field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #Format)!

Format: anObject
	"Set the receiver's Format field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #Format) put: anObject!

LoggingFlags
	"Answer the receiver's LoggingFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #LoggingFlags)!

LoggingFlags: anObject
	"Set the receiver's LoggingFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #LoggingFlags) put: anObject!

MaxRecordSize
	"Answer the receiver's MaxRecordSize field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #MaxRecordSize)!

MaxRecordSize: anObject
	"Set the receiver's MaxRecordSize field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #MaxRecordSize) put: anObject!

NumOfExtFields
	"Answer the receiver's NumOfExtFields field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #NumOfExtFields)!

NumOfExtFields: anObject
	"Set the receiver's NumOfExtFields field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #NumOfExtFields) put: anObject!

pExtFields
	"Answer the receiver's pExtFields field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pExtFields)) asExternalAddress!

pExtFields: anObject
	"Set the receiver's pExtFields field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pExtFields) put: anObject!

pSecurityDescriptor
	"Answer the receiver's pSecurityDescriptor field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pSecurityDescriptor)) asExternalAddress!

pSecurityDescriptor: anObject
	"Set the receiver's pSecurityDescriptor field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pSecurityDescriptor) put: anObject!

RolloverSize
	"Answer the receiver's RolloverSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #RolloverSize)!

RolloverSize: anObject
	"Set the receiver's RolloverSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #RolloverSize) put: anObject!

RolloverType
	"Answer the receiver's RolloverType field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #RolloverType)!

RolloverType: anObject
	"Set the receiver's RolloverType field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #RolloverType) put: anObject!

SoftwareName
	"Answer the receiver's SoftwareName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #SoftwareName))!

SoftwareName: anObject
	"Set the receiver's SoftwareName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #SoftwareName) put: anObject yourAddress!

SoftwareNameLength
	"Answer the receiver's SoftwareNameLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #SoftwareNameLength)!

SoftwareNameLength: anObject
	"Set the receiver's SoftwareNameLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #SoftwareNameLength) put: anObject! !
!HTTP_LOGGING_INFO categoriesFor: #DirectoryName!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #DirectoryName:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #DirectoryNameLength!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #DirectoryNameLength:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #Fields!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #Fields:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #Format!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #Format:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #LoggingFlags!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #LoggingFlags:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #MaxRecordSize!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #MaxRecordSize:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #NumOfExtFields!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #NumOfExtFields:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #pExtFields!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #pExtFields:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #pSecurityDescriptor!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #pSecurityDescriptor:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #RolloverSize!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #RolloverSize:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #RolloverType!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #RolloverType:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #SoftwareName!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #SoftwareName:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #SoftwareNameLength!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #SoftwareNameLength:!**compiled accessors**!public! !

!HTTP_LOGGING_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_LOGGING_INFO structure.

	HTTP_LOGGING_INFO  compileDefinition

		typedef [uuid(41C67887-C529-4196-9C0F-5BB698324D32), helpstring('Configuration structure used for setting the logging property.')]
		struct tagHTTP_LOGGING_INFO {
			[helpstring('Specifies whether this property exists or not.')] HTTP_PROPERTY_FLAGS flags;
			[helpstring('Optional logging flags.')] unsigned long LoggingFlags;
			[helpstring('Optional informational software directive string for W3C type logging. Not used for other types of logging. If nothing is provided here HTTPAPI will log a default string. Any arbitrary string could be used here to identify the application.')] LPCWSTR SoftwareName;
			[helpstring('Lengh of SoftwareName in number of bytes. Cannot be greater than MAX_PATH.')] unsigned short SoftwareNameLength;
			[helpstring('Lengh of DirectoryName in number of bytes. Cannot be greater than MAX_PATH.')] unsigned short DirectoryNameLength;
			[helpstring('Log file directory must be a fully qualified path.')] LPCWSTR DirectoryName;
			[helpstring('Specifies the format for the log files.')] HTTP_LOGGING_TYPE Format;
			[helpstring('Bitmask value indicates which fields to be logged if the log format is set to W3C.This must be the 'bitwise or' of the HTTP_LOG_FIELD_... values.')] unsigned long Fields;
			[helpstring('Reserved must be NULL.')] void* pExtFields;
			[helpstring('Reserved must be zero.')] unsigned short NumOfExtFields;
			[helpstring('Reserved must be zero.')] unsigned short MaxRecordSize;
			[helpstring('Defines the rollover type for the log files.')] HTTP_LOGGING_ROLLOVER_TYPE RolloverType;
			[helpstring('Indicates the maximum size (in bytes) after which the log files should be rolled over.A value of HTTP_LIMIT_INFINITE (-1) indicates an unlimited size. This value is discarded if rollover type is not set to HttpLoggingRolloverSize.')] unsigned long RolloverSize;
			[helpstring('Specifies the security descriptor to be applied to the log files and the sub - directories. If null we will inherit the system default. This security descriptor must be self-relative.')] void* pSecurityDescriptor;
		} HTTP_LOGGING_INFO;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #LoggingFlags type: DWORDField new offset: 4;
		defineField: #SoftwareName type: (PointerField type: UnicodeString) offset: 8;
		defineField: #SoftwareNameLength type: WORDField new offset: 12;
		defineField: #DirectoryNameLength type: WORDField new offset: 14;
		defineField: #DirectoryName type: (PointerField type: UnicodeString) offset: 16;
		defineField: #Format type: SDWORDField new offset: 20;
		defineField: #Fields type: DWORDField new offset: 24;
		defineField: #pExtFields type: LPVOIDField new offset: 28;
		defineField: #NumOfExtFields type: WORDField new offset: 32;
		defineField: #MaxRecordSize type: WORDField new offset: 34;
		defineField: #RolloverType type: SDWORDField new offset: 36;
		defineField: #RolloverSize type: DWORDField new offset: 40;
		defineField: #pSecurityDescriptor type: LPVOIDField new offset: 44.
	self byteSize: 48! !
!HTTP_LOGGING_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

