"Filed out from Dolphin Smalltalk"!

StaticView subclass: #ImageViewAbstract
	instanceVariableNames: 'image viewMode ivFlags insets imageBorder'
	classVariableNames: 'DoubleBufferMask EdgeStyles EraseWholeMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ImageViewAbstract guid: (GUID fromString: '{49987909-4a1f-4e2e-8b1f-2cc2f3ca2c3c}')!
ImageViewAbstract isAbstract: true!
ImageViewAbstract addClassConstant: 'DoubleBufferMask' value: 16r2!
ImageViewAbstract addClassConstant: 'EraseWholeMask' value: 16r1!
ImageViewAbstract comment: 'ImageViewAbstract is an abstract class of <valueView>s for displaying static <image>s. The <valueModel> associated with an image view must always yield an <image> value when mapped through the installed type converter. An ImageViewAbstract will normally be used in conjunction with a <ImagePresenter>. The mode in which the image is displayed can be controlled using the #viewMode aspect which can be set to one of the following: (#normal, #centered, #scale, #scaleToFit, or #scaleBestFit). 

Instance Variables:
	image		<image> which is a cache for the image being displayed.
	viewMode	<Symbol> identifying the mode of display.
	ivFlags		<integer> flags controlling styles/modes, etc.
	insets 		<Rectangle> specifying insets of the image from its border on each edge.
	imageBorder	<Symbol> identifying style of the border (if any) drawn around the image'!
!ImageViewAbstract categoriesForClass!MVP-Views! !
!ImageViewAbstract methodsFor!

calcRectangle: displayRect
	"Answer the rectangle that should be the destination of the blt "

	| mode |
	mode := self viewMode.
	mode == #normal ifTrue: [^self normal: image extent in: displayRect].
	mode == #centered ifTrue: [^self centered: image extent in: displayRect].
	mode == #scaleToFit ifTrue: [^self scaleToFit: image extent in: displayRect].
	mode == #scaleBestFit ifTrue: [^self scaleBestFit: image extent in: displayRect].
	mode == #scale ifTrue: [^self scale: image extent in: displayRect].
	^self default: image extent in: displayRect!

calculateExtent: aLayoutContext 
	"Private - Answer an extent for the receiver within the specified <LayoutContext>. If an
	image is present then naturally we'd prefer to use its full extent, otherwise the existing
	extent is answered."

	^image isNil 
		ifTrue: [super calculateExtent: aLayoutContext]
		ifFalse: [self calcExtentFromClientExtent: image extent]!

centered: imageExtent in: displayRect
	^Rectangle center: displayRect center extent: imageExtent!

default: imageExtent in: displayRect 
	^self scale: imageExtent in: displayRect!

defaultWindowProcessing: message wParam: wParam lParam: lParam
	"Private - Pass an event to the 'default' window procedure of the receiver."

	^UserLibrary default
		defWindowProc: handle
		msg: message
		wParam: wParam
		lParam: lParam!

displayRectangle
	^self clientRectangle insetBy: self insets!

displayValue
	"Answer the displayable contents of the receiver"

	^image!

displayValue: anImage
	"Private - Set the displayable contents of the receiver to anImage"

	image := anImage.
	self
		invalidate;
		invalidateLayout!

drawBorderOn: aCanvas imageRect: imageRect displayRect: displayRect 
	"Draw the border on the canvas
		- If the imageBorder <Symbol> is a recognized edgeStyle, use the Win32 function
		  to draw the border.
		
	-displayRect is the clientRectangle adjusted by the insets.
	-imageRect is the destination rectangle that was blt"

	| edgeStyle edgeRect borderStyle |
	borderStyle := self imageBorder.
	borderStyle == #none ifTrue: [^imageRect].
	edgeStyle := self class edgeStyleTable at: borderStyle
				ifAbsent: [^Notification signal: self class name displayString , 'unknown edge style'].
	"- Using the intersect of the two rectangles takes care of
		 both scaling and clipping types of viewModes.
	- Expand by the padding. NOTE: if insets>0, and viewMode clips (ie #normal #centered) 
		you need to draw the border the width of the padding. (or it will look strange)"
	edgeRect := (imageRect intersect: displayRect) expandBy: self insets.
	aCanvas 
		drawEdge: edgeRect
		edge: edgeStyle
		grfFlags: 15.	"15 = BF_RECT "
	^edgeRect!

eraseBackground: aCanvas around: aRectangle 
	| bkColor |
	bkColor := self actualBackcolor.
	bkColor isNone ifTrue: [^self].
	aRectangle isNil ifFalse: [aCanvas excludeClipRectangle: aRectangle].
	aCanvas fillRectangle: self clientRectangle color: bkColor!

imageBorder
	^imageBorder ?? #none!

imageBorder: aSymbol
	"Can be
		#none
		#raised
		#sunken
		#etched
		#bump
	Or a 3 arg symbol of a loose method. See
		#drawBorderOn:imageRect:displayRect:"

	imageBorder := aSymbol.
	self invalidate!

initialize
	"Private - Initialise the new receiver."

	super initialize.
	viewMode := #normal!

insets
	"Answer the <Rectangle> whose edges specify the distance (in pixels) by which the sub views
	are inset from the border of the receiver."

	^insets ifNil: [Rectangle new]!

insets: aRectangle 
	"Set the <Rectangle> whose edges specify the distance (in pixels) by which the sub views are
	inset from the border of the receiver."

	insets := aRectangle = Rectangle new ifFalse: [aRectangle].
	self invalidateLayout; invalidate!

invalidateRect: aRectangle erase: aBoolean 
	"Invalidates the specified client rectangle (a RECT, Rectangle, or nil for the whole client window).
	Set whether to erase the receivers background before repainting. Answer whether the function succeeds."

	"There is a possibility that this may be called before the receiver has been created
	so check for this to avoid accidentally redrawing the entire desktop"

	handle isNull ifTrue: [^false].
	^self hasTransparentBackground 
		ifTrue: 
			[self parentView invalidateRect: (aRectangle isNil 
						ifTrue: [self rectangle]
						ifFalse: [self mapRectangle: aRectangle to: self parentView])
				erase: aBoolean]
		ifFalse: 
			[UserLibrary default 
				invalidate: handle
				lpRect: aRectangle asParameter
				bErase: aBoolean asParameter]!

isDoubleBuffered
	"Answer whether erase/paint is double-buffered."

	^self ivFlags allMask: DoubleBufferMask!

isDoubleBuffered: aBoolean 
	"Set whether erase/paint is double-buffered."

	ivFlags := self ivFlags mask: DoubleBufferMask set: aBoolean!

isWholeBackgroundErased
	"Answer whether the entire background should be erased, rather than just that part not
	covered by the image. This setting should be true to display a partically transparent (alpha
	blended) bitmap over a solid background colour. This setting is ignored if #isDoubleBuffered
	is true."

	^self ivFlags allMask: EraseWholeMask!

isWholeBackgroundErased: aBoolean 
	"Set whether the entire background should be erased, rather than just that part not covered
	by the image. This setting should be true to display a partically transparent (alpha
	blended) bitmap over a solid background colour. This setting is ignored if #isDoubleBuffered
	is true."

	ivFlags := self ivFlags mask: EraseWholeMask set: aBoolean!

ivFlags
	^ivFlags ?? 0!

normal: imageExtent in: displayRect
	"Modified ImageView's #normal ... answer a new Rectangle instance"

	^Rectangle origin: displayRect origin extent: imageExtent!

onEraseRequired: aColorEvent 
	"Private - Handler for erase background event - we perform all erasure in the paint routine."

	^true!

onPaintRequired: aPaintEvent
	"Private - Handler for paint event. Show the image scaled as defined by viewMode."

	| canvas |
	canvas := aPaintEvent canvas.
	self isDoubleBuffered
		ifTrue: 
			[| rect extent bmp bmpCanvas |
			rect := self clientRectangle.
			extent := rect extent.
			bmp := Bitmap compatible: canvas extent: extent.
			bmpCanvas := bmp canvas.
			self eraseBackground: bmpCanvas around: nil.
			self paintImageOn: bmpCanvas.
			canvas
				bitBlt: bmpCanvas
				rectangle: (0 @ 0 extent: extent)
				to: rect origin
				rop: SRCCOPY.
			bmp free]
		ifFalse: [self paintOn: canvas]!

paintImageOn: aCanvas 
	^self subclassResponsibility!

paintOn: canvas 
	self isWholeBackgroundErased 
		ifTrue: 
			[self eraseBackground: canvas around: nil.
			self paintImageOn: canvas]
		ifFalse: [self eraseBackground: canvas around: (self paintImageOn: canvas)]!

scale: imageExtent in: displayRect
	^displayRect!

scaleBestFit: imageExtent in: displayRect
	"Unlike #scaleToFit, only scale if the image extent is larger than the displayRect"

	| scale |
	scale := (imageExtent isZero or: [imageExtent < displayRect extent]) 
				ifTrue: [1]
				ifFalse: 
					[| r |
					r := displayRect extent / imageExtent.
					r x min: r y].
	^Rectangle center: displayRect center extent: (imageExtent * scale) rounded!

scaleToFit: imageExtent in: displayRect
	| scale |
	scale := imageExtent isZero 
				ifTrue: [1]
				ifFalse: 
					[| r |
					r := displayRect extent / imageExtent.
					r x min: r y].
	^Rectangle center: displayRect center extent: (imageExtent * scale) rounded!

subclassWindow: hWnd
	"Private - Subclass the receiver's associated Win32 window, if necessary, by substituting the VM's 
	window procedure and saving the old one, and record hWnd as the handle of the receiver's window.
	Windows of Smalltalk registered classes (i.e. most windows apart from Windows controls) need only 
	record the handle passed by the VM (which has previously been instructed to hook the window create
	for the receiver).
	Implementation Note: This message is sent by the VM with asynchronous process switching disabled."

	self attachHandle: hWnd!

viewMode
	"Answer the view mode of the receiver."

	^viewMode
		!

viewMode: aSymbol 
	"Sets the view mode of the reciver to aSymbol.
	This can be one of:
		#normal
		#centered
		#scale
		#scaleToFit
		#scaleBestFit"

	viewMode := aSymbol.
	self invalidate!

wmPaint: message wParam: wParam lParam: lParam
	"Private - This window requires painting.
	The receiver is not actually a native widget, so we use the internal painting routine."

	self ensureLayoutValid.
	^self basicPaint: message wParam: wParam lParam: lParam
!

wmPrintClient: message wParam: wParam lParam: lParam 
	self ensureLayoutValid.
	self paintOn: (Canvas withNonOwnedDC: wParam).
	^0! !
!ImageViewAbstract categoriesForMethods!
calcRectangle:!geometry!private! !
calculateExtent:!geometry!private! !
centered:in:!geometry!private! !
default:in:!geometry!private! !
defaultWindowProcessing:wParam:lParam:!dispatching!private! !
displayRectangle!geometry!private! !
displayValue!private!updating! !
displayValue:!private!updating! !
drawBorderOn:imageRect:displayRect:!drawing!private! !
eraseBackground:around:!event handling!private! !
imageBorder!modes!public! !
imageBorder:!modes!public! !
initialize!initializing!private! !
insets!accessing!public! !
insets:!accessing!public! !
invalidateRect:erase:!drawing!public! !
isDoubleBuffered!public!testing! !
isDoubleBuffered:!accessing!public! !
isWholeBackgroundErased!public!testing! !
isWholeBackgroundErased:!accessing!public! !
ivFlags!private!testing! !
normal:in:!geometry!private! !
onEraseRequired:!drawing!event handling!private! !
onPaintRequired:!event handling!private! !
paintImageOn:!drawing!private! !
paintOn:!drawing!event handling!private! !
scale:in:!geometry!private! !
scaleBestFit:in:!geometry!private! !
scaleToFit:in:!geometry!private! !
subclassWindow:!operations!private! !
viewMode!modes!public! !
viewMode:!modes!public! !
wmPaint:wParam:lParam:!event handling-win32!private! !
wmPrintClient:wParam:lParam:!event handling-win32!private! !
!

!ImageViewAbstract class methodsFor!

edgeStyles
	^self edgeStyleTable keys asArray!

edgeStyleTable
	^EdgeStyles!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 'ImageView.ico'!

initialize
	self addClassConstant: 'EraseWholeMask' value: 1.
	self addClassConstant: 'DoubleBufferMask' value: 2.
	self addClassConstant: 'EdgeStyles'
		value: (IdentityDictionary new
				at: #none put: 0;
				at: #raised put: 5;
				at: #sunken put: 10;
				at: #etched put: 6;
				at: #bump put: 9;
				isImmutable: true;
				yourself)!

stbConvertFromVersion12: anArray 
	"Private - Perform an STB conversion from a version 12 <View> to version 13. 13 adds
	inheritable background colours if the backcolor is nil (similar to the way fonts are
	inherited). The special colour 'default' can be used to specify the control's default
	background colour. In this version ImageView itself adds a flags instance variable."

	(anArray at: 6) ifNil: [anArray at: 6 put: Color default].
	^anArray, #(0 nil nil)!

viewModes
	^#(#normal #centered #scale #scaleToFit #scaleBestFit)!

winClassName
	"Private - Answer the Windows class name, or atom, to be used when creating Windows attached
	to instances of the receiver."

	^self wndClassName! !
!ImageViewAbstract class categoriesForMethods!
edgeStyles!constants!public! !
edgeStyleTable!constants!public! !
icon!constants!public! !
initialize!development!initializing!private! !
stbConvertFromVersion12:!binary filing!private! !
viewModes!constants!public! !
winClassName!constants!private! !
!

