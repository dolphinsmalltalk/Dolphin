"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #MENUITEMINFOA
	instanceVariableNames: 'text'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MENUITEMINFOA guid: (GUID fromString: '{D9F31567-D705-4885-9ED7-F92AE9FEFBF2}')!
MENUITEMINFOA comment: '<MENUITEMINFOA> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

See the Win32 SDK documentation for further information.'!
!MENUITEMINFOA categoriesForClass!External-Data-Structured-Win32! !
!MENUITEMINFOA methodsFor!

basicText: aString
	"Private - Set the menu item text to be the <readableString> argument, aString."

	text := aString.
	self 
		dwTypeData: text
		"; cch: text size"	"It isn't necessary to set this"!

commandMenuItem: aCommandMenuItem 
	self basicText: aCommandMenuItem text.
	self
		fType: (MFT_STRING bitOr: aCommandMenuItem styleFlags);
		wID: aCommandMenuItem id;
		fMask: ##(MIIM_TYPE | MIIM_ID)!

dwItemData: anObject 
	"Set the receiver's dwItemData field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #dwItemData) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

dwTypeData
	"Answer the receiver's dwTypeData field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #dwTypeData))!

dwTypeData: anObject 
	"Set the receiver's dwTypeData field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #dwTypeData) put: anObject yourAddress!

fMask
	"Answer the receiver's fMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #fMask)!

fMask: anObject 
	"Set the receiver's fMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #fMask) put: anObject!

fState
	"Answer the receiver's fState field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #fState)!

fState: anObject 
	"Set the receiver's fState field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #fState) put: anObject!

fType
	"Answer the receiver's fType field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #fType)!

fType: anObject 
	"Set the receiver's fType field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #fType) put: anObject!

hbmpChecked: anObject 
	"Set the receiver's hbmpChecked field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hbmpChecked) put: anObject!

hbmpUnchecked: anObject 
	"Set the receiver's hbmpUnchecked field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hbmpUnchecked) put: anObject!

hSubMenu: anObject 
	"Set the receiver's hSubMenu field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hSubMenu) put: anObject!

maskOut: anInteger
	"Private - Reset the specified contents mask flags. This specifies to Windows which
	information should be retrieved or set (i.e. which members of the structure are
	to be populated or are valid)."

	self fMask: (self fMask maskClear: anInteger)!

menuItem: aMenuItem text: aStringOrNil state: anInteger 
	"Private - Update the details for a normal menu item (i.e. the text, type flags, and state).
	This message is used when dynamically updating menu items."

	| mask |
	mask := aStringOrNil isNil 
				ifTrue: 
					["Note that we can't set the type if not changing the text"

					MIIM_STATE]
				ifFalse: 
					[self
						fType: (MFT_STRING bitOr: aMenuItem styleFlags);
						basicText: aStringOrNil.
					##(MIIM_STATE | MIIM_TYPE)].
	self
		fState: anInteger;
		fMask: mask!

subMenu: aMenuOrHandle text: aString
	"Private - Set menu insertion details for a Sub-menu."

	self 
		fType: MFT_STRING;
		basicText: aString;
		hSubMenu: aMenuOrHandle asParameter;
		fMask: ##(MIIM_SUBMENU|MIIM_TYPE)!

type: anInteger
	"Private - Set the fType field only.
	Note that on Win95 and NT4 the type can't really be set independently of the text
	because of the use of a shared mask (MIIM_TYPE) for both."

	self 
		fType: anInteger;
		fMask: MIIM_TYPE!

wID
	"Answer the receiver's wID field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #wID)!

wID: anObject 
	"Set the receiver's wID field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #wID) put: anObject! !
!MENUITEMINFOA categoriesFor: #basicText:!accessing!private! !
!MENUITEMINFOA categoriesFor: #commandMenuItem:!initializing!private! !
!MENUITEMINFOA categoriesFor: #dwItemData:!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #dwSize:!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #dwTypeData!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #dwTypeData:!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #fMask!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #fMask:!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #fState!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #fState:!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #fType!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #fType:!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #hbmpChecked:!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #hbmpUnchecked:!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #hSubMenu:!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #maskOut:!accessing!private! !
!MENUITEMINFOA categoriesFor: #menuItem:text:state:!accessing!private! !
!MENUITEMINFOA categoriesFor: #subMenu:text:!accessing!private! !
!MENUITEMINFOA categoriesFor: #type:!accessing!private! !
!MENUITEMINFOA categoriesFor: #wID!**compiled accessors**!public! !
!MENUITEMINFOA categoriesFor: #wID:!**compiled accessors**!public! !

!MENUITEMINFOA class methodsFor!

defineFields
	"Define the fields of the MENUITEMINFOA structure.
		MENUITEMINFOA compileDefinition
	
		typedef 		struct tagMENUITEMINFOA {
			unsigned int cbSize;
			unsigned int fMask;
			unsigned int fType;
			unsigned int fState;
			unsigned int wID;
			HMENU hSubMenu;
			HBITMAP hbmpChecked;
			HBITMAP hbmpUnchecked;
			ULONG_PTR dwItemData;
			LPSTR dwTypeData;
			unsigned int cch;
		} MENUITEMINFOA;
	"

	self
		defineField: #dwSize type: DWORDField writeOnly;
		defineField: #fMask type: DWORDField new;
		defineField: #fType type: DWORDField new;
		defineField: #fState type: DWORDField new;
		defineField: #wID type: DWORDField new;
		defineField: #hSubMenu type: HANDLEField writeOnly;
		defineField: #hbmpChecked type: HANDLEField writeOnly;
		defineField: #hbmpUnchecked type: HANDLEField writeOnly;
		defineField: #dwItemData type: UINT_PTRField writeOnly;
		defineField: #dwTypeData type: (PointerField type: String);
		defineField: #cch type: DWORDField new beFiller	"Rename to override superclass accessor"!

new
	"Answer a new subinstance of the receiver of a type appropriate for the host OS."

	^(SystemMetrics current hasMenuImages ifTrue: [MENUITEMINFOV5] ifFalse: [MENUITEMINFOA]) newBuffer! !
!MENUITEMINFOA class categoriesFor: #defineFields!initializing!public! !
!MENUITEMINFOA class categoriesFor: #new!instance creation!public! !

