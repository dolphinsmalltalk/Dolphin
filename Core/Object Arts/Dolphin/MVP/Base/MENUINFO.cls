"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #MENUINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MENUINFO guid: (GUID fromString: '{d51f8f53-401e-4f12-9712-28458e3c48ca}')!
MENUINFO comment: 'MENUINFO is an <ExternalStructure> class to represent the Win32 structure of the same name. The MENUINFO structure suprises by containing information about a menu.'!
!MENUINFO categoriesForClass!External-Data-Structured-Win32! !
!MENUINFO methodsFor!

cyMax
	"Answer the <Integer> value of the receiver's 'cyMax' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cyMax)!

cyMax: anInteger
	"Set the receiver's 'cyMax' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cyMax) put: anInteger!

dwContextHelpID
	"Answer the <Integer> value of the receiver's 'dwContextHelpID' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwContextHelpID)!

dwContextHelpID: anInteger
	"Set the receiver's 'dwContextHelpID' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwContextHelpID) put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

dwStyle
	"Answer the <Integer> value of the receiver's 'dwStyle' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwStyle)!

dwStyle: anInteger
	"Set the receiver's 'dwStyle' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwStyle) put: anInteger!

fMask
	"Answer the <Integer> value of the receiver's 'fMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #fMask)!

fMask: anInteger
	"Set the receiver's 'fMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #fMask) put: anInteger!

maskIn: anInteger 
	self fMask: (self fMask bitOr: anInteger)!

style: anInteger 
	self dwStyle: anInteger.
	self maskIn: MIM_STYLE! !
!MENUINFO categoriesFor: #cyMax!**compiled accessors**!public! !
!MENUINFO categoriesFor: #cyMax:!**compiled accessors**!public! !
!MENUINFO categoriesFor: #dwContextHelpID!**compiled accessors**!public! !
!MENUINFO categoriesFor: #dwContextHelpID:!**compiled accessors**!public! !
!MENUINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!MENUINFO categoriesFor: #dwStyle!**compiled accessors**!public! !
!MENUINFO categoriesFor: #dwStyle:!**compiled accessors**!public! !
!MENUINFO categoriesFor: #fMask!**compiled accessors**!public! !
!MENUINFO categoriesFor: #fMask:!**compiled accessors**!public! !
!MENUINFO categoriesFor: #maskIn:!accessing!private! !
!MENUINFO categoriesFor: #style:!accessing!public! !

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
!MENUINFO class categoriesFor: #defineFields!initializing!public! !
!MENUINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

