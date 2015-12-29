"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPAUDIOBUFFERINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPAUDIOBUFFERINFO guid: (GUID fromString: '{A2431A7E-AB79-4CB5-9AA4-B33D33C38201}')!
SPAUDIOBUFFERINFO comment: '<SPAUDIOBUFFERINFO> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPAUDIOBUFFERINFO'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPAUDIOBUFFERINFO {
	unsigned long ulMsMinNotification;
	unsigned long ulMsBufferSize;
	unsigned long ulMsEventBias;
} SPAUDIOBUFFERINFO;
'!
!SPAUDIOBUFFERINFO categoriesForClass!SpeechLib-Structs! !
!SPAUDIOBUFFERINFO methodsFor!

ulMsBufferSize
	"Answer the receiver's ulMsBufferSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

ulMsBufferSize: anObject
	"Set the receiver's ulMsBufferSize field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

ulMsEventBias
	"Answer the receiver's ulMsEventBias field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

ulMsEventBias: anObject
	"Set the receiver's ulMsEventBias field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

ulMsMinNotification
	"Answer the receiver's ulMsMinNotification field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

ulMsMinNotification: anObject
	"Set the receiver's ulMsMinNotification field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!SPAUDIOBUFFERINFO categoriesFor: #ulMsBufferSize!**compiled accessors**!public! !
!SPAUDIOBUFFERINFO categoriesFor: #ulMsBufferSize:!**compiled accessors**!public! !
!SPAUDIOBUFFERINFO categoriesFor: #ulMsEventBias!**compiled accessors**!public! !
!SPAUDIOBUFFERINFO categoriesFor: #ulMsEventBias:!**compiled accessors**!public! !
!SPAUDIOBUFFERINFO categoriesFor: #ulMsMinNotification!**compiled accessors**!public! !
!SPAUDIOBUFFERINFO categoriesFor: #ulMsMinNotification:!**compiled accessors**!public! !

!SPAUDIOBUFFERINFO class methodsFor!

defineFields
	"Define the fields of the SPAUDIOBUFFERINFO structure.
		SPAUDIOBUFFERINFO compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPAUDIOBUFFERINFO {
			unsigned long ulMsMinNotification;
			unsigned long ulMsBufferSize;
			unsigned long ulMsEventBias;
		} SPAUDIOBUFFERINFO;
"

	self
		defineField: #ulMsMinNotification type: DWORDField new offset: 0;
		defineField: #ulMsBufferSize type: DWORDField new offset: 4;
		defineField: #ulMsEventBias type: DWORDField new offset: 8.
	self byteSize: 12!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 175! !
!SPAUDIOBUFFERINFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPAUDIOBUFFERINFO class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

