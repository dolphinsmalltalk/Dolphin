"Filed out from Dolphin Smalltalk"!

Object subclass: #Canvas
	instanceVariableNames: 'handle source owned pen brush font saved saveIds'
	classVariableNames: 'DesktopResolution'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Canvas guid: (GUID fromString: '{87b4c45e-026e-11d3-9fd7-00a0cc3e4a32}')!
Canvas comment: 'Canvas is the class that represents device contexts for drawing graphical output such as lines, shapes, bitmaps and text. As a context, Canvas instances maintain not only the current drawing position, but also the current pen, brush, font, foreground and background colors, text drawing mode, etc.

Instance Variables:
	handle		<ExternalHandle>
	source		<dcSource>. Object from which the device context was obtained, and to which it should be returned when free''d.
	owned		<boolean>. Whether or not the associated GDI device context is owned by this canvas and should be free''d with it.
	pen			The currently selected <Pen>, if any.
	brush		The currently selected <Brush>, if any.
	font		The currently selected <Font>, if any.
	saved		<IdentityDictionary> mapping ids to save/restore check points (used to save/restore pen, brush font, etc settings).
	saveIds		<OrderedCollection> of the idse of previous saves of the context state (see ''saved'').

Class Variables:
	DesktopResolution		<Point>. Resolution of the primary display.




'!
!Canvas categoriesForClass!Graphics-Drawing! !
!Canvas methodsFor!

alphaBlend: aCanvas rectangle: aRectangle to: dstOrigin extent: dstExtent blend: blendFunction
	"Alpha blends a rectangular region from aCanvas to the receiver with scaling.
	Answer true if the operation succeeds"

	^GDILibrary default
		gdiAlphaBlend: self asParameter
		xoriginDest: dstOrigin x
		yoriginDest: dstOrigin y
		wDest: dstExtent x
		hDest: dstExtent y
		hdcSrc: aCanvas asParameter
		xoriginSrc: aRectangle left
		yoriginSrc: aRectangle top
		wSrc: aRectangle width
		hSrc: aRectangle height
		ftn: blendFunction!

alphaBlendBitmap: aBitmap at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent blend: blendFunction
	"Private - Alpha blend the specified rectangle of aBitmap to the specified destination
	rectangle with the specified blendFunction. The receiver is stretched to
	fit the destination rectangle. Handles and palette changes required
	by the bitmap. Answers zero if the operation fails"

	"Create and apply the receiver's palette (if any)"

	| hPalette oldPalette answer |
	hPalette := aBitmap createPalette.
	hPalette notNil ifTrue: [oldPalette := self palette: hPalette].
	answer := self 
				alphaBlend: aBitmap canvas
				rectangle: (Rectangle origin: srcOrigin extent: srcExtent)
				to: dstOrigin
				extent: dstExtent
				blend: blendFunction.
	hPalette notNil 
		ifTrue: 
			["Tidy up palette manipulation"

			self selectPalette: oldPalette.
			GDILibrary default deleteObject: hPalette].
	^answer!

asParameter
	"Answer the receiver in a form suitable for passing to an external function."

	^handle!

backcolor
	"Get the receiver's current background color."

	^Color fromCOLORREF: (GDILibrary default getBkColor: self asParameter)!

backcolor: aColor
	"Set the receiver's background color to the <Color>, aColor.
	Answers the previous background <Color>."

	^Color fromCOLORREF: (GDILibrary default setBkColor: self asParameter crColor: aColor asCOLORREF)!

backgroundMode
	^GDILibrary default getBkMode: self asParameter!

backgroundMode: anInteger 
	"Set the receiver's background drawing mode to mode."

	^GDILibrary default setBkMode: self asParameter iBkMode: anInteger!

basicFree
	"Private - Free external resources held by the receiver.
	If we don't 'own' the hDC we do nothing.
	If we know the handle used for the original GetDC() then we do a ReleaseDC(),
	otherwise we do a DeleteDC()."

	owned ifTrue: [source releaseDC: self asParameter]!

bitBlt: aCanvasOrHandle rectangle: aRectangle to: dstOrigin rop: rop
	"Blits a rectangular region from aCanvasOrHandle to the receiver
	Answer true if the operation succeeds"

	^GDILibrary default
		bitBlt: self asParameter
		nXDest: dstOrigin x 
		nYDest: dstOrigin y 
		nWidth: aRectangle width 
		nHeight: aRectangle height 
		hdcSrc: aCanvasOrHandle asParameter 
		nXSrc: aRectangle left 
		nYSrc: aRectangle top 
		dwRop: rop
!

brush
	"Answer the current brush."

	brush isNil ifTrue: [brush := Brush fromHandle: (self getCurrentObject: OBJ_BRUSH)].
	^brush!

brush: aBrush
	"Select aBrush into this canvas."

	| oldBrush |
	oldBrush := brush.
	brush := aBrush.
	self selectObject: aBrush.
	^oldBrush!

brushColor
	"Get the colour of the brush currently selected into the DC. N.B. Only works on XP and
	later, and undefined if the brush is not solid."

	^Color fromCOLORREF: (GDILibrary default getDCBrushColor: self asParameter)!

brushOrigin: aPoint
	"Sets the origin offset for brush drawing within the receiver to
	be aPoint. Answers the previous origin"

	| previous |
	previous := POINTL new.
	GDILibrary default 
		setBrushOrgEx: self asParameter nXOrg: aPoint x nYOrg: aPoint y lppt: previous asParameter.
	^previous asPoint
!

clipBox
	"Answers the smallest <Rectangle> the completely bounds the receiver's current clipping region."

	| answer |
	answer := RECT new.
	GDILibrary default getClipBox: self asParameter lprc: answer.
	^answer asRectangle!

colorDepth
	"Answers the colour bit depth supported by the receiver"

	^(self getDeviceCaps: BITSPIXEL) * (self getDeviceCaps: PLANES)!

colors
	"Answers the number of colours supported by the receiver"

	^2 raisedToInteger: (self colorDepth)!

drawBitmap: aBitmap at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent rop: dwRasterOp 
	"Private - Blit the specified rectangle of aBitmap to the specified destination
	rectangle with the specified raster op. The receiver is stretched to
	fit the destination rectangle. Handles and palette changes required
	by the bitmap. Answers zero if the operation fails"

	"Create and apply the receiver's palette (if any)"

	| hPalette oldPalette answer |
	hPalette := aBitmap createPalette.
	hPalette notNil ifTrue: [oldPalette := self palette: hPalette].
	answer := self 
				stretchBlt: aBitmap canvas
				rectangle: (Rectangle origin: srcOrigin extent: srcExtent)
				to: dstOrigin
				extent: dstExtent
				rop: dwRasterOp.
	hPalette notNil 
		ifTrue: 
			["Tidy up palette manipulation"

			self selectPalette: oldPalette.
			GDILibrary default deleteObject: hPalette].
	^answer!

drawEdge: aRectangle edge: edgeInteger grfFlags: bdrInteger 
	"The DrawEdge function draws one or more edges of rectangle."

	^UserLibrary default 
		drawEdge: self asParameter
		qrc: aRectangle asParameter
		edge: edgeInteger
		grfFlags: bdrInteger!

ellipse: aRectangle
	"Draw an ellipse on the receiver with the bounds of aRectangle."

	^GDILibrary default
		ellipse: self asParameter
		nLeftRect: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom
!

erase
	"Erase the receiver to the current background colour (not the current brush)."

	self fillRectangle: (RECT 
				left: 0
				top: 0
				right: self width
				bottom: self height)
		color: self backcolor!

excludeClipRectangle: aRectangle 
	"Exclude the specified <Rectangle> from the receiver's clip region, this means that any
	attempt to draw in that rectangle will be ignored."

	^GDILibrary default 
		excludeClipRect: self asParameter
		nLeftRect: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom!

extent
	"Answers a <Point> containing the pixel extent of the receiver"

	^self width @ self height!

fillRectangle: aRectangle
	"Draw a filled rectangle of size aRectangle using the current brush."

	^UserLibrary default
		fillRect: self asParameter
		lprc: aRectangle asParameter
		hbr: self brush asParameter!

fillRectangle: aRectangle brush: aBrush
	"Draw a filled rectangle of size aRectangle using aBrush."

	^UserLibrary default
		fillRect: self asParameter
		lprc: aRectangle asParameter
		hbr: aBrush asParameter!

fillRectangle: aRectangle color: aColor 
	| fillBrush |
	fillBrush := aColor brush.
	self fillRectangle: aRectangle brush: fillBrush.
	fillBrush free!

fillRectangle: aRectangle startColor: startColor endColor: endColor verticalGradient: aBoolean
	| vertices gRect |
	vertices := StructureArray length: 2 elementClass: TRIVERTEX.
	vertices beUnfinalizable.
	(vertices at: 1)
		color: startColor;
		position: aRectangle origin.
	(vertices at: 2)
		color: endColor;
		position: aRectangle corner.
	gRect := GRADIENT_RECT new.
	gRect
		upperLeft: 0;
		lowerRight: 1.
	^GDILibrary default
		gdiGradientFill: self asParameter
		pVertex: vertices
		nVertex: 2
		pMesh: gRect
		nCount: 1
		ulMode: (aBoolean ifTrue: [GRADIENT_FILL_RECT_V] ifFalse: [GRADIENT_FILL_RECT_H])!

fillRegion: aRegion brush: aBrush
	"Draw a filled region, aRegion, using aBrush."

	^GDILibrary default
		fillRgn: self asParameter
		hRgn: aRegion asParameter
		hBr: aBrush asParameter!

font
	"Answer the current <Font>."

	^font ifNil: [self getFont]!

font: aFont 
	"Select the specified <Font> into this canvas. Ensure that the font is realized for the
	receiver's resolution. Answer the previously selected <Font>."

	| oldFont |
	oldFont := self font.
	oldFont == aFont ifTrue: [^oldFont].
	font := aFont.
	(true or: [self mapMode = MM_TEXT]) ifTrue: [font resolution: self resolution].
	self selectObject: aFont.
	^oldFont!

fontHandle
	^self getCurrentObject: OBJ_FONT!

fontNames
	"Answer a <collection> containing the face names of all the Fonts supported by the receiver."

	| answer |
	answer := Set new.
	self fonts: nil
		do: 
			[:lf :lp :dw | 
			answer add: lf faceName.
			true].
	^answer!

fonts: aString do: operation 
	"Enumerate the fonts in a specified font family that are available on the receiver's device.
	The triadic valuable argument, operation, is passed the LOGFONTW, TEXTMETRICW and font 
	type as its three arguments, and should answer true to continue the enueration, false to 
	terminate it (it must not contain a ^-return).

		int CALLBACK EnumFontsProc(
			lplf lplf,	// pointer to logical-font data 
			lptm lptm,	// pointer to physical-font data 
			DWORD dwType,	// font type 
			LPARAM lpData 	// pointer to application-defined data  
		);"

	| callback answer |
	callback := ExternalCallback block: 
					[:lplf :lptm :dwType :lpData | 
					operation 
						value: lplf
						value: lptm
						value: dwType]
				descriptor: (ExternalDescriptor returnType: 'sdword' argumentTypes: 'LOGFONTW* lpvoid dword uintptr').
	answer := GDILibrary default 
				enumFonts: self asParameter
				lpFaceName: aString
				lpFontFunc: callback asParameter
				lParam: 0.
	callback free.
	^answer!

forecolor
	"Get the receiver's colour for drawing text."

	^Color fromCOLORREF: (GDILibrary default getTextColor: self asParameter)!

forecolor: colour
	"Set the receiver's colour for drawing text."

	^GDILibrary default setTextColor: self asParameter crColor: colour asCOLORREF!

formatText: text in: rect
	"Formats the <readableString> text within the <Rectangle> rect with wordbreak and 
	basic left alignment. Answers the height of the formatted text in pixels."

	^self formatText: text in: rect flags: ##(DT_WORDBREAK | DT_LEFT)
!

formatText: aString in: aRectangle flags: anInteger
	"Formats the specified <readableString> text within the specified <Rectangle> and using the
	specified <Integer> mode flags. Answers the height of the formatted text in pixels."

	| text |
	"We need to do an explicit conversion to UTF-16 here, because we want to pass the correct number of code units."
	text := aString asUtf16String.
	^UserLibrary default
		drawTextEx: self asParameter
		lpchText: text
		cchText: text size
		lprc: aRectangle asParameter
		dwDTFormat: anInteger
		lpDTParams: nil!

frameRectangle: aRectangle brush: aBrush
	"Frame aRectangle on the receiver using aBrush."

	^UserLibrary default
		frameRect: self asParameter
		lprc: aRectangle asParameter
		hbr: aBrush asParameter!

free
	"Free any external resources."

	"Handle will be null (but not nil) on any old instances after an image restart"

	self beUnfinalizable.
	handle isNil ifTrue: [^self].
	handle notNull ifTrue: [self basicFree].
	handle := source := font := pen := brush := nil.
	owned := false!

getCurrentObject: aTypeInteger
	"Answers a handle to the current selected object of aTypeInteger.
	This should be one of OBJ_PEN, OBJ_BRUSH, OBJ_FONT etc"

	^GDILibrary default getCurrentObject: self asParameter uObjectType: aTypeInteger!

getDeviceCaps: anInteger 
	"Private - Answer the specified device capability."

	^GDILibrary default getDeviceCaps: self asParameter nIndex: anInteger!

getFont
	^Font fromHandle: self fontHandle!

getPixel: aPoint
	"Private - Get the colour of the pixel at x@y. Note that the indices are zero-based!!"

	^GDILibrary default
		getPixel: self asParameter
		xPos: aPoint x
		yPos: aPoint y!

handle
	"Answer the receiver's handle."

	^self asParameter.

	#todo "Remove this"!

height
	^self getDeviceCaps: VERTRES!

hiMetricToPels: himetric
	"Answer a <Point> which represents the same coordinate/dimension as the himetric
	coordinate <Point>, himetric, 	but expressed in pixels, using the receiver's resolution to 
	perform the conversion.
	There are 2540 himetric units per logical inch (one inch = 25.4 millimetres)."

	| res |
	res := self resolution.
	^((res x * himetric x) / 2540) rounded @
		((res y * himetric y) / 2540) rounded

!

intersectClipRectangle: aRectangle
	"Create a new clipping region for the receiver from the intersection of the
	current clipping region and aRectangle."

	^GDILibrary default
		intersectClipRect: self asParameter
		nLeftRect: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom!

invertRectangle: aRectangle 
	"Invert the pixels within aRectangle"

	^UserLibrary default
		invertRect: self asParameter
		lprc: aRectangle asParameter
!

invertRegion: aRegion 
	"Invert the pixels within aRegion"

	^GDILibrary default invertRgn: self asParameter hRgn: aRegion asParameter!

isRectangleVisible: aRectangle
	"Answer whether any part of aRectangle is within the receivers device
	context cliiping region."

	^GDILibrary default
		rectVisible: self asParameter
		lprc: aRectangle asParameter!

lineFrom: startPoint to: endPoint 
	"Draws a line from the <Point>, startPoint, up to BUT NOT INCLUDING, 
	the <Point>, endPoint.
	Implementation Note: For speed inline the raw calls."

	(GDILibrary default)
		moveToEx: self asParameter
			x: startPoint x
			y: startPoint y
			lpPoint: nil;
		lineTo: self asParameter
			nXEnd: endPoint x
			nYEnd: endPoint y!

lineTo: aPoint 
	"Draws a line from the current position up to, BUT NOT INCLUDING, aPoint."

	^GDILibrary default 
		lineTo: self asParameter
		nXEnd: aPoint x
		nYEnd: aPoint y!

mapMode
	"Answer the receiver's map mode, e.g. MM_TEXT."

	^GDILibrary default getMapMode: self asParameter!

mapMode: anInteger 
	"Sets the mapping mode of the receiver"

	^GDILibrary default setMapMode: self asParameter fnMapMode: anInteger!

moveTo: aPoint 
	"Moves the current position to the <Point> argument."

	^GDILibrary default 
		moveToEx: self asParameter
		x: aPoint x
		y: aPoint y
		lpPoint: nil!

nonOwnedDC: hDC
	"Private - Initialize the receiver to encapsulate the DC
	with handle, hDC, which the receiver does not own, and will not
	therefore free. The receiver is not finalizable (to reduce GC overhead)."

	handle := hDC asParameter.
	owned := false
!

offsetWindowOrigin: aPoint
	"Offset the origin of the receiver's window mapping. 
	Answers the old window origin"

	| previous |
	previous := POINTL new.
	(GDILibrary default 
		offsetWindowOrgEx: self asParameter
		nXOrg: aPoint x
		nYOrg: aPoint y
		lppt: previous) ifFalse: [^GDILibrary default systemError].
	^previous asPoint!

onExit
	"Sent at session shutdown to ensure that all external resources are released."

	self free
!

outlineTextMetrics
	"Answer the standard Win32 OUTLINETEXTMETRICs for the currently selected font,
	or nil if not a TrueType font."

	"Implementation Note: See the MSDN article KB84132"

	| answer size lib |
	lib := GDILibrary default.
	size := lib
				getOutlineTextMetrics: self asParameter
				cbData: 0
				lpotm: nil.
	"Only true-type fonts have OTM info, so if the current font is not a TT font return nil."
	size == 0 ifTrue: [^nil].
	answer := OUTLINETEXTMETRICW new: size.
	(lib
		getOutlineTextMetrics: self asParameter
		cbData: size
		lpotm: answer) == 0
		ifTrue: [lib systemError].
	^answer!

ownedDC: hDC
	"Private - Initialize the receiver as the owner of the DC with
	the handle, hDC. The receiver is marked as finalizable to ensure
	that the DC is released/freed."

	handle := hDC asParameter.
	owned := true.
	self beFinalizable!

paintRegion: aRegion
	"Draw a filled region, aRegion, using the current brush"

	^GDILibrary default
		paintRgn: self asParameter
		hRgn: aRegion asParameter
!

palette: hPalette
	"Selects and realizes the palette in hPalette into the receiver. 
	Answers the handle of the previous palette"

	| oldPalette |
	oldPalette := self selectPalette: hPalette.
	self realizePalette.
	^oldPalette
!

patBlt: aRectangle rop: rop
	"Blits a rectangular region from aCanvasOrHandle to the receiver
	Answer true if the operation succeeds"

	^GDILibrary default
		patBlt: self asParameter
		nXLeft: aRectangle left
		nYLeft: aRectangle top
		nWidth: aRectangle width
		nHeight: aRectangle height
		dwRop: rop!

pelsToHiMetric: pels
	"Answer a <Point> which represents the same coordinate/dimension as the <Point>, pels,
	but expressed in Hi-metric, using the receiver's resolution to perform the conversion.
	There are 2540 himetric units per logical inch (one inch = 25.4 millimetres)."

	| res |
	res := self resolution.
	^((2540*pels x) / res x) rounded @
		((2540*pels y) / res y) rounded.


!

pen
	"Answer the current pen."

	^pen ifNil: [Pen fromHandle: (self getCurrentObject: OBJ_PEN)]!

pen: aPen
	"Select aPen into the receiver, and answer the old pen."

	| oldPen |
	oldPen := self pen.
	pen := aPen.
	self selectObject: aPen.
	^oldPen!

penColor
	"Get the colour of the pen currently selected into the DC. N.B. Only works on XP and later."

	^Color fromCOLORREF: (GDILibrary default getDCBrushColor: self asParameter)!

pixelAt: aPoint 
	"Answer the <Color> the pixel at the <Point> argument. Note that the co-ordinates are zero-based!!"

	^Color fromCOLORREF: (self getPixel: aPoint)!

pixelAt: aPoint put: pixelColor
	"Set the colour of the pixel at aPoint to pixelColor.
	Answer whether it succeeded."

	^GDILibrary default
		setPixelV: self asParameter
		x: aPoint x
		y: aPoint y
		crColor: pixelColor asCOLORREF!

plgBlt: aCanvas rectangle: aRectangle topLeft: topLeftPoint topRight: topRightPoint bottomLeft: bottomLeftPoint 
	| points |
	points := ByteArray newFixed: 24.
	points
		sdwordAtOffset: 0 put: topLeftPoint x;
		sdwordAtOffset: 4 put: topLeftPoint y;
		sdwordAtOffset: 8 put: topRightPoint x;
		sdwordAtOffset: 12 put: topRightPoint y;
		sdwordAtOffset: 16 put: bottomLeftPoint x;
		sdwordAtOffset: 20 put: bottomLeftPoint y.
	^GDILibrary default 
		plgBlt: self asParameter
		lpPoint: points
		hdcSrc: aCanvas asParameter
		nXSrc: aRectangle left
		nYSrc: aRectangle top
		nWidth: aRectangle width
		nHeight: aRectangle height
		hbmMask: nil
		sMask: 0
		yMask: 0!

polygon: collectionOfPoints
	"Draw a filled polygon from the collection of points."

	^GDILibrary default
		polygon: self asParameter
		lpPoints: ((StructureArray
				withAll: collectionOfPoints
				elementClass: POINTL
				initializer: [:pointl :point | pointl x: point x y: point y])
				beUnfinalizable;
				yourself)
		nCount: collectionOfPoints size!

realizePalette
	"Realizes the current logical palette of the receiver into the system palette"

	^GDILibrary default realizePalette: self asParameter
!

rectangle: aRectangle
	"Draw aRectangle on the receiver."

	^GDILibrary default rectangle: self asParameter
		nLeftRect: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom
!

rectangle: aRectangle round: aPoint
	"Draw a round rectangle on the receiver."

	^GDILibrary default
		roundRect: self asParameter
		nLeftRect: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom
		nWidth: aPoint x
		nHeight: aPoint y
!

resolution
	"Answers a Point containing the logical pixels per inch for the receiver"

	^(self getDeviceCaps: LOGPIXELSX) @ (self getDeviceCaps: LOGPIXELSY)
!

restore
	"Restore the last saved state of the receiver."

	^self restore: -1!

restore: saveIndex
	"Restore the receiver's state to that saved at saveIndex using #save."

	| restoredId restoredObjects |
	GDILibrary default restoreDC: self asParameter nSavedDC: saveIndex.
	saveIndex == -1
		ifTrue: [
			"Effectivaly a 'pop' to previous context"
			restoredId := self saveIds removeLast]
		ifFalse: [
			"Restored to a specified point"
			restoredId := self saveIds remove: saveIndex].
	restoredObjects := self saved removeKey: restoredId.
	pen := restoredObjects at: 1.
	brush := restoredObjects at: 2.
	font := restoredObjects at: 3			
			!

rop2
	^GDILibrary default getROP2: self asParameter!

rop2: anInteger 
	^GDILibrary default setROP2: self asParameter fnDrawMode: anInteger!

save
	"Save the state of the receiver and answer its id. This can then later
	be restored using #restore:.
	Implementation Note: We must also save the current pen, brush, and
	font in order to prevent them from being GC'd, and so that we can
	restore them correctly later."

	| id |
	id := GDILibrary default saveDC: self asParameter.
	self saved at: id put: {pen. brush. font}.
	^self saveIds addLast: id!

saved
	"Private - Answer the value of the receiver's 'saved' instance variable."

	saved isNil ifTrue: [saved := IdentityDictionary new].
	^saved!

saveIds
	"Private - Answer the value of the receiver's 'saveIds' instance variable."

	saveIds isNil ifTrue: [saveIds := OrderedCollection new].
	^saveIds!

selectClipRegion: aRegion
	"Select aRegion as the clipping region of the receiver or deselect
	current clipping region if aRegion is nil."

	^GDILibrary default
		selectClipRgn: self asParameter
		hrgn: aRegion asParameter!

selectObject: aGraphicsToolOrHandle
	"Private - Select aGraphicsToolOrHandle into the receiver, answering the handle of the previous
	object of that type."

	^GDILibrary default selectObject: self asParameter
		hgdiobj: aGraphicsToolOrHandle asParameter!

selectPalette: hPalette
	"Selects the palette in hPalette into the receiver. Follow this with
	a #realizePalette to actual change the system palette. Answers the handle
	of the previous palette"

	^GDILibrary default selectPalette: self asParameter hPal: hPalette bForceBackground: false
!

setDefaultAttributes
	"Private - Set the receiver's initial pen, brush and font."

	self
		pen: Pen black;
		brush: Brush black;
		font: Font default.!

setTextAlign: alignment
	"Set the receiver's alignment for drawing text."

	^GDILibrary default setTextAlign: self asParameter fMode: alignment!

source: aDCSource
	"Private - Set the receiver's DC source to the argument
	(which must implement #getDC and #releaseDC:).
	Answer the receiver."

	source := aDCSource!

stretchBlt: aCanvas rectangle: aRectangle to: dstOrigin extent: dstExtent rop: rop
	"Blits a rectangular region from aCanvas to the receiver with scaling.
	Answer true if the operation succeeds"

	^GDILibrary default
		stretchBlt: self asParameter 
		nXOriginDest: dstOrigin x 
		nYOriginDest: dstOrigin y 
		nWidthDest: dstExtent x 
		nHeightDest: dstExtent y 
		hdcSrc: aCanvas asParameter 
		nXOriginSrc: aRectangle left 
		nYOriginSrc: aRectangle top 
		nWidthSrc: aRectangle width 
		nHeightSrc: aRectangle height 
		dwRop: rop
!

text: aString at: aPoint
	"Draw aString on the receiver starting at aPoint."

	| text |
	"We need to do an explicit conversion to UTF16 here, because we have to pass the correct number of code units."
	text := aString asUtf16String.
	^GDILibrary default
		textOut: self asParameter
		nXStart: aPoint x
		nYStart: aPoint y
		lpString: text
		cbString: text size
!

textExtent: aString
	"Answer the extent of string using the receivers currently selected font. Note this will only provide an accurate result for a single line of text, and when paired with the GDI ExtTextOut function for painting the text, which will only be the case if the Canvas>>text:at: method is used. For calculating the extent of text drawn with the User32 DrawText API (e.g. by Canvas>>formatText:&c) one of the textExtent:width:&c family of methods must be used."

	| size text |
	size := POINTL new.
	"We need to do an explicit conversion to UTF16 here, because we have to pass the correct number of code units."
	text := aString asUtf16String.
	(GDILibrary default
		getTextExtentPoint32: self asParameter
		lpString: text
		c: text size
		lpSize: size asParameter) ifFalse: [^GDILibrary default systemError].
	^size asPoint!

textExtent: aString width: anIntegerWidth alignment: anAlignSymbol
	"Answer the extent of aString when formatted with an areas of anIntegerWidth
	using an alignment given by anAlignSymbol. The latter can be one of
	#left, #center, #right. Uses the receiver's currently selected font."

	| rect height align |
	align := ##(IdentityDictionary new
				at: #left put: DT_LEFT;
				at: #center put: DT_CENTER;
				at: #right put: DT_RIGHT;
				shrink;
				yourself) at: anAlignSymbol ifAbsent: [DT_LEFT].
	rect := RECT extent: anIntegerWidth @ 0.
	height := self
				formatText: aString
				in: rect
				flags: ##(DT_CALCRECT | DT_WORDBREAK) | align.
	^anIntegerWidth @ height!

textExtent: aString width: widthInteger flags: flagsInteger
	"Answer the extent of string using the receivers currently selected font when drawn with the User32 DrawText API that underlies the Canvas>>formatText:&c family of methods.
	There are a large number of DT_XXX flags that can be used to draw the text in different ways - see https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-drawtextexw for details."

	| rect |
	rect := RECT extent: widthInteger @ 0.
	self
		formatText: aString
		in: rect
		flags: (DT_CALCRECT bitOr: flagsInteger).
	^rect extent!

textMetrics
	"Answer the standard Win32 TEXTMETRICs for the currently selected font.
		Canvas forDisplay textMetrics
	"

	| answer |
	answer := TEXTMETRICW new.
	(GDILibrary default getTextMetrics: self asParameter lptm: answer)
		ifFalse: [GDILibrary default systemError].
	^answer!

viewportExtent
	"Answers the extent of the receiver's viewport mapping."

	| extent |
	extent := POINTL new.
	(GDILibrary default getViewportExtEx: self asParameter lpSize: extent) 
		ifFalse: [^GDILibrary default systemError].
	^extent asPoint!

viewportExtent: aPoint
	"Sets the extent of the receiver's viewport mapping. 
	Answers the old viewport extent"

	| previous |
	previous := POINTL new.
	(GDILibrary default 
		setViewportExtEx: self asParameter
		nXExtent: aPoint x
		nYExtent: aPoint y
		lpSize: previous) ifFalse: [^GDILibrary default systemError].
	^previous asPoint!

viewportOrigin
	"Answers the origin of the receiver's viewport mapping."

	| origin |
	origin := POINTL new.
	(GDILibrary default getViewportOrgEx: self asParameter lppt: origin) 
		ifFalse: [^GDILibrary default systemError].
	^origin asPoint!

viewportOrigin: aPoint
	"Set the origin of the receiver's viewport mapping and 
	answer the old viewport origin."

	| previous |
	previous := POINTL new.
	(GDILibrary default 
		setViewportOrgEx: self asParameter
		nXOrg: aPoint x
		nYOrg: aPoint y
		lppt: previous) ifFalse: [^GDILibrary default systemError].
	^previous asPoint!

viewportRectangle: aRectangle
	"Sets the rectangle of the receiver's viewport mapping. 
	Answers the old viewport rectangle"

	| oldExtent oldOrigin |
	oldOrigin := self viewportOrigin: aRectangle topLeft.
	oldExtent := self viewportExtent: aRectangle extent.
	^Rectangle origin: oldOrigin extent: oldExtent
!

width
	^self getDeviceCaps: HORZRES!

windowExtent
	"Answers the extent of the receiver's window mapping."

	| extent |
	extent := POINTL new.
	(GDILibrary default getWindowExtEx: self asParameter lpSize: extent) 
		ifFalse: [^GDILibrary default systemError].
	^extent asPoint!

windowExtent: aPoint 
	"Sets the extent of the receiver's window mapping. 
	Answers the old window extent"

	| previous |
	previous := SIZE new.
	(GDILibrary default 
		setWindowExtEx: self asParameter
		nXExtent: aPoint x
		nYExtent: aPoint y
		lpSize: previous) ifFalse: [^GDILibrary default systemError].
	^previous asObject!

windowOrigin
	"Answers the origin of the receiver's window mapping."

	| origin |
	origin := POINTL new.
	(GDILibrary default getWindowOrgEx: self asParameter lppt: origin) 
		ifFalse: [^GDILibrary default systemError].
	^origin asPoint!

windowOrigin: aPoint
	"Sets the origin of the receiver's window mapping. 
	Answers the old window origin"

	| previous |
	previous := POINTL new.
	(GDILibrary default 
		setWindowOrgEx: self asParameter
		nXOrg: aPoint x
		nYOrg: aPoint y
		lppt: previous) ifFalse: [^GDILibrary default systemError].
	^previous asPoint!

windowRectangle: aRectangle
	"Sets the rectangle of the receiver's window mapping. 
	Answers the old viewport rectangle"

	| oldExtent oldOrigin |
	oldOrigin := self windowOrigin: aRectangle topLeft.
	oldExtent := self windowExtent: aRectangle extent.
	^Rectangle origin: oldOrigin extent: oldExtent
!

windowScaling
	"Answers a Point that is the ratio of window units to device units for the receiver"

	^self windowExtent / self viewportExtent! !
!Canvas categoriesForMethods!
alphaBlend:rectangle:to:extent:blend:!drawing!public! !
alphaBlendBitmap:at:extent:from:extent:blend:!colors!private! !
asParameter!converting!public! !
backcolor!accessing!colors!public! !
backcolor:!accessing!colors!public! !
backgroundMode!accessing!public! !
backgroundMode:!accessing!public! !
basicFree!private!realizing/unrealizing! !
bitBlt:rectangle:to:rop:!drawing!public! !
brush!public!tools! !
brush:!public!tools! !
brushColor!accessing!colors!public! !
brushOrigin:!accessing!public! !
clipBox!accessing!public! !
colorDepth!accessing!public! !
colors!accessing!public! !
drawBitmap:at:extent:from:extent:rop:!colors!private! !
drawEdge:edge:grfFlags:!drawing!public! !
ellipse:!drawing!public! !
erase!drawing!public! !
excludeClipRectangle:!operations!public! !
extent!accessing!public! !
fillRectangle:!drawing!public! !
fillRectangle:brush:!drawing!public! !
fillRectangle:color:!drawing!public! !
fillRectangle:startColor:endColor:verticalGradient:!drawing!public! !
fillRegion:brush:!drawing!public! !
font!accessing!public!tools! !
font:!accessing!public!tools! !
fontHandle!accessing!private!tools! !
fontNames!enquiries!public! !
fonts:do:!enumerating!public! !
forecolor!modes!public! !
forecolor:!modes!public! !
formatText:in:!drawing!public! !
formatText:in:flags:!drawing!public! !
frameRectangle:brush:!drawing!public! !
free!public!realizing/unrealizing! !
getCurrentObject:!accessing!public! !
getDeviceCaps:!accessing!private! !
getFont!accessing!public!tools! !
getPixel:!drawing!private! !
handle!accessing!public! !
height!accessing!public! !
hiMetricToPels:!converting!public! !
intersectClipRectangle:!drawing!public! !
invertRectangle:!drawing!public! !
invertRegion:!drawing!public! !
isRectangleVisible:!drawing!public!testing! !
lineFrom:to:!drawing!public! !
lineTo:!drawing!public! !
mapMode!public!transformations! !
mapMode:!public!transformations! !
moveTo:!drawing!public! !
nonOwnedDC:!initializing!private! !
offsetWindowOrigin:!public!transformations! !
onExit!event handling!public! !
outlineTextMetrics!accessing!public! !
ownedDC:!initializing!private! !
paintRegion:!drawing!public! !
palette:!colors!public! !
patBlt:rop:!drawing!public! !
pelsToHiMetric:!converting!public! !
pen!public!tools! !
pen:!public!tools! !
penColor!accessing!colors!public! !
pixelAt:!accessing!public! !
pixelAt:put:!accessing!public! !
plgBlt:rectangle:topLeft:topRight:bottomLeft:!drawing!public! !
polygon:!drawing!public! !
realizePalette!colors!public! !
rectangle:!drawing!public! !
rectangle:round:!drawing!public! !
resolution!accessing!public! !
restore!operations!public! !
restore:!operations!public! !
rop2!accessing!public! !
rop2:!accessing!public! !
save!operations!public! !
saved!accessing!private! !
saveIds!accessing!private! !
selectClipRegion:!operations!public! !
selectObject:!operations!private! !
selectPalette:!colors!public! !
setDefaultAttributes!private!tools! !
setTextAlign:!modes!public! !
source:!accessing!private! !
stretchBlt:rectangle:to:extent:rop:!drawing!public! !
text:at:!drawing!public! !
textExtent:!enquiries!public! !
textExtent:width:alignment:!enquiries!public! !
textExtent:width:flags:!enquiries!public! !
textMetrics!accessing!public! !
viewportExtent!public!transformations! !
viewportExtent:!public!transformations! !
viewportOrigin!public!transformations! !
viewportOrigin:!public!transformations! !
viewportRectangle:!public!transformations! !
width!accessing!public! !
windowExtent!public!transformations! !
windowExtent:!public!transformations! !
windowOrigin!public!transformations! !
windowOrigin:!public!transformations! !
windowRectangle:!public!transformations! !
windowScaling!public!transformations! !
!

!Canvas class methodsFor!

desktopResolution
	"Answer the resolution of the active desktop."

	DesktopResolution isNil ifTrue: [
		DesktopResolution := self forDesktop resolution].
	^DesktopResolution!

forDesktop
	"Answers a new Canvas with an owned hDC for the REAL desktop window."

	^self on: UserLibrary default!

forDisplay
	"Answers a new Canvas with an owned hDC for the display device."

	^self on: self!

forNonClientView: aView
	"Answers a new non-client Canvas with an owned hDC for aView"

	^self withDC: aView getWindowDC ownedBy: aView!

forView: aView
	"Answers a new client Canvas with an owned hDC for aView"

	^self on: aView!

getDC
	"Answer a DC for drawing on the display.
	N.B. This is one half of the <dcSource> protocol, and must be matched with 
	a call to #releaseDC: to delete the DC."

	^GDILibrary default 
		createDC: 'DISPLAY'
		lpszDevice: nil
		lpszOutput: nil
		lpInitData: nil!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new
	"Private - Use #withNonOwnedDC:, #withOwnedDC:, #withDC:ownedBy: or one of their derivatives."

	^self shouldNotImplement!

on: aDCSource
	"Answers a new client Canvas with an owned hDC for aDCSource.
	aDCSource must implement the <dcSource> prototocl #(getDC releaseDC:)"

	^self withDC: aDCSource getDC ownedBy: aDCSource!

onExit
	"Ensure all the receiver's instances are in their 'invalidated' state on exit
	so that they have released any external resources they are holding."

	self primAllInstances do: [ :i | i onExit ]!

onStartup
	"Private - Perform system startup processing."

	DesktopResolution := nil!

releaseDC: hDC
	"Delete the specified hDC.
	Canvas implements this to provide the second half of the 'DC source' protocol
	for clients which supply a DC directly via #withOwnedDC:
	Answer whether the DC was indeed deleted."

	^(GDILibrary default
		deleteDC: hDC asParameter) ~~ 0!

screenResolution
	"Answers a Point containing the logical pixels per inch of the screen.
	This is to avoid going recursive when creating a font."

	| display resolution |
	display := self forDisplay.
	resolution := display resolution.
	display free.
	^resolution!

withDC: hDC ownedBy: aDCSource
	"Answers a new Canvas with the given hDC owned by aDCSource.
	The DC will be freed by sending a #releaseDC:, message with the DC
	handle as its parameter, to aDCSource."

	^super new
		ownedDC: hDC;
		source: aDCSource!

withNonOwnedDC: hDC
	"Answers a new Canvas with the given non-owned hDC.
	When this instance is freed it will use neither DeleteDC() nor ReleaseDC()."

	^super new
		nonOwnedDC: hDC;
		yourself!

withOwnedDC: hDC
	"Answers a new instance of the receiver with the given owned hDC.
	The DC with the handle, hDC, will be freed when the new instance is
	finalized (or explicitly freed) with a call to DeleteDC()."

	^self withDC: hDC ownedBy: self! !
!Canvas class categoriesForMethods!
desktopResolution!initializing!public! !
forDesktop!instance creation!public! !
forDisplay!instance creation!public! !
forNonClientView:!instance creation!public! !
forView:!instance creation!public! !
getDC!accessing!public! !
icon!constants!public! !
new!instance creation!private! !
on:!instance creation!public! !
onExit!event handling!public! !
onStartup!event handling!private! !
releaseDC:!operations!public! !
screenResolution!environment!public! !
withDC:ownedBy:!instance creation!public! !
withNonOwnedDC:!instance creation!public! !
withOwnedDC:!instance creation!public! !
!

Canvas class methodProtocol: #dcSource attributes: #(#readOnly) selectors: #(#getDC #releaseDC:)!

