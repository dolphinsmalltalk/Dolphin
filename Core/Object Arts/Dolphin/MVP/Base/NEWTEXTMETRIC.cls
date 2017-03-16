"Filed out from Dolphin Smalltalk 7"!

TEXTMETRIC subclass: #NEWTEXTMETRIC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NEWTEXTMETRIC guid: (GUID fromString: '{5a49e86c-3d79-4c3d-b5be-65a1b21f73ed}')!
NEWTEXTMETRIC comment: '<NEWTEXTMETRIC> is an <ExternalStructure> class to wrap the struct ''Win.NEWTEXTMETRIC'' from type information in the ''Windows API (ANSI)'' library.

IDL definition follows:

typedef 
struct tagNEWTEXTMETRIC {
	// ... TEXTMETRIC fields ...
	DWORD ntmFlags;
	UINT ntmSizeEM;
	UINT ntmCellHeight;
	UINT ntmAvgWidth;
} NEWTEXTMETRIC;
'!
!NEWTEXTMETRIC categoriesForClass!Win-Structs! !
!NEWTEXTMETRIC methodsFor!

ntmAvgWidth
	"Answer the receiver's ntmAvgWidth field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ntmAvgWidth)!

ntmCellHeight
	"Answer the receiver's ntmCellHeight field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ntmCellHeight)!

ntmFlags
	"Answer the receiver's ntmFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ntmFlags)!

ntmSizeEM
	"Answer the receiver's ntmSizeEM field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ntmSizeEM)! !
!NEWTEXTMETRIC categoriesFor: #ntmAvgWidth!**compiled accessors**!public! !
!NEWTEXTMETRIC categoriesFor: #ntmCellHeight!**compiled accessors**!public! !
!NEWTEXTMETRIC categoriesFor: #ntmFlags!**compiled accessors**!public! !
!NEWTEXTMETRIC categoriesFor: #ntmSizeEM!**compiled accessors**!public! !

!NEWTEXTMETRIC class methodsFor!

defineFields
	"Define the fields of the NEWTEXTMETRIC structure.
		NEWTEXTMETRIC compileDefinition
	
		typedef 
		struct tagNEWTEXTMETRIC {
			// ... all fields of TEXTMETRIC...
			long ntmFlags;
			int ntmSizeEM;
			int ntmCellHeight;
			int ntmAvgWidth;
		} NEWTEXTMETRIC;
"

	super defineFields.
	self
		defineField: #ntmFlags type: DWORDField readOnly;
		defineField: #ntmSizeEM type: DWORDField readOnly;
		defineField: #ntmCellHeight type: DWORDField readOnly;
		defineField: #ntmAvgWidth type: DWORDField readOnly! !
!NEWTEXTMETRIC class categoriesFor: #defineFields!initializing!public! !

