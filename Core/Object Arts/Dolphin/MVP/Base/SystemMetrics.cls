"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SystemMetrics
	instanceVariableNames: 'menuCheckExtent smallIconExtent largeIconExtent dragHysteresis scrollThumbExtent sizingFrameExtent dialogFrameExtent borderExtent nonClientMetrics menuFont edgeExtent hasFlatMenus iconTitleFont hasSmoothScrollingLists isVistaOrLater defaultColorDepth hasIconScaleDown isNotWine'
	classVariableNames: 'Current'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
SystemMetrics guid: (GUID fromString: '{e56cc456-8490-47f1-bd85-71118b110166}')!
SystemMetrics comment: 'SystemMetrics is a singleton class that provides a central service for accessing Windows configuration details such as the configurable aspects of the GUI''s appearance (height of title bars, fonts, etc). It has quite a large number of instance variables that cache information in order to avoid the expense of repeatedly querying it from the operating system.

Instance Variables:
	menuCheckExtent	<Point>. Size of the checkmark icon drawn on menus.
	smallIconExtent		<Point>. Size of a small icon, usually 16x16.
	largeIconExtent		<Point>. Size of a large icon, usually 32x32.
	dragHysteresis		<Point>. Extent of the mouse movement necessary to initiate a drag operation.
	scrollThumbExtent	<Point>. Size of a scrollbar thumb (dependent on scrollbar width/height).
	sizingFrameExtent	<Point>. Width/height of the overlapped window resizing edge.
	dialogFrameExtent	<Point>. Width/height of the dialog window edge.
	borderExtent		<Point>. Width/height of the a window border (normally 1x1).
	nonClientMetrics	<NONCLIENTMETRICS>. Various non-client measurements.
	menuFont			<Font>. The font used to paint menus.
	edgeExtent		<Point>. Width/height of a 3d window edge (normally 2x2).
	hasFlatMenus		<Boolean>. Whether or not the system menus are flat (XP-look) or have 3d appearance (classic Windows)
	iconTitleFont		<Font>. The font used to paint icon titles on the desktop - the nearest thing to a default desktop font.

Class Variables:
	Current			<SystemMetrics>. Singleton instance.

'!
!SystemMetrics categoriesForClass!Unclassified! !
!SystemMetrics methodsFor!

borderExtent
	^borderExtent ifNil: [borderExtent := self getMetric: SM_CXBORDER pair: SM_CYBORDER]!

cursorExtent
	"Answer a <Point> that gives the dimensions of the system cursor."

	^self getMetric: SM_CXCURSOR pair: SM_CYCURSOR!

defaultColorDepth
	"Answer the default color depth based on that of the current screen driver."

	^defaultColorDepth ifNil: [defaultColorDepth := self getDefaultColorDepth]
!

dialogFrameExtent
	^dialogFrameExtent ifNil: [dialogFrameExtent := self getMetric: SM_CXDLGFRAME pair: SM_CYDLGFRAME]!

dragHysteresis
	"Answer the default distance in pixels that the mouse must move before 
	a tracking operation is actually started"

	^dragHysteresis ifNil: [dragHysteresis := self getMetric: SM_CXDRAG pair: SM_CYDRAG]!

dragImageColorDepth
	^32!

edgeExtent
	"Answer the dimensions of 3d window borders."

	^edgeExtent ifNil: [edgeExtent := self getMetric: SM_CXEDGE pair: SM_CYEDGE]!

getDefaultColorDepth
	"Private - Answer the default color depth based on that of the current screen driver."

	| gdi hDC |
	gdi := GDILibrary default.
	hDC := gdi 
				createDC: 'DISPLAY'
				lpszDevice: nil
				lpszOutput: nil
				lpInitData: nil.
	^[(gdi getDeviceCaps: hDC nIndex: BITSPIXEL) * (gdi getDeviceCaps: hDC nIndex: PLANES) max: 4] 
		ensure: [gdi deleteDC: hDC]!

getIconTitleFont
	"Private - Answer a <Font> which is that used for icon titles on the desktop.

		SystemMetrics current getIconTitleFont
	"

	^Font fromLogFont: (self 
				getSysParamW: SPI_GETICONTITLELOGFONT
				type: LOGFONTW
				ifError: [^Font system])
!

getMetric: anInteger 
	^UserLibrary default getSystemMetrics: anInteger!

getMetric: anInteger1 pair: anInteger2 
	^(self getMetric: anInteger1) @ (self getMetric: anInteger2)!

getSysParam: anInteger type: anExternalStructureClass ifError: aNiladicValuable
	| struct |
	struct := anExternalStructureClass new.
	(UserLibrary default
		systemParametersInfo: anInteger
		uiParam: 0
		pvParam: struct
		fWinIni: 0) ifFalse: [^aNiladicValuable value].
	^struct!

getSysParamBool: anInteger 
	^(self 
		getSysParam: anInteger
		type: BOOL
		ifError: [^false]) value!

getSysParamDword: anInteger 
	^(self getSysParamStruct: anInteger type: DWORDBytes) value!

getSysParamSdword: anInteger
	^(self getSysParamStruct: anInteger type: DWORDBytes) asSignedInteger!

getSysParamStruct: anInteger type: anExternalStructureClass 
	^self 
		getSysParam: anInteger
		type: anExternalStructureClass
		ifError: [UserLibrary default systemError]!

getSysParamW: anInteger type: anExternalStructureClass ifError: aNiladicValuable
	| struct |
	struct := anExternalStructureClass new.
	(UserLibrary default
		systemParametersInfo: anInteger
		uiParam: 0
		pvParam: struct
		fWinIni: 0) ifFalse: [^aNiladicValuable value].
	^struct!

hasButtonNotes
	"Answer whether the host supports 'notes' for link buttons."

	^isVistaOrLater!

hasDesktopComposition
	"Answer whether the host supports off-screen desktop composition,"

	^isVistaOrLater!

hasEnhancedThemes
	"Answer whether the host supports enhanced desktop themes (Vista and later)."

	^isVistaOrLater!

hasFlatMenus
	"Answer whether the host menu style is 'flat'"

	^hasFlatMenus ifNil: [hasFlatMenus := self getSysParamBool: SPI_GETFLATMENU]!

hasGdiPalettes
	"Answer whether the host supports GDI palettes."

	"Wine doesn't yet implement GDILibrary>>getPaletteEntries:"

	#wineFix.
	^isNotWine!

hasIconScaleDown
	"Answer whether the host supports scaling down of larger icons when the requested size is
	not available (as opposed to scaling up)."

	^hasIconScaleDown!

hasImageListDragCursors
	"Answer whether the host supports using image lists for drag cursors."

	"Wine doesn't appear to support setting drag cursors from image lists."

	#wineFix.
	^isNotWine!

hasInternetExplorerControl
	"Answer whether the host provides an Internet Explorer control."

	#wineFix.
	^isNotWine!

hasLinkButtons
	"Answer whether the host supports link buttons (i.e. push buttons with the BS_COMMANDLINK
	style)."

	^isVistaOrLater!

hasMenuBitmaps
	"Answer whether the host support direct setting of menu bitmaps through the menu item info
	structure. If false they have to be provided through a callback."

	^isVistaOrLater!

hasSmoothScrollingLists
	"Answer whether the host supports smooth (as opposed to jump) scrolling of lists."

	hasSmoothScrollingLists isNil
		ifTrue: 
			[| bool |
			bool := DWORD new.
			hasSmoothScrollingLists := (UserLibrary default
						systemParametersInfo: SPI_GETLISTBOXSMOOTHSCROLLING
						uiParam: 0
						pvParam: bool
						fWinIni: 0) ifTrue: [bool value asBoolean] ifFalse: [false]].
	^hasSmoothScrollingLists!

hasTextBoxMargins
	"Answer whether the host supports configurable margins for EDIT controls."

	"Wine doesn't yet implement EM_SETMARGINS "

	#wineFix.
	^isNotWine!

hasThemes
	"Answer whether the host support desktop themes (XP and later)."

	"Wine currently errors on theme APIs, so bypass"

	#wineFix.
	^isNotWine!

hasTreeViewHotTracking
	"Does the host support hot tracking in tree views?"

	^isVistaOrLater!

iconTitleFont
	"Answer a <Font> which is that used for icon titles on the desktop."

	^iconTitleFont ifNil: [iconTitleFont := self getIconTitleFont]!

initialize
	"Private - "

	"So many capabilities depend on these flag, we may as well query them immediately. These also cannot change because of a Windows settings change."

	isVistaOrLater := VMLibrary default isWindowsVistaOrGreater.
	isNotWine := NTLibrary isWine not.
	"Wine does not support the ComMCtrlLibrary>>loadIconWithScaleDown:.. method which is normally
	availble under Vista and later. Hence we don't allow this to be called even if the Windows
	version indicates Vista is available."
	hasIconScaleDown := isVistaOrLater & isNotWine.
	SessionManager current when: #settingChanged: send: #onSettingChanged: to: self!

isSlowMachine
	"Answer true if this machine is judged to be slow."

	^(self getMetric: SM_SLOWMACHINE) ~~ 0!

largeIconExtent
	"Answer a <Point> that gives the dimensions of a large size icon."

	^largeIconExtent ifNil: [largeIconExtent := self getMetric: SM_CXICON pair: SM_CYICON]!

menuBarColor
	^ThemeLibrary default isAppThemed ifTrue: [Color menuBar] ifFalse: [Color menu]!

menuBarHeight
	"Answer the height of a menu item as currently configured."

	^self getMetric: SM_CYMENU!

menuCheckExtent
	"Answer a <Point> that specifies the dimensions of the menu check mark bitmap."

	^menuCheckExtent ifNil: [menuCheckExtent := self getMetric: SM_CXMENUCHECK pair: SM_CYMENUCHECK]!

menuDividerHeight
	"It doesn't seem to be possible to determine this from system metrics."

	"^self menuHeight-2."

	^9!

menuFont
	"Answer the currently configured menu font."

	^menuFont ifNil: [menuFont := Font fromLogFont: self nonClientMetrics lfMenuFont]!

menuHeight
	"Answer the height of a menu item as currently configured."

	^self getMetric: SM_CYMENUSIZE!

menuImageExtent
	"Answer a <Point>, being the width and height of the images displayed on menus."

	"Implementation Note: This seems to be fixed and not available as a config. item?"

	^self smallIconExtent!

menuImageTextGap
	"The gap between the text in a menu item and the image. It doesn't seem to be possible to
	determine this from system metrics."

	^16!

menuTextAcceleratorGap
	"The gap between the text in a menu item and the accelerator. It doesn't seem to be possible to
	determine this from system metrics."

	^32!

menuWidth
	^self nonClientMetrics iMenuWidth!

minimumTreeViewIndent
	^16!

mouseHoverTime
	^(self 
		getSysParam: SPI_GETMOUSEHOVERTIME
		type: DWORD
		ifError: [^400]) value!

nonClientMetrics
	"
		SystemMetrics current nonClientMetrics
	"
	nonClientMetrics isNil
		ifTrue: 
			["N.B. SPI_GETNONCLIENTMETRICS does not work in NT 3.51, but we no longer support it."
			nonClientMetrics := self
						getSysParamW: SPI_GETNONCLIENTMETRICS
						type: NONCLIENTMETRICSW
						ifError: [UserLibrary default systemError]].
	^nonClientMetrics

!

onSettingChanged: anArray
	| code |
	(##(#('Policy' 'intl' 'Environment' 'ImmersiveColorSet') asSet) includes: anArray first)
		ifTrue: 
			[^self].
	menuCheckExtent := smallIconExtent := largeIconExtent := dragHysteresis := scrollThumbExtent := sizingFrameExtent := dialogFrameExtent := borderExtent := edgeExtent := nil.
	code := anArray second.
	code == SPI_SETICONTITLELOGFONT
		ifTrue: 
			[iconTitleFont := nil.
			^self].
	code == SPI_SETNONCLIENTMETRICS
		ifTrue: 
			[menuFont := nonClientMetrics := nil.
			^self].
	code == SPI_SETFLATMENU
		ifTrue: 
			[hasFlatMenus := nil.
			^self].
	code == SPI_SETLISTBOXSMOOTHSCROLLING
		ifTrue: 
			[hasSmoothScrollingLists := nil.
			^self]!

paddedBorderThickness
	^self nonClientMetrics iPaddedBorderWidth!

scrollbarHeight
	"Answer the height, in pixels, of a horizontal scroll bar."

	^self nonClientMetrics iScrollHeight!

scrollbarWidth
	"Answer the width, in pixels, of a vertical scroll bar."

	^self nonClientMetrics iScrollWidth!

scrollThumbExtent
	^scrollThumbExtent ifNil: [scrollThumbExtent := self getMetric: SM_CXHTHUMB pair: SM_CYVTHUMB]!

setSysParamBool: anInteger value: aBoolean
	^UserLibrary default
		systemParametersInfo: anInteger
		uiParam: 0
		pvParam: aBoolean asInteger
		fWinIni: 0!

sizingFrameExtent
	sizingFrameExtent isNil 
		ifTrue: [sizingFrameExtent := self getMetric: SM_CXSIZEFRAME pair: SM_CYSIZEFRAME].
	^sizingFrameExtent!

smallIconExtent
	"Answer a <Point> that gives the dimensions of a small size icon."

	^smallIconExtent ifNil: [smallIconExtent := self getMetric: SM_CXSMICON pair: SM_CYSMICON]!

supportsAlphaBlending
	"Answer whether the host supports alpha blending."

	^true!

virtualScreenExtent
	"Answer the extent of the virtual screen, i.e. including desktops on all monitors"

	^(self getMetric: SM_CXVIRTUALSCREEN) @ (self getMetric: SM_CYVIRTUALSCREEN)!

virtualScreenOrigin
	"Answer the origin of the virtual screen, i.e. including desktops on all monitors"

	^(self getMetric: SM_XVIRTUALSCREEN) @ (self getMetric: SM_YVIRTUALSCREEN)!

virtualScreenRectangle
	"Answer the rectangle of the virtual screen, i.e. including desktops on all monitors"

	^self virtualScreenOrigin extent: self virtualScreenExtent! !
!SystemMetrics categoriesFor: #borderExtent!constants!public! !
!SystemMetrics categoriesFor: #cursorExtent!constants!public! !
!SystemMetrics categoriesFor: #defaultColorDepth!accessing!public! !
!SystemMetrics categoriesFor: #dialogFrameExtent!constants!public! !
!SystemMetrics categoriesFor: #dragHysteresis!constants!public! !
!SystemMetrics categoriesFor: #dragImageColorDepth!accessing!private! !
!SystemMetrics categoriesFor: #edgeExtent!constants!public! !
!SystemMetrics categoriesFor: #getDefaultColorDepth!accessing!helpers!private! !
!SystemMetrics categoriesFor: #getIconTitleFont!geometry!private! !
!SystemMetrics categoriesFor: #getMetric:!helpers!private! !
!SystemMetrics categoriesFor: #getMetric:pair:!helpers!private! !
!SystemMetrics categoriesFor: #getSysParam:type:ifError:!helpers!private! !
!SystemMetrics categoriesFor: #getSysParamBool:!helpers!private! !
!SystemMetrics categoriesFor: #getSysParamDword:!helpers!private! !
!SystemMetrics categoriesFor: #getSysParamSdword:!helpers!private! !
!SystemMetrics categoriesFor: #getSysParamStruct:type:!helpers!private! !
!SystemMetrics categoriesFor: #getSysParamW:type:ifError:!helpers!private! !
!SystemMetrics categoriesFor: #hasButtonNotes!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasDesktopComposition!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasEnhancedThemes!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasFlatMenus!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasGdiPalettes!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasIconScaleDown!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasImageListDragCursors!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasInternetExplorerControl!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasLinkButtons!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasMenuBitmaps!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasSmoothScrollingLists!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasTextBoxMargins!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasThemes!capability enquiries!public! !
!SystemMetrics categoriesFor: #hasTreeViewHotTracking!capability enquiries!public! !
!SystemMetrics categoriesFor: #iconTitleFont!geometry!public! !
!SystemMetrics categoriesFor: #initialize!initializing!private! !
!SystemMetrics categoriesFor: #isSlowMachine!public!testing! !
!SystemMetrics categoriesFor: #largeIconExtent!constants!public! !
!SystemMetrics categoriesFor: #menuBarColor!constants!public! !
!SystemMetrics categoriesFor: #menuBarHeight!constants!public! !
!SystemMetrics categoriesFor: #menuCheckExtent!constants!public! !
!SystemMetrics categoriesFor: #menuDividerHeight!constants!public! !
!SystemMetrics categoriesFor: #menuFont!constants!public! !
!SystemMetrics categoriesFor: #menuHeight!constants!public! !
!SystemMetrics categoriesFor: #menuImageExtent!accessing!public! !
!SystemMetrics categoriesFor: #menuImageTextGap!constants!public! !
!SystemMetrics categoriesFor: #menuTextAcceleratorGap!constants!public! !
!SystemMetrics categoriesFor: #menuWidth!constants!public! !
!SystemMetrics categoriesFor: #minimumTreeViewIndent!constants!public! !
!SystemMetrics categoriesFor: #mouseHoverTime!constants!public! !
!SystemMetrics categoriesFor: #nonClientMetrics!constants!public! !
!SystemMetrics categoriesFor: #onSettingChanged:!event handling-win32!private! !
!SystemMetrics categoriesFor: #paddedBorderThickness!constants!public! !
!SystemMetrics categoriesFor: #scrollbarHeight!constants!public! !
!SystemMetrics categoriesFor: #scrollbarWidth!constants!public! !
!SystemMetrics categoriesFor: #scrollThumbExtent!constants!public! !
!SystemMetrics categoriesFor: #setSysParamBool:value:!helpers!private! !
!SystemMetrics categoriesFor: #sizingFrameExtent!constants!public! !
!SystemMetrics categoriesFor: #smallIconExtent!constants!public! !
!SystemMetrics categoriesFor: #supportsAlphaBlending!capability enquiries!public! !
!SystemMetrics categoriesFor: #virtualScreenExtent!constants!public! !
!SystemMetrics categoriesFor: #virtualScreenOrigin!constants!public! !
!SystemMetrics categoriesFor: #virtualScreenRectangle!constants!public! !

!SystemMetrics class methodsFor!

current
	"Answer the current instance of the receiver."

	Current isNil ifTrue: [Current := self basicNew initialize].
	^Current!

new
	^self shouldNotImplement!

onPreStripImage
	self reset!

reset
	"Reinitialize the receiver. This is done on startup (see UserLibrary class>>clear) or when system settings are changed."

	Current := nil!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self reset! !
!SystemMetrics class categoriesFor: #current!instance creation!public! !
!SystemMetrics class categoriesFor: #new!instance creation!public! !
!SystemMetrics class categoriesFor: #onPreStripImage!event handling!public! !
!SystemMetrics class categoriesFor: #reset!initializing!public! !
!SystemMetrics class categoriesFor: #uninitialize!class hierarchy-removing!private! !

