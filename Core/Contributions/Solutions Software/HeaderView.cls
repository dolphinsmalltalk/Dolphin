"Filed out from Dolphin Smalltalk 7"!

ControlView subclass: #HeaderView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HeaderView guid: (GUID fromString: '{7A6B97FA-0FD4-424D-99DE-515000F88886}')!
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

	header := self headerForColumnIndex: anInteger mask: 16r0004. "HDI_FORMAT"

	header fmt: ((header fmt maskClear: 16r400 "HDF_SORTUP") maskClear: 16r0200) "HDF_SORTDOWN".

	self setHeader: header!

hdmGetItem: aHdItem index: index

	(self sendMessage: ##(16r1200+3) "HDM_GETITEMA" wParam: index lpParam: aHdItem) == 0
		ifTrue: [^self errorInCommonControlCall]
!

hdmSetItem: aHdItem index: index

	(self sendMessage: ##(16r1200+4) "HDM_SETITEMA" wParam: index lpParam: aHdItem) == 0
		ifTrue: [^self errorInCommonControlCall]
!

headerForColumn: aListViewColumn mask: anInteger

	"Private - Stuff the header index into the lparam for easy resetting with setHeader:"

	^self headerForColumnIndex: aListViewColumn index mask: anInteger!

headerForColumnIndex: aListViewColumnIndex mask: anInteger

	"Private - Stuff the header index into the lparam for easy resetting with setHeader:
	NB aListViewColumnIndex is 1-based; internal indexing is 0-based"

	| index item |

	index := aListViewColumnIndex - 1.
	item := HDITEM new.
	item 
		mask: anInteger;
		lParam: index.

	self hdmGetItem: item index: index.

	^item!

nmNotify: anNMHDR
	| msg |

	msg := anNMHDR sdwordAtOffset: 8.

	msg = ##(-300 "HDN_FIRST"  - 10) "HDN_BEGINDRAG" ifTrue: [self trigger: #beginDrag].
	msg = ##(-300 "HDN_FIRST" - 11) "HDN_ENDDRAG" ifTrue: [self trigger: #endDrag].
	msg = ##(-300 "HDN_FIRST" - 25) "DIVIDERDBLCLICK" ifTrue: [self trigger: #dividerDoubleClick].
	msg = ##(-300 "HDN_FIRST" - 26) "HDN_BEGINTRACK" ifTrue: [self trigger: #beginTrack].
	msg = ##(-300 "HDN_FIRST" - 27) "HDN_ENDTRACK" ifTrue: [self trigger: #endTrack].

	^super nmNotify: anNMHDR
!

setAlignment: aSymbol forColumn: aListViewColumn

	"Set the alignment of the header item for the given column (distinct from the column's alignment"

	| header alignmentMask |

	alignmentMask := 
		##(Dictionary new
			at: #left	put: 16r0000; "HDF_LEFT"
			at: #right	put: 16r0001; "HDF_RIGHT"
			at: #center	put: 16r0002; "HDF_CENTER"
			yourself) at: aSymbol.

	header := self headerForColumn: aListViewColumn mask: 16r0004. "HDI_FORMAT"

	header fmt: ((header fmt maskClear: 16r0003 "HDF_JUSTIFYMASK") maskSet: alignmentMask).

	self setHeader: header!

setHeader: aHDITEM

	"Private - Assume the header item index is stuffed in lParam (see headerForColumn:mask:)"

	self hdmSetItem: aHDITEM index: aHDITEM lParam!

setSortIconForColumn: aListViewColumn

	| header |

	header := self headerForColumn: aListViewColumn mask: 16r0004. "HDI_FORMAT"

	aListViewColumn isSortOrderInverted
		ifTrue: [header fmt: ((header fmt maskClear: 16r400 "HDF_SORTUP") maskSet: 16r0200) "HDF_SORTDOWN"]
		ifFalse: [header fmt: ((header fmt maskClear: 16r200 "HDF_SORTDOWN") maskSet: 16r0400) "HDF_SORTUP"].

	self setHeader: header! !
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

