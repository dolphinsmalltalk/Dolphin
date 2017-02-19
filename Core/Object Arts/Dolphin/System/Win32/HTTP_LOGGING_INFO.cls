"Filed out from Dolphin Smalltalk 7"!

HTTP_PROPERTY_FLAGS subclass: #HTTP_LOGGING_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_LOGGING_INFO guid: (GUID fromString: '{41c67887-c529-4196-9c0f-5bb698324d32}')!
HTTP_LOGGING_INFO comment: '<HTTP_LOGGING_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_LOGGING_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Configuration structure used for setting the logging property."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(41c67887-c529-4196-9c0f-5bb698324d32), helpstring("Configuration structure used for setting the logging property.")]
struct tagHTTP_LOGGING_INFO {
	[helpstring("Specifies whether this property exists or not.")] HTTP_PROPERTY_FLAGS;
	[helpstring("Optional logging flags.")] ULONG LoggingFlags;
	[helpstring("Optional informational software directive string for W3C type logging. Not used for other types of logging. If nothing is provided here HTTPAPI will log a default string. Any arbitrary string could be used here to identify the application.")] LPCWSTR SoftwareName;
	[helpstring("Length of SoftwareName in number of bytes. Cannot be greater than MAX_PATH.")] USHORT SoftwareNameLength;
	[helpstring("Length of DirectoryName in number of bytes. Cannot be greater than MAX_PATH.")] USHORT DirectoryNameLength;
	[helpstring("Log file directory must be a fully qualified path.")] LPCWSTR DirectoryName;
	[helpstring("Specifies the format for the log files.")] HTTP_LOGGING_TYPE Format;
	[helpstring("Bitmask value indicates which fields to be logged if the log format is set to W3C.This must be the ''bitwise or'' of the HTTP_LOG_FIELD_... values.")] ULONG Fields;
	[helpstring("Reserved must be NULL.")] void* pExtFields;
	[helpstring("Reserved must be zero.")] USHORT NumOfExtFields;
	[helpstring("Reserved must be zero.")] USHORT MaxRecordSize;
	[helpstring("Defines the rollover type for the log files.")] HTTP_LOGGING_ROLLOVER_TYPE RolloverType;
	[helpstring("Indicates the maximum size (in bytes) after which the log files should be rolled over.A value of HTTP_LIMIT_INFINITE (-1) indicates an unlimited size. This value is discarded if rollover type is not set to HttpLoggingRolloverSize.")] ULONG RolloverSize;
	[helpstring("Specifies the security descriptor to be applied to the log files and the sub - directories. If null we will inherit the system default. This security descriptor must be self-relative.")] void* pSecurityDescriptor;
} HTTP_LOGGING_INFO;
'!
!HTTP_LOGGING_INFO categoriesForClass!Win32-Structs! !
!HTTP_LOGGING_INFO methodsFor!

DirectoryName
	"Answer the <UnicodeString> value of the receiver's 'DirectoryName' field."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #DirectoryName))!

DirectoryName: anUnicodeString
	"Set the receiver's 'DirectoryName' field to the value of the argument, anUnicodeString"

	bytes uintPtrAtOffset: ##(self offsetOf: #DirectoryName) put: anUnicodeString yourAddress!

DirectoryNameLength
	"Answer the <Integer> value of the receiver's 'DirectoryNameLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #DirectoryNameLength)!

DirectoryNameLength: anInteger
	"Set the receiver's 'DirectoryNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #DirectoryNameLength) put: anInteger!

Fields
	"Answer the <Integer> value of the receiver's 'Fields' field."

	^bytes dwordAtOffset: ##(self offsetOf: #Fields)!

Fields: anInteger
	"Set the receiver's 'Fields' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #Fields) put: anInteger!

Format
	"Answer the <Integer> value of the receiver's 'Format' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #Format)!

Format: anInteger
	"Set the receiver's 'Format' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #Format) put: anInteger!

LoggingFlags
	"Answer the <Integer> value of the receiver's 'LoggingFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #LoggingFlags)!

LoggingFlags: anInteger
	"Set the receiver's 'LoggingFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #LoggingFlags) put: anInteger!

MaxRecordSize
	"Answer the <Integer> value of the receiver's 'MaxRecordSize' field."

	^bytes wordAtOffset: ##(self offsetOf: #MaxRecordSize)!

MaxRecordSize: anInteger
	"Set the receiver's 'MaxRecordSize' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #MaxRecordSize) put: anInteger!

NumOfExtFields
	"Answer the <Integer> value of the receiver's 'NumOfExtFields' field."

	^bytes wordAtOffset: ##(self offsetOf: #NumOfExtFields)!

NumOfExtFields: anInteger
	"Set the receiver's 'NumOfExtFields' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #NumOfExtFields) put: anInteger!

pExtFields
	"Answer the <ExternalAddress> value of the receiver's 'pExtFields' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pExtFields)) asExternalAddress!

pExtFields: anExternalAddress
	"Set the receiver's 'pExtFields' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: ##(self offsetOf: #pExtFields) put: anExternalAddress!

pSecurityDescriptor
	"Answer the <ExternalAddress> value of the receiver's 'pSecurityDescriptor' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pSecurityDescriptor)) asExternalAddress!

pSecurityDescriptor: anExternalAddress
	"Set the receiver's 'pSecurityDescriptor' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: ##(self offsetOf: #pSecurityDescriptor) put: anExternalAddress!

RolloverSize
	"Answer the <Integer> value of the receiver's 'RolloverSize' field."

	^bytes dwordAtOffset: ##(self offsetOf: #RolloverSize)!

RolloverSize: anInteger
	"Set the receiver's 'RolloverSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #RolloverSize) put: anInteger!

RolloverType
	"Answer the <Integer> value of the receiver's 'RolloverType' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #RolloverType)!

RolloverType: anInteger
	"Set the receiver's 'RolloverType' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #RolloverType) put: anInteger!

SoftwareName
	"Answer the <UnicodeString> value of the receiver's 'SoftwareName' field."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #SoftwareName))!

SoftwareName: anUnicodeString
	"Set the receiver's 'SoftwareName' field to the value of the argument, anUnicodeString"

	bytes uintPtrAtOffset: ##(self offsetOf: #SoftwareName) put: anUnicodeString yourAddress!

SoftwareNameLength
	"Answer the <Integer> value of the receiver's 'SoftwareNameLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #SoftwareNameLength)!

SoftwareNameLength: anInteger
	"Set the receiver's 'SoftwareNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #SoftwareNameLength) put: anInteger! !
!HTTP_LOGGING_INFO categoriesFor: #DirectoryName!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #DirectoryName:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #DirectoryNameLength!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #DirectoryNameLength:!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #Fields!**compiled accessors**!public! !
!HTTP_LOGGING_INFO categoriesFor: #Fields:!**compiled accessors**!public! !
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

	HTTP_LOGGING_INFO compileDefinition

		typedef [uuid(41c67887-c529-4196-9c0f-5bb698324d32), helpstring('Configuration structure used for setting the logging property.')]
		struct tagHTTP_LOGGING_INFO {
			[helpstring('Specifies whether this property exists or not.')] HTTP_PROPERTY_FLAGS;
			[helpstring('Optional logging flags.')] ULONG LoggingFlags;
			[helpstring('Optional informational software directive string for W3C type logging. Not used for other types of logging. If nothing is provided here HTTPAPI will log a default string. Any arbitrary string could be used here to identify the application.')] LPCWSTR SoftwareName;
			[helpstring('Length of SoftwareName in number of bytes. Cannot be greater than MAX_PATH.')] USHORT SoftwareNameLength;
			[helpstring('Length of DirectoryName in number of bytes. Cannot be greater than MAX_PATH.')] USHORT DirectoryNameLength;
			[helpstring('Log file directory must be a fully qualified path.')] LPCWSTR DirectoryName;
			[helpstring('Specifies the format for the log files.')] HTTP_LOGGING_TYPE Format;
			[helpstring('Bitmask value indicates which fields to be logged if the log format is set to W3C.This must be the 'bitwise or' of the HTTP_LOG_FIELD_... values.')] ULONG Fields;
			[helpstring('Reserved must be NULL.')] void* pExtFields;
			[helpstring('Reserved must be zero.')] USHORT NumOfExtFields;
			[helpstring('Reserved must be zero.')] USHORT MaxRecordSize;
			[helpstring('Defines the rollover type for the log files.')] HTTP_LOGGING_ROLLOVER_TYPE RolloverType;
			[helpstring('Indicates the maximum size (in bytes) after which the log files should be rolled over.A value of HTTP_LIMIT_INFINITE (-1) indicates an unlimited size. This value is discarded if rollover type is not set to HttpLoggingRolloverSize.')] ULONG RolloverSize;
			[helpstring('Specifies the security descriptor to be applied to the log files and the sub - directories. If null we will inherit the system default. This security descriptor must be self-relative.')] void* pSecurityDescriptor;
		} HTTP_LOGGING_INFO;
"

	super defineFields.
	self
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

