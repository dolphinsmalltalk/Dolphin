"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #MENUITEMINFOW
	instanceVariableNames: 'text bitmap'
	classVariableNames: '_OffsetOf_cch _OffsetOf_dwItemData _OffsetOf_dwSize _OffsetOf_dwTypeData _OffsetOf_fMask _OffsetOf_fState _OffsetOf_fType _OffsetOf_hbmpChecked _OffsetOf_hbmpItem _OffsetOf_hbmpUnchecked _OffsetOf_hSubMenu _OffsetOf_wID'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MENUITEMINFOW guid: (GUID fromString: '{d9f31567-d705-4885-9ed7-f92ae9fefbf2}')!

MENUITEMINFOW addClassConstant: '_OffsetOf_cch' value: 16r28!
MENUITEMINFOW addClassConstant: '_OffsetOf_dwItemData' value: 16r20!
MENUITEMINFOW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
MENUITEMINFOW addClassConstant: '_OffsetOf_dwTypeData' value: 16r24!
MENUITEMINFOW addClassConstant: '_OffsetOf_fMask' value: 16r4!
MENUITEMINFOW addClassConstant: '_OffsetOf_fState' value: 16rC!
MENUITEMINFOW addClassConstant: '_OffsetOf_fType' value: 16r8!
MENUITEMINFOW addClassConstant: '_OffsetOf_hbmpChecked' value: 16r18!
MENUITEMINFOW addClassConstant: '_OffsetOf_hbmpItem' value: 16r2C!
MENUITEMINFOW addClassConstant: '_OffsetOf_hbmpUnchecked' value: 16r1C!
MENUITEMINFOW addClassConstant: '_OffsetOf_hSubMenu' value: 16r14!
MENUITEMINFOW addClassConstant: '_OffsetOf_wID' value: 16r10!

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

	bytes dwordAtOffset: _OffsetOf_cch put: anInteger!

commandMenuItem: aCommandMenuItem metrics: aSystemMetrics
	| mask fType |
	mask := aCommandMenuItem image
				ifNil: [##(MIIM_STRING | MIIM_ID)]
				ifNotNil: 
					[:icon |
					self setImage: icon metrics: aSystemMetrics.
					##(MIIM_STRING | MIIM_ID | MIIM_BITMAP)].
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

	bytes uintPtrAtOffset: _OffsetOf_dwItemData put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

dwTypeData
	"Answer the <Utf16String> value of the receiver's 'dwTypeData' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_dwTypeData)!

dwTypeData: anUtf16String
	"Set the receiver's 'dwTypeData' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_dwTypeData put: anUtf16String yourAddress!

fMask
	"Answer the <Integer> value of the receiver's 'fMask' field."

	^bytes dwordAtOffset: _OffsetOf_fMask!

fMask: anInteger
	"Set the receiver's 'fMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_fMask put: anInteger!

fState
	"Answer the <Integer> value of the receiver's 'fState' field."

	^bytes dwordAtOffset: _OffsetOf_fState!

fState: anInteger
	"Set the receiver's 'fState' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_fState put: anInteger!

fType
	"Answer the <Integer> value of the receiver's 'fType' field."

	^bytes dwordAtOffset: _OffsetOf_fType!

fType: anInteger
	"Set the receiver's 'fType' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_fType put: anInteger!

hbmpChecked: anExternalHandle
	"Set the receiver's 'hbmpChecked' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbmpChecked put: anExternalHandle!

hbmpItem: anExternalHandle
	"Set the receiver's 'hbmpItem' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbmpItem put: anExternalHandle!

hbmpUnchecked: anExternalHandle
	"Set the receiver's 'hbmpUnchecked' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbmpUnchecked put: anExternalHandle!

hSubMenu: anExternalHandle
	"Set the receiver's 'hSubMenu' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hSubMenu put: anExternalHandle!

maskOut: anInteger
	"Private - Reset the specified contents mask flags. This specifies to Windows which
	information should be retrieved or set (i.e. which members of the structure are
	to be populated or are valid)."

	self fMask: (self fMask maskClear: anInteger)!

menuItem: aMenuItem text: aStringOrNil state: stateInteger metrics: aSystemMetrics
	"Private - Update the details for a normal menu item (i.e. the text, type flags, and state).
	This message is used when dynamically updating menu items."

	| mask |
	mask := aStringOrNil isNil
				ifTrue: [##(MIIM_FTYPE | MIIM_STATE)]
				ifFalse: 
					[self basicText: aStringOrNil.
					##(MIIM_FTYPE | MIIM_STATE | MIIM_STRING)].
	aMenuItem image
		ifNotNil: 
			[:icon |
			mask := mask bitOr: MIIM_BITMAP.
			self setImage: icon metrics: aSystemMetrics].
	self
		fType: aMenuItem styleFlags;
		fState: stateInteger;
		fMask: mask!

setImage: anIcon metrics: aSystemMetrics
	"Private - Populate the receiver with a command image."

	"We no longer use the HBMMENU_CALLBACK method with the menu images drawn on demand by Menu>>drawItemImage:on:at:disabled:, because that approach causes themed menus to be disabled. It seems a retrograde step to have to generate a 32-bit pre-multiplied alpha bitmap specifically for each image and to add that individually to the menu, but that is what we must do. It's not clear why Microsoft didn't use image lists for this instead of individual bitmaps. The IconImageManager does maintain a cache of menu bitmaps, so at least we don't have multiple copies. Note that the menu doesn't take ownership of the bitmap. We are responsible for making sure it stays around long enough, and is freed when no longer needed."

	bitmap := anIcon asSharedBitmap: aSystemMetrics menuImageExtent.
	self hbmpItem: bitmap handle!

subMenu: aMenu text: aString
	"Private - Set menu insertion details for a Sub-menu."

	| mask |
	mask := aMenu image
				ifNil: [##(MIIM_SUBMENU | MIIM_STRING | MIIM_ID)]
				ifNotNil: 
					[:icon |
					self setImage: icon metrics: aMenu metrics.
					##(MIIM_SUBMENU | MIIM_STRING | MIIM_ID | MIIM_BITMAP)].
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

wID
	"Answer the <Integer> value of the receiver's 'wID' field."

	^bytes dwordAtOffset: _OffsetOf_wID!

wID: anInteger
	"Set the receiver's 'wID' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_wID put: anInteger! !

!MENUITEMINFOW categoriesForMethods!
basicText:!accessing!private! !
cch:!**compiled accessors**!public! !
commandMenuItem:metrics:!initializing!private! !
dwItemData:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
dwTypeData!**compiled accessors**!public! !
dwTypeData:!**compiled accessors**!public! !
fMask!**compiled accessors**!public! !
fMask:!**compiled accessors**!public! !
fState!**compiled accessors**!public! !
fState:!**compiled accessors**!public! !
fType!**compiled accessors**!public! !
fType:!**compiled accessors**!public! !
hbmpChecked:!**compiled accessors**!public! !
hbmpItem:!**compiled accessors**!public! !
hbmpUnchecked:!**compiled accessors**!public! !
hSubMenu:!**compiled accessors**!public! !
maskOut:!accessing!private! !
menuItem:text:state:metrics:!accessing!private! !
setImage:metrics:!helpers!private! !
subMenu:text:!accessing!private! !
type:!accessing!private! !
wID!**compiled accessors**!public! !
wID:!**compiled accessors**!public! !
!

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
		defineField: #hbmpItem type: HANDLEField writeOnly!

getFieldNames
	^#(#dwSize #fMask #fType #fState #wID #hSubMenu #hbmpChecked #hbmpUnchecked #dwItemData #dwTypeData #cch #hbmpItem)! !

!MENUITEMINFOW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

