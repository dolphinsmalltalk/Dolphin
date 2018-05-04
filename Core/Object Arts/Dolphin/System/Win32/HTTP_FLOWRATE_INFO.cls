"Filed out from Dolphin Smalltalk 7"!

HttpQosSetting subclass: #HTTP_FLOWRATE_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_FLOWRATE_INFO guid: (GUID fromString: '{c2fad8f6-f179-4bbb-a5f2-073c416f6704}')!
HTTP_FLOWRATE_INFO comment: '<HTTP_FLOWRATE_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_FLOWRATE_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"The transfer rate of a response."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(c2fad8f6-f179-4bbb-a5f2-073c416f6704), helpstring("The transfer rate of a response.")]
struct tagHTTP_FLOWRATE_INFO {
	[nonbrowsable, helpstring("Specifies whether the property is present.")] HTTP_PROPERTY_FLAGS;
	[helpstring("The maximum bandwidth represented in bytes/second. This is the maximum bandwidth for the response after the burst content, whose size is specified in BurstSize, has been sent.")] ULONG MaxBandwidth;
	[helpstring("The peak bandwidth represented in bytes/second. This is the maximum bandwidth at which the burst is delivered.")] ULONG MaxPeakBandwidth;
	[helpstring("The size of the content, in bytes, to be delivered at MaxPeakBandwidth. Once this content has been delivered, the response is throttled at MaxBandwidth.")] ULONG BurstSize;
} HTTP_FLOWRATE_INFO;
'!
!HTTP_FLOWRATE_INFO categoriesForClass!WinHttpServer-Structs! !
!HTTP_FLOWRATE_INFO methodsFor!

BurstSize
	"Answer the <Integer> value of the receiver's 'BurstSize' field."

	^bytes dwordAtOffset: ##(self offsetOf: #BurstSize)!

BurstSize: anInteger
	"Set the receiver's 'BurstSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #BurstSize) put: anInteger!

MaxBandwidth
	"Answer the <Integer> value of the receiver's 'MaxBandwidth' field."

	^bytes dwordAtOffset: ##(self offsetOf: #MaxBandwidth)!

MaxBandwidth: anInteger
	"Set the receiver's 'MaxBandwidth' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #MaxBandwidth) put: anInteger!

MaxPeakBandwidth
	"Answer the <Integer> value of the receiver's 'MaxPeakBandwidth' field."

	^bytes dwordAtOffset: ##(self offsetOf: #MaxPeakBandwidth)!

MaxPeakBandwidth: anInteger
	"Set the receiver's 'MaxPeakBandwidth' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #MaxPeakBandwidth) put: anInteger! !
!HTTP_FLOWRATE_INFO categoriesFor: #BurstSize!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #BurstSize:!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #MaxBandwidth!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #MaxBandwidth:!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #MaxPeakBandwidth!**compiled accessors**!public! !
!HTTP_FLOWRATE_INFO categoriesFor: #MaxPeakBandwidth:!**compiled accessors**!public! !

!HTTP_FLOWRATE_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_FLOWRATE_INFO structure.

	HTTP_FLOWRATE_INFO compileDefinition

		typedef [uuid(c2fad8f6-f179-4bbb-a5f2-073c416f6704), helpstring('The transfer rate of a response.')]
		struct tagHTTP_FLOWRATE_INFO {
			[nonbrowsable, helpstring('Specifies whether the property is present.')] HTTP_PROPERTY_FLAGS;
			[helpstring('The maximum bandwidth represented in bytes/second. This is the maximum bandwidth for the response after the burst content, whose size is specified in BurstSize, has been sent.')] ULONG MaxBandwidth;
			[helpstring('The peak bandwidth represented in bytes/second. This is the maximum bandwidth at which the burst is delivered.')] ULONG MaxPeakBandwidth;
			[helpstring('The size of the content, in bytes, to be delivered at MaxPeakBandwidth. Once this content has been delivered, the response is throttled at MaxBandwidth.')] ULONG BurstSize;
		} HTTP_FLOWRATE_INFO;
"

	super defineFields.
	self
		defineField: #MaxBandwidth type: DWORDField new offset: 4;
		defineField: #MaxPeakBandwidth type: DWORDField new offset: 8;
		defineField: #BurstSize type: DWORDField new offset: 12.
	self byteSize: 16!

maxBandwidth: maxInteger maxPeakBandwidth: peakInteger burstSize: burstInteger
	^(self new)
		BurstSize: burstInteger;
		MaxBandwidth: maxInteger;
		MaxPeakBandwidth: peakInteger;
		Present: 1;
		yourself!

qosType
	^HttpQosSettingTypeFlowRate! !
!HTTP_FLOWRATE_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!HTTP_FLOWRATE_INFO class categoriesFor: #maxBandwidth:maxPeakBandwidth:burstSize:!constants!instance creation!public! !
!HTTP_FLOWRATE_INFO class categoriesFor: #qosType!constants!public! !

