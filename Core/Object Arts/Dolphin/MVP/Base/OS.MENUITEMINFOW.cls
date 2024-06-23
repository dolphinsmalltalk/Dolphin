"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.MENUITEMINFOW'
	instanceVariableNames: 'text bitmap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_MENUITEMINFOW_Size' -> 16r30.
			'_OffsetOf_cch' -> 16r28.
			'_OffsetOf_dwItemData' -> 16r20.
			'_OffsetOf_dwTypeData' -> 16r24.
			'_OffsetOf_fMask' -> 16r4.
			'_OffsetOf_fState' -> 16rC.
			'_OffsetOf_fType' -> 16r8.
			'_OffsetOf_hbmpChecked' -> 16r18.
			'_OffsetOf_hbmpItem' -> 16r2C.
			'_OffsetOf_hbmpUnchecked' -> 16r1C.
			'_OffsetOf_hSubMenu' -> 16r14.
			'_OffsetOf_wID' -> 16r10.
			'MF_APPEND' -> 16r100.
			'MF_BYCOMMAND' -> 16r0.
			'MF_BYPOSITION' -> 16r400.
			'MF_CHANGE' -> 16r80.
			'MF_DELETE' -> 16r200.
			'MF_HELP' -> 16r4000.
			'MF_INSERT' -> 16r0.
			'MF_MOUSESELECT' -> 16r8000.
			'MF_POPUP' -> 16r10.
			'MF_REMOVE' -> 16r1000.
			'MF_SYSMENU' -> 16r2000.
			'MF_USECHECKBITMAPS' -> 16r200.
			'MFS_CHECKED' -> 16r8.
			'MFS_DEFAULT' -> 16r1000.
			'MFS_DISABLED' -> 16r3.
			'MFS_ENABLED' -> 16r0.
			'MFS_HILITE' -> 16r80.
			'MFS_UNCHECKED' -> 16r0.
			'MFS_UNHILITE' -> 16r0.
			'MFT_BITMAP' -> 16r4.
			'MFT_MENUBARBREAK' -> 16r20.
			'MFT_MENUBREAK' -> 16r40.
			'MFT_OWNERDRAW' -> 16r100.
			'MFT_RADIOCHECK' -> 16r200.
			'MFT_RIGHTJUSTIFY' -> 16r4000.
			'MFT_RIGHTORDER' -> 16r2000.
			'MFT_SEPARATOR' -> 16r800.
			'MFT_STRING' -> 16r0.
			'MIIM_BITMAP' -> 16r80.
			'MIIM_CHECKMARKS' -> 16r8.
			'MIIM_DATA' -> 16r20.
			'MIIM_FTYPE' -> 16r100.
			'MIIM_ID' -> 16r2.
			'MIIM_STATE' -> 16r1.
			'MIIM_STRING' -> 16r40.
			'MIIM_SUBMENU' -> 16r4.
			'MIIM_TYPE' -> 16r10
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

cch: anInteger
	"Set the receiver's 'cch' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cch put: anInteger!

commandMenuItem: aCommandMenuItem
	| mask fType |
	mask := aCommandMenuItem image
				ifNil: [##(MIIM_STRING | MIIM_ID)]
				ifNotNil: 
					[:img |
					self image: img.
					##(MIIM_STRING | MIIM_ID | MIIM_BITMAP)].
	fType := aCommandMenuItem styleFlags.
	fType == 0
		ifFalse: 
			[bytes uint32AtOffset: _OffsetOf_fType put: fType.
			mask := mask bitOr: MIIM_FTYPE].
	self basicText: aCommandMenuItem text.
	bytes
		uint32AtOffset: _OffsetOf_wID put: aCommandMenuItem id;
		uint32AtOffset: _OffsetOf_fMask put: mask!

dwItemData: anInteger
	"Set the receiver's 'dwItemData' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_dwItemData put: anInteger!

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

hbmpChecked: aHandle
	"Set the receiver's 'hbmpChecked' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbmpChecked put: aHandle!

hbmpItem: aHandle
	"Set the receiver's 'hbmpItem' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbmpItem put: aHandle!

hbmpUnchecked: aHandle
	"Set the receiver's 'hbmpUnchecked' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbmpUnchecked put: aHandle!

hSubMenu: aHandle
	"Set the receiver's 'hSubMenu' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hSubMenu put: aHandle!

image: anImage
	"Populate the receiver with a command image. We no longer use the HBMMENU_CALLBACK method with the menu images drawn on demand by Menu>>drawItemImage:on:at:disabled:, because that approach causes themed menus to be disabled. It seems a retrograde step to have to generate a 32-bit pre-multiplied alpha bitmap specifically for each image and to add that individually to the menu, but that is what we must do. It's not clear why Microsoft didn't use image lists for this instead of individual bitmaps. The IconImageManager does maintain a cache of menu bitmaps, so at least we don't have multiple copies."

	anImage
		ifNil: 
			[bitmap := nil.
			bytes uintPtrAtOffset: _OffsetOf_hbmpItem put: 0]
		ifNotNil: 
			["Note that the menu doesn't take ownership of the bitmap. We are responsible for making sure it stays around long enough, and is freed when no longer needed. The menu bitmaps are cached in the IconImageManager."
			bitmap := anImage asMenuBitmap.
			bytes uintPtrAtOffset: _OffsetOf_hbmpItem put: bitmap handle]!

text: aString
	self basicText: aString!

type: anInteger
	"Private - Set the fType field only. Used when creating menu items."

	bytes
		uint32AtOffset: _OffsetOf_fType put: anInteger;
		uint32AtOffset: _OffsetOf_fMask put: MIIM_FTYPE!

updateQuery: priorCommandQuery to: newCommandQuery
	| mask |
	mask := 0.
	newCommandQuery text = priorCommandQuery text
		ifFalse: 
			["Text changed"
			mask := mask bitOr: MIIM_STRING.
			self basicText: newCommandQuery newMenuText].
	newCommandQuery image = priorCommandQuery image
		ifFalse: 
			["Image changed"
			mask := mask bitOr: MIIM_BITMAP.
			self image: newCommandQuery newMenuImage].
	newCommandQuery menuStateFlags = priorCommandQuery menuStateFlags
		ifFalse: 
			["State changed"
			mask := mask bitOr: MIIM_STATE.
			self fState: newCommandQuery menuStateFlags].
	self fMask: mask.
	^mask ~~ 0!

wID
	"Answer the <Integer> value of the receiver's 'wID' field."

	^bytes uint32AtOffset: _OffsetOf_wID!

wID: anInteger
	"Set the receiver's 'wID' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_wID put: anInteger! !

!OS.MENUITEMINFOW categoriesForMethods!
basicText:!accessing!private! !
cch:!**compiled accessors**!public! !
commandMenuItem:!initializing!private! !
dwItemData:!**compiled accessors**!public! !
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
image:!helpers!public! !
text:!accessing!public! !
type:!accessing!private! !
updateQuery:to:!operations!private! !
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

	super defineFields.
	self
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

