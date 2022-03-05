"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #MENUINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cyMax _OffsetOf_dwContextHelpID _OffsetOf_dwMenuData _OffsetOf_dwSize _OffsetOf_dwStyle _OffsetOf_fMask _OffsetOf_hbrBack'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MENUINFO guid: (GUID fromString: '{d51f8f53-401e-4f12-9712-28458e3c48ca}')!
MENUINFO addClassConstant: '_OffsetOf_cyMax' value: 16rC!
MENUINFO addClassConstant: '_OffsetOf_dwContextHelpID' value: 16r14!
MENUINFO addClassConstant: '_OffsetOf_dwMenuData' value: 16r18!
MENUINFO addClassConstant: '_OffsetOf_dwSize' value: 16r0!
MENUINFO addClassConstant: '_OffsetOf_dwStyle' value: 16r8!
MENUINFO addClassConstant: '_OffsetOf_fMask' value: 16r4!
MENUINFO addClassConstant: '_OffsetOf_hbrBack' value: 16r10!
MENUINFO comment: 'MENUINFO is an <ExternalStructure> class to represent the Win32 structure of the same name. The MENUINFO structure suprises by containing information about a menu.'!
!MENUINFO categoriesForClass!External-Data-Structured-Win32! !
!MENUINFO methodsFor!

cyMax
	"Answer the <Integer> value of the receiver's 'cyMax' field."

	^bytes dwordAtOffset: _OffsetOf_cyMax!

cyMax: anInteger
	"Set the receiver's 'cyMax' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cyMax put: anInteger!

dwContextHelpID
	"Answer the <Integer> value of the receiver's 'dwContextHelpID' field."

	^bytes dwordAtOffset: _OffsetOf_dwContextHelpID!

dwContextHelpID: anInteger
	"Set the receiver's 'dwContextHelpID' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwContextHelpID put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

dwStyle
	"Answer the <Integer> value of the receiver's 'dwStyle' field."

	^bytes dwordAtOffset: _OffsetOf_dwStyle!

dwStyle: anInteger
	"Set the receiver's 'dwStyle' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwStyle put: anInteger!

fMask
	"Answer the <Integer> value of the receiver's 'fMask' field."

	^bytes dwordAtOffset: _OffsetOf_fMask!

fMask: anInteger
	"Set the receiver's 'fMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_fMask put: anInteger!

maskIn: anInteger 
	self fMask: (self fMask bitOr: anInteger)!

style: anInteger 
	self dwStyle: anInteger.
	self maskIn: MIM_STYLE! !
!MENUINFO categoriesForMethods!
cyMax!**compiled accessors**!public! !
cyMax:!**compiled accessors**!public! !
dwContextHelpID!**compiled accessors**!public! !
dwContextHelpID:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
dwStyle!**compiled accessors**!public! !
dwStyle:!**compiled accessors**!public! !
fMask!**compiled accessors**!public! !
fMask:!**compiled accessors**!public! !
maskIn:!accessing!private! !
style:!accessing!public! !
!

!MENUINFO class methodsFor!

defineFields
	"Define the fields of the MENUINFO structure.
		MENUINFO compileDefinition
	
		struct {
			unsigned int cbSize;
			unsigned int fMask;
			unsigned int dwStyle;
			unsigned int cyMax;
			HBRUSH hbrBack;
 			DWORD dwContextHelpID;
			ULONG_PTR dwMenuData;
		} MENUINFO;
	"

	"Implementation Note: cbSize is renamed to dwSize to override superclass accessor"

	self
		defineField: #dwSize type: DWORDField writeOnly;
		defineField: #fMask type: DWORDField new;
		defineField: #dwStyle type: DWORDField new;
		defineField: #cyMax type: DWORDField new;
		defineField: #hbrBack type: HANDLEField filler;
		defineField: #dwContextHelpID type: DWORDField new;
		defineField: #dwMenuData type: UINT_PTRField filler!

getFieldNames
	^#(#dwSize #fMask #dwStyle #cyMax #dwContextHelpID)! !
!MENUINFO class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

