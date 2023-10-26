"Filed out from Dolphin Smalltalk"!

UI.ImageViewAbstract
	subclass: #'Tools.ImageListView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ImageListView guid: (Core.GUID fromString: '{3089fd81-d572-4492-a0ac-037b8ad4125e}')!
Tools.ImageListView comment: '`ImageListView` is debugging aid for displaying the entire content of an image list, e.g. in an inspector open on an image list.
'!
!Tools.ImageListView categoriesForClass!MVP-Views! !
!Tools.ImageListView methodsFor!

invalidateOnResize
	"Private - The images in the list are wrapped so that as many as possible fit in each row, therefore as the view is resized complete redraw is required"

	^true!

paintImageOn: aCanvas
	"Private - Paint the images in the image list at natural extent (i.e. the viewMode is ignored), using a flowing layout. No edge is drawn."

	| displayRect cx imageSize cy origin count perRow |
	(image isNil or: [image handle isNull]) ifTrue: [^nil].
	displayRect := self displayRectangle.
	imageSize := image extent.
	cx := imageSize x.
	cy := imageSize y.
	perRow := displayRect extent x // cx max: 1.
	aCanvas fillRectangle: displayRect color: (image backcolor ifNil: [self actualBackcolor]).
	origin := displayRect origin.
	count := image getImageCount.
	0 to: count - 1
		do: 
			[:i |
			image
				draw: i + 1
				on: aCanvas
				at: origin + ((i \\ perRow * cx) @ (i // perRow * cy))].
	^displayRect origin: origin extent: (perRow * cx) @ ((count / perRow) ceiling * cy)! !
!Tools.ImageListView categoriesForMethods!
invalidateOnResize!private!testing! !
paintImageOn:!drawing!event handling!private! !
!

!Tools.ImageListView class methodsFor!

publishedAspectsOfInstances
	"Answer a <LookupTable> of the <Aspect>s published by instances of the receiver."

	^super publishedAspectsOfInstances
		removeAllKeys: #(#viewMode #isWholeBackgroundErased #isDoubleBuffered #imageBorder);
		yourself! !
!Tools.ImageListView class categoriesForMethods!
publishedAspectsOfInstances!constants!public! !
!

