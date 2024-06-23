"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.MENUINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_MENUINFO_Size' -> 16r1C.
			'_OffsetOf_cyMax' -> 16rC.
			'_OffsetOf_dwContextHelpID' -> 16r14.
			'_OffsetOf_dwMenuData' -> 16r18.
			'_OffsetOf_dwStyle' -> 16r8.
			'_OffsetOf_fMask' -> 16r4.
			'_OffsetOf_hbrBack' -> 16r10.
			'MIM_APPLYTOSUBMENUS' -> 16r80000000.
			'MIM_BACKGROUND' -> 16r2.
			'MIM_HELPID' -> 16r4.
			'MIM_MAXHEIGHT' -> 16r1.
			'MIM_MENUDATA' -> 16r8.
			'MIM_STYLE' -> 16r10.
			'MNS_AUTODISMISS' -> 16r10000000.
			'MNS_CHECKORBMP' -> 16r4000000.
			'MNS_DRAGDROP' -> 16r20000000.
			'MNS_MODELESS' -> 16r40000000.
			'MNS_NOCHECK' -> 16r80000000.
			'MNS_NOTIFYBYPOS' -> 16r8000000
		}!

OS.MENUINFO guid: (Core.GUID fromString: '{d51f8f53-401e-4f12-9712-28458e3c48ca}')!

OS.MENUINFO comment: 'MENUINFO is an <ExternalStructure> class to represent the Win32 structure of the same name. The MENUINFO structure suprises by containing information about a menu.'!

!OS.MENUINFO categoriesForClass!External-Data-Structured-Win32! !

!OS.MENUINFO methodsFor!

cyMax
	"Answer the <Integer> value of the receiver's 'cyMax' field."

	^bytes uint32AtOffset: _OffsetOf_cyMax!

cyMax: anInteger
	"Set the receiver's 'cyMax' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cyMax put: anInteger!

dwContextHelpID
	"Answer the <Integer> value of the receiver's 'dwContextHelpID' field."

	^bytes uint32AtOffset: _OffsetOf_dwContextHelpID!

dwContextHelpID: anInteger
	"Set the receiver's 'dwContextHelpID' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwContextHelpID put: anInteger!

dwStyle
	"Answer the <Integer> value of the receiver's 'dwStyle' field."

	^bytes uint32AtOffset: _OffsetOf_dwStyle!

dwStyle: anInteger
	"Set the receiver's 'dwStyle' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwStyle put: anInteger!

fMask
	"Answer the <Integer> value of the receiver's 'fMask' field."

	^bytes uint32AtOffset: _OffsetOf_fMask!

fMask: anInteger
	"Set the receiver's 'fMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_fMask put: anInteger!

maskIn: anInteger
	bytes uint32AtOffset: _OffsetOf_fMask put: ((bytes uint32AtOffset: _OffsetOf_fMask) bitOr: anInteger)!

style: anInteger
	bytes uint32AtOffset: _OffsetOf_dwStyle put: anInteger.
	self maskIn: MIM_STYLE! !

!OS.MENUINFO categoriesForMethods!
cyMax!**compiled accessors**!public! !
cyMax:!**compiled accessors**!public! !
dwContextHelpID!**compiled accessors**!public! !
dwContextHelpID:!**compiled accessors**!public! !
dwStyle!**compiled accessors**!public! !
dwStyle:!**compiled accessors**!public! !
fMask!**compiled accessors**!public! !
fMask:!**compiled accessors**!public! !
maskIn:!accessing!private! !
style:!accessing!public! !
!

!OS.MENUINFO class methodsFor!

byteSize
	^_MENUINFO_Size!

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

	super defineFields.
	self
		defineField: #fMask type: UInt32Field new;
		defineField: #dwStyle type: UInt32Field new;
		defineField: #cyMax type: UInt32Field new;
		defineField: #hbrBack type: HANDLEField filler;
		defineField: #dwContextHelpID type: UInt32Field new;
		defineField: #dwMenuData type: UIntPtrField filler!

getFieldNames
	^#(#dwSize #fMask #dwStyle #cyMax #dwContextHelpID)! !

!OS.MENUINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

