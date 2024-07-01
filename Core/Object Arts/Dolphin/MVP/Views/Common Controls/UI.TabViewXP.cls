"Filed out from Dolphin Smalltalk"!

UI.TabView
	subclass: #'UI.TabViewXP'
	instanceVariableNames: '_tvxReserved0 lastSelection _tvxReserved1 _tvxReserved2 _tvxReserved3'
	classVariableNames: ''
	imports: #(#{OS.ThemeConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.TabViewXP guid: (Core.GUID fromString: '{160cce99-d70d-49cc-9308-00476ce82b28}')!

UI.TabViewXP comment: 'TabViewXP is a custom <TabView> that replaces the control''s default painting with its own implementation using the XP theme engine if running in a themed app on XP/2k3. In an unthemed app (or in Windows 2000) it degrades back to use the control''s own ''classic'' drawing.

TabViewXP is needed because the themed control implementation provided by Microsoft only works correctly when the tab orientation is ''top'' (i.e. the tab strip is along the top). The ''bottom'' tab orientation is useable in the standard control with themes enabled (e.g. see Outlook Express'' e-mail editor window), but is aesthetically unpleasing because the bottom tabs are painted using the same bitmaps used to paint the top tabs, and the selection and hot highlighting are thus in the wrong place. The two vertical orientations (left and right) are completely unusable with themes enabled, so when using the standard control one has to turn off theming for vertical (address book) tabs, but the classic appearance looks poor alongside other themed controls because it has a heavy old-fashioned 3-d edge and no hot/selection hightlight. TabViewXP makes use of the XP theme engine to draw the correct themed appearance for the control when in ''top'' orientation, and our interpretation of what the appearance should have been like for the other orientations if MS had bothered to implement it correctly. Note that we don''t even use the control''s standard painting for the ''top'' orientation, as this allows us to support a configurable background colour.

'!

!UI.TabViewXP categoriesForClass!MVP-Views! !

!UI.TabViewXP methodsFor!

calcClientRectangleFromRectangle: aRectangle 
	"Private - Given a window rectangle represented by the <Rectangle> argument, answer the
	client area that this would provide, taking into account the current window styles etc."

	^self tcmAdjustRect: false for: aRectangle!

createVerticalFont
	| vertical |
	vertical := self actualFont copy.
	vertical logFont lfEscapement: (self isInverted ifTrue: [2700] ifFalse: [900]).
	^vertical!

imageTextGap
	^6!

onEraseRequired: aColorEvent 
	"Private - Handler for erase background event - allow the control to take care of this, unless
	transparent backcolor is set in which case the erase is suppressed.."

	self isThemed ifFalse: [^super onEraseRequired: aColorEvent].
	^true!

onPaintRequired: aPaintEvent
	| orientation canvas |
	canvas := aPaintEvent canvas.
	canvas forecolor: self forecolor ?? Color.WindowText.
	orientation := self tabOrientation.
	orientation == #top
		ifTrue: [self paintTopOrientationOn: canvas]
		ifFalse: 
			[orientation == #left
				ifTrue: [self paintLeftOrientationOn: canvas]
				ifFalse: 
					[orientation == #bottom
						ifTrue: [self paintBottomOrientationOn: canvas]
						ifFalse: [self paintRightOrientationOn: canvas]]].
	^0!

onSelChanged: anArray 
	lastSelection notNil 
		ifTrue: 
			[| rect |
			rect := self mapRectangle: ((self itemRect: lastSelection) expandBy: self selExtra)
						to: self parentView.
			self parentView invalidateRect: rect].
	super onSelChanged: anArray!

onSelectionChanging: aSelectionChangingEvent 
	lastSelection := self getSingleSelection.
	super onSelectionChanging: aSelectionChangingEvent!

onViewDestroyed
	super onViewDestroyed.
	self freeTheme!

paintBottomOrientationOn: aCanvas
	| clientRect insets extent backSurface offset backBitmap |
	clientRect := self clientRectangle.
	insets := clientRect insetBy: (self tcmAdjustRect: false for: clientRect).
	extent := clientRect extent.
	backBitmap := Bitmap compatible: aCanvas extent: extent.
	backSurface := backBitmap canvas.
	self paintThemedBackgroundOn: backSurface
		in: (clientRect left @ (clientRect top + insets bottom - (insets top // 2)) corner: clientRect corner).
	offset := 0 @ (-1 * (clientRect height - insets bottom)).
	self paintThemedTabsOn: backSurface offset: [:rc | rc translatedBy: offset].
	backBitmap
		drawOn: aCanvas
			at: clientRect bottomLeft - ##(0 @ 1)
			extent: extent * ##(1 @ -1);
		free.
	self paintTabLabelsOn: aCanvas!

paintLabel: anInteger on: aCanvas in: aRectangle
	| inverted rcItem textExtent labelRect textOffset text tcItem imageIndex |
	tcItem := self getItem: anInteger.
	text := tcItem pszText.
	imageIndex := self hasIcons ifTrue: [tcItem iImage + 1] ifFalse: [-1].
	inverted := self isInverted.
	rcItem := aRectangle copy.
	inverted ifTrue: [rcItem bottom: rcItem bottom - 1] ifFalse: [rcItem top: rcItem top + 1].
	textExtent := aCanvas
				textExtent: text
				width: 0
				flags: DT_SINGLELINE.
	imageIndex <= 0
		ifTrue: 
			[textOffset := 0.
			labelRect := Rectangle center: rcItem center extent: textExtent]
		ifFalse: 
			[| space imageExtent |
			imageExtent := self scaledImageExtent.
			textOffset := imageExtent x + self imageTextGap.
			labelRect := Rectangle center: rcItem center
						extent: (textExtent isZero
								ifTrue: [imageExtent]
								ifFalse: [(textOffset + textExtent x) @ (imageExtent y max: textExtent y + 1)]).
			space := labelRect height - imageExtent y.
			(self imageManager imageListWithExtent: imageExtent)
				draw: imageIndex
				on: aCanvas
				at: labelRect left
						@ (labelRect top + (inverted ifTrue: [space // 2] ifFalse: [space - (space // 2)]))].
	textExtent > 0 ifFalse: [^self].
	labelRect := labelRect insetOriginBy: textOffset @ (inverted ifTrue: [-1] ifFalse: [1]).
	aCanvas
		formatText: text
		in: labelRect
		flags: ##(DT_VCENTER | DT_SINGLELINE | DT_END_ELLIPSIS)!

paintLeftOrientationOn: aCanvas
	| clientRect insets extent backSurface backBitmap |
	clientRect := self clientRectangle.
	extent := clientRect extent transpose.
	backBitmap := Bitmap compatible: aCanvas extent: extent.
	backSurface := backBitmap canvas.
	insets := clientRect insetBy: (self tcmAdjustRect: false for: clientRect).
	self paintThemedBackgroundOn: backSurface
		in: (clientRect left @ (clientRect top + insets left - (insets right // 2))
				corner: clientRect corner transpose).
	self paintThemedTabsOn: backSurface offset: [:rc | rc topLeft transpose extent: rc extent transpose].
	aCanvas
		plgBlt: backSurface
		rectangle: (Rectangle extent: extent)
		topLeft: clientRect topLeft
		topRight: clientRect bottomLeft
		bottomLeft: clientRect topRight.
	backBitmap free.
	self paintVerticalTabLabelsOn: aCanvas!

paintRightOrientationOn: aCanvas
	| clientRect extent insets backSurface backBitmap |
	clientRect := self clientRectangle.
	extent := clientRect extent transpose.
	backBitmap := Bitmap compatible: aCanvas extent: extent.
	backSurface := backBitmap canvas.
	insets := clientRect insetBy: (self tcmAdjustRect: false for: clientRect).
	self paintThemedBackgroundOn: backSurface
		in: (clientRect left @ (clientRect top + insets right - (insets left // 2))
				corner: clientRect corner transpose).
	self paintThemedTabsOn: backSurface
		offset: [:rc | rc top @ (clientRect right - rc right) extent: rc extent transpose].
	aCanvas
		plgBlt: backSurface
		rectangle: (Rectangle extent: extent)
		topLeft: clientRect topRight
		topRight: clientRect bottomRight
		bottomLeft: clientRect topLeft.
	backBitmap free.
	self paintVerticalTabLabelsOn: aCanvas!

paintTabLabelsOn: aCanvas
	| selectedIndex nOldMode oldFont itemCount |
	itemCount := self itemCount.
	itemCount < 1 ifTrue: [^self].
	nOldMode := aCanvas backgroundMode: TRANSPARENT.
	oldFont := aCanvas font: self actualFont.
	1 to: (selectedIndex := self selectionByIndex) - 1
		do: 
			[:i |
			self
				paintLabel: i
				on: aCanvas
				in: (self itemRect: i)].
	"It doesn't particularly make sense, but there can be no selection in a TabView."
	selectedIndex ~~ 0
		ifTrue: 
			[| rect |
			rect := self itemRect: selectedIndex.
			self
				paintLabel: selectedIndex
				on: aCanvas
				in: (rect translateBy: 0 @ (self isInverted ifTrue: [self selExtra] ifFalse: [self selExtra negated])).
			self hasFocus
				ifTrue: [User32 drawFocusRect: aCanvas asParameter lprc: (rect insetBy: 1) asParameter]].
	selectedIndex + 1 to: itemCount
		do: 
			[:i |
			self
				paintLabel: i
				on: aCanvas
				in: (self itemRect: i)].
	aCanvas
		backgroundMode: nOldMode;
		font: oldFont!

paintThemedBackgroundOn: aCanvas in: aRectangle
	| bkColor |
	UxTheme
		drawThemeBackground: self theme
		hdc: aCanvas asParameter
		iPartId: TABP_PANE
		iStateId: 0
		pRect: aRectangle asParameter
		pClipRect: nil.
	bkColor := self actualBackcolor.
	bkColor isNone
		ifFalse: 
			["This is the background fill behind the tabs"
			aCanvas fillRectangle: (aCanvas getClipBox subtract: aRectangle) color: bkColor]!

paintThemedTabsOn: aCanvas offset: aMonadicValuable
	| selected hot numItems dc hTheme part rcItem  |
	numItems := self itemCount.
	numItems <= 0 ifTrue: [^self].
	"Paint all the tabs except for the selected one (assuming there is one; in very unusual circumstances there may not be)"
	hot := self itemFromPoint: self cursorPosition.
	selected := self selectionByIndex.
	dc := aCanvas asParameter.
	hTheme := self theme.
	selected == 1
		ifFalse: 
			[UxTheme
				drawThemeBackground: hTheme
				hdc: dc
				iPartId: TABP_TABITEMLEFTEDGE
				iStateId: (1 == hot ifTrue: [TIS_HOT] ifFalse: [TIS_NORMAL])
				pRect: (aMonadicValuable value: (self itemRect: 1)) asParameter
				pClipRect: nil].
	2 to: selected - 1
		do: 
			[:i |
			UxTheme
				drawThemeBackground: hTheme
				hdc: dc
				iPartId: TABP_TABITEM
				iStateId: (i == hot ifTrue: [TIS_HOT] ifFalse: [TIS_NORMAL])
				pRect: (aMonadicValuable value: (self itemRect: i)) asParameter
				pClipRect: nil].
	(selected + 1 max: 2) to: numItems - 1
		do: 
			[:i |
			UxTheme
				drawThemeBackground: hTheme
				hdc: dc
				iPartId: TABP_TABITEM
				iStateId: (i == hot ifTrue: [TIS_HOT] ifFalse: [TIS_NORMAL])
				pRect: (aMonadicValuable value: (self itemRect: i)) asParameter
				pClipRect: nil].
	selected == numItems
		ifFalse: 
			[UxTheme
				drawThemeBackground: hTheme
				hdc: dc
				iPartId: TABP_TABITEMRIGHTEDGE
				iStateId: (numItems == hot ifTrue: [TIS_HOT] ifFalse: [TIS_NORMAL])
				pRect: (aMonadicValuable value: (self itemRect: numItems)) asParameter
				pClipRect: nil].

	"Paint the active selected tab. This must be done last as it is made slightly larger, and
	therefore draws over the top of the inactive tabs"
	rcItem := (aMonadicValuable value: (self itemRect: selected)) expandBy: self selExtra.
	part := selected == 1
				ifTrue: 
					["Clip out the last line to avoid the theme bitmap overwriting the left edge if selection is first item"
					aCanvas excludeClipRectangle: (rcItem left @ rcItem bottom - 1 corner: rcItem corner).
					TABP_TABITEMLEFTEDGE]
				ifFalse: 
					["We don't bother with using TABP_TABITEMRIGHTEDGE for the selected tab as Windows 10 has a cosmetic bug whereby the edge extends one pixel past the bottom edge, which looks a bit sloppy."

					"selected == numItems ifTrue: [TABP_TABITEMRIGHTEDGE] ifFalse: [TABP_TABITEM]"
					TABP_TABITEM].
	UxTheme
		drawThemeBackground: hTheme
		hdc: dc
		iPartId: part
		iStateId: TIS_SELECTED
		pRect: rcItem asParameter
		pClipRect: nil!

paintTopOrientationOn: aCanvas
	| clientRect insets |
	clientRect := self clientRectangle.
	insets := clientRect insetBy: (self tcmAdjustRect: false for: clientRect).
	self
		paintThemedBackgroundOn: aCanvas
			in: (clientRect left @ (clientRect top + insets top - (insets bottom // 2)) corner: clientRect corner);
		paintThemedTabsOn: aCanvas offset: [:rc | rc];
		paintTabLabelsOn: aCanvas!

paintVerticalLabel: anInteger on: aCanvas in: aRectangle
	| text inverted textExtent textOffset labelRect tcItem imageIndex |
	inverted := self isInverted.
	tcItem := self getItem: anInteger.
	text := tcItem pszText copyWithout: $&.
	imageIndex := self hasIcons ifTrue: [tcItem iImage + 1] ifFalse: [-1].
	textExtent := (aCanvas textExtent: text) transpose.
	imageIndex <= 0
		ifTrue: 
			[textOffset := 0.
			labelRect := Rectangle center: aRectangle center extent: textExtent]
		ifFalse: 
			[| space imagePos imageExtent |
			imageExtent := self scaledImageExtent.
			textOffset := imageExtent y + self imageTextGap.
			labelRect := Rectangle center: aRectangle center
						extent: (textExtent isZero
								ifTrue: [imageExtent]
								ifFalse: [(imageExtent x max: textExtent x) @ (textOffset + textExtent y)]).
			space := labelRect width - imageExtent x.
			inverted
				ifTrue: 
					[imagePos := (labelRect left + (space // 2)) @ labelRect top.
					labelRect := labelRect insetOriginBy: 0 @ textOffset]
				ifFalse: [imagePos := (labelRect left + (space - (space // 2))) @ (labelRect bottom - imageExtent y)].
			(self imageManager imageListWithExtent: imageExtent)
				draw: imageIndex
				on: aCanvas
				at: imagePos].
	text isEmpty ifTrue: [^self].

	"From MSDN: 'The DrawText function supports only fonts whose escapement and orientation are
	both zero.' Actually it does draw the text, but most of the functions such as centering do
	not work correctly, therefore we might as well use ExtTextOut. Of course this means we must
	do the centreing ourselves, and we lose the prefix handling."
	aCanvas setTextAlign: (inverted ifTrue: [TA_BOTTOM] ifFalse: [TA_RIGHT]).
	aCanvas text: text at: (labelRect left + ((labelRect width - textExtent x) // 2)) @ labelRect top!

paintVerticalTabLabelsOn: aCanvas
	| selectedIndex nOldMode oldFont rect itemCount |
	itemCount := self itemCount.
	itemCount < 1 ifTrue: [^self].
	oldFont := aCanvas font: self createVerticalFont.
	nOldMode := aCanvas backgroundMode: TRANSPARENT.
	selectedIndex := self selectionByIndex.
	1 to: selectedIndex - 1
		do: 
			[:i |
			self
				paintVerticalLabel: i
				on: aCanvas
				in: (self itemRect: i)].
	rect := self itemRect: selectedIndex.
	self
		paintVerticalLabel: selectedIndex
		on: aCanvas
		in: (rect translateBy: (self isInverted ifTrue: [self selExtra] ifFalse: [self selExtra negated]) @ 0).
	self hasFocus
		ifTrue: [User32 drawFocusRect: aCanvas asParameter lprc: (rect insetBy: 1) asParameter].
	selectedIndex + 1 to: itemCount
		do: 
			[:i |
			self
				paintVerticalLabel: i
				on: aCanvas
				in: (self itemRect: i)].
	aCanvas backgroundMode: nOldMode.
	"We created the vertical font, so we might as well free it to save on finalisation"
	(aCanvas font: oldFont) free!

selExtra
	^2!

supportsThemedVertical
	^true!

wmPaint: message wParam: wParam lParam: lParam
	"Private - This window requires painting. By default we use the internal painting
	 dispatch."

	self ensureLayoutValid.
	self isThemed
		ifFalse: 
			[^super
				wmPaint: message
				wParam: wParam
				lParam: lParam].
	self withOldWndProc: 
			[self
				basicPaint: message
				wParam: wParam
				lParam: lParam].
	^0!

wmPrintClient: message wParam: wParam lParam: lParam
	self ensureLayoutValid.
	self isThemed
		ifFalse: 
			[^super
				wmPaint: message
				wParam: wParam
				lParam: lParam].
	^self withOldWndProc: 
			[self onPaintRequired: (PaintEvent
						window: self
						wParam: 0
						hdc: wParam
						paintStruct: nil)]! !

!UI.TabViewXP categoriesForMethods!
calcClientRectangleFromRectangle:!geometry!private! !
createVerticalFont!event handling!private! !
imageTextGap!constants!private! !
onEraseRequired:!event handling!private! !
onPaintRequired:!event handling!painting!private! !
onSelChanged:!event handling!private! !
onSelectionChanging:!event handling!private! !
onViewDestroyed!event handling!private! !
paintBottomOrientationOn:!painting!private! !
paintLabel:on:in:!painting!private! !
paintLeftOrientationOn:!painting!private! !
paintRightOrientationOn:!painting!private! !
paintTabLabelsOn:!painting!private! !
paintThemedBackgroundOn:in:!painting!private! !
paintThemedTabsOn:offset:!painting!private! !
paintTopOrientationOn:!event handling!painting!private! !
paintVerticalLabel:on:in:!painting!private! !
paintVerticalTabLabelsOn:!painting!private! !
selExtra!constants!private! !
supportsThemedVertical!constants!private! !
wmPaint:wParam:lParam:!event handling-win32!private! !
wmPrintClient:wParam:lParam:!event handling-win32!private! !
!

!UI.TabViewXP class methodsFor!

themePartName
	^'TAB'! !

!UI.TabViewXP class categoriesForMethods!
themePartName!public! !
!

