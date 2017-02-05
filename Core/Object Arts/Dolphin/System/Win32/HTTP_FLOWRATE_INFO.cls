"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_FLOWRATE_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_FLOWRATE_INFO guid: (GUID fromString: '{C2FAD8F6-F179-4BBB-A5F2-073C416F6704}')!
HTTP_FLOWRATE_INFO comment: '<HTTP_FLOWRATE_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_FLOWRATE_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The transfer rate of a response."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(C2FAD8F6-F179-4BBB-A5F2-073C416F6704), helpstring("The transfer rate of a response.")]
struct tagHTTP_FLOWRATE_INFO {
	HTTP_PROPERTY_FLAGS flags;
	unsigned long MaxBandwidth;
	unsigned long MaxPeakBandwidth;
	unsigned long BurstSize;
} HTTP_FLOWRATE_INFO;
'!
!HTTP_FLOWRATE_INFO categoriesForClass!Win32-Structs! !
!HTTP_FLOWRATE_INFO methodsFor!

BurstSize
	"Answer the receiver's BurstSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #BurstSize)!

BurstSize: anObject
	"Set the receiver's BurstSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #BurstSize) put: anObject!

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

	bytes dwordAtOffset: ##(self offsetOf: #MaxBandwidth) put: anObject!

MaxPeakBandwidth
	"Answer the receiver's MaxPeakBandwidth field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #MaxPeakBandwidth)!

MaxPeakBandwidth: anObject
	"Set the receiver's MaxPeakBandwidth field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #MaxPeakBandwidth) put: anObject! !
!HTTP_FLOWRATE_INFO categoriesFor: #BurstSize!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #BurstSize:!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #MaxBandwidth!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #MaxBandwidth:!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #MaxPeakBandwidth!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #MaxPeakBandwidth:!**compiled accessors**!public! !

!HTTP_FLOWRATE_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_FLOWRATE_INFO structure.

	HTTP_FLOWRATE_INFO  compileDefinition

		typedef [uuid(C2FAD8F6-F179-4BBB-A5F2-073C416F6704), helpstring('The transfer rate of a response.')]
		struct tagHTTP_FLOWRATE_INFO {
			HTTP_PROPERTY_FLAGS flags;
			unsigned long MaxBandwidth;
			unsigned long MaxPeakBandwidth;
			unsigned long BurstSize;
		} HTTP_FLOWRATE_INFO;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #MaxBandwidth type: DWORDField new offset: 4;
		defineField: #MaxPeakBandwidth type: DWORDField new offset: 8;
		defineField: #BurstSize type: DWORDField new offset: 12.
	self byteSize: 16! !
!HTTP_FLOWRATE_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

