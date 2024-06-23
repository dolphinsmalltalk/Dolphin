"Filed out from Dolphin Smalltalk"!

UI.ImageViewAbstract
	subclass: #'UI.ImageView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ImageView guid: (Core.GUID fromString: '{87b4c73e-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ImageView comment: 'ImageView is a <valueView> for displaying static <image>s. The <valueModel> associated with an ImageView must always yield an <image> value when mapped through the installed type converter. An ImageView will normally be used in conjunction with a <ImagePresenter>. The mode in which the image is displayed can be controlled using the #viewMode aspect which can be set to one of the following: (#normal, #centered, scale or #scaleToFit). 

Normally ImageView will only erase background areas not covered by the image to avoid flicker. To display a partially transparent (alpha-blended) bitmap over a solid background colour, you must set either the #isWholeBackgroundErased or #isDoubleBuffered aspects to true.

Note that ImageView is not actually a control, but a pure Dolphin window.

Example:

	ImagePresenter show: ''Basic image'' on: (Bitmap fromFile: ''d:\object arts\dev\dolphin6\Resources\Beach Ball.bmp'')



'!

!UI.ImageView categoriesForClass!MVP-Views! !

!UI.ImageView methodsFor!

image: anImage
	(image := anImage)
		ifNotNil: 
			["The image may have a cached DC that is not display compatible"
			image freeDC]!

paintImageOn: aCanvas 
	| imageRect displayRect |
	(image isNil or: [
		image realize.
		image isRealized not]) ifTrue: [^nil].
	displayRect := self displayRectangle.
	imageRect := self calcRectangle: displayRect.
	image 
		drawOn: aCanvas
		at: imageRect topLeft
		extent: imageRect extent.
	image freeDC.
	^self 
		drawBorderOn: aCanvas
		imageRect: imageRect
		displayRect: displayRect! !

!UI.ImageView categoriesForMethods!
image:!private!updating! !
paintImageOn:!drawing!event handling!private! !
!

