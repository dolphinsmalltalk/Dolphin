"Filed out from Dolphin Smalltalk"!

ToolbarButton subclass: #ToolbarSystemButton
	instanceVariableNames: 'bitmapId bitmapIndex'
	classVariableNames: 'BitmapButtons Bitmaps HistoryButtons StandardButtons ViewButtons'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ToolbarSystemButton guid: (GUID fromString: '{87b4c702-026e-11d3-9fd7-00a0cc3e4a32}')!
ToolbarSystemButton comment: '`ToolbarSystemButton` represents a system defined button for a `Toolbar`. The button image is identified by an index into one of a number of system supplied bitmaps. Unfortunately these are not very useful any more, as Microsoft has not updated some of the bitmaps for decades.

For example (evaluated one expression at a time):
```
tb := Toolbar new hasFlatAppearance: true; isTransparent: true; show; extent: 300@ 64; zOrderTop; yourself.
"Add all the available system buttons to the toolbar; as you''ll see they are a mix of old a newer styles"
((MethodCategory name: ''instance creation-system buttons'') methodsInBehavior: ToolbarButton class) do: [:each | 
	each selector argumentCount = 0 ifTrue: [tb addItem: (ToolbarButton perform: each selector)]].
tb destroy.
```'!
!ToolbarSystemButton categoriesForClass!MVP-Views-Support! !
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

	^aToolbar addSystemBitmap: self bitmapId index: self bitmapIndex! !
!ToolbarSystemButton categoriesForMethods!
bitmapId!accessing!public! !
bitmapId:!accessing!public! !
bitmapId:index:commandDescription:!initializing!private! !
bitmapIndex!accessing!public! !
bitmapIndex:!accessing!public! !
imageIndexIn:!operations!private! !
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
	"Version 1 is refactored so that bitmap and bitmapIndex instance variables are no longer inherited.

	Version 0 inst var layout was:
		ToolbarItem
			1: commandId
			2: unused
			3: window (toolbar)
			4: style
			5: commandDescription
		ToolbarButton
			6: bitmap	(bitmapId)
			7: bitmapIndex
		ToolbarSystemButton

	Version 1 inst var layout is:
		ToolbarItem
			1: toolbar
		ToolbarButton (now abstract)
			2: style
			3: commandDescription
			4: commandId
		ToolbarSystemButton
			5: bitmapId
			6: bitmapIndex
	"

	^
	[:data |
	| newInstance |
	newInstance := self basicNew.
	1 to: 3 do: [:i | newInstance instVarAt: i put: (data at: i + 2)].
	newInstance instVarAt: 4 put: (data at: 1).
	5 to: 6 do: [:i | newInstance instVarAt: i put: (data at: i + 1)].
	newInstance]! !
!ToolbarSystemButton class categoriesForMethods!
bitmapId:index:commandDescription:!instance creation!public! !
initialize!development!initializing!public! !
new!instance creation!public! !
stbConvertFrom:!binary filing!private! !
!

