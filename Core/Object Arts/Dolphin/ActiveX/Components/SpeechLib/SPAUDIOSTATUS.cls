"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #SPAUDIOSTATUS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SPAUDIOSTATUS guid: (GUID fromString: '{4129A18F-7568-418B-B743-70B4440E606B}')!
SPAUDIOSTATUS comment: '<SPAUDIOSTATUS> is an <ExternalStructure> class to wrap the struct ''SpeechLib.SPAUDIOSTATUS'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagSPAUDIOSTATUS {
	long cbFreeBuffSpace;
	unsigned long cbNonBlockingIO;
	SPAUDIOSTATE State;
	unsigned __int64 CurSeekPos;
	unsigned __int64 CurDevicePos;
	unsigned long dwReserved1;
	unsigned long dwReserved2;
} SPAUDIOSTATUS;
'!
!SPAUDIOSTATUS categoriesForClass!SpeechLib-Structs! !
!SPAUDIOSTATUS methodsFor!

cbFreeBuffSpace
	"Answer the receiver's cbFreeBuffSpace field as a Smalltalk object."

	^(bytes sdwordAtOffset: 0)!

cbFreeBuffSpace: anObject
	"Set the receiver's cbFreeBuffSpace field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

cbNonBlockingIO
	"Answer the receiver's cbNonBlockingIO field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

cbNonBlockingIO: anObject
	"Set the receiver's cbNonBlockingIO field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

CurDevicePos
	"Answer the receiver's CurDevicePos field as a Smalltalk object."

	^(bytes qwordAtOffset: 24)!

CurDevicePos: anObject
	"Set the receiver's CurDevicePos field to the value of anObject."

	bytes qwordAtOffset: 24 put: anObject!

CurSeekPos
	"Answer the receiver's CurSeekPos field as a Smalltalk object."

	^(bytes qwordAtOffset: 16)!

CurSeekPos: anObject
	"Set the receiver's CurSeekPos field to the value of anObject."

	bytes qwordAtOffset: 16 put: anObject!

dwReserved1
	"Answer the receiver's dwReserved1 field as a Smalltalk object."

	^(bytes dwordAtOffset: 32)!

dwReserved1: anObject
	"Set the receiver's dwReserved1 field to the value of anObject."

	bytes dwordAtOffset: 32 put: anObject!

dwReserved2
	"Answer the receiver's dwReserved2 field as a Smalltalk object."

	^(bytes dwordAtOffset: 36)!

dwReserved2: anObject
	"Set the receiver's dwReserved2 field to the value of anObject."

	bytes dwordAtOffset: 36 put: anObject!

State
	"Answer the receiver's State field as a Smalltalk object."

	^(bytes sdwordAtOffset: 8)!

State: anObject
	"Set the receiver's State field to the value of anObject."

	bytes sdwordAtOffset: 8 put: anObject! !
!SPAUDIOSTATUS categoriesFor: #cbFreeBuffSpace!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #cbFreeBuffSpace:!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #cbNonBlockingIO!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #cbNonBlockingIO:!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #CurDevicePos!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #CurDevicePos:!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #CurSeekPos!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #CurSeekPos:!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #dwReserved1!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #dwReserved1:!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #dwReserved2!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #dwReserved2:!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #State!**compiled accessors**!public! !
!SPAUDIOSTATUS categoriesFor: #State:!**compiled accessors**!public! !

!SPAUDIOSTATUS class methodsFor!

defineFields
	"Define the fields of the SPAUDIOSTATUS structure.
		SPAUDIOSTATUS compileDefinition
	
		typedef [hidden, restricted]
		struct tagSPAUDIOSTATUS {
			long cbFreeBuffSpace;
			unsigned long cbNonBlockingIO;
			SPAUDIOSTATE State;
			unsigned __int64 CurSeekPos;
			unsigned __int64 CurDevicePos;
			unsigned long dwReserved1;
			unsigned long dwReserved2;
		} SPAUDIOSTATUS;
"

	self
		defineField: #cbFreeBuffSpace type: SDWORDField new offset: 0;
		defineField: #cbNonBlockingIO type: DWORDField new offset: 4;
		defineField: #State type: SDWORDField new offset: 8;
		defineField: #CurSeekPos type: QWORDField new offset: 16;
		defineField: #CurDevicePos type: QWORDField new offset: 24;
		defineField: #dwReserved1 type: DWORDField new offset: 32;
		defineField: #dwReserved2 type: DWORDField new offset: 36.
	self byteSize: 40!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 174! !
!SPAUDIOSTATUS class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SPAUDIOSTATUS class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

