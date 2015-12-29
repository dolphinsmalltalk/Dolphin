"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #MENUINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MENUINFO guid: (GUID fromString: '{D51F8F53-401E-4F12-9712-28458E3C48CA}')!
MENUINFO comment: 'MENUINFO is an <ExternalStructure> class to represent the Win32 structure of the same name. The MENUINFO structure suprises by containing information about a menu.'!
!MENUINFO categoriesForClass!External-Data-Structured-Win32! !
!MENUINFO methodsFor!

cyMax
	"Answer the receiver's cyMax field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cyMax)!

cyMax: anObject 
	"Set the receiver's cyMax field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cyMax) put: anObject!

dwContextHelpID
	"Answer the receiver's dwContextHelpID field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwContextHelpID)!

dwContextHelpID: anObject 
	"Set the receiver's dwContextHelpID field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwContextHelpID) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

dwStyle
	"Answer the receiver's dwStyle field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwStyle)!

dwStyle: anObject 
	"Set the receiver's dwStyle field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwStyle) put: anObject!

fMask
	"Answer the receiver's fMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #fMask)!

fMask: anObject 
	"Set the receiver's fMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #fMask) put: anObject!

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
		defineField: #dwMenuData type: UINT_PTRField filler! !
!MENUINFO class categoriesFor: #defineFields!initializing!public! !

