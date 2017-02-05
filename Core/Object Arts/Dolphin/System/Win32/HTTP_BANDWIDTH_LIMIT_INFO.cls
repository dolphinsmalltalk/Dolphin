"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_BANDWIDTH_LIMIT_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_BANDWIDTH_LIMIT_INFO guid: (GUID fromString: '{197B6874-68BB-4A22-B2FA-9E02210F4CD9}')!
HTTP_BANDWIDTH_LIMIT_INFO comment: '<HTTP_BANDWIDTH_LIMIT_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_BANDWIDTH_LIMIT_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used to set or query the bandwidth throttling limit."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(197B6874-68BB-4A22-B2FA-9E02210F4CD9), helpstring("Used to set or query the bandwidth throttling limit.")]
struct tagHTTP_BANDWIDTH_LIMIT_INFO {
	HTTP_PROPERTY_FLAGS flags;
	unsigned long MaxBandwidth;
} HTTP_BANDWIDTH_LIMIT_INFO;
'!
!HTTP_BANDWIDTH_LIMIT_INFO categoriesForClass!Win32-Structs! !
!HTTP_BANDWIDTH_LIMIT_INFO methodsFor!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

MaxBandwidth
	"Answer the receiver's MaxBandwidth field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #MaxBandwidth)!

MaxBandwidth: anObject
	"Set the receiver's MaxBandwidth field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #MaxBandwidth) put: anObject! !
!HTTP_BANDWIDTH_LIMIT_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_BANDWIDTH_LIMIT_INFO categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_BANDWIDTH_LIMIT_INFO categoriesFor: #MaxBandwidth!**compiled accessors**!public! !
!HTTP_BANDWIDTH_LIMIT_INFO categoriesFor: #MaxBandwidth:!**compiled accessors**!public! !

!HTTP_BANDWIDTH_LIMIT_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_BANDWIDTH_LIMIT_INFO structure.

	HTTP_BANDWIDTH_LIMIT_INFO  compileDefinition

		typedef [uuid(197B6874-68BB-4A22-B2FA-9E02210F4CD9), helpstring('Used to set or query the bandwidth throttling limit.')]
		struct tagHTTP_BANDWIDTH_LIMIT_INFO {
			HTTP_PROPERTY_FLAGS flags;
			unsigned long MaxBandwidth;
		} HTTP_BANDWIDTH_LIMIT_INFO;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #MaxBandwidth type: DWORDField new offset: 4.
	self byteSize: 8! !
!HTTP_BANDWIDTH_LIMIT_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

