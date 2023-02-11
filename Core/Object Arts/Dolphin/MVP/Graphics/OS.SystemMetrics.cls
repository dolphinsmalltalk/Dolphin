"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'OS.SystemMetrics'
	instanceVariableNames: 'menuCheckExtent dragHysteresis scrollThumbExtent sizingFrameExtent dialogFrameExtent borderExtent nonClientMetrics menuFont edgeExtent hasFlatMenus iconTitleFont hasSmoothScrollingLists defaultColorDepth isNotWine'
	classVariableNames: 'Current'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.SystemMetrics guid: (Core.GUID fromString: '{e56cc456-8490-47f1-bd85-71118b110166}')!
OS.SystemMetrics comment: 'SystemMetrics is a singleton class that provides a central service for accessing Windows configuration details such as the configurable aspects of the GUI''s appearance (height of title bars, fonts, etc). It has quite a large number of instance variables that cache information in order to avoid the expense of repeatedly querying it from the operating system.

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
!OS.SystemMetrics methodsFor!

borderExtent
	^borderExtent ifNil: [borderExtent := self getMetric: SM_CXBORDER pair: SM_CYBORDER]!

cursorExtent
	"Answer a <Point> that gives the dimensions of the system cursor. Note that this is only a nominal/default size. It is essentially useless for practical purposes in more recent versions of Windows: See [What is the deal with the SM_CXCURSOR system metric?](https://devblogs.microsoft.com/oldnewthing/20210819-00/?p=105572). The follow up [](https://devblogs.microsoft.com/oldnewthing/20210820-00/?p=105593) suggests loading the arrow cursor and querying its extent. Experimentation suggests that, on Windows 11 at least, this doesn't work. The cursor loaded is always the 32x32 image, regardless of DPI and magnification. It seems there is no reliable way to find the actual size of cursor that should be considered the default load size."

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

edgeExtent
	"Answer the dimensions of 3d window borders."

	^edgeExtent ifNil: [edgeExtent := self getMetric: SM_CXEDGE pair: SM_CYEDGE]!

getDefaultColorDepth
	"Private - Answer the default color depth based on that of the current screen driver."

	| hDC |
	hDC := Gdi32
				createDC: 'DISPLAY'
				lpszDevice: nil
				lpszOutput: nil
				lpInitData: nil.
	^[(Gdi32 getDeviceCaps: hDC nIndex: BITSPIXEL) * (Gdi32 getDeviceCaps: hDC nIndex: PLANES) max: 4]
		ensure: [Gdi32 deleteDC: hDC]!

getIconTitleFont
	"Private - Answer a <Font> which is that used for icon titles on the desktop.

		SystemMetrics current getIconTitleFont
	"

	^Graphics.Font fromLogFont: (self
				getSysParamW: SPI_GETICONTITLELOGFONT
				type: LOGFONTW
				ifError: [^Graphics.Font system])!

getMetric: anInteger
	^User32 getSystemMetrics: anInteger!

getMetric: anInteger1 pair: anInteger2 
	^(self getMetric: anInteger1) @ (self getMetric: anInteger2)!

getSysParam: anInteger type: anExternalStructureClass ifError: aNiladicValuable
	| struct |
	struct := anExternalStructureClass new.
	(User32
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
	^(self getSysParamStruct: anInteger type: UInt32Bytes) value!

getSysParamSdword: anInteger
	^(self getSysParamStruct: anInteger type: UInt32Bytes) asSignedInteger!

getSysParamStruct: anInteger type: anExternalStructureClass
	^self
		getSysParam: anInteger
		type: anExternalStructureClass
		ifError: [User32 systemError]!

getSysParamW: anInteger type: anExternalStructureClass ifError: aNiladicValuable
	| struct |
	struct := anExternalStructureClass new.
	(User32
		systemParametersInfo: anInteger
		uiParam: 0
		pvParam: struct
		fWinIni: 0) ifFalse: [^aNiladicValuable value].
	^struct!

hasFlatMenus
	"Answer whether the host menu style is 'flat'"

	^hasFlatMenus ifNil: [hasFlatMenus := self getSysParamBool: SPI_GETFLATMENU]!

hasGdiPalettes
	"Answer whether the host supports GDI palettes."

	"Wine doesn't yet implement GDILibrary>>getPaletteEntries:"

	#wineFix.
	^isNotWine!

hasIconScaleDown
	"Answer whether the host supports scaling down of larger icons when the requested size is not available (as opposed to scaling up)."

	"Wine does not support the ComMCtrlLibrary>>loadIconWithScaleDown:.. method which is normally availble under Vista and later. Hence we don't allow this to be called even if the Windows version indicates Vista is available."

	^isNotWine!

hasImageListDragCursors
	"Answer whether the host supports using image lists for drag cursors."

	"Wine doesn't appear to support setting drag cursors from image lists."

	#wineFix.
	^isNotWine!

hasSmoothScrollingLists
	"Answer whether the host supports smooth (as opposed to jump) scrolling of lists."

	hasSmoothScrollingLists isNil
		ifTrue: 
			[| bool |
			bool := UInt32Bytes new.
			hasSmoothScrollingLists := (User32
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

hasWebView
	"Answer whether the host provides a WebView2 Edge Browser control."

	#wineFix.
	^isNotWine!

iconTitleFont
	"Answer a <Font> which is that used for icon titles on the desktop."

	^iconTitleFont ifNil: [iconTitleFont := self getIconTitleFont]!

initialize
	"Private - "

	"So many capabilities depend on these flag, we may as well query them immediately. These also cannot change because of a Windows settings change."

	isNotWine := NtDll isWine not.
	SessionManager current
		when: #settingChanged:
		send: #onSettingChanged:
		to: self!

isSlowMachine
	"Answer true if this machine is judged to be slow."

	^(self getMetric: SM_SLOWMACHINE) ~~ 0!

largeIconExtent
	"Answer a <Point> that gives the dimensions of a large size icon."

	^self getMetric: SM_CXICON pair: SM_CYICON!

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

	^menuFont ifNil: [menuFont := Graphics.Font fromLogFont: self nonClientMetrics lfMenuFont]!

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

monitorCount
	"Answer the number of monitors currently attached."

	^self getMetric: SM_CMONITORS!

mouseHoverTime
	^(self
		getSysParam: SPI_GETMOUSEHOVERTIME
		type: UInt32Bytes
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
						ifError: [User32 systemError]].
	^nonClientMetrics!

onSettingChanged: anArray
	| code |
	(##(#('Policy' 'intl' 'Environment' 'ImmersiveColorSet') asSet) includes: anArray first)
		ifTrue: [^self].
	menuCheckExtent := dragHysteresis := scrollThumbExtent := sizingFrameExtent := dialogFrameExtent := borderExtent := edgeExtent := nil.
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
	^User32
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

	^self getMetric: SM_CXSMICON pair: SM_CYSMICON!

virtualScreenExtent
	"Answer the extent of the virtual screen, i.e. including desktops on all monitors"

	^(self getMetric: SM_CXVIRTUALSCREEN) @ (self getMetric: SM_CYVIRTUALSCREEN)!

virtualScreenOrigin
	"Answer the origin of the virtual screen, i.e. including desktops on all monitors"

	^(self getMetric: SM_XVIRTUALSCREEN) @ (self getMetric: SM_YVIRTUALSCREEN)!

virtualScreenRectangle
	"Answer the rectangle of the virtual screen, i.e. including desktops on all monitors"

	^self virtualScreenOrigin extent: self virtualScreenExtent! !
!OS.SystemMetrics categoriesForMethods!
borderExtent!constants!public! !
cursorExtent!constants!public! !
defaultColorDepth!accessing!public! !
dialogFrameExtent!constants!public! !
dragHysteresis!constants!public! !
edgeExtent!constants!public! !
getDefaultColorDepth!accessing!helpers!private! !
getIconTitleFont!geometry!private! !
getMetric:!helpers!private! !
getMetric:pair:!helpers!private! !
getSysParam:type:ifError:!helpers!private! !
getSysParamBool:!helpers!private! !
getSysParamDword:!helpers!private! !
getSysParamSdword:!helpers!private! !
getSysParamStruct:type:!helpers!private! !
getSysParamW:type:ifError:!helpers!private! !
hasFlatMenus!capability enquiries!public! !
hasGdiPalettes!capability enquiries!public! !
hasIconScaleDown!capability enquiries!public! !
hasImageListDragCursors!capability enquiries!public! !
hasSmoothScrollingLists!capability enquiries!public! !
hasTextBoxMargins!capability enquiries!public! !
hasThemes!capability enquiries!public! !
hasWebView!capability enquiries!public! !
iconTitleFont!geometry!public! !
initialize!initializing!private! !
isSlowMachine!public!testing! !
largeIconExtent!constants!public! !
menuBarHeight!constants!public! !
menuCheckExtent!constants!public! !
menuDividerHeight!constants!public! !
menuFont!constants!public! !
menuHeight!constants!public! !
menuImageExtent!accessing!public! !
menuImageTextGap!constants!public! !
menuTextAcceleratorGap!constants!public! !
menuWidth!constants!public! !
minimumTreeViewIndent!constants!public! !
monitorCount!accessing!public! !
mouseHoverTime!constants!public! !
nonClientMetrics!constants!public! !
onSettingChanged:!event handling-win32!private! !
paddedBorderThickness!constants!public! !
scrollbarHeight!constants!public! !
scrollbarWidth!constants!public! !
scrollThumbExtent!constants!public! !
setSysParamBool:value:!helpers!private! !
sizingFrameExtent!constants!public! !
smallIconExtent!constants!public! !
virtualScreenExtent!constants!public! !
virtualScreenOrigin!constants!public! !
virtualScreenRectangle!constants!public! !
!

!OS.SystemMetrics class methodsFor!

current
	"Answer the current instance of the receiver."

	^Current
		ifNil: 
			[Current := self basicNew
						initialize;
						yourself]!

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
!OS.SystemMetrics class categoriesForMethods!
current!instance creation!public! !
new!instance creation!public! !
onPreStripImage!event handling!public! !
reset!initializing!public! !
uninitialize!class hierarchy-removing!private! !
!

