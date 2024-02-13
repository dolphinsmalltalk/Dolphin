"Filed out from Dolphin Smalltalk"!

Object subclass: #SystemMetrics
	instanceVariableNames: 'dpi menuCheckExtent smallIconExtent largeIconExtent dragHysteresis scrollThumbExtent sizingFrameExtent dialogFrameExtent borderExtent nonClientMetrics menuFont edgeExtent iconTitleFont defaultColorDepth tileIconExtent'
	classVariableNames: 'Current Default HasFlatMenus HasIconScaleDown Instances IsNotWine IsVistaOrLater MouseHoverTime SysParamVariables WheelScrollLines'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

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

captionHeight
	^self nonClientMetrics iCaptionHeight!

cursorExtent
	"Answer a <Point> that gives the dimensions of the system cursor."

	^self getMetric: SM_CXCURSOR pair: SM_CYCURSOR!

defaultColorDepth
	"Answer the default color depth based on that of the current screen driver."

	^defaultColorDepth ifNil: [defaultColorDepth := self getDefaultColorDepth]
!

dialogFrameExtent
	^dialogFrameExtent ifNil: [dialogFrameExtent := self getMetric: SM_CXDLGFRAME pair: SM_CYDLGFRAME]!

dpi
	^dpi!

dragHysteresis
	"Answer the default distance in pixels that the mouse must move before 
	a tracking operation is actually started"

	^dragHysteresis ifNil: [dragHysteresis := self getMetric: SM_CXDRAG pair: SM_CYDRAG]!

dragImageColorDepth
	^32!

edgeExtent
	"Answer the dimensions of 3d window borders."

	^edgeExtent ifNil: [edgeExtent := self getMetric: SM_CXEDGE pair: SM_CYEDGE]!

extraLargeIconExtent
	"Answer a <Point> that gives the dimensions of an extra large icon."

	"Currently, this if fixed."
	^256@256!

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

		(SystemMetrics forDpi: 192) getIconTitleFont
	"

	^(self
		getSysParamForDpi: SPI_GETICONTITLELOGFONT
		type: LOGFONTW
		ifError: []) ifNil: [Font system] ifNotNil: [:lf | Font fromLogFont: lf resolution: dpi @ dpi]!

getMetric: anInteger 
	^UserLibrary default getSystemMetricsForDpi: anInteger dpi: dpi!

getMetric: anInteger1 pair: anInteger2 
	^(self getMetric: anInteger1) @ (self getMetric: anInteger2)!

getNonClientMetrics
	^self
		getSysParamForDpi: SPI_GETNONCLIENTMETRICS
		type: NONCLIENTMETRICSW
		ifError: [UserLibrary default systemError]!

getSysParam: anInteger type: anExternalStructureClass ifError: aNiladicValuable
	| struct |
	struct := anExternalStructureClass new.
	(UserLibrary default
		systemParametersInfo: anInteger
		uiParam: struct byteSize
		pvParam: struct
		fWinIni: 0) ifFalse: [^aNiladicValuable value].
	^struct value!

getSysParamBool: anInteger
	^(self getSysParamDword: anInteger ifError: [0]) asBoolean!

getSysParamDword: anInteger ifError: aNiladicValuable
	| struct |
	struct := DWORDBytes new.
	(UserLibrary default
		systemParametersInfo: anInteger
		uiParam: 0
		pvParam: struct
		fWinIni: 0) ifFalse: [^aNiladicValuable value].
	^struct value!

getSysParamForDpi: anInteger type: anExternalStructureClass ifError: aNiladicValuable
	"Private - Rather stupidly the Windows API SystemParametersInfoForDpi  doesn't work for any system parameter as one might expect, but only for a limited set that are documented as varying at different DPIs. It would be simpler, and less likely to break with future modifications/additions, if it just did what the GetSystemMetrics call does and work for everything, ignoring the DPI when it isn't relevant. As it stands we need to call both functions. The DPI aware function is called for these three settings only:
		SPI_GETICONTITLELOGFONT
		SPI_GETICONMETRICS
		SPI_GETNONCLIENTMETRICS
	For everything else, the non-DPI aware function must be called as the DPI-aware one just returns false and doesn't populate the structure.
	"

	| struct |
	struct := anExternalStructureClass new.
	(UserLibrary default
		systemParametersInfoForDpi: anInteger
		uiParam: struct byteSize
		pvParam: struct
		fWinIni: 0
		dpi: dpi) ifFalse: [^aNiladicValuable value].
	^struct value!

hasButtonNotes
	"Answer whether the host supports 'notes' for link buttons."

	^IsVistaOrLater!

hasDesktopComposition
	"Answer whether the host supports off-screen desktop composition,"

	^IsVistaOrLater!

hasEnhancedThemes
	"Answer whether the host supports enhanced desktop themes (Vista and later)."

	^IsVistaOrLater!

hasFlatMenus
	"Answer whether the host menu style is 'flat'"

	^HasFlatMenus ifNil: [HasFlatMenus := self getSysParamBool: SPI_GETFLATMENU]!

hasGdiPalettes
	"Answer whether the host supports GDI palettes."

	"Wine does not implement GDILibrary>>getPaletteEntries:, and probably never will since palettes are essentially obsolete."

	#wineFix.
	^IsNotWine!

hasIconScaleDown
	"Answer whether the host supports scaling down of larger icons when the requested size is not available (as opposed to scaling up)."

	^HasIconScaleDown!

hasImageListDragCursors
	"Answer whether the host supports using image lists for drag cursors."

	"Wine doesn't appear to support setting drag cursors from image lists."

	#wineFix.
	^IsNotWine!

hasLinkButtons
	"Answer whether the host supports link buttons (i.e. push buttons with the BS_COMMANDLINK
	style)."

	^IsVistaOrLater!

hasMenuBitmaps
	"Answer whether the host support direct setting of menu bitmaps through the menu item info
	structure. If false they have to be provided through a callback."

	^IsVistaOrLater!

hasSmoothScrollingLists
	"Answer whether the host supports smooth (as opposed to jump) scrolling of lists."

	^self getSysParamBool: SPI_GETLISTBOXSMOOTHSCROLLING!

hasTextBoxMargins
	"Answer whether the host supports configurable margins for EDIT controls."

	"Wine doesn't yet implement EM_SETMARGINS "

	#wineFix.
	^IsNotWine!

hasThemes
	"Answer whether the host support desktop themes (XP and later)."

	"Wine currently errors on theme APIs, so bypass"

	#wineFix.
	^IsNotWine!

hasTreeViewHotTracking
	"Does the host support hot tracking in tree views?"

	^IsVistaOrLater!

hasWebView
	"Answer whether the host provides a WebView2 Edge Browser control."

	#wineFix.
	^IsNotWine!

iconTitleFont
	"Answer a <Font> which is that used for icon titles on the desktop."

	^iconTitleFont ifNil: [iconTitleFont := self getIconTitleFont]!

isSlowMachine
	"Answer true if this machine is judged to be slow."

	^(self getMetric: SM_SLOWMACHINE) ~~ 0!

largeIconExtent
	"Answer a <Point> that gives the dimensions of a large size icon."

	^largeIconExtent ifNil: [largeIconExtent := self getMetric: SM_CXICON pair: SM_CYICON]!

mapDipsToPels: aMagnitude
	"Scale the device-independent pixel (DIP) extent representer by the <Magnitude> argument to the receiver's DPI and answer the result. DIPs are equivalent to 96-dpi."

	^aMagnitude * dpi / USER_DEFAULT_SCREEN_DPI!

mapPelsToDips: aMagnitude
	"Scale the device-dependent pixel <Magnitude> argument from the receiver's DPI to DIPs (device-independent, i.e. 96-dpi, pixels) equivalent, and answer the result."

	^aMagnitude * USER_DEFAULT_SCREEN_DPI / dpi!

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

monitorCount
	"Answer the number of monitors currently attached."

	^self getMetric: SM_CMONITORS!

mouseHoverTime
	^MouseHoverTime
		ifNil: [MouseHoverTime := self getSysParamDword: SPI_GETMOUSEHOVERTIME ifError: [400]]!

nonClientMetrics
	"
		SystemMetrics current nonClientMetrics
	"

	^nonClientMetrics ifNil: [nonClientMetrics := self getNonClientMetrics]!

onSettingChanged: anArray
	| code |
	(##(#('Policy' 'intl' 'Environment' 'ImmersiveColorSet') asSet) includes: anArray first)
		ifTrue: [^self].
	menuCheckExtent := smallIconExtent := largeIconExtent := dragHysteresis := scrollThumbExtent := sizingFrameExtent := dialogFrameExtent := borderExtent := edgeExtent := nil.
	code := anArray second.
	code == SPI_SETICONTITLELOGFONT
		ifTrue: 
			[iconTitleFont := nil.
			^self].
	code == SPI_SETNONCLIENTMETRICS
		ifTrue: 
			[menuFont := nonClientMetrics := nil.
			^self]!

paddedBorderThickness
	^self nonClientMetrics iPaddedBorderWidth!

printOn: aStream
	aStream
		basicPrint: self;
		nextPut: $(;
		print: dpi;
		nextPutAll: ' dpi)'!

resolution
	^dpi @ dpi!

scrollbarHeight
	"Answer the height, in pixels, of a horizontal scroll bar."

	^self nonClientMetrics iScrollHeight!

scrollbarWidth
	"Answer the width, in pixels, of a vertical scroll bar."

	^self nonClientMetrics iScrollWidth!

scrollThumbExtent
	^scrollThumbExtent ifNil: [scrollThumbExtent := self getMetric: SM_CXHTHUMB pair: SM_CYVTHUMB]!

setDpi: anInteger
	dpi := anInteger.
	^self!

setSysParamBool: anInteger value: aBoolean
	^UserLibrary default
		systemParametersInfo: anInteger
		uiParam: 0
		pvParam: aBoolean asInteger
		fWinIni: 0!

sizingFrameExtent
	^sizingFrameExtent
		ifNil: [sizingFrameExtent := self getMetric: SM_CXSIZEFRAME pair: SM_CYSIZEFRAME]!

smallIconExtent
	"Answer a <Point> that gives the dimensions of a small size icon."

	^smallIconExtent ifNil: [smallIconExtent := self getMetric: SM_CXSMICON pair: SM_CYSMICON]!

supportsAlphaBlending
	"Answer whether the host supports alpha blending."

	^true!

tileIconExtent
	"Answer a <Point> that gives the dimensions of an icon tile."

	#todo.	"Is there a system metric for this?"
	^tileIconExtent ifNil: [tileIconExtent := self mapDipsToPels: ##(48 @ 48)]!

virtualScreenExtent
	"Answer the extent of the virtual screen, i.e. including desktops on all monitors"

	^(self getMetric: SM_CXVIRTUALSCREEN) @ (self getMetric: SM_CYVIRTUALSCREEN)!

virtualScreenOrigin
	"Answer the origin of the virtual screen, i.e. including desktops on all monitors"

	^(self getMetric: SM_XVIRTUALSCREEN) @ (self getMetric: SM_YVIRTUALSCREEN)!

virtualScreenRectangle
	"Answer the rectangle of the virtual screen, i.e. including desktops on all monitors"

	^self virtualScreenOrigin extent: self virtualScreenExtent!

wheelScrollLines
	^WheelScrollLines
		ifNil: [WheelScrollLines := self getSysParamDword: SPI_GETWHEELSCROLLLINES ifError: [3]]! !

!SystemMetrics categoriesForMethods!
borderExtent!constants!public! !
captionHeight!accessing!public! !
cursorExtent!constants!public! !
defaultColorDepth!accessing!public! !
dialogFrameExtent!constants!public! !
dpi!accessing!public! !
dragHysteresis!constants!public! !
dragImageColorDepth!accessing!private! !
edgeExtent!constants!public! !
extraLargeIconExtent!constants!public! !
getDefaultColorDepth!accessing!helpers!private! !
getIconTitleFont!geometry!private! !
getMetric:!helpers!private! !
getMetric:pair:!helpers!private! !
getNonClientMetrics!constants!private! !
getSysParam:type:ifError:!helpers!private! !
getSysParamBool:!helpers!private! !
getSysParamDword:ifError:!helpers!private! !
getSysParamForDpi:type:ifError:!helpers!private! !
hasButtonNotes!capability enquiries!public! !
hasDesktopComposition!capability enquiries!public! !
hasEnhancedThemes!capability enquiries!public! !
hasFlatMenus!capability enquiries!public! !
hasGdiPalettes!capability enquiries!public! !
hasIconScaleDown!capability enquiries!public! !
hasImageListDragCursors!capability enquiries!public! !
hasLinkButtons!capability enquiries!public! !
hasMenuBitmaps!capability enquiries!public! !
hasSmoothScrollingLists!capability enquiries!public! !
hasTextBoxMargins!capability enquiries!public! !
hasThemes!capability enquiries!public! !
hasTreeViewHotTracking!capability enquiries!public! !
hasWebView!capability enquiries!public! !
iconTitleFont!geometry!public! !
isSlowMachine!public!testing! !
largeIconExtent!constants!public! !
mapDipsToPels:!helpers!public! !
mapPelsToDips:!geometry!public!utilities! !
menuBarColor!constants!public! !
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
printOn:!printing!public! !
resolution!public! !
scrollbarHeight!constants!public! !
scrollbarWidth!constants!public! !
scrollThumbExtent!constants!public! !
setDpi:!initializing!private! !
setSysParamBool:value:!helpers!private! !
sizingFrameExtent!constants!public! !
smallIconExtent!constants!public! !
supportsAlphaBlending!capability enquiries!public! !
tileIconExtent!constants!public! !
virtualScreenExtent!constants!public! !
virtualScreenOrigin!constants!public! !
virtualScreenRectangle!constants!public! !
wheelScrollLines!constants!public! !
!

!SystemMetrics class methodsFor!

cacheDpiIndependentSettings
	IsVistaOrLater := VMLibrary default isWindowsVistaOrGreater.
	IsNotWine := NTLibrary isWine not.
	"Wine does not support the CommCtrlLibrary>>loadIconWithScaleDown:&c method which is normally available under Vista and later. Hence we don't allow this to be called even if the Windows version indicates Vista is available."
	HasIconScaleDown := IsVistaOrLater & IsNotWine!

current
	"Answer the current instance of the receiver. This provides metrics at the system DPI setting."

	^Current ifNil: [Current := self forDpi: UserLibrary default getDpiForSystem]!

default
	"Answer an instance of the receiver that returns device-independent metrics (i.e. at 96-dpi)."

	^Default ifNil: [Default := self forDpi: USER_DEFAULT_SCREEN_DPI]!

forDpi: anInteger
	"Answer an instance of the receiver to query metrics at the specified DPI."

	^(Instances lookup: anInteger)
		ifNil: 
			[IsVistaOrLater ifNil: [self cacheDpiIndependentSettings].
			Instances at: anInteger put: (self basicNew setDpi: anInteger)]!

initialize
	| sysParamVars |
	sysParamVars := IdentityDictionary new.
	{SPI_SETFLATMENU.
		'HasFlatMenus'.
		SPI_SETMOUSEHOVERTIME.
		'MouseHoverTime'.
		SPI_SETWHEELSCROLLLINES.
		'WheelScrollLines'}
			pairsDo: [:setting :varName | sysParamVars at: setting put: (self bindingFor: varName)].
	self addClassConstant: 'SysParamVariables' value: sysParamVars.
	self reset.
	SessionManager current
		when: #settingChanged:
		send: #onSettingChanged:
		to: self!

new
	^self shouldNotImplement!

onPreStripImage
	self reset!

onSettingChanged: anArray
	"Note that in system high DPI awareness mode, that the screen resolution is not changed for running apps, so we don't need to accommodate that yet"

	Instances do: [:each | each onSettingChanged: anArray].
	SysParamVariables at: anArray second ifPresent: [:var | var value: nil]!

reset
	"Reinitialize the receiver. This is done on startup (see UserLibrary class>>clear) or when system settings are changed."

	Default := Current := IsVistaOrLater := IsNotWine := HasIconScaleDown := nil.
	SysParamVariables do: [:each | each value: nil].
	Instances := IdentityDictionary new!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self reset! !

!SystemMetrics class categoriesForMethods!
cacheDpiIndependentSettings!initializing!private! !
current!instance creation!public! !
default!instance creation!public! !
forDpi:!instance creation!public! !
initialize!class initialization!public! !
new!instance creation!public! !
onPreStripImage!event handling!public! !
onSettingChanged:!event handling-win32!private! !
reset!initializing!public! !
uninitialize!class hierarchy-removing!private! !
!

