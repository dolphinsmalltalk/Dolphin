"Filed out from Dolphin Smalltalk 7"!

ToolbarButton subclass: #ToolbarSystemButton
	instanceVariableNames: ''
	classVariableNames: 'BitmapButtons Bitmaps HistoryButtons StandardButtons ViewButtons'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ToolbarSystemButton guid: (GUID fromString: '{87b4c702-026e-11d3-9fd7-00a0cc3e4a32}')!
ToolbarSystemButton comment: 'ToolbarButton represents a system defined button for a <Toolbar>. The button image is identified by an index into one of a number of system supplied <Bitmap>s.'!
!ToolbarSystemButton categoriesForClass!MVP-Views-Support! !
!ToolbarSystemButton methodsFor!

bitmap: anInteger
	bitmap := anInteger.
	self bitmapIndex: 0!

imageIndexIn: aToolbar
	"Private - Adds the receiver's bitmap to aToolbar.
	Answer the index of the bitmap from aToolbar's registered bitmaps."

	^aToolbar addSystemBitmap: self bitmap index: self bitmapIndex! !
!ToolbarSystemButton categoriesFor: #bitmap:!accessing!public! !
!ToolbarSystemButton categoriesFor: #imageIndexIn:!operations!private! !

!ToolbarSystemButton class methodsFor!

initialize
	"
	self initialize
	"

	StandardButtons := (IdentityDictionary new)
				at: #copySelection put: STD_COPY;
				at: #cutSelection put: STD_CUT;
				at: #clearSelection put: STD_DELETE;
				at: #fileNew put: STD_FILENEW;
				at: #fileOpen put: STD_FILEOPEN;
				at: #fileSave put: STD_FILESAVE;
				at: #find put: STD_FIND;
				at: #help put: STD_HELP;
				at: #pasteClipboard put: STD_PASTE;
				at: #print put: STD_PRINT;
				at: #printPreview put: STD_PRINTPRE;
				at: #properties put: STD_PROPERTIES;
				at: #redo put: STD_REDOW;
				at: #replace put: STD_REPLACE;
				at: #undo put: STD_UNDO;
				shrink;
				yourself.
	ViewButtons := (IdentityDictionary new)
				at: #largeIcons put: VIEW_LARGEICONS;
				at: #smallIcons put: VIEW_SMALLICONS;
				at: #list put: VIEW_LIST;
				at: #report put: VIEW_DETAILS;
				at: #sortDate put: VIEW_SORTDATE;
				at: #sortName put: VIEW_SORTNAME;
				at: #sortSize put: VIEW_SORTSIZE;
				at: #sortType put: VIEW_SORTTYPE;
				at: #parentFolder put: VIEW_PARENTFOLDER;
				at: #newConnect put: VIEW_NETCONNECT;
				at: #newDisconnect put: VIEW_NETDISCONNECT;
				at: #newFolder put: VIEW_NEWFOLDER;
				at: #viewMenu put: VIEW_VIEWMENU;
				shrink;
				yourself.
	Bitmaps := (IdentityDictionary new)
				at: #standard put: IDB_STD_SMALL_COLOR;
				at: #view put: IDB_VIEW_SMALL_COLOR;
				at: #history put: IDB_HIST_SMALL_COLOR;
				shrink;
				yourself.
	HistoryButtons := (IdentityDictionary new)
				at: #historyBack put: HIST_BACK;
				at: #historyForward put: HIST_FORWARD;
				at: #favorites put: HIST_FAVORITES;
				at: #addToFavorites put: HIST_ADDTOFAVORITES;
				at: #historyTree put: HIST_VIEWTREE;
				shrink;
				yourself.
	BitmapButtons := (IdentityDictionary new)
				at: IDB_STD_SMALL_COLOR put: StandardButtons;
				at: IDB_VIEW_SMALL_COLOR put: ViewButtons;
				at: IDB_HIST_SMALL_COLOR put: HistoryButtons;
				shrink;
				yourself!

new
	"Answer a new default ToolbarButton"

	^self standardImage: STD_FILESAVE command: #noCommand description: 'No command'! !
!ToolbarSystemButton class categoriesFor: #initialize!development!initializing!public! !
!ToolbarSystemButton class categoriesFor: #new!instance creation!public! !

