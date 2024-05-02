"Filed out from Dolphin Smalltalk"!

Object subclass: #TextTileIcon
	instanceVariableNames: 'text fontName tilecolor textcolor icon fontStyle flags margin _reserved9'
	classVariableNames: 'FontStyleNames RotationMask StringFormat'
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!

TextTileIcon guid: (GUID fromString: '{a5c05489-c3fa-486a-9e1b-1660f9b3a55a}')!

TextTileIcon addClassConstant: 'FontStyleNames' value: #(#regular #bold #italic #boldItalic #underline #strikeout)!
TextTileIcon addClassConstant: 'RotationMask' value: 16r3!

TextTileIcon comment: 'An icon representation of one or more letters on a plain solid colour background, which can be `Color none` for a transparent background. The text can contain any Unicode characters (including symbols, emoticons, etc), although there is limited font support for extended characters (if the text renders as an empty box, try using the ''Segoe UI Symbol'' font).

The text colour can be specified, but if not then either white or black will be chosen depending on the luminance of the background colour. When drawn on a transparent background the text is black by default.

TextTileIcon uses GDI+ in order to be able to create bitmaps with an alpha channel. This does mean they are slower than one would wish. It also means that Emojis are drawn in monochrome, rather than full colour. A rewrite using DirectWrite over Direct2D would be an interesting exercise that would address the ability to draw with coloured fonts, and probably improve performance too.

There is generally only sufficient space for between one and three characters of text or the result will be too small in a 16x16 icon. The text is drawn at the best-fit size so that is as large as possible without being clipped within the available pixel size. 

The resulting "icon" can be substituted for an actual `Icon` for essentially any use, including associating with a Window as its icon, and is capable of being rendered at high quality into any size image list. 

Examples:

	(TextTileIcon text: ''aA'' fontName: ''Georgia'' color: Color darkBlue) bitmapWithExtent: 256@256

	"White Dolphin on a green tile"
	(TextTileIcon text: Character dolphin fontName: ''Segoe UI Symbol'' color: (ARGB named: #seaGreen)) bitmapWithExtent: 64@64

	"For St Patrick''s day"
	((TextTileIcon text: $\x2618 fontName: ''Segoe UI Symbol'' color: Color darkGreen) fontStyle: #bold) bitmapWithExtent: 128@128.

	'!

!TextTileIcon categoriesForClass!Unclassified! !

!TextTileIcon methodsFor!

= comperand
	^self == comperand or: 
			[self species = comperand species and: 
					[text = comperand text and: 
							[tilecolor = comperand tilecolor and: 
									[fontName = comperand fontName and: 
											[textcolor = comperand textcolor
												and: [fontStyle == comperand basicFontStyle and: [flags == comperand flags]]]]]]]!

actualFontName
	^fontName ifNil: [self defaultFontName]!

actualFontStyle
	^fontStyle ?? FontStyleRegular!

actualTextcolor
	"Private - Answer the colour used to draw the text. If unspecified this will default to either black
	or white, depending on the luminance of the tile background colour."

	^textcolor
		ifNil: [(tilecolor isNil or: [tilecolor luminance > 0.6]) ifTrue: [Color black] ifFalse: [Color white]]
!

addToImageList: aWinImageList mask: aColorOrNil
	"Private - Add a pictorial representation of the receiver to aWinImageList drawn directly at the
	extent of the image list so as to produce a high-quality image."

	| bitmap index |
	bitmap := self bitmapWithExtent: aWinImageList extent.
	index := bitmap addToImageList: aWinImageList mask: aColorOrNil.
	bitmap free.
	^index!

applyTransforms: aGdiplusGraphics rect: aRectangle
	| i matrix |
	(i := flags bitAnd: RotationMask) == 0 ifTrue: [^self].
	matrix := (##({
				[:x :y |
				GdiplusMatrix
					m11: 0.0
					m12: 1.0
					m21: -1.0
					m22: 0.0
					m31: (y + x) / 2.0
					m32: (y - x) / 2.0].
				
				[:x :y |
				GdiplusMatrix
					m11: -1.0
					m12: 0.0
					m21: 0.0
					m22: -1.0
					m31: x
					m32: y].
				
				[:x :y |
				GdiplusMatrix
					m11: 0.0
					m12: -1.0
					m21: 1.0
					m22: 0.0
					m31: (x - y) / 2.0
					m32: (x + y) / 2.0]})
					at: i) value: aRectangle left + aRectangle right value: aRectangle top + aRectangle bottom.
	aGdiplusGraphics transform: matrix.
	matrix free!

asAlphaBitmap: aPoint 
	"Answer a 32-bpp RGBA DIBSection (i.e. with Alpha channel) that contains the receiver's
	image rendered at the specified size."

	| bmp |
	bmp := DIBSection 
				width: aPoint x
				height: aPoint y
				depth: 32.
	"Use the services of an ImageList to get the correct sized icon automagically, and to
	provide an alpha channel even if the original icon had no more than a simple mask."
	(self imageManager imageListWithExtent: aPoint) 
		draw: self imageIndex
		on: bmp canvas
		at: Point.Zero
		flags: CommCtrlConstants.ILD_PRESERVEALPHA.
	bmp freeDC.
	^bmp!

asBitmap
	^self bitmapWithExtent: self extent!

asMenuBitmap
	#deprecated.	"Extent required depends on DPI of the view the menu"
	^self asSharedBitmap: SystemMetrics current menuImageExtent!

asParameter
	"Answer the handle of the receiver's default icon representation, realizing it if necessary. 
	Implementing this allows TextTileIcons to be used as the icons for ShellViews."

	^self largeIcon asParameter


!

asSharedBitmap: aPoint
	"Answer a 32-bpp bitmap (i.e. with alpha channel) containing the receiver's image at the specified extenT. The result will be a shared bitmap which is always the same
	instance for the same icon."

	^self imageManager bitmapForIcon: self extent: aPoint!

basicFontStyle
	^fontStyle!

bitmapWithExtent: aPoint
	| bitmap graphics |
	bitmap := GdiplusBitmap
				width: aPoint x
				height: aPoint y
				format: PixelFormat32bppPARGB.
	graphics := bitmap graphics.
	self
		drawOnGraphics: graphics
		at: Point.Zero
		extent: aPoint.
	graphics free.
	^bitmap!

defaultFontName
	"The most type of TextTileIcons is that composed of a single Unicode symbol, and the most useful font for those 
	is the default system symbol font (although sometimes Cambria or Segoe UI Emoji are worth a try)."

	^'Segoe UI Symbol'!

drawOn: aCanvas
	"Draw the receiver to aCanvas at position aPoint (no stretching).
	Answer whether the operation succeeded."

	^self drawOn: aCanvas at: Point zero!

drawOn: aCanvas at: aPoint
	"Draw the receiver to aCanvas at position aPoint (no stretching).
	Answer whether the operation succeeded."

	^self drawOn: aCanvas at: aPoint extent: self extent!

drawOn: aCanvas at: dstOrigin extent: dstExtent
	"Draw the receiver on aCanvas at Point dstOrigin, and with size dstExtent. 
	The receiver is stretched to fit the destination rectangle."

	| graphics |
	graphics := GdiplusGraphics fromCanvas: aCanvas.
	self drawOnGraphics: graphics at: dstOrigin extent: dstExtent.
	graphics free!

drawOnGraphics: graphics at: originPoint extent: extentPoint
	| scale height faceName utf16 font rect textExtent width style format textBrush |
	extentPoint isZero ifTrue: [^self].
	rect := originPoint extent: extentPoint.
	tilecolor
		ifNotNil: 
			[| backbrush |
			backbrush := tilecolor gdiplusBrush: rect.
			graphics fillRectangle: rect brush: backbrush.
			backbrush free].
	margin ifNotNil: [rect := rect insetBy: extentPoint * margin // 16].
	utf16 := self text asUtf16String.
	"TextTileIcon can be used to render empty tiles efficiently if no text is provided."
	utf16 isEmpty ifTrue: [^self].
	"The text can be rotated in 90° increments"
	self applyTransforms: graphics rect: rect.
	width := rect width.
	height := rect height.
	"Work out a suitable font size to best fit the space"
	faceName := self actualFontName.
	style := self actualFontStyle.
	font := GdiplusFont
				name: faceName
				pixelSize: height
				style: style.
	graphics textRenderingHint: TextRenderingHintAntiAlias.
	format := GdiplusStringFormat genericTypographic clone.
	format flags: (format flags maskClear: StringFormatFlagsLineLimit).
	textExtent := (graphics
				measureString: utf16
				font: font
				rect: RECTF new
				format: format) extent.
	scale := width asFloat / textExtent x.
	scale * textExtent y > height ifTrue: [scale := height asFloat / textExtent y].
	scale = 1
		ifFalse: 
			[font free.
			font := GdiplusFont
						name: faceName
						pixelSize: (height * scale max: 1)
						style: style].
	textBrush := GdiplusBrush color: self actualTextcolor.
	graphics
		drawString: utf16
		font: font
		rect: rect
		format: format
		brush: textBrush.
	font free.
	textBrush free.
	graphics resetTransform!

drawOnGraphics: aGraphics at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent unit: aUnit attributes: aImageAtt 
	"For compatibility with GdiplusImageView. The source origin, source extent, unit and attributes arguments are ignored."

	self drawOnGraphics: aGraphics at: dstOrigin extent: dstExtent!

extent
	"Answer the receiver's default extent. This is the extent used to provide an bitmap if
	requested without a desired extent being specified. TextTileIcons can render any sized
	bitmap or icon, however."

	^64@64!

flags
	^flags!

flags: anInteger
	flags := anInteger!

fontName
	^fontName!

fontStyle
	^FontStyleNames at: (fontStyle ?? 0) + 1!

fontStyle: aSymbol
	fontStyle := aSymbol ifNotNil: [(FontStyleNames identityIndexOf: aSymbol) - 1]!

freeDC
	"For compatibility with the Image hierarchy"!

hash
	"Answer the <SmallInteger> hash value for the receiver."

	^(text hash bitXor: tilecolor hash) bitXor: fontName hash!

hotspot
	^Point zero!

icon
	"Answer the receiver's icon (well, itself)."

	^self!

imageIndex
	^self imageManager indexOfImage: self!

imageManager
	"Private - Answer an image manager to use for storing icons"

	^IconImageManager current!

imageType
	^Win32Constants.IMAGE_ICON!

isRealized
	"For compatibility with <GraphicsTool>s. We realize on demand, but can always do so (system resources permitting)."

	^true!

largeIcon
	"Answer a 'large' (32x32) <Icon> equivalent of the receiver. This is sometimes needed, e.g. to set the icon for a Window."

	(icon isNil or: [icon isRealized not]) ifTrue: [icon := (self bitmapWithExtent: SystemMetrics current largeIconExtent) asIcon].
	^icon!

margin: anInteger 
	margin := anInteger!

printOn: aStream
	"Append the ASCII representation of the receiver to aStream."

	self storeOn: aStream!

realize
	"Present for compatibility with <GraphicsTools>. Nothing to do."!

rotation
	^(flags bitAnd: RotationMask) * 90!

rotation: anInteger
	flags := (flags maskClear: RotationMask) bitOr: (anInteger // 90)!

setText: labelString fontName: fontString color: aColor
	text := labelString.
	fontName := fontString.
	tilecolor := aColor ifNotNil: [aColor isNone ifFalse: [aColor]].
	flags := 0.
	^self!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler."

	"We must ensure that the dynamically generated icon is not saved."

	anSTBOutFiler override: icon with: nil.
	super stbSaveOn: anSTBOutFiler!

storeOn: aStream
	| requiresCascade r styleName |
	r := self rotation.
	styleName := self fontStyle.
	requiresCascade := textcolor notNil or: [styleName ~~ #regular or: [r ~= 0]].
	requiresCascade ifTrue: [aStream nextPut: $(].
	aStream
		nextPut: $(;
		print: self class;
		nextPutAll: ' text: ';
		print: self text.
	fontName isNil
		ifFalse: 
			[aStream
				nextPutAll: ' fontName: ';
				print: fontName].
	tilecolor
		ifNotNil: 
			[aStream nextPutAll: ' color: '.
			tilecolor storeOn: aStream].
	aStream nextPut: $).
	requiresCascade
		ifTrue: 
			[textcolor isNil
				ifFalse: 
					[aStream
						space;
						display: #textcolor:;
						space;
						print: textcolor;
						nextPut: $;].
			styleName ~~ #regular ifTrue:
					[aStream
						space;
						display: #fontStyle:;
						space;
						print: self fontStyle;
						nextPut: $;].
			r = 0
				ifFalse: 
					[aStream
						space;
						display: #rotation:;
						space;
						print: r;
						nextPut: $;].
			aStream nextPutAll: ' yourself)']!

stringFormat
	(StringFormat isNil or: [StringFormat isRealized not])
		ifTrue: 
			[StringFormat := (GdiplusStringFormat flags: ##(StringFormatFlagsNoFitBlackBox | StringFormatFlagsNoClip | StringFormatFlagsNoWrap))
						trimming: StringTrimmingNone;
						lineAlignment: StringAlignmentCenter;
						alignment: StringAlignmentCenter;
						yourself].
	^StringFormat!

text
	"Answer the text to be rendered onto the tile."

	^text!

textcolor
	"Answer the colour used to draw the text. If unspecified (nil) this will be defaulted to either black
	or white, depending on the luminance of the tile background colour when the tile is eventually drawn."

	^textcolor!

textcolor: aColor
	textcolor := aColor!

tilecolor
	"Answer the tile background colour, or nil for transparent."

	^tilecolor! !

!TextTileIcon categoriesForMethods!
=!comparison!public! !
actualFontName!accessing!private! !
actualFontStyle!accessing!private! !
actualTextcolor!accessing!private! !
addToImageList:mask:!double dispatch!private! !
applyTransforms:rect:!drawing-bitmaps!private! !
asAlphaBitmap:!converting!public! !
asBitmap!converting!public! !
asMenuBitmap!converting!public! !
asParameter!converting!public! !
asSharedBitmap:!converting!public! !
basicFontStyle!accessing!private! !
bitmapWithExtent:!converting!private! !
defaultFontName!accessing!constants!public! !
drawOn:!drawing-bitmaps!public! !
drawOn:at:!drawing-bitmaps!public! !
drawOn:at:extent:!drawing-bitmaps!public! !
drawOnGraphics:at:extent:!drawing-bitmaps!public! !
drawOnGraphics:at:extent:from:extent:unit:attributes:!drawing-bitmaps!public! !
extent!accessing!public! !
flags!accessing!private! !
flags:!accessing!private! !
fontName!accessing!public! !
fontStyle!accessing!public! !
fontStyle:!accessing!public! !
freeDC!public!realizing/unrealizing! !
hash!comparison!public! !
hotspot!accessing!public! !
icon!accessing!public! !
imageIndex!image management!private! !
imageManager!image management!private! !
imageType!constants!public! !
isRealized!public!testing! !
largeIcon!converting!public! !
margin:!initializing!public! !
printOn:!printing!public! !
realize!public!realizing/unrealizing! !
rotation!accessing!public! !
rotation:!accessing!public! !
setText:fontName:color:!initializing!private! !
stbSaveOn:!binary filing!public! !
storeOn:!printing!public! !
stringFormat!drawing-bitmaps!private! !
text!accessing!public! !
textcolor!accessing!public! !
textcolor:!accessing!public! !
tilecolor!accessing!public! !
!

!TextTileIcon class methodsFor!

defaultExtent
	^SystemMetrics current largeIconExtent!

icon
	^(self
		text: 'Aa'
		fontName: 'Georgia'
		color: Color cadetBlue)
		fontStyle: #italic;
		margin: 1;
		yourself!

new
	"Private - User #text:font:color:"

	^self shouldNotImplement!

stbConvertFrom: anSTBClassFormat
	"Version 1 added textcolor, icon, style and flags instance variables. flags must be initialized to zero, the rest can be nil."

	^
	[:data | 
	| newInstance |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	newInstance flags: 0.
	newInstance]!

stbVersion
	^1!

text: aString
	^self
		text: aString
		color: nil!

text: aString color: aColor
	^self
		text: aString
		fontName: nil
		color: aColor!

text: labelString fontName: fontString
	^self text: labelString
		fontName: fontString
		color: nil!

text: labelString fontName: fontString color: aColor
	^self basicNew
		setText: labelString
		fontName: fontString
		color: aColor! !

!TextTileIcon class categoriesForMethods!
defaultExtent!constants!private! !
icon!public! !
new!instance creation!private! !
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!public! !
text:!instance creation!public! !
text:color:!instance creation!public! !
text:fontName:!instance creation!public! !
text:fontName:color:!instance creation!public! !
!

