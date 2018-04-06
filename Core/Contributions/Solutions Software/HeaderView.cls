"Filed out from Dolphin Smalltalk 7"!

ControlView subclass: #HeaderView
	instanceVariableNames: ''
	classVariableNames: 'HDF_CENTER HDF_JUSTIFYMASK HDF_LEFT HDF_RIGHT HDF_SORTDOWN HDF_SORTUP HDI_FORMAT HDM_FIRST HDM_GETITEMW HDM_SETITEMW HDN_BEGINDRAG HDN_BEGINTRACKW HDN_DIVIDERDBLCLICKW HDN_ENDDRAG HDN_ENDTRACKW HDN_FIRST'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HeaderView guid: (GUID fromString: '{7a6b97fa-0fd4-424d-99de-515000f88886}')!
HeaderView addClassConstant: 'HDF_CENTER' value: 2!
HeaderView addClassConstant: 'HDF_JUSTIFYMASK' value: 3!
HeaderView addClassConstant: 'HDF_LEFT' value: 0!
HeaderView addClassConstant: 'HDF_RIGHT' value: 1!
HeaderView addClassConstant: 'HDF_SORTDOWN' value: 512!
HeaderView addClassConstant: 'HDF_SORTUP' value: 1024!
HeaderView addClassConstant: 'HDI_FORMAT' value: 4!
HeaderView addClassConstant: 'HDM_FIRST' value: 4608!
HeaderView addClassConstant: 'HDM_GETITEMW' value: 4619!
HeaderView addClassConstant: 'HDM_SETITEMW' value: 4620!
HeaderView addClassConstant: 'HDN_BEGINDRAG' value: -310!
HeaderView addClassConstant: 'HDN_BEGINTRACKW' value: -326!
HeaderView addClassConstant: 'HDN_DIVIDERDBLCLICKW' value: -325!
HeaderView addClassConstant: 'HDN_ENDDRAG' value: -311!
HeaderView addClassConstant: 'HDN_ENDTRACKW' value: -327!
HeaderView addClassConstant: 'HDN_FIRST' value: -300!
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

clearSortIconForColumnAtIndex: anInteger

	| header |

	header := self headerForColumnIndex: anInteger mask: HDI_FORMAT.

	header fmt: ((header fmt maskClear: HDF_SORTUP) maskClear: HDF_SORTDOWN).

	self setHeader: header!

hdmGetItem: aHdItem index: index
	(self
		sendMessage: HDM_GETITEMW
		wParam: index
		lpParam: aHdItem) == 0
		ifTrue: [^self errorInCommonControlCall]!

hdmSetItem: aHdItem index: index
	(self
		sendMessage: HDM_SETITEMW
		wParam: index
		lpParam: aHdItem) == 0
		ifTrue: [^self errorInCommonControlCall]!

headerForColumn: aListViewColumn mask: anInteger

	"Private - Stuff the header index into the lparam for easy resetting with setHeader:"

	^self headerForColumnIndex: aListViewColumn index mask: anInteger!

headerForColumnIndex: aListViewColumnIndex mask: anInteger
	"Private - Stuff the header index into the lparam for easy resetting with setHeader:
	NB aListViewColumnIndex is 1-based; internal indexing is 0-based"

	| index item |
	index := aListViewColumnIndex - 1.
	item := HDITEMW new.
	item
		mask: anInteger;
		lParam: index.
	self hdmGetItem: item index: index.
	^item!

nmNotify: anNMHDR
	| msg |
	msg := anNMHDR sdwordAtOffset: 8.
	msg == HDN_BEGINDRAG ifTrue: [self trigger: #beginDrag].
	msg == HDN_ENDDRAG ifTrue: [self trigger: #endDrag].
	msg == HDN_DIVIDERDBLCLICKW ifTrue: [self trigger: #dividerDoubleClick].
	msg == HDN_BEGINTRACKW ifTrue: [self trigger: #beginTrack].
	msg == HDN_ENDTRACKW ifTrue: [self trigger: #endTrack].
	^super nmNotify: anNMHDR!

setAlignment: aSymbol forColumn: aListViewColumn

	"Set the alignment of the header item for the given column (distinct from the column's alignment"

	| header alignmentMask |

	alignmentMask := 
		##(IdentityDictionary new
			at: #left	put: HDF_LEFT;
			at: #right	put: HDF_RIGHT;
			at: #center	put: HDF_CENTER;
			yourself) at: aSymbol.

	header := self headerForColumn: aListViewColumn mask: HDI_FORMAT.

	header fmt: ((header fmt maskClear: HDF_JUSTIFYMASK) maskSet: alignmentMask).

	self setHeader: header
!

setHeader: aHDITEM

	"Private - Assume the header item index is stuffed in lParam (see headerForColumn:mask:)"

	self hdmSetItem: aHDITEM index: aHDITEM lParam!

setSortIconForColumn: aListViewColumn

	| header |

	header := self headerForColumn: aListViewColumn mask: HDI_FORMAT.

	aListViewColumn isSortOrderInverted
		ifTrue: [header fmt: ((header fmt maskClear: HDF_SORTUP) maskSet: HDF_SORTDOWN) ]
		ifFalse: [header fmt: ((header fmt maskClear: HDF_SORTDOWN) maskSet: HDF_SORTUP)].

	self setHeader: header
! !
!HeaderView categoriesFor: #clearSortIconForColumnAtIndex:!helpers!public! !
!HeaderView categoriesFor: #hdmGetItem:index:!accessing!public! !
!HeaderView categoriesFor: #hdmSetItem:index:!accessing!public! !
!HeaderView categoriesFor: #headerForColumn:mask:!helpers!private! !
!HeaderView categoriesFor: #headerForColumnIndex:mask:!helpers!private! !
!HeaderView categoriesFor: #nmNotify:!event handling-win32!private! !
!HeaderView categoriesFor: #setAlignment:forColumn:!helpers!public! !
!HeaderView categoriesFor: #setHeader:!helpers!private! !
!HeaderView categoriesFor: #setSortIconForColumn:!helpers!public! !

!HeaderView class methodsFor!

winClassName
	^'BUTTON'! !
!HeaderView class categoriesFor: #winClassName!constants!public! !

