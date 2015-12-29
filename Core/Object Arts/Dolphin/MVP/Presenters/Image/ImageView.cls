"Filed out from Dolphin Smalltalk X6"!

ImageViewAbstract subclass: #ImageView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ImageView guid: (GUID fromString: '{87B4C73E-026E-11D3-9FD7-00A0CC3E4A32}')!
ImageView comment: 'ImageView is a <valueView> for displaying static <image>s. The <valueModel> associated with an ImageView must always yield an <image> value when mapped through the installed type converter. An ImageView will normally be used in conjunction with a <ImagePresenter>. The mode in which the image is displayed can be controlled using the #viewMode aspect which can be set to one of the following: (#normal, #centered, scale or #scaleToFit). 

Normally ImageView will only erase background areas not covered by the image to avoid flicker. To display a partially transparent (alpah-blended) bitmap over a solid background colour, you must set either the #isWholeBackgroundErased or #isDoubleBuffered aspects to true.

Note that ImageView is not actually a control, but a pure Dolphin window.

Example:

	ImagePresenter show: ''Basic image'' on: (Bitmap fromFile: ''d:\object arts\dev\dolphin6\Resources\Beach Ball.bmp'')



'!
!ImageView categoriesForClass!MVP-Views! !
!ImageView methodsFor!

paintImageOn: aCanvas 
	| imageRect displayRect |
	(image isNil or: [image handle isNull]) ifTrue: [^nil].
	displayRect := self displayRectangle.
	imageRect := self calcRectangle: displayRect.
	image 
		drawOn: aCanvas
		at: imageRect topLeft
		extent: imageRect extent.
	^self 
		drawBorderOn: aCanvas
		imageRect: imageRect
		displayRect: displayRect! !
!ImageView categoriesFor: #paintImageOn:!drawing!event handling!private! !

