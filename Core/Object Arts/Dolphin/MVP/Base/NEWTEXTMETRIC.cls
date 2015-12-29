"Filed out from Dolphin Smalltalk X6.1"!

TEXTMETRIC subclass: #NEWTEXTMETRIC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NEWTEXTMETRIC guid: (GUID fromString: '{5A49E86C-3D79-4C3D-B5BE-65A1B21F73ED}')!
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

