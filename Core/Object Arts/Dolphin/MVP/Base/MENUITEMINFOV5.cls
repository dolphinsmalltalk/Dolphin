"Filed out from Dolphin Smalltalk X6.1"!

MENUITEMINFOA subclass: #MENUITEMINFOV5
	instanceVariableNames: 'bitmap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MENUITEMINFOV5 guid: (GUID fromString: '{B3297E1F-24C9-4702-AE63-F2170927F81B}')!
MENUITEMINFOV5 comment: '<MENUITEMINFOV5> is an <ExternalStructure> class to wrap the Win32 MENUITEMINFO structure with additional fields added with the introduction of the so-called version 5 user interface (i.e. Windows 98 and 2000). Essentially this adds support for item bitmaps.
'!
!MENUITEMINFOV5 categoriesForClass!External-Data-Structured-Win32! !
!MENUITEMINFOV5 methodsFor!

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

hasBitmapCallbackBug
	^OSVERSIONINFO current isWinVista and: [OSVERSIONINFO current dwBuildNumber < 5480]!

hbmpItem: anObject 
	"Set the receiver's hbmpItem field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hbmpItem) put: anObject!

menuItem: aMenuItem text: aStringOrNil state: aString 
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
		fState: aString;
		fMask: mask!

setImage: aCommandMenuItem 
	^(aCommandMenuItem image isNil or: [self hasBitmapCallbackBug]) 
		ifTrue: [0]
		ifFalse: 
			[self hbmpItem: (OSVERSIONINFO current isWinV6OrLater 
						ifTrue: 
							["Note that the menu doesn't take ownership
							 of the bitmap. We are responsible for
							 making sure it stays around long enough,
							 and is freed when no longer needed."
							bitmap := aCommandMenuItem image asMenuBitmap.
							bitmap handle]
						ifFalse: [HBMMENU_CALLBACK]).
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
		fMask: ##(MIIM_FTYPE | MIIM_STRING | MIIM_ID)! !
!MENUITEMINFOV5 categoriesFor: #commandMenuItem:!initializing!private! !
!MENUITEMINFOV5 categoriesFor: #hasBitmapCallbackBug!private!testing! !
!MENUITEMINFOV5 categoriesFor: #hbmpItem:!**compiled accessors**!public! !
!MENUITEMINFOV5 categoriesFor: #menuItem:text:state:!accessing!private! !
!MENUITEMINFOV5 categoriesFor: #setImage:!helpers!private! !
!MENUITEMINFOV5 categoriesFor: #subMenu:text:!accessing!private! !
!MENUITEMINFOV5 categoriesFor: #type:!accessing!private! !
!MENUITEMINFOV5 categoriesFor: #type:text:id:!initializing!public! !

!MENUITEMINFOV5 class methodsFor!

defineFields
	"Define the fields of the MENUITEMINFOV5 structure.
		MENUITEMINFOV5 compileDefinition
	"

	super defineFields.
	self
		defineField: #hbmpItem type: HANDLEField writeOnly! !
!MENUITEMINFOV5 class categoriesFor: #defineFields!initializing!public! !

