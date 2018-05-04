"Filed out from Dolphin Smalltalk 7"!

TEXTMETRICW subclass: #NEWTEXTMETRICW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NEWTEXTMETRICW guid: (GUID fromString: '{5a49e86c-3d79-4c3d-b5be-65a1b21f73ed}')!
NEWTEXTMETRICW comment: '<NEWTEXTMETRIC> is an <ExternalStructure> class to wrap the struct ''Win.NEWTEXTMETRIC'' from type information in the ''Windows API'' library.

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
!NEWTEXTMETRICW categoriesForClass!Win-Structs! !
!NEWTEXTMETRICW methodsFor!

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
!NEWTEXTMETRICW categoriesFor: #ntmAvgWidth!**compiled accessors**!public! !
!NEWTEXTMETRICW categoriesFor: #ntmCellHeight!**compiled accessors**!public! !
!NEWTEXTMETRICW categoriesFor: #ntmFlags!**compiled accessors**!public! !
!NEWTEXTMETRICW categoriesFor: #ntmSizeEM!**compiled accessors**!public! !

!NEWTEXTMETRICW class methodsFor!

defineFields
	"Define the fields of the NEWTEXTMETRIC structure.
		NEWTEXTMETRIC compileDefinition
	
		typedef 
		struct tagNEWTEXTMETRICW {
			// ... all fields of TEXTMETRIC...
			long ntmFlags;
			int ntmSizeEM;
			int ntmCellHeight;
			int ntmAvgWidth;
		} NEWTEXTMETRICW;
"

	super defineFields.
	self
		defineField: #ntmFlags type: DWORDField readOnly;
		defineField: #ntmSizeEM type: DWORDField readOnly;
		defineField: #ntmCellHeight type: DWORDField readOnly;
		defineField: #ntmAvgWidth type: DWORDField readOnly! !
!NEWTEXTMETRICW class categoriesFor: #defineFields!initializing!public! !

