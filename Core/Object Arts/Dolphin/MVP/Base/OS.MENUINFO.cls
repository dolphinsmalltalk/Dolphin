"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.MENUINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cyMax' -> 16rC.
		'_OffsetOf_dwContextHelpID' -> 16r14.
		'_OffsetOf_dwMenuData' -> 16r18.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_dwStyle' -> 16r8.
		'_OffsetOf_fMask' -> 16r4.
		'_OffsetOf_hbrBack' -> 16r10
	}!
OS.MENUINFO guid: (Core.GUID fromString: '{d51f8f53-401e-4f12-9712-28458e3c48ca}')!
OS.MENUINFO comment: 'MENUINFO is an <ExternalStructure> class to represent the Win32 structure of the same name. The MENUINFO structure suprises by containing information about a menu.'!
!OS.MENUINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.MENUINFO methodsFor!

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
!OS.MENUINFO categoriesFor: #cyMax!**compiled accessors**!public! !
!OS.MENUINFO categoriesFor: #cyMax:!**compiled accessors**!public! !
!OS.MENUINFO categoriesFor: #dwContextHelpID!**compiled accessors**!public! !
!OS.MENUINFO categoriesFor: #dwContextHelpID:!**compiled accessors**!public! !
!OS.MENUINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!OS.MENUINFO categoriesFor: #dwStyle!**compiled accessors**!public! !
!OS.MENUINFO categoriesFor: #dwStyle:!**compiled accessors**!public! !
!OS.MENUINFO categoriesFor: #fMask!**compiled accessors**!public! !
!OS.MENUINFO categoriesFor: #fMask:!**compiled accessors**!public! !
!OS.MENUINFO categoriesFor: #maskIn:!accessing!private! !
!OS.MENUINFO categoriesFor: #style:!accessing!public! !

!OS.MENUINFO class methodsFor!

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
!OS.MENUINFO class categoriesFor: #defineFields!public!template definition! !
!OS.MENUINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

