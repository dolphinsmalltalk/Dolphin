"Filed out from Dolphin Smalltalk"!

WinHttpServer.HTTP_PROPERTY_FLAGS
	subclass: #'WinHttpServer.HTTP_LOGGING_INFO'
	instanceVariableNames: 'directoryName softwareName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_LOGGING_INFO_Size' -> 16r30.
			'_OffsetOf_DirectoryName' -> 16r10.
			'_OffsetOf_DirectoryNameLength' -> 16rE.
			'_OffsetOf_Fields' -> 16r18.
			'_OffsetOf_Format' -> 16r14.
			'_OffsetOf_LoggingFlags' -> 16r4.
			'_OffsetOf_MaxRecordSize' -> 16r22.
			'_OffsetOf_NumOfExtFields' -> 16r20.
			'_OffsetOf_pExtFields' -> 16r1C.
			'_OffsetOf_pSecurityDescriptor' -> 16r2C.
			'_OffsetOf_RolloverSize' -> 16r28.
			'_OffsetOf_RolloverType' -> 16r24.
			'_OffsetOf_SoftwareName' -> 16r8.
			'_OffsetOf_SoftwareNameLength' -> 16rC
		}!
WinHttpServer.HTTP_LOGGING_INFO guid: (Core.GUID fromString: '{41c67887-c529-4196-9c0f-5bb698324d32}')!
WinHttpServer.HTTP_LOGGING_INFO comment: '`HTTP_LOGGING_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_LOGGING_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Configuration structure used for setting the logging property."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(41c67887-c529-4196-9c0f-5bb698324d32), helpstring("Configuration structure used for setting the logging property.")]
struct tagHTTP_LOGGING_INFO {
	[helpstring("Specifies whether this property exists or not.")] HTTP_PROPERTY_FLAGS;
	[helpstring("Optional logging flags.")] ULONG LoggingFlags;
	[helpstring("Optional informational software directive string for W3C type logging. Not used for other types of logging. If nothing is provided here HTTPAPI will log a default string. Any arbitrary string could be used here to identify the application."), size_is("SoftwareNameLength>>1"), string] LPCWSTR SoftwareName;
	[helpstring("Length of SoftwareName in number of bytes. Cannot be greater than MAX_PATH.")] USHORT SoftwareNameLength;
	[helpstring("Length of DirectoryName in number of bytes. Cannot be greater than MAX_PATH.")] USHORT DirectoryNameLength;
	[helpstring("Log file directory must be a fully qualified path."), size_is("DirectoryNameLength>>1"), string] LPCWSTR DirectoryName;
	[helpstring("Specifies the format for the log files.")] HTTP_LOGGING_TYPE Format;
	[helpstring("Bitmask value indicates which fields to be logged if the log format is set to W3C.This must be the ''bitwise or'' of the HTTP_LOG_FIELD_... values.")] ULONG Fields;
	[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] PVOID pExtFields;
	[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] USHORT NumOfExtFields;
	[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] USHORT MaxRecordSize;
	[helpstring("Defines the rollover type for the log files.")] HTTP_LOGGING_ROLLOVER_TYPE RolloverType;
	[helpstring("Indicates the maximum size (in bytes) after which the log files should be rolled over.A value of HTTP_LIMIT_INFINITE (-1) indicates an unlimited size. This value is discarded if rollover type is not set to HttpLoggingRolloverSize.")] ULONG RolloverSize;
	[helpstring("Specifies the security descriptor to be applied to the log files and the sub - directories. If null we will inherit the system default. This security descriptor must be self-relative.")] void* pSecurityDescriptor;
} HTTP_LOGGING_INFO;
```
'!
!WinHttpServer.HTTP_LOGGING_INFO categoriesForClass!Win32-Structs! !
!WinHttpServer.HTTP_LOGGING_INFO methodsFor!

DirectoryName
	"Answer the <Utf16String> value of the receiver's 'DirectoryName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_DirectoryName)
		length: self DirectoryNameLength >> 1!

DirectoryName: anUtf16String
	"Set the receiver's 'DirectoryName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_DirectoryName put: anUtf16String yourAddress.
	self DirectoryNameLength: anUtf16String size << 1!

DirectoryNameLength
	"Answer the <Integer> value of the receiver's 'DirectoryNameLength' field."

	^bytes uint16AtOffset: _OffsetOf_DirectoryNameLength!

DirectoryNameLength: anInteger
	"Set the receiver's 'DirectoryNameLength' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_DirectoryNameLength put: anInteger!

Fields
	"Answer the <Integer> value of the receiver's 'Fields' field."

	^bytes uint32AtOffset: _OffsetOf_Fields!

Fields: anInteger
	"Set the receiver's 'Fields' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Fields put: anInteger!

Format
	"Answer the <Integer> value of the receiver's 'Format' field."

	^bytes int32AtOffset: _OffsetOf_Format!

Format: anInteger
	"Set the receiver's 'Format' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_Format put: anInteger!

LoggingFlags
	"Answer the <Integer> value of the receiver's 'LoggingFlags' field."

	^bytes uint32AtOffset: _OffsetOf_LoggingFlags!

LoggingFlags: anInteger
	"Set the receiver's 'LoggingFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_LoggingFlags put: anInteger!

pSecurityDescriptor
	"Answer the <Address> value of the receiver's 'pSecurityDescriptor' field."

	^(bytes uintPtrAtOffset: _OffsetOf_pSecurityDescriptor) asExternalAddress!

pSecurityDescriptor: anAddress
	"Set the receiver's 'pSecurityDescriptor' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_pSecurityDescriptor put: anAddress!

RolloverSize
	"Answer the <Integer> value of the receiver's 'RolloverSize' field."

	^bytes uint32AtOffset: _OffsetOf_RolloverSize!

RolloverSize: anInteger
	"Set the receiver's 'RolloverSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_RolloverSize put: anInteger!

RolloverType
	"Answer the <Integer> value of the receiver's 'RolloverType' field."

	^bytes int32AtOffset: _OffsetOf_RolloverType!

RolloverType: anInteger
	"Set the receiver's 'RolloverType' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_RolloverType put: anInteger!

SoftwareName
	"Answer the <Utf16String> value of the receiver's 'SoftwareName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_SoftwareName)
		length: self SoftwareNameLength >> 1!

SoftwareName: anUtf16String
	"Set the receiver's 'SoftwareName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_SoftwareName put: anUtf16String yourAddress.
	self SoftwareNameLength: anUtf16String size << 1!

SoftwareNameLength
	"Answer the <Integer> value of the receiver's 'SoftwareNameLength' field."

	^bytes uint16AtOffset: _OffsetOf_SoftwareNameLength!

SoftwareNameLength: anInteger
	"Set the receiver's 'SoftwareNameLength' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_SoftwareNameLength put: anInteger! !
!WinHttpServer.HTTP_LOGGING_INFO categoriesForMethods!
DirectoryName!**compiled accessors**!public! !
DirectoryName:!**compiled accessors**!public! !
DirectoryNameLength!**compiled accessors**!public! !
DirectoryNameLength:!**compiled accessors**!public! !
Fields!**compiled accessors**!public! !
Fields:!**compiled accessors**!public! !
Format!**compiled accessors**!public! !
Format:!**compiled accessors**!public! !
LoggingFlags!**compiled accessors**!public! !
LoggingFlags:!**compiled accessors**!public! !
pSecurityDescriptor!**compiled accessors**!public! !
pSecurityDescriptor:!**compiled accessors**!public! !
RolloverSize!**compiled accessors**!public! !
RolloverSize:!**compiled accessors**!public! !
RolloverType!**compiled accessors**!public! !
RolloverType:!**compiled accessors**!public! !
SoftwareName!**compiled accessors**!public! !
SoftwareName:!**compiled accessors**!public! !
SoftwareNameLength!**compiled accessors**!public! !
SoftwareNameLength:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_LOGGING_INFO class methodsFor!

byteSize
	^_HTTP_LOGGING_INFO_Size!

defineFields
	"Define the fields of the HTTP_LOGGING_INFO structure.

	HTTP_LOGGING_INFO compileDefinition

		typedef [uuid(41c67887-c529-4196-9c0f-5bb698324d32), helpstring('Configuration structure used for setting the logging property.')]
		struct tagHTTP_LOGGING_INFO {
			[helpstring('Specifies whether this property exists or not.')] HTTP_PROPERTY_FLAGS;
			[helpstring('Optional logging flags.')] ULONG LoggingFlags;
			[helpstring('Optional informational software directive string for W3C type logging. Not used for other types of logging. If nothing is provided here HTTPAPI will log a default string. Any arbitrary string could be used here to identify the application.'), size_is('SoftwareNameLength>>1'), string] LPCWSTR SoftwareName;
			[helpstring('Length of SoftwareName in number of bytes. Cannot be greater than MAX_PATH.')] USHORT SoftwareNameLength;
			[helpstring('Length of DirectoryName in number of bytes. Cannot be greater than MAX_PATH.')] USHORT DirectoryNameLength;
			[helpstring('Log file directory must be a fully qualified path.'), size_is('DirectoryNameLength>>1'), string] LPCWSTR DirectoryName;
			[helpstring('Specifies the format for the log files.')] HTTP_LOGGING_TYPE Format;
			[helpstring('Bitmask value indicates which fields to be logged if the log format is set to W3C.This must be the 'bitwise or' of the HTTP_LOG_FIELD_... values.')] ULONG Fields;
			[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] PVOID pExtFields;
			[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] USHORT NumOfExtFields;
			[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] USHORT MaxRecordSize;
			[helpstring('Defines the rollover type for the log files.')] HTTP_LOGGING_ROLLOVER_TYPE RolloverType;
			[helpstring('Indicates the maximum size (in bytes) after which the log files should be rolled over.A value of HTTP_LIMIT_INFINITE (-1) indicates an unlimited size. This value is discarded if rollover type is not set to HttpLoggingRolloverSize.')] ULONG RolloverSize;
			[helpstring('Specifies the security descriptor to be applied to the log files and the sub - directories. If null we will inherit the system default. This security descriptor must be self-relative.')] void* pSecurityDescriptor;
		} HTTP_LOGGING_INFO;
"

	super defineFields.
	self
		defineField: #LoggingFlags type: UInt32Field new offset: 4;
		defineField: #SoftwareName type: (ArrayPointerField type: Utf16String arrayLength: (SizeIsArrayFieldLength sizeIs: 'SoftwareNameLength >> 1')) offset: 8;
		defineField: #SoftwareNameLength type: UInt16Field new offset: 12;
		defineField: #DirectoryNameLength type: UInt16Field new offset: 14;
		defineField: #DirectoryName type: (ArrayPointerField type: Utf16String arrayLength: (SizeIsArrayFieldLength sizeIs: 'DirectoryNameLength >> 1')) offset: 16;
		defineField: #Format type: Int32Field new offset: 20;
		defineField: #Fields type: UInt32Field new offset: 24;
		defineField: #pExtFields type: LPVOIDField new beFiller offset: 28;
		defineField: #NumOfExtFields type: UInt16Field new beFiller offset: 32;
		defineField: #MaxRecordSize type: UInt16Field new beFiller offset: 34;
		defineField: #RolloverType type: Int32Field new offset: 36;
		defineField: #RolloverSize type: UInt32Field new offset: 40;
		defineField: #pSecurityDescriptor type: LPVOIDField new offset: 44.
	self byteSize: 48!

getFieldNames
	^#(#Present #LoggingFlags #SoftwareName #SoftwareNameLength #DirectoryNameLength #DirectoryName #Format #Fields #RolloverType #RolloverSize #pSecurityDescriptor)!

propertyId
	^HttpServerLoggingProperty! !
!WinHttpServer.HTTP_LOGGING_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
propertyId!public! !
!

