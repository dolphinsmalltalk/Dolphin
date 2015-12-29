"Filed out from Dolphin Smalltalk X6.2"!

ContainerView subclass: #StyledContainer
	instanceVariableNames: 'edges styledPen styledBrush cornerRadii isAntialiased styledShadow _spare4'
	classVariableNames: 'Nest'
	poolDictionaries: 'GdiplusConstants ThemeConstants Win32Constants'
	classInstanceVariableNames: ''!
StyledContainer guid: (GUID fromString: '{5C05AF7C-9F44-44B6-A823-0B80C9E8E8CB}')!
StyledContainer comment: 'A GroupContainer is a <ContainerView> with improved edge and frame styling'!
!StyledContainer categoriesForClass!MVP-Resources-Containers! !
!StyledContainer methodsFor!

actualCornerRadii
	"Answer a LookupTable of the actual corner radii that we'll use to paint the receiver. Each
	is keyed by the name of the corner in question and we make allowance for the fact that the
	corners must shrink when the size of the receiver becomes too small"

	| answer rads |
	rads := self cornerRadii.
	answer := LookupTable new.
	answer
		at: #topLeft put: rads first asPoint;
		at: #topRight put: rads second asPoint;
		at: #bottomRight put: rads third asPoint;
		at: #bottomLeft put: rads fourth asPoint.
	^answer!

actualEdges
	^self edges!

addArc: aRectangle angles: aPoint to: aGdiplusGraphicsPath 
	"Private - Safely add an arc to a graphicsPath accounting for the possibility that the arc may be of zero radius"

	aRectangle area = 0 
		ifTrue: [^aGdiplusGraphicsPath addLineFrom: aRectangle topLeft to: aRectangle bottomRight].
	aGdiplusGraphicsPath addArc: aRectangle angles: aPoint!

addCorner: cornerSymbol of: bounds corners: aCornersRadiiArray toPath: path 
	| cornerRadius |
	cornerRadius := aCornersRadiiArray at: cornerSymbol.
	cornerSymbol = #topLeft 
		ifTrue: 
			[self 
				addArc: (bounds left @ bounds top extent: cornerRadius)
				angles: 180 @ 90
				to: path].
	cornerSymbol = #topRight 
		ifTrue: 
			[self 
				addArc: ((bounds left + bounds width - cornerRadius x) @ bounds top extent: cornerRadius)
				angles: 270 @ 90
				to: path].
	cornerSymbol = #bottomRight 
		ifTrue: 
			[self 
				addArc: ((bounds left + bounds width - cornerRadius x) 
						@ (bounds top + bounds height - cornerRadius y) extent: cornerRadius)
				angles: 0 @ 90
				to: path].
	cornerSymbol = #bottomLeft 
		ifTrue: 
			[self 
				addArc: (bounds left @ (bounds top + bounds height - cornerRadius y) extent: cornerRadius)
				angles: 90 @ 90
				to: path]!

addCorner: cornerSymbol of: bounds toPath: path 
	self 
		addCorner: cornerSymbol
		of: bounds
		corners: self actualCornerRadii
		toPath: path!

addEdge: edgeSymbol of: bounds toPath: path 
	edgeSymbol = #top 
		ifTrue: 
			[self 
				addCorner: #topLeft
				of: bounds
				toPath: path.
			self 
				addCorner: #topRight
				of: bounds
				toPath: path].
	edgeSymbol = #bottom 
		ifTrue: 
			[self 
				addCorner: #bottomRight
				of: bounds
				toPath: path.
			self 
				addCorner: #bottomLeft
				of: bounds
				toPath: path].
	edgeSymbol = #left 
		ifTrue: 
			[self 
				addCorner: #bottomLeft
				of: bounds
				toPath: path.
			self 
				addCorner: #topLeft
				of: bounds
				toPath: path].
	edgeSymbol = #right 
		ifTrue: 
			[self 
				addCorner: #topRight
				of: bounds
				toPath: path.
			self 
				addCorner: #bottomRight
				of: bounds
				toPath: path]!

allEdges
	^OrderedCollection withAll: #(#top #bottom #left #right)!

ambientBackcolor
	"Private - Answer the background colour that should be inherited by children of this view
	that don't have their own background colour specified. ."

	^Color none!

cornerRadii
	cornerRadii ifNil: [cornerRadii := #(0 0 0 0)].
	^cornerRadii!

cornerRadii: anArrayOrNumber 
	cornerRadii := (anArrayOrNumber isKindOf: Number) 
				ifTrue: [(1 to: 4) collect: [:each | anArrayOrNumber]]
				ifFalse: [anArrayOrNumber].
	self invalidate!

edges
	^edges notNil ifTrue: [edges] ifFalse: [OrderedCollection new]!

edges: anArrayOfSymbolsOrNil 
	edges := anArrayOfSymbolsOrNil notNil ifTrue: [anArrayOfSymbolsOrNil asSet asOrderedCollection].
	self invalidate!

getEdgeBits
	| bits edgeSymbols |
	bits := 0.
	edgeSymbols := self actualEdges.
	(edgeSymbols includes: #top) ifTrue: [bits := bits maskSet: BF_TOP].
	(edgeSymbols includes: #bottom) ifTrue: [bits := bits maskSet: BF_BOTTOM].
	(edgeSymbols includes: #left) ifTrue: [bits := bits maskSet: BF_LEFT].
	(edgeSymbols includes: #right) ifTrue: [bits := bits maskSet: BF_RIGHT].
	^bits!

hasStyledBrush
	^self styledBrush notNil!

hasStyledPen
	^self styledPen notNil!

hasStyledShadow
	^self styledShadow notNil!

initialize
	super initialize.
	edges := self allEdges.
	cornerRadii := #(0 0 0 0).

	"Ther default is to turn clip clhildren on. For non-transparent child views this stops
	flashing during resize. Transparent children, however, will disappear in this mode so we
	have to explicitly draw them into our clips during WM_PAINT"
	self clipChildren: true!

isAntialiased
	"Answers true f the receiver uses antialiasing for it's drawing. This is the default but it
	may sometimes be worth turning this off e.g. for testing"

	isAntialiased isNil ifTrue: [isAntialiased := true].
	^isAntialiased!

isAntialiased: aBoolean 
	isAntialiased := aBoolean.
	self invalidate!

onEraseRequired: aColorEvent 
	"Private - We handle all non-transparent drawing of the background inside the paint handler. This allows us to double buffer
	the graphics calls for less flickering"

	self hasTransparentBackground ifFalse: [^false].
	^super onEraseRequired: aColorEvent!

onPaintRequired: aPaintEvent 
	"Double buffered paint of the receiver"

	"Create a back buffer and a GdiplusGraphics onto it"

	| canvas graphics backGraphics backSurface ms updateRect paintStruct |
	_spare4 ifNil: [_spare4 := 0].
	_spare4 := _spare4 + 1.
	_spare4 < 2 
		ifTrue: 
			[paintStruct := aPaintEvent paintStruct.
			Nest ifNil: [Nest := 0].
			Nest := Nest + 1.
			Nest timesRepeat: [Transcript show: '---'].
			Transcript
				show: 'Enter ';
				show: self handle displayString;
				cr.
			updateRect := paintStruct isNil ifTrue: [self rectangle] ifFalse: [paintStruct rcPaint asRectangle].
			updateRect area > 0 
				ifTrue: 
					[ms := Time millisecondsToRun: 
									[backSurface := GdiplusBitmap extent: self extent.
									backGraphics := backSurface graphics.

									"Draw everything into the buffer"
									self isAntialiased ifTrue: [backGraphics smoothingMode: SmoothingModeAntiAlias].
									self paintParentBackgroundOn: backGraphics.
									self paintStyledBackgroundOn: backGraphics.
									self paintStyledEdgesOn: backGraphics.
									self paintTransparentChildrenOn: backSurface updateRect: updateRect.

									"Flip the back buffer onto the screen"
									canvas := aPaintEvent canvas.
									graphics := GdiplusGraphics fromCanvas: canvas.
									graphics drawImage: backSurface.

									"Tidy up"
									graphics free.
									backGraphics free.
									backSurface free]].
			Nest timesRepeat: [Transcript show: '---'].
			Transcript
				show: 'Exit ';
				show: self handle displayString;
				space;
				show: ms displayString;
				show: 'ms';
				cr.
			Nest := Nest - 1].
	_spare4 := _spare4 - 1.
	^true!

onPositionChanged: aPositionEvent 
	"Private - Handle a window position change event (move or resize)."

	aPositionEvent isResize 
		ifTrue: 
			[Transcript
				show: 'size changed';
				cr.
			self invalidate].
	^super onPositionChanged: aPositionEvent!

paintEdge: edgeSymbol of: aRectangle onGraphics: aGdiplusGraphics withPen: aGdiplusPen 
	| path |
	path := GdiplusGraphicsPath new.
	self 
		addEdge: edgeSymbol
		of: aRectangle
		toPath: path.
	aGdiplusGraphics drawPath: path pen: aGdiplusPen.
	path free!

paintParentBackgroundOn: aGdiplusGraphics 
	"If we do not have a transparent background then we must fill our client rectangle with our parent's background color. In the case of
	our being transparent this is dealt with in the #onEraseRequired: handler."

	| bkColor brush |
	self hasTransparentBackground ifTrue: [^self].
	bkColor := self actualBackcolor.
	bkColor isNone 
		ifFalse: 
			[brush := GdiplusSolidBrush color: bkColor asARGB.
			aGdiplusGraphics fillRectangle: self clientRectangle brush: brush.
			brush free]!

paintStyledBackgroundOn: graphics 
	"Private - Paint the nackground of the receiver"

	| bounds sbrush bbrush backcolorARGB path corners |
	bounds := self styledBackgroundRectangle.
	sbrush := self hasStyledBrush 
				ifTrue: 
					["if we have a styled  brush use that "
					self styledBrush asBackgroundGdiplusBrushFor: self].
	backcolorARGB := self actualBackcolor asARGB.
	bbrush := backcolorARGB isNone ifFalse: [GdiplusSolidBrush color: backcolorARGB].

	"We have to reduce our corner radii by the pen width"
	corners := self actualCornerRadii 
				collect: [:each | each - self styledBorderWidth asPoint max: 0 asPoint].
	path := GdiplusGraphicsPath new.
	self 
		addCorner: #topLeft
		of: bounds
		corners: corners
		toPath: path.
	self 
		addCorner: #topRight
		of: bounds
		corners: corners
		toPath: path.
	self 
		addCorner: #bottomRight
		of: bounds
		corners: corners
		toPath: path.
	self 
		addCorner: #bottomLeft
		of: bounds
		corners: corners
		toPath: path.
	path closeFigure.

	"Paint any shadow first"
	self paintStyledShadowOf: path on: graphics.

	"Follow by the solid background brush"
	bbrush notNil 
		ifTrue: 
			[graphics fillPath: path brush: bbrush.
			bbrush free].

	"And now any styled brush"
	sbrush notNil 
		ifTrue: 
			[graphics fillPath: path brush: sbrush.
			sbrush free]!

paintStyledEdgesOn: graphics 
	| bounds gpen |
	(self hasStyledPen and: [self hasBorder not]) ifFalse: [^self].
	bounds := self styledBorderRectangle.
	gpen := self styledPen asGdiplusPen.
	self actualEdges do: 
			[:each | 
			self 
				paintEdge: each
				of: bounds
				onGraphics: graphics
				withPen: gpen].
	^self!

paintStyledShadowOf: aGdiplusGraphicsPath on: aGdiplusGraphics 
	"Paint the shadow of aGdiplusGraphicsPath on aGdiplusGraphics"

	self hasStyledShadow ifFalse: [^self].
	self hasStyledPen 
		ifFalse: 
			[| shadowPen |
			shadowPen := GdiplusPen color: self styledShadow shadowColor.
			aGdiplusGraphics drawPath: aGdiplusGraphicsPath pen: shadowPen.
			shadowPen free].
	self styledShadow paintShadowOf: aGdiplusGraphicsPath on: aGdiplusGraphics!

paintTransparentChildrenOn: parentImage updateRect: updateRect 
	| parentGraphics |
	parentGraphics := parentImage graphics.
	(self subViews select: [:each | each isTransparent and: [each rectangle intersects: updateRect]]) 
		do: 
			[:eachView | 
			"We need to go a few hoops here. Apparently, getting a canvas onto the
			parentImage directly doesn't work correctly since any text in the child view
			is draw 'bold'. For this reason we create our own GDI bitmap to supply to
			WM_PRINT and thgis seems to work better. We must first copy the parentImage
			background to this."
			| eachBitmap eachCanvas eachImage eachGraphics |
			eachBitmap := Bitmap displayCompatibleWithExtent: eachView extent.
			eachCanvas := eachBitmap canvas.

			"Copy over the parent background image"
			eachGraphics := GdiplusGraphics fromCanvas: eachCanvas.
			eachGraphics 
				drawImage: parentImage
				at: Point zero
				extent: eachView extent
				from: eachView position
				extent: eachView extent.
			eachGraphics free.

			"Print the subview's contemts"
			eachView 
				sendMessage: WM_PRINT
				wParam: eachCanvas handle
				lParam: PRF_CLIENT | PRF_OWNED | PRF_CHILDREN | PRF_NONCLIENT | PRF_CHECKVISIBLE.
			eachView validate.

			"Blit composite background and print to parent image"
			eachImage := GdiplusBitmap fromBitmap: eachBitmap.
			parentGraphics drawImage: eachImage at: eachView position.
			eachImage free.
			eachCanvas free.
			eachBitmap free].
	parentGraphics free.

	"Not sure why the following is required. Validate ALL child views to tell windows not to
	repaint them. If we don't do this then we get a request for an extra paint of the receiver
	for every non-transparent child that it contains. The SHOULD be safe since Windows always
	paints children first. Hence when we arrive here, everything should be up to date"
	self subViews do: [:eachView | eachView validate]!

styledBackgroundRectangle
	"Private - Answer the Rectangle for the background rectangle in the coordinate system of the
	client area. "

	^self styledBorderRectangle!

styledBorderRectangle
	"Private - Answer the Rectangle for the border in the coordinate system of the client area"

	| shadowOffset |
	shadowOffset := self hasStyledShadow ifTrue: [self styledShadow offset] ifFalse: [0].
	^(self styledBorderWidth // 2) asPoint 
		extent: self clientExtent - self styledBorderWidth asPoint - shadowOffset asPoint!

styledBorderWidth
	self hasBorder ifTrue: [^0].
	^self styledPen ifNotNil: [:pen | pen width] ifNil: [0]!

styledBrush
	^styledBrush!

styledBrush: aStyledBrushOrNil 
	styledBrush := aStyledBrushOrNil.
	self invalidate!

styledPen
	^styledPen!

styledPen: aStyledPenOrNil 
	styledPen := aStyledPenOrNil.
	self invalidate!

styledShadow
	^styledShadow!

styledShadow: aStyledShadowOrNil 
	styledShadow := aStyledShadowOrNil.
	self invalidate!

wmPrint: message wParam: wParam lParam: lParam 
	"Private - Handle WM_PRINT."

	self ensureLayoutValid.
	self 
		defaultWindowProcessing: message
		wParam: wParam
		lParam: lParam.
	^true! !
!StyledContainer categoriesFor: #actualCornerRadii!private! !
!StyledContainer categoriesFor: #actualEdges!private! !
!StyledContainer categoriesFor: #addArc:angles:to:!private! !
!StyledContainer categoriesFor: #addCorner:of:corners:toPath:!private! !
!StyledContainer categoriesFor: #addCorner:of:toPath:!private! !
!StyledContainer categoriesFor: #addEdge:of:toPath:!private! !
!StyledContainer categoriesFor: #allEdges!private! !
!StyledContainer categoriesFor: #ambientBackcolor!accessing!private! !
!StyledContainer categoriesFor: #cornerRadii!public! !
!StyledContainer categoriesFor: #cornerRadii:!public! !
!StyledContainer categoriesFor: #edges!accessing!public! !
!StyledContainer categoriesFor: #edges:!accessing!public! !
!StyledContainer categoriesFor: #getEdgeBits!event handling!private! !
!StyledContainer categoriesFor: #hasStyledBrush!public! !
!StyledContainer categoriesFor: #hasStyledPen!public! !
!StyledContainer categoriesFor: #hasStyledShadow!public! !
!StyledContainer categoriesFor: #initialize!private! !
!StyledContainer categoriesFor: #isAntialiased!accessing!public! !
!StyledContainer categoriesFor: #isAntialiased:!accessing!public! !
!StyledContainer categoriesFor: #onEraseRequired:!event handling!private! !
!StyledContainer categoriesFor: #onPaintRequired:!private! !
!StyledContainer categoriesFor: #onPositionChanged:!event handling!private! !
!StyledContainer categoriesFor: #paintEdge:of:onGraphics:withPen:!private! !
!StyledContainer categoriesFor: #paintParentBackgroundOn:!private! !
!StyledContainer categoriesFor: #paintStyledBackgroundOn:!event handling!private! !
!StyledContainer categoriesFor: #paintStyledEdgesOn:!event handling!private! !
!StyledContainer categoriesFor: #paintStyledShadowOf:on:!private! !
!StyledContainer categoriesFor: #paintTransparentChildrenOn:updateRect:!private! !
!StyledContainer categoriesFor: #styledBackgroundRectangle!private! !
!StyledContainer categoriesFor: #styledBorderRectangle!private! !
!StyledContainer categoriesFor: #styledBorderWidth!public! !
!StyledContainer categoriesFor: #styledBrush!public! !
!StyledContainer categoriesFor: #styledBrush:!public! !
!StyledContainer categoriesFor: #styledPen!public! !
!StyledContainer categoriesFor: #styledPen:!public! !
!StyledContainer categoriesFor: #styledShadow!public! !
!StyledContainer categoriesFor: #styledShadow:!public! !
!StyledContainer categoriesFor: #wmPrint:wParam:lParam:!event handling-win32!private! !

!StyledContainer class methodsFor!

clearNest
	Nest := 0!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.StyledContainer)  98 22 0 0 98 2 8 1174405120 131073 416 0 0 0 7 0 0 0 416 0 234 256 98 0 0 202 208 98 4 8 #top 8 #bottom 8 #left 8 #right 590598 ##(Smalltalk.StyledPen)  786694 ##(Smalltalk.IndexedColor)  33554433 5 98 1 3 1246214 ##(Smalltalk.StyledGradientBrush)  721158 ##(Smalltalk.SystemColor)  31 0 328198 ##(Smalltalk.Point)  327734 ##(Smalltalk.Float)  8 0 0 0 0 0 0 224 63 1 770 802 8 0 0 0 0 0 0 224 63 3 98 4 41 41 41 41 16 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 770 3359 21 770 701 501 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 237 7 0 0 4 1 0 0] 98 0 770 193 193 0 27 )! !
!StyledContainer class categoriesFor: #clearNest!public! !
!StyledContainer class categoriesFor: #resource_Default_view!public!resources-views! !

