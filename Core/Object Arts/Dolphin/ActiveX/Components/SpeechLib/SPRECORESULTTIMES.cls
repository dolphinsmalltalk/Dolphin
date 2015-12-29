"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPRECORESULTTIMES
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPRECORESULTTIMES guid: (GUID fromString: '{CAE03167-9B57-42AC-A6ED-B53F369AB998}')!
SPRECORESULTTIMES comment: '<SPRECORESULTTIMES> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPRECORESULTTIMES'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPRECORESULTTIMES {
	FILETIME ftStreamTime;
	unsigned __int64 ullLength;
	unsigned long dwTickCount;
	unsigned __int64 ullStart;
} SPRECORESULTTIMES;
'!
!SPRECORESULTTIMES categoriesForClass!SpeechLib-Structs! !
!SPRECORESULTTIMES methodsFor!

dwTickCount
	"Answer the receiver's dwTickCount field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

dwTickCount: anObject
	"Set the receiver's dwTickCount field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject!

ftStreamTime
	"Answer the receiver's ftStreamTime field as a Smalltalk object."

	^FILETIME fromAddress: (bytes yourAddress)!

ftStreamTime: anObject
	"Set the receiver's ftStreamTime field to the value of anObject."

	anObject replaceBytesOf: bytes from: 1 to: 8 startingAt: 1!

ullLength
	"Answer the receiver's ullLength field as a Smalltalk object."

	^(bytes qwordAtOffset: 8)!

ullLength: anObject
	"Set the receiver's ullLength field to the value of anObject."

	bytes qwordAtOffset: 8 put: anObject!

ullStart
	"Answer the receiver's ullStart field as a Smalltalk object."

	^(bytes qwordAtOffset: 24)!

ullStart: anObject
	"Set the receiver's ullStart field to the value of anObject."

	bytes qwordAtOffset: 24 put: anObject! !
!SPRECORESULTTIMES categoriesFor: #dwTickCount!**compiled accessors**!public! !
!SPRECORESULTTIMES categoriesFor: #dwTickCount:!**compiled accessors**!public! !
!SPRECORESULTTIMES categoriesFor: #ftStreamTime!**compiled accessors**!public! !
!SPRECORESULTTIMES categoriesFor: #ftStreamTime:!**compiled accessors**!public! !
!SPRECORESULTTIMES categoriesFor: #ullLength!**compiled accessors**!public! !
!SPRECORESULTTIMES categoriesFor: #ullLength:!**compiled accessors**!public! !
!SPRECORESULTTIMES categoriesFor: #ullStart!**compiled accessors**!public! !
!SPRECORESULTTIMES categoriesFor: #ullStart:!**compiled accessors**!public! !

!SPRECORESULTTIMES class methodsFor!

defineFields
	"Define the fields of the SPRECORESULTTIMES structure.
		SPRECORESULTTIMES compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPRECORESULTTIMES {
			FILETIME ftStreamTime;
			unsigned __int64 ullLength;
			unsigned long dwTickCount;
			unsigned __int64 ullStart;
		} SPRECORESULTTIMES;
"

	self
		defineField: #ftStreamTime type: (StructureField type: FILETIME) offset: 0;
		defineField: #ullLength type: QWORDField new offset: 8;
		defineField: #dwTickCount type: DWORDField new offset: 16;
		defineField: #ullStart type: QWORDField new offset: 24.
	self byteSize: 32!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 219! !
!SPRECORESULTTIMES class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPRECORESULTTIMES class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

