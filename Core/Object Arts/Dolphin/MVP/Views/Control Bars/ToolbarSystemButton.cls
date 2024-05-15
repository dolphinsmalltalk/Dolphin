"Filed out from Dolphin Smalltalk"!

ToolbarButton subclass: #ToolbarSystemButton
	instanceVariableNames: 'bitmapId bitmapIndex'
	classVariableNames: 'BitmapButtons Bitmaps HistoryButtons StandardButtons ViewButtons'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ToolbarSystemButton guid: (GUID fromString: '{87b4c702-026e-11d3-9fd7-00a0cc3e4a32}')!

ToolbarSystemButton comment: '`ToolbarSystemButton` represents a system defined button for a `Toolbar`. The button image is identified by an index into one of a number of system supplied bitmaps. The bitmaps have not been changed since the 90''s and look very outdated now.

Aside from the fact that Microsoft has not updated the bitmaps for decades, they do not scale so are not High DPI friendly. Given the aesthetic and accessibility issues, it is recommended that these no longer be used, so the class is soft deprecated.
'!

!ToolbarSystemButton categoriesForClass!Deprecated! !

!ToolbarSystemButton methodsFor!

bitmapId
	"Answer the id of the system bitmap from which the receiver's bitmap is drawn."

	^bitmapId!

bitmapId: anInteger
	bitmapId := anInteger.
	self bitmapIndex: 0!

bitmapId: idInteger index: indexInteger commandDescription: aCommandDescription
	"Private - Initialize the instance variables of the receiver."

	self initialize.
	bitmapId := idInteger.
	bitmapIndex := indexInteger.
	commandDescription := aCommandDescription!

bitmapIndex
	"Answer the index of receivers sub-bitmap within its system bitmap."

	^bitmapIndex!

bitmapIndex: anInteger
	"Set the index of receivers sub-bitmap within its bitmap to anInteger."

	bitmapIndex := anInteger.
	self update
!

imageIndexIn: aToolbar
	"Private - Adds the receiver's bitmap to aToolbar.
	Answer the index of the bitmap from aToolbar's registered bitmaps."

	^aToolbar addSystemBitmap: self bitmapId index: self bitmapIndex!

isScalable
	"Answer whether the receiver can be scaled, e.g. for DPI."

	^false! !

!ToolbarSystemButton categoriesForMethods!
bitmapId!accessing!public! !
bitmapId:!accessing!public! !
bitmapId:index:commandDescription:!initializing!private! !
bitmapIndex!accessing!public! !
bitmapIndex:!accessing!public! !
imageIndexIn:!operations!private! !
isScalable!public!testing! !
!

!ToolbarSystemButton class methodsFor!

bitmapId: idInteger index: bitmapIndex commandDescription: aCommandDescription
	"Answer a new instance of the receiver containing the bitmapIndex'd subimage of aBitmap."

	^self basicNew
		bitmapId: idInteger
		index: bitmapIndex
		commandDescription: aCommandDescription!

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

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_FILESAVE
		command: #noCommand
		description: 'No command'!

stbConvertFrom: anSTBClassFormat
	"ToolbarSystemButton used to be a subclass of what is now effectively ToolbarBitmapButton, but was then ToolbarButton, now the abstract superclass of both."

	anSTBClassFormat version == 0
		ifTrue: [^[:data | (self stbConvertFromVersion0: data) becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat! !

!ToolbarSystemButton class categoriesForMethods!
bitmapId:index:commandDescription:!instance creation!public! !
initialize!development!initializing!public! !
new!instance creation!public! !
stbConvertFrom:!binary filing!private! !
!

