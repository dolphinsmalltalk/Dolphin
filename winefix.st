"File in to make Dolphin 6.0x, 6.1x images compatible with Wine"!

"** WF1 ** Test for isWine in NTLibrary"!
SourceManager default fileIn: 'Core\Object Arts\Dolphin\Base\NTLibrary.cls'!

"** WF2 ** Wine doesn't yet implement EM_SETMARGINS "!
!TextEdit methodsFor!

setMarginWidths: anArray 
	| margins |
	NTLibrary isWine 
		ifTrue: 
			[ #wineFix.
			^self].
	margins := (DWORD new)
				highWord: anArray first;
				lowWord: anArray last.
	self 
		sendMessage: EM_SETMARGINS
		wParam: (EC_LEFTMARGIN bitOr: EC_RIGHTMARGIN)
		lParam: margins asParameter! !
!TextEdit categoriesFor: #setMarginWidths:!accessing!private!wine fix! !

"** WF3 ** Wine doesn't yet implement GDILibrary>>getPaletteEntries:..."!
!IndexedColor methodsFor!

asRGBUsingNoPalette
	"Answer the receiver as an RGB  when no palette is available ."

	| colorNameMap stdColorName |
	#wineFix.
	colorNameMap := LookupTable new.
	#(#(#black 16r1000000) #(#darkRed 16r1000001) #(#darkGreen 16r1000002) #(#brown 16r1000003) #(#darkBlue 16r1000004) #(#darkMagenta 16r1000005) #(#darkCyan 16r1000006) #(#gray 16r1000007) #(#darkGray 16r100000C) #(#red 16r100000D) #(#green 16r100000E) #(#yellow 16r100000F) #(#blue 16r1000010) #(#magenta 16r1000011) #(#cyan 16r1000012) #(#white 16r1000013)) 
		do: [:each | colorNameMap at: each second put: each first].
	stdColorName := colorNameMap at: index.
	^RGB stdColor: stdColorName! !
!IndexedColor categoriesFor: #asRGBUsingNoPalette!converting!public!wine fix! !

!IndexedColor methodsFor!asRGB	"Answer the receiver as an RGB using the default palette."	#wineFix.
	NTLibrary isWine ifTrue: [		^self asRGBUsingNoPalette].
	^self asRGBUsingPalette: self defaultPalette! !
!IndexedColor categoriesFor: #asRGBUsingPalette:!converting!public!wine fix! !

"** WF4 ** ListView watermark in system folder causes problems"!
!SmalltalkSystemShell methodsFor!

onViewCreated
	"Private - The receiver's has been created (that is the CreateWindow() API call has returned), but may
	not yet be connected to the receiver (if the view-presenter pair is being instantiated, then
	the connection will not have been made, but if the view is being restored from saved state
	in the image then the presenter will be connected). This is an appropriate point for
	subclasses to apply any dynamic view configuration that must be performed every time the
	view is created. Typically this might involve customising some feature of the view that it
	does not itself save, perhaps because a feature of the underlying control does not have full
	support in the wrapper class. Note that one should normally override #onViewAvailable to
	restore user configuration settings, since the views will normally save and restore all
	relevant settings across an image save."

	NTLibrary isWine ifFalse: [
		#wineFix.
		[self setListViewWatermark] postToMessageQueue].
	self registerHotKey.
	^super onViewCreated! !
!SmalltalkSystemShell categoriesFor: #onViewCreated!event handling!private!wine fix! !

"** WF5 ** Wine does not support the ComCtrlLibrary>>loadIconWithScaleDown:.. method which is normally availble under Vista
and later. Hence we don't allow this to be called even if the Windows version indicates Vista is available"!
!Icon methodsFor!

valueWithHandle: operation forExtent: aPoint 
	"Private - Evaluate the <monadicValuable>, operation, with a handle for the receiver's icon at the best possible
	rendering for the specified extent. On Vista and later platforms the icon will be scaled down from the next largest
	icon if the requested size is not available."

	| hModule ident |
	self handle = self class question handle 
		ifTrue: 
			["If the icon failed to load, the standard question icon will have been substituted"
			hModule := 0.
			ident := self class question identifier]
		ifFalse: 
			[ident := self identifier.
			hModule := instanceHandle asParameter].
	hModule isNull 
		ifTrue: 
			["If loaded from a file or a standard system icon, then need to reload to ensure has correct extent"
			instanceHandle isNil 
				ifTrue: 
					[(self loadFromFile: self fileSpec extent: aPoint) ifNotNil: [:hIcon | ^operation value: hIcon]]
				ifFalse: 
					[(hModule == 0 
						and: [aPoint ~= SystemMetrics current largeIconExtent and: [#wineFix. 
							OSVERSIONINFO current isWinVista & NTLibrary isWine not ]]) 
							ifTrue: 
								[(self 
									load: ident
									fromInstance: hModule
									extent: aPoint) ifNotNil: [:hIcon | ^operation value: hIcon]]]].
	^operation value: self asParameter! !
!Icon categoriesFor: #valueWithHandle:forExtent:!helpers!private!wine fix! !

"** WF6 **  Suppressible message boxes under Wine have a bug where they ignore the buttonStyles #yesNo and #yesNoCancel and will
always answer #ok or #cancel instead. Here we map the return button ids to the correct values"!

!MessageBox methodsFor!

result
	"Answer a portable symbolic constant describing the button that was pressed by the user
	to close the receiver."

	NTLibrary isWine 
		ifTrue: 
			[#wineFix.
			"Suppressible message boxes under Wine have a bug where they ignore the buttonStyles #yesNo and #yesNoCancel and will
			always answer #ok or #cancel instead. Here we map the return button ids to the correct values"
			(self buttonStyle == #yesNo or: [self buttonStyle == #yesNoCancel]) 
				ifTrue: 
					[button = IDOK ifTrue: [button := IDYES].
					button = IDCANCEL ifTrue: [button := IDNO]]].
	^ButtonMap at: button! !
!MessageBox categoriesFor: #result!accessing!public!wine fix! !

"** WF7 ** Helper method to edit view resources"!
!ResourceIdentifier methodsFor!

editViewUsing: aMonadicBlock 
	| view |
	view := self loadWithContext: View desktop.
	aMonadicBlock value: view.
	self assign: view literalStoreArray.
	view destroy! !
!ResourceIdentifier categoriesFor: #editViewUsing:!operations!public! !

"** WF8 ** Wine gives error when turning of theming"!
!View methodsFor!

beNotThemed
	"Turns off any visual theme for the receiver. Only effective on Windows XP and above"

	NTLibrary isWine ifTrue: [
		"Wine currently errors on this, so ignore"
		#wineFix.
		^self].

	ThemeLibrary default 
		setWindowTheme: self handle
		pszSubAppName: '' asUnicodeString
		pszSubIdList: '' asUnicodeString! !
!View categoriesFor: #beNotThemed!modes!wine fix!public! !

"** WF9 ** Having autoSelectPackages option turned on in System Browser gives unpleasant scrolling effect when many multiple packages
are selected. This also happens in Package Browser. Problem under Wine traced to LVIS_FOCUSED option in ListView>>selectIndex:. Not
sure  what overall effect it will have turning this off."!

!ListView methodsFor!

selectIndex: anInteger set: aBoolean 
	"Private - Set/reset the selection state of the object at the specified one-based <integer>
	index within the receiver according to the <boolean> argument."

	| anLvItem mask |
	anLvItem := LVITEM new.
	mask := ##(LVIS_SELECTED|LVIS_FOCUSED).
	NTLibrary isWine ifTrue: [
				#wineFix.
				mask := mask maskClear: LVIS_FOCUSED
		].
	anLvItem stateMask: mask.
	aBoolean ifTrue: [anLvItem dwState: mask].
	self lvmSetItem: anInteger - 1 state: anLvItem! !
!ListView categoriesFor: #selectIndex:set:!private!selection! !

"** WF10 ** Wine ListViews seem to expect image indices to always be set in ListView>>onDisplayDetailsRequired:, even if we don't want
images to appear. Normally, we don't set an image if none is required. In Wine we set an image index of 0"!

!ListViewColumn methodsFor!

imageFromRow: item
	"Private - Answer the image for this column extracted from the <Object>, item,
	which is an element of the receiver's parent <ListView>.
	As of Dolphin 3.0 the image block is permitted to be nil for the common case
	where the columns does not have images."

	NTLibrary isWine ifTrue: [
		#wineFix.
		"WF10: Wine ListViews seem to expect image indices to always be set in ListView>>onDisplayDetailsRequired:, 
		even if we don't want images to appear. Normally, we answer nil here if no image is required. 
		In Wine we must answer an image index of 0"
		getImageBlock ifNil: [^0]].

	^getImageBlock isNil ifFalse: [
		getImageBlock value: (self contentFromRow: item)].
! !
!ListViewColumn categoriesFor: #imageFromRow:!adapters!private!wine fix! !

!ListView methodsFor!

imageFromRow: item 
	"Private - Answer the image for row which represents the <Object>, item.
	As of Dolphin 3.0 the image block is permitted to be nil for the common case
	where the list does not have images."

	self viewMode == #thumbnails ifTrue: [^self getThumbnailOf: item].

	NTLibrary isWine ifTrue: [
		#wineFix.
		"WF10: Wine ListViews seem to expect image indices to always be set in ListView>>onDisplayDetailsRequired:, 
		even if we don't want images to appear. Normally, we answer nil here if no image is required. 
		In Wine we must answer an image index of 0"
		getImageBlock ifNil: [^0]].
	^self getImageBlock isNil ifFalse: [getImageBlock value: item]! !
!ListView categoriesFor: #imageFromRow:!adapters!private!wine fix! !

"** WF11 ** Wine doesn't appear to support setting drag cursors from image lists. Until available we fall back to using the old (non-specific) drag and drop cursors"!

!InternalDragDropSession methodsFor!

giveFeedback
	"Private - Set the drag cursor to indicate the effect of a drop on the current target."

	| imageKey |
	(imageKey := self imageKey) ~~ lastImageKey 
		ifTrue: 
			[| dragIm |
			NTLibrary isWine 
				ifTrue: 
					[| cursorSelector |
					#wineFix.
					"WF11: Wine doesn't appear to support setting drag cursors
					from image lists. Until available we fall back to using the
					old (non-specific) drag and drop cursors"
					cursorSelector := ##((LookupTable new)
								at: #none put: #ddNone;
								at: #move put: #ddMove;
								at: #copy put: #ddCopy;
								at: #copyScroll put: #ddCopyScroll;
								at: #moveScroll put: #ddMoveScroll;
								at: #linkScroll put: #ddLinkScroll;
								yourself) at: self imageKey.
					(Cursor perform: cursorSelector) makeCurrent.
					lastImageKey := imageKey].
			dragIm := dragImages at: imageKey.
			imageList 
				setDragCursorImage: dragIm key
				hotSpotX: dragIm value x
				hotSpotY: dragIm value y.
			lastImageKey := imageKey].
	imageList dragMoveTo: self dragPoint! !
!InternalDragDropSession categoriesFor: #giveFeedback!operations!wine fix!private! !

"** WF 12 ** Fixes for Registry Editor sample are already in Dolphin 7"!

"** WF13 ** Uninstall Simple Web Browser sample since it requires IE component"!
| swb |
swb := (Package manager packageNamed: 'Simple Web Browser' ifNone:[]).
swb notNil ifTrue: [swb uninstall]!

"** WF14 ** Remove CodeMentorPlugin from all browsers since it requires IE component"!
Smalltalk at: #CodeMentorPlugin ifPresent: [:cmp |
	ClassBrowserShell plugins: (ClassBrowserShell plugins reject: [:each | each==cmp]).
	(Smalltalk at: #SystemBrowserShell) plugins: (ClassBrowserShell plugins reject: [:each | each==cmp])]!

"Appearances for Mac OS/X"!
NTLibrary isMacOSX ifTrue: [
	| macSystemFont |
	macSystemFont := (Font name: 'Lucida Grande' pointSize: 10) .
	SmalltalkWorkspace defaultFont: macSystemFont.
	SmalltalkSystem current defaultFont: macSystemFont.
	SmalltalkWorkspace defaultBackcolor: (RGB red: 0 green: 128 blue: 192).
	(ResourceIdentifier class: SmalltalkSystemShell name: 'Default view') editViewUsing: [:shell |
		(shell viewNamed: 'systemFolder') 
			forecolor: Color white;
			iconSpacing: 96@96].
	]!

"Reset UI"!
SmalltalkSystem current panic !


