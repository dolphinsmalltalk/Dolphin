"Filed out from Dolphin Smalltalk"!

ControlView subclass: #HeaderView
	instanceVariableNames: 'columnHeaders'
	classVariableNames: 'HdnMap'
	poolDictionaries: 'HeaderViewConstants'
	classInstanceVariableNames: ''!

HeaderView guid: (GUID fromString: '{7a6b97fa-0fd4-424d-99de-515000f88886}')!

HeaderView comment: '#define HDI_WIDTH               0x0001
#define HDI_HEIGHT              HDI_WIDTH
#define HDI_TEXT                0x0002
#define HDI_FORMAT              0x0004
#define HDI_LPARAM              0x0008
#define HDI_BITMAP              0x0010
#if (_WIN32_IE >= 0x0300)
#define HDI_IMAGE               0x0020
#define HDI_DI_SETITEM          0x0040
#define HDI_ORDER               0x0080
#endif
#if (_WIN32_IE >= 0x0500)
#define HDI_FILTER              0x0100
#endif

#define HDF_LEFT                0x0000
#define HDF_RIGHT               0x0001
#define HDF_CENTER              0x0002
#define HDF_JUSTIFYMASK         0x0003
#define HDF_RTLREADING          0x0004

#define HDF_OWNERDRAW           0x8000
#define HDF_STRING              0x4000
#define HDF_BITMAP              0x2000
#if (_WIN32_IE >= 0x0300)
#define HDF_BITMAP_ON_RIGHT     0x1000
#define HDF_IMAGE               0x0800
#endif

#if (_WIN32_WINNT >= 0x501)
#define HDF_SORTUP              0x0400
#define HDF_SORTDOWN            0x0200
#endif'!

!HeaderView categoriesForClass!Unclassified! !

!HeaderView methodsFor!

columnHeader: anInteger

	"Return the ColumnHeader at the 1-based index anInteger"

	anInteger > columnHeaders size ifTrue: [columnHeaders := columnHeaders, (Array new: anInteger - columnHeaders size)].

	^(columnHeaders at: anInteger) ifNil: 
		[columnHeaders at: anInteger put: 
			(ColumnHeader new
				parent: self;
				index: anInteger;
				yourself)]!

columnHeaderFrom: anNMHDR

	^self columnHeader: (anNMHDR sdwordAtOffset: 12) + 1!

hdmGetItem: aHdItem index: index
	(self
		sendMessage: HDM_GETITEMW
		wParam: index
		lpParam: aHdItem) == 0
		ifTrue: [^self errorInCommonControlCall]!

hdmGetItemRect: anInteger
	"Private - Answer the bounding RECT for the receiver's column with the specified
	<Integer> index"

	| rect |
	rect := RECT new.
	(self sendMessage: HDM_GETITEMRECT wParam: anInteger lpParam: rect) == 0
		ifTrue: [^self errorInCommonControlCall].
	^rect!

hdmSetItem: aHdItem index: index
	(self
		sendMessage: HDM_SETITEMW
		wParam: index
		lpParam: aHdItem) == 0
		ifTrue: [^self errorInCommonControlCall]!

hdnBeginDrag: anNMHDR

	self trigger: #beginDrag!

hdnBeginTrack: anNMHDR

	self trigger: #beginTrack!

hdnDividerDblClick: anNMHDR

	self trigger: #dividerDoubleClick!

hdnDropDown: anNMHDR

	^(self columnHeaderFrom: anNMHDR) onDropDownButtonClicked!

hdnEndDrag: anNMHDR

	self trigger: #endDrag!

hdnEndTrack: anNMHDR

	self trigger: #endTrack!

hdnItemClick: anNMHDR

	"Placeholder"!

hdnItemDblClick: anNMHDR

	"Placeholder"!

hdnItemStateIconClick: anNMHDR

	"We handle column checking and unchecking ourselves to avoid the default 'select all' behavior"

	| column |

	column := self columnHeaderFrom: anNMHDR.
	column setIsChecked: column isChecked not.

	self invalidateUserInterface. 

	"Suppress default behavior"
	^0!

initialize
	"Private - Initialise the receiver."

	super initialize.
	columnHeaders := Array new!

isCheckBoxesStyle

	^self baseStyleAllMask: HDS_CHECKBOXES!

isCheckBoxesStyle: aBoolean

	self baseStyleMask: HDS_CHECKBOXES set: aBoolean recreateIfChanged: false!

nmNotify: pNMHDR
	"Private - Handler for a WM_NOTIFY message."

	^(HdnMap lookup: (pNMHDR sdwordAtOffset: 8))
		ifNil: [super nmNotify: pNMHDR]
		ifNotNil: [:action | self perform: action with: pNMHDR]!

rectangleForColumnIndex: anInteger

	^(self hdmGetItemRect: anInteger - 1) asRectangle! !

!HeaderView categoriesForMethods!
columnHeader:!accessing!public! !
columnHeaderFrom:!helpers!private! !
hdmGetItem:index:!helpers!private! !
hdmGetItemRect:!helpers!private! !
hdmSetItem:index:!helpers!private! !
hdnBeginDrag:!event handling-win32!private! !
hdnBeginTrack:!event handling-win32!private! !
hdnDividerDblClick:!event handling-win32!private! !
hdnDropDown:!event handling-win32!private! !
hdnEndDrag:!event handling-win32!private! !
hdnEndTrack:!event handling-win32!private! !
hdnItemClick:!event handling-win32!private! !
hdnItemDblClick:!event handling-win32!private! !
hdnItemStateIconClick:!event handling-win32!private! !
initialize!initializing!private! !
isCheckBoxesStyle!public!style! !
isCheckBoxesStyle:!public!style! !
nmNotify:!event handling-win32!private! !
rectangleForColumnIndex:!geometry!private! !
!

!HeaderView class methodsFor!

initialize

	self initializeNotificationMap!

initializeNotificationMap
	"Private - Initialise the map of HeaderView notification codes to selector/parameter-class pairs.
	N.B. Must not be stripped in order to preserve notification handlers."

	HdnMap := (IdentityDictionary new: 14)
			at: HDN_ITEMCLICKW put: #hdnItemClick:;
			at: HDN_ITEMDBLCLICKW put: #hdnItemDblClick:;
			at: HDN_DIVIDERDBLCLICKW put: #hdnDividerDblClick:;
			at: HDN_BEGINTRACKW put: #hdnBeginTrack:;
			at: HDN_ENDTRACKW put: #hdnEndTrack:;
			at: HDN_BEGINDRAG put: #hdnBeginDrag:;
			at: HDN_ENDDRAG put: #hdnEndDrag:;
			at: HDN_ITEMSTATEICONCLICK put: #hdnItemStateIconClick:;
			at: HDN_DROPDOWN put: #hdnDropDown:;
			shrink;
			yourself!

winClassName
	^'BUTTON'! !

!HeaderView class categoriesForMethods!
initialize!initializing!must not strip!private! !
initializeNotificationMap!initializing!must not strip!private! !
winClassName!constants!public! !
!

