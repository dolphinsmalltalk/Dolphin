"Filed out from Dolphin Smalltalk"!

TabView subclass: #TabViewXP
	instanceVariableNames: '_tvxReserved0 lastSelection _tvxReserved1 _tvxReserved2 _tvxReserved3'
	classVariableNames: ''
	poolDictionaries: 'ThemeConstants'
	classInstanceVariableNames: ''!
TabViewXP guid: (GUID fromString: '{160cce99-d70d-49cc-9308-00476ce82b28}')!
TabViewXP comment: 'TabViewXP is a custom <TabView> that replaces the control''s default painting with its own implementation using the XP theme engine if running in a themed app on XP/2k3. In an unthemed app (or in Windows 2000) it degrades back to use the control''s own ''classic'' drawing.

TabViewXP is needed because the themed control implementation provided by Microsoft only works correctly when the tab orientation is ''top'' (i.e. the tab strip is along the top). The ''bottom'' tab orientation is useable in the standard control with themes enabled (e.g. see Outlook Express'' e-mail editor window), but is aesthetically unpleasing because the bottom tabs are painted using the same bitmaps used to paint the top tabs, and the selection and hot highlighting are thus in the wrong place. The two vertical orientations (left and right) are completely unusable with themes enabled, so when using the standard control one has to turn off theming for vertical (address book) tabs, but the classic appearance looks poor alongside other themed controls because it has a heavy old-fashioned 3-d edge and no hot/selection hightlight. TabViewXP makes use of the XP theme engine to draw the correct themed appearance for the control when in ''top'' orientation, and our interpretation of what the appearance should have been like for the other orientations if MS had bothered to implement it correctly. Note that we don''t even use the control''s standard painting for the ''top'' orientation, as this allows us to support a configurable background colour.

'!
!TabViewXP categoriesForClass!MVP-Views! !
!TabViewXP methodsFor!

calcClientRectangleFromRectangle: aRectangle 
	"Private - Given a window rectangle represented by the <Rectangle> argument, answer the
	client area that this would provide, taking into account the current window styles etc."

	^self tcmAdjustRect: false for: aRectangle!

createVerticalFont
	| lf |
	lf := self actualFont logFont copy.
	lf lfEscapement: (self isInverted ifTrue: [2700] ifFalse: [900]).
	^Font fromLogFont: lf!

imageTextGap
	^6!

onEraseRequired: aColorEvent 
	"Private - Handler for erase background event - allow the control to take care of this, unless
	transparent backcolor is set in which case the erase is suppressed.."

	self isThemed ifFalse: [^super onEraseRequired: aColorEvent].
	^true!

onPaintRequired: aPaintEvent 
	"Private - Default handler for paint.
	N.B. Do not invoke default processing from this event because BeginPaint() has already
	been called. If you need to invoke default processing then you will have to override
	#wmPaint:wParam:lParam: (e.g. see ControlView)."

	| backSurface pageRect clientRect tabOrientation backBitmap canvas insets extent itemTransform |
	canvas := aPaintEvent canvas.
	canvas forecolor: (self forecolor ifNil: [Color windowText]).
	clientRect := self clientRectangle.
	extent := clientRect extent.
	insets := clientRect insetBy: (self tcmAdjustRect: false for: clientRect).
	pageRect := clientRect copy.
	tabOrientation := self tabOrientation.
	tabOrientation == #top 
		ifTrue: 
			[pageRect := clientRect left @ (clientRect top + insets top - (insets bottom // 2)) 
						corner: clientRect corner.
			self paintThemedBackgroundOn: canvas in: pageRect.
			itemTransform := [:rc | rc].
			self paintThemedTabsOn: canvas offset: itemTransform.
			self paintTabLabelsOn: canvas.
			^0].
	tabOrientation == #bottom 
		ifTrue: 
			[| offset |
			pageRect := clientRect left @ (clientRect top + insets bottom - (insets top // 2)) 
						corner: clientRect corner.
			offset := 0 @ (-1 * (clientRect height - insets bottom)).
			itemTransform := [:rc | rc translatedBy: offset]].
	tabOrientation == #left 
		ifTrue: 
			[extent := extent transpose.
			pageRect := clientRect left @ (clientRect top + insets left - (insets right // 2)) 
						corner: clientRect corner transpose.
			itemTransform := [:rc | rc topLeft transpose extent: rc extent transpose]].
	tabOrientation == #right 
		ifTrue: 
			[extent := extent transpose.
			pageRect := clientRect left @ (clientRect top + insets right - (insets left // 2)) 
						corner: clientRect corner transpose.
			itemTransform := [:rc | rc top @ (clientRect right - rc right) extent: rc extent transpose]].
	backBitmap := Bitmap compatible: canvas extent: extent.
	backSurface := backBitmap canvas.
	self paintThemedBackgroundOn: backSurface in: pageRect.
	self paintThemedTabsOn: backSurface offset: itemTransform.
	tabOrientation == #bottom 
		ifTrue: 
			[backBitmap 
				drawOn: canvas
				at: clientRect bottomLeft - (0 @ 1)
				extent: extent * (1 @ -1).
			self paintTabLabelsOn: canvas].
	tabOrientation == #right 
		ifTrue: 
			[canvas 
				plgBlt: backSurface
				rectangle: (0 @ 0 extent: extent)
				topLeft: clientRect topRight
				topRight: clientRect bottomRight
				bottomLeft: clientRect topLeft.
			self paintVerticalTabLabelsOn: canvas].
	tabOrientation == #left 
		ifTrue: 
			[canvas 
				plgBlt: backSurface
				rectangle: (0 @ 0 extent: extent)
				topLeft: clientRect topLeft
				topRight: clientRect bottomLeft
				bottomLeft: clientRect topRight.
			self paintVerticalTabLabelsOn: canvas].
	backBitmap free.
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

paintLabel: anInteger on: aCanvas in: aRectangle
	| inverted rcItem textExtent labelRect textOffset text tcItem imageIndex |
	tcItem := self getItem: anInteger.
	text := tcItem text.
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
			imageExtent := self imageExtent.
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

paintTabLabelsOn: aCanvas
	| selectedIndex nOldMode oldFont rect itemCount |
	itemCount := self itemCount.
	itemCount < 1 ifTrue: [^self].
	nOldMode := aCanvas backgroundMode: TRANSPARENT.
	oldFont := aCanvas font: self actualFont.
	selectedIndex := self selectionByIndex.
	1 to: selectedIndex - 1
		do: 
			[:i |
			self
				paintLabel: i
				on: aCanvas
				in: (self itemRect: i)].
	"It doesn't particularly make sense, but there can be no selection in a TabView."
	selectedIndex ~~ 0
		ifTrue: 
			[rect := self itemRect: selectedIndex.
			self
				paintLabel: selectedIndex
				on: aCanvas
				in: (rect translateBy: 0 @ (self isInverted ifTrue: [self selExtra] ifFalse: [self selExtra negated])).
			self hasFocus ifTrue: [UserLibrary default drawFocusRect: aCanvas asParameter lprc: (rect insetBy: 1) asParameter]].
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
	ThemeLibrary default 
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
			aCanvas fillRectangle: (aCanvas clipBox subtract: aRectangle) color: bkColor]!

paintThemedTabsOn: aCanvas offset: aMonadicValuable
	| selected hot numItems themeLib dc part rcItem hTheme |
	numItems := self itemCount.
	numItems <= 0 ifTrue: [^self].
	"Paint all the tabs except for the selected one (assuming there is one; in very unusual circumstances there may not be)"
	hot := self itemFromPoint: self cursorPosition.
	selected := self selectionByIndex.
	themeLib := ThemeLibrary default.
	dc := aCanvas asParameter.
	hTheme := self theme.
	selected == 1
		ifFalse: 
			[themeLib
				drawThemeBackground: hTheme
				hdc: dc
				iPartId: TABP_TABITEMLEFTEDGE
				iStateId: (1 == hot ifTrue: [TIS_HOT] ifFalse: [TIS_NORMAL])
				pRect: (aMonadicValuable value: (self itemRect: 1)) asParameter
				pClipRect: nil].
	2 to: selected - 1
		do: 
			[:i |
			themeLib
				drawThemeBackground: hTheme
				hdc: dc
				iPartId: TABP_TABITEM
				iStateId: (i == hot ifTrue: [TIS_HOT] ifFalse: [TIS_NORMAL])
				pRect: (aMonadicValuable value: (self itemRect: i)) asParameter
				pClipRect: nil].
	(selected + 1 max: 2) to: numItems - 1
		do: 
			[:i |
			themeLib
				drawThemeBackground: hTheme
				hdc: dc
				iPartId: TABP_TABITEM
				iStateId: (i == hot ifTrue: [TIS_HOT] ifFalse: [TIS_NORMAL])
				pRect: (aMonadicValuable value: (self itemRect: i)) asParameter
				pClipRect: nil].
	selected == numItems
		ifFalse: 
			[| anInteger |
			anInteger := TABP_TABITEMRIGHTEDGE.
			themeLib
				drawThemeBackground: hTheme
				hdc: dc
				iPartId: anInteger
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
	themeLib
		drawThemeBackground: hTheme
		hdc: dc
		iPartId: part
		iStateId: TIS_SELECTED
		pRect: rcItem asParameter
		pClipRect: nil!

paintVerticalLabel: anInteger on: aCanvas in: aRectangle 
	| text inverted textExtent textOffset labelRect tcItem imageIndex |
	inverted := self isInverted.
	tcItem := self getItem: anInteger.
	text := tcItem text copyWithout: $&.
	imageIndex := self hasIcons ifTrue: [tcItem iImage + 1] ifFalse: [-1].
	textExtent := (aCanvas textExtent: text) transpose.
	imageIndex <= 0 
		ifTrue: 
			[textOffset := 0.
			labelRect := Rectangle center: aRectangle center extent: textExtent]
		ifFalse: 
			[| space imagePos imageExtent |
			imageExtent := self imageExtent.
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
	selectedIndex := self selectionByIndex .
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
		in: (rect 
				translateBy: (self isInverted ifTrue: [self selExtra] ifFalse: [self selExtra negated]) @ 0).
	self hasFocus 
		ifTrue: [UserLibrary default drawFocusRect: aCanvas asParameter lprc: (rect insetBy: 1) asParameter].
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
!TabViewXP categoriesForMethods!
calcClientRectangleFromRectangle:!geometry!private! !
createVerticalFont!event handling!private! !
imageTextGap!constants!private! !
onEraseRequired:!event handling!private! !
onPaintRequired:!event handling!private! !
onSelChanged:!event handling!private! !
onSelectionChanging:!event handling!private! !
onViewDestroyed!event handling!private! !
paintLabel:on:in:!painting!private! !
paintTabLabelsOn:!event handling!private! !
paintThemedBackgroundOn:in:!painting!private! !
paintThemedTabsOn:offset:!painting!private! !
paintVerticalLabel:on:in:!painting!private! !
paintVerticalTabLabelsOn:!event handling!private! !
selExtra!constants!private! !
supportsThemedVertical!constants!private! !
wmPaint:wParam:lParam:!event handling-win32!private! !
wmPrintClient:wParam:lParam:!event handling-win32!private! !
!

!TabViewXP class methodsFor!

themePartName
	^'TAB'! !
!TabViewXP class categoriesForMethods!
themePartName!public! !
!

