"Filed out from Dolphin Smalltalk 7"!

UI.ImageViewAbstract subclass: #'Tools.ImageListView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ImageListView guid: (Core.GUID fromString: '{3089fd81-d572-4492-a0ac-037b8ad4125e}')!
Tools.ImageListView comment: 'ImageListView is debugging aid for displaying the entire content of an image list, e.g. in an inspector open on an image list.
'!
!Tools.ImageListView categoriesForClass!MVP-Views! !
!Tools.ImageListView methodsFor!

paintImageOn: aCanvas 
	"Private - Paint the images in the image list at natural extent (i.e. the image mode is
	ignored), using a flow layout. No edge is drawn."

	| displayRect cx imageSize cy rows origin count perRow |
	(image isNil or: [image handle isNull]) ifTrue: [^nil].
	displayRect := self displayRectangle.
	count := image getImageCount.
	imageSize := image extent.
	cx := imageSize x.
	cy := imageSize y.
	perRow := displayRect extent x // cx max: 1.
	rows := (count / perRow) ceiling.
	aCanvas fillRectangle: displayRect color: (image backcolor ifNil: [self actualBackcolor]).
	origin := displayRect origin.
	0 to: count - 1
		do: 
			[:i | 
			image 
				draw: i + 1
				on: aCanvas
				at: origin + ((i \\ perRow * cx) @ (i // perRow * cy))].
	^displayRect origin: origin extent: (perRow * cx) @ (rows * cy)! !
!Tools.ImageListView categoriesFor: #paintImageOn:!drawing!event handling!private! !

