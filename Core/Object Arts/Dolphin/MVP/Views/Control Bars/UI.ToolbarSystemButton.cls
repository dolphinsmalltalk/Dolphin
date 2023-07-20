"Filed out from Dolphin Smalltalk"!

UI.ToolbarButton
	subclass: #'UI.ToolbarSystemButton'
	instanceVariableNames: 'bitmapId bitmapIndex'
	classVariableNames: 'BitmapButtons'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'Bitmaps'
				-> (IdentityDictionary withAll: { #history -> 16r8. #standard -> 16r0. #view -> 16r4 }).
			'HistoryButtons'
				-> (IdentityDictionary withAll: {
								#addToFavorites -> 16r3.
								#favorites -> 16r2.
								#historyBack -> 16r0.
								#historyForward -> 16r1.
								#historyTree -> 16r4
							}).
			'StandardButtons'
				-> (IdentityDictionary withAll: {
								#clearSelection -> 16r5.
								#copySelection -> 16r1.
								#cutSelection -> 16r0.
								#fileNew -> 16r6.
								#fileOpen -> 16r7.
								#fileSave -> 16r8.
								#find -> 16rC.
								#help -> 16rB.
								#pasteClipboard -> 16r2.
								#print -> 16rE.
								#printPreview -> 16r9.
								#properties -> 16rA.
								#redo -> 16r4.
								#replace -> 16rD.
								#undo -> 16r3
							}).
			'ViewButtons'
				-> (IdentityDictionary withAll: {
								#largeIcons -> 16r0.
								#list -> 16r2.
								#newConnect -> 16r9.
								#newDisconnect -> 16rA.
								#newFolder -> 16rB.
								#parentFolder -> 16r8.
								#report -> 16r3.
								#smallIcons -> 16r1.
								#sortDate -> 16r6.
								#sortName -> 16r4.
								#sortSize -> 16r5.
								#sortType -> 16r7.
								#viewMenu -> 16rC
							})
		}!
UI.ToolbarSystemButton guid: (Core.GUID fromString: '{87b4c702-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ToolbarSystemButton comment: '`ToolbarSystemButton` represents a system defined button for a `Toolbar`. The button image is identified by an index into one of a number of system supplied bitmaps. Unfortunately these are not very useful any more, as Microsoft has not updated some of the bitmaps for decades.

For example (evaluated one expression at a time):
```
tb := Toolbar new hasFlatAppearance: true; isTransparent: true; show; extent: 300@ 64; zOrderTop; yourself.
"Add all the available system buttons to the toolbar; as you''ll see they are a mix of old a newer styles"
((MethodCategory name: ''instance creation-system buttons'') methodsInBehavior: ToolbarButton class) do: [:each | 
	each selector argumentCount = 0 ifTrue: [tb addItem: (ToolbarButton perform: each selector)]].
tb destroy.
```'!
!UI.ToolbarSystemButton categoriesForClass!MVP-Views-Support! !
!UI.ToolbarSystemButton methodsFor!

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
	"Answer the index of receiver's sub-bitmap within its system bitmap."

	^bitmapIndex!

bitmapIndex: anInteger
	"Set the index of receiver's sub-bitmap within its bitmap to anInteger."

	bitmapIndex := anInteger.
	self update
!

imageIndexIn: aToolbar
	"Private - Adds the receiver's bitmap to aToolbar.
	Answer the index of the bitmap from aToolbar's registered bitmaps."

	^aToolbar addSystemBitmap: self bitmapId index: self bitmapIndex! !
!UI.ToolbarSystemButton categoriesForMethods!
bitmapId!accessing!public! !
bitmapId:!accessing!public! !
bitmapId:index:commandDescription:!initializing!private! !
bitmapIndex!accessing!public! !
bitmapIndex:!accessing!public! !
imageIndexIn:!operations!private! !
!

!UI.ToolbarSystemButton class methodsFor!

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

	self addClassConstant: 'StandardButtons' value: (IdentityDictionary new
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
				yourself).
	self addClassConstant: 'ViewButtons' value: (IdentityDictionary new
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
				yourself).
	self addClassConstant: 'Bitmaps' value: (IdentityDictionary new
				at: #standard put: IDB_STD_SMALL_COLOR;
				at: #view put: IDB_VIEW_SMALL_COLOR;
				at: #history put: IDB_HIST_SMALL_COLOR;
				shrink;
				yourself).
	self addClassConstant: 'HistoryButtons' value: (IdentityDictionary new
				at: #historyBack put: HIST_BACK;
				at: #historyForward put: HIST_FORWARD;
				at: #favorites put: HIST_FAVORITES;
				at: #addToFavorites put: HIST_ADDTOFAVORITES;
				at: #historyTree put: HIST_VIEWTREE;
				shrink;
				yourself).
	self addClassVariable: 'BitmapButtons' value: (IdentityDictionary new
				at: IDB_STD_SMALL_COLOR put: StandardButtons;
				at: IDB_VIEW_SMALL_COLOR put: ViewButtons;
				at: IDB_HIST_SMALL_COLOR put: HistoryButtons;
				shrink;
				yourself)!

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
!UI.ToolbarSystemButton class categoriesForMethods!
bitmapId:index:commandDescription:!instance creation!public! !
initialize!development!initializing!public! !
new!instance creation!public! !
stbConvertFrom:!binary filing!private! !
!

