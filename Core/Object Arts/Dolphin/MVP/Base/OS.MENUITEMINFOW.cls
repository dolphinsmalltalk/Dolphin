"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.MENUITEMINFOW'
	instanceVariableNames: 'text bitmap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_MENUITEMINFOW_Size' -> 16r30.
			'_OffsetOf_cch' -> 16r28.
			'_OffsetOf_dwItemData' -> 16r20.
			'_OffsetOf_dwSize' -> 16r0.
			'_OffsetOf_dwTypeData' -> 16r24.
			'_OffsetOf_fMask' -> 16r4.
			'_OffsetOf_fState' -> 16rC.
			'_OffsetOf_fType' -> 16r8.
			'_OffsetOf_hbmpChecked' -> 16r18.
			'_OffsetOf_hbmpItem' -> 16r2C.
			'_OffsetOf_hbmpUnchecked' -> 16r1C.
			'_OffsetOf_hSubMenu' -> 16r14.
			'_OffsetOf_wID' -> 16r10
		}!
OS.MENUITEMINFOW guid: (Core.GUID fromString: '{d9f31567-d705-4885-9ed7-f92ae9fefbf2}')!
OS.MENUITEMINFOW comment: '<MENUITEMINFOA> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

See the Win32 SDK documentation for further information.'!
!OS.MENUITEMINFOW categoriesForClass!External-Data-Structured-Win32! !
!OS.MENUITEMINFOW methodsFor!

basicText: aString
	"Private - Set the menu item text to be the <readableString> argument, aString."

	text := aString asUtf16String.
	bytes uintPtrAtOffset: _OffsetOf_dwTypeData put: text yourAddress.
	"It has never been necessary to set the text size - the documentation is explicit about this, stating 'cch is ignored when the content of a menu item is set by calling SetMenuItemInfo.'"
	"self cch: text size"!

bitmap: anImage
	"Populate the receiver with a command image. We no longer use the HBMMENU_CALLBACK method with the menu images drawn on demand by Menu>>drawItemImage:on:at:disabled:, because that approach causes themed menus to be disabled. It seems a retrograde step to have to generate a 32-bit pre-multiplied alpha bitmap specifically for each image and to add that individually to the
	menu, but that is what we must do. It's not clear why Microsoft didn't use image lists for this instead of individual bitmaps. The IconImageManager does maintain a cache of menu bitmaps, so at least we don't have multiple copies."

	"Note that the menu doesn't take ownership of the bitmap. We are responsible for making sure it stays around long enough, and is freed when no longer needed. The menu bitmaps are cached in the IconImageManager."

	bitmap := anImage asMenuBitmap.
	bytes uintPtrAtOffset: _OffsetOf_hbmpItem put: bitmap handle!

cch: anInteger
	"Set the receiver's 'cch' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cch put: anInteger!

dwItemData: anInteger
	"Set the receiver's 'dwItemData' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_dwItemData put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

dwTypeData
	"Answer the <Utf16String> value of the receiver's 'dwTypeData' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_dwTypeData)!

dwTypeData: anUtf16String
	"Set the receiver's 'dwTypeData' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_dwTypeData put: anUtf16String yourAddress!

fMask
	"Answer the <Integer> value of the receiver's 'fMask' field."

	^bytes uint32AtOffset: _OffsetOf_fMask!

fMask: anInteger
	"Set the receiver's 'fMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_fMask put: anInteger!

fState
	"Answer the <Integer> value of the receiver's 'fState' field."

	^bytes uint32AtOffset: _OffsetOf_fState!

fState: anInteger
	"Set the receiver's 'fState' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_fState put: anInteger!

fType
	"Answer the <Integer> value of the receiver's 'fType' field."

	^bytes uint32AtOffset: _OffsetOf_fType!

fType: anInteger
	"Set the receiver's 'fType' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_fType put: anInteger!

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

menuItem: aMenuItem text: aStringOrNil state: stateInteger
	"Private - Update the details for a normal menu item (i.e. the text, type flags, and state).
	This message is used when dynamically updating menu items."

	| mask |
	mask := aStringOrNil
				ifNil: [##(MIIM_FTYPE | MIIM_STATE)]
				ifNotNil: 
					[self basicText: aStringOrNil.
					##(MIIM_FTYPE | MIIM_STATE | MIIM_STRING)].
	aMenuItem image
		ifNotNil: 
			[:image |
			self bitmap: image.
			mask := mask bitOr: MIIM_BITMAP].
	self
		fType: aMenuItem styleFlags;
		fState: stateInteger;
		fMask: mask!

type: anInteger
	"Private - Set the fType field only. Used when creating menu items."

	bytes
		uint32AtOffset: _OffsetOf_fType put: anInteger;
		uint32AtOffset: _OffsetOf_fMask put: MIIM_FTYPE!

wID
	"Answer the <Integer> value of the receiver's 'wID' field."

	^bytes uint32AtOffset: _OffsetOf_wID!

wID: anInteger
	"Set the receiver's 'wID' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_wID put: anInteger! !
!OS.MENUITEMINFOW categoriesForMethods!
basicText:!accessing!private! !
bitmap:!helpers!public! !
cch:!**compiled accessors**!public! !
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
menuItem:text:state:!accessing!private! !
type:!accessing!private! !
wID!**compiled accessors**!public! !
wID:!**compiled accessors**!public! !
!

!OS.MENUITEMINFOW class methodsFor!

byteSize
	^_MENUITEMINFOW_Size!

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
		defineField: #dwSize type: UInt32Field writeOnly;
		defineField: #fMask type: UInt32Field new;
		defineField: #fType type: UInt32Field new;
		defineField: #fState type: UInt32Field new;
		defineField: #wID type: UInt32Field new;
		defineField: #hSubMenu type: HANDLEField writeOnly;
		defineField: #hbmpChecked type: HANDLEField writeOnly;
		defineField: #hbmpUnchecked type: HANDLEField writeOnly;
		defineField: #dwItemData type: UIntPtrField writeOnly;
		defineField: #dwTypeData type: (PointerField type: Utf16String);
		defineField: #cch type: UInt32Field writeOnly;
		defineField: #hbmpItem type: HANDLEField writeOnly!

getFieldNames
	^#(#dwSize #fMask #fType #fState #wID #hSubMenu #hbmpChecked #hbmpUnchecked #dwItemData #dwTypeData #cch #hbmpItem)! !
!OS.MENUITEMINFOW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

