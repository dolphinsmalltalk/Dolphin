"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #MENUITEMINFOW
	instanceVariableNames: 'text bitmap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MENUITEMINFOW guid: (GUID fromString: '{d9f31567-d705-4885-9ed7-f92ae9fefbf2}')!
MENUITEMINFOW comment: '<MENUITEMINFOA> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

See the Win32 SDK documentation for further information.'!
!MENUITEMINFOW categoriesForClass!External-Data-Structured-Win32! !
!MENUITEMINFOW methodsFor!

basicText: aString
	"Private - Set the menu item text to be the <readableString> argument, aString."

	text := aString asUtf16String.
	self dwTypeData: text
	"It has never been necessary to set the text size"
	"self cch: text size"!

cch: anInteger
	"Set the receiver's 'cch' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cch) put: anInteger!

commandMenuItem: aCommandMenuItem 
	| mask fType |
	mask := ##(MIIM_STRING | MIIM_ID).
	mask := mask bitOr: (self setImage: aCommandMenuItem).
	fType := aCommandMenuItem styleFlags.
	fType == 0 
		ifFalse: 
			[self fType: fType.
			mask := mask bitOr: MIIM_FTYPE].
	self
		basicText: aCommandMenuItem text;
		wID: aCommandMenuItem id;
		fMask: mask!

dwItemData: anInteger
	"Set the receiver's 'dwItemData' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: ##(self offsetOf: #dwItemData) put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

dwTypeData
	"Answer the <Utf16String> value of the receiver's 'dwTypeData' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #dwTypeData))!

dwTypeData: anUtf16String
	"Set the receiver's 'dwTypeData' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #dwTypeData) put: anUtf16String yourAddress!

fMask
	"Answer the <Integer> value of the receiver's 'fMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #fMask)!

fMask: anInteger
	"Set the receiver's 'fMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #fMask) put: anInteger!

fState
	"Answer the <Integer> value of the receiver's 'fState' field."

	^bytes dwordAtOffset: ##(self offsetOf: #fState)!

fState: anInteger
	"Set the receiver's 'fState' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #fState) put: anInteger!

fType
	"Answer the <Integer> value of the receiver's 'fType' field."

	^bytes dwordAtOffset: ##(self offsetOf: #fType)!

fType: anInteger
	"Set the receiver's 'fType' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #fType) put: anInteger!

hbmpChecked: anExternalHandle
	"Set the receiver's 'hbmpChecked' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hbmpChecked) put: anExternalHandle!

hbmpItem: anExternalHandle
	"Set the receiver's 'hbmpItem' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hbmpItem) put: anExternalHandle!

hbmpUnchecked: anExternalHandle
	"Set the receiver's 'hbmpUnchecked' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hbmpUnchecked) put: anExternalHandle!

hSubMenu: anExternalHandle
	"Set the receiver's 'hSubMenu' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hSubMenu) put: anExternalHandle!

maskOut: anInteger
	"Private - Reset the specified contents mask flags. This specifies to Windows which
	information should be retrieved or set (i.e. which members of the structure are
	to be populated or are valid)."

	self fMask: (self fMask maskClear: anInteger)!

menuItem: aMenuItem text: aStringOrNil state: stateInteger
	"Private - Update the details for a normal menu item (i.e. the text, type flags, and state).
	This message is used when dynamically updating menu items."

	| mask |
	mask := aStringOrNil isNil
				ifTrue: [##(MIIM_FTYPE | MIIM_STATE)]
				ifFalse: 
					[self basicText: aStringOrNil.
					##(MIIM_FTYPE | MIIM_STATE | MIIM_STRING)].
	mask := mask bitOr: (self setImage: aMenuItem).
	self
		fType: aMenuItem styleFlags;
		fState: stateInteger;
		fMask: mask
!

setImage: aCommandMenuItem
	^aCommandMenuItem image
		ifNil: [0]
		ifNotNil: 
			[:image |
			"Note that the menu doesn't take ownership of the bitmap. We are responsible
			for making sure it stays around long enough, and is freed when no longer
			needed."
			bitmap := image asMenuBitmap.
			self hbmpItem: bitmap handle.
			MIIM_BITMAP]!

subMenu: aMenu text: aString 
	"Private - Set menu insertion details for a Sub-menu."

	| mask |
	mask := ##(MIIM_SUBMENU | MIIM_STRING | MIIM_ID) bitOr: (self setImage: aMenu).
	self
		basicText: aString;
		wID: aMenu id;
		hSubMenu: aMenu asParameter;
		fMask: mask!

type: anInteger
	"Private - Set the fType field only. Used when creating menu items."

	self 
		fType: anInteger;
		fMask: MIIM_FTYPE!

type: flagsInteger text: aString id: idInteger
	"Private - Set insertion details for a normal menu item (i.e. the text, type flags, and id)."

	self
		fType: flagsInteger;
		basicText: aString;
		wID: idInteger;
		fMask: ##(MIIM_FTYPE | MIIM_STRING | MIIM_ID)!

wID
	"Answer the <Integer> value of the receiver's 'wID' field."

	^bytes dwordAtOffset: ##(self offsetOf: #wID)!

wID: anInteger
	"Set the receiver's 'wID' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #wID) put: anInteger! !
!MENUITEMINFOW categoriesFor: #basicText:!accessing!private! !
!MENUITEMINFOW categoriesFor: #cch:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #commandMenuItem:!initializing!private! !
!MENUITEMINFOW categoriesFor: #dwItemData:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #dwSize:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #dwTypeData!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #dwTypeData:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #fMask!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #fMask:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #fState!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #fState:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #fType!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #fType:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #hbmpChecked:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #hbmpItem:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #hbmpUnchecked:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #hSubMenu:!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #maskOut:!accessing!private! !
!MENUITEMINFOW categoriesFor: #menuItem:text:state:!accessing!private! !
!MENUITEMINFOW categoriesFor: #setImage:!helpers!private! !
!MENUITEMINFOW categoriesFor: #subMenu:text:!accessing!private! !
!MENUITEMINFOW categoriesFor: #type:!accessing!private! !
!MENUITEMINFOW categoriesFor: #type:text:id:!initializing!public! !
!MENUITEMINFOW categoriesFor: #wID!**compiled accessors**!public! !
!MENUITEMINFOW categoriesFor: #wID:!**compiled accessors**!public! !

!MENUITEMINFOW class methodsFor!

defineFields
	"Define the fields of the MENUITEMINFOW structure.
		self compileDefinition
	
		typedef 		struct tagMENUITEMINFOW {
			unsigned int cbSize;
			unsigned int fMask;
			unsigned int fType;
			unsigned int fState;
			unsigned int wID;
			HMENU hSubMenu;
			HBITMAP hbmpChecked;
			HBITMAP hbmpUnchecked;
			ULONG_PTR dwItemData;
			LPWSTR dwTypeData;
			unsigned int cch;
		} MENUITEMINFOW;
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
		defineField: #dwTypeData type: (PointerField type: Utf16String);
		defineField: #cch type: DWORDField writeOnly;
		defineField: #hbmpItem type: HANDLEField writeOnly! !
!MENUITEMINFOW class categoriesFor: #defineFields!initializing!public! !

