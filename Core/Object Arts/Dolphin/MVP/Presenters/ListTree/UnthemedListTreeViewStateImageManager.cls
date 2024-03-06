"Filed out from Dolphin Smalltalk"!

AbstractListTreeViewStateImageManager subclass: #UnthemedListTreeViewStateImageManager
	instanceVariableNames: ''
	classVariableNames: 'BoxSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

UnthemedListTreeViewStateImageManager guid: (GUID fromString: '{b18d4b1f-4b48-4b8b-8f33-9d3b85afcd87}')!

UnthemedListTreeViewStateImageManager addClassConstant: 'BoxSize' value: 16r9!

UnthemedListTreeViewStateImageManager comment: ''!

!UnthemedListTreeViewStateImageManager categoriesForClass!Graphics-Tools! !

!UnthemedListTreeViewStateImageManager methodsFor!

addExpandos: imageList forDpi: dpi
	| buttonSize bitmap box inset extent |
	buttonSize := BoxSize * dpi // Win32Constants.USER_DEFAULT_SCREEN_DPI.
	buttonSize even ifTrue: [buttonSize := buttonSize + 1].
	extent := imageList extent.
	box := ((extent - buttonSize) / 2) rounded extent: buttonSize @ buttonSize.
	inset := 2 * dpi // Win32Constants.USER_DEFAULT_SCREEN_DPI.

	"Image for expanded state"
	bitmap := Bitmap displayCompatibleWithExtent: extent.
	bitmap canvas
		erase;
		rectangle: box;
		lineFrom: box leftCenter + (inset @ 0) to: box rightCenter - (inset @ 0).
	imageList addBitmap: bitmap mask: Color white.

	"Image for collapsed state"
	bitmap canvas lineFrom: box topCenter + (0 @ inset) to: box bottomCenter - (0 @ inset).
	imageList addBitmap: bitmap mask: Color white.
	bitmap free! !

!UnthemedListTreeViewStateImageManager categoriesForMethods!
addExpandos:forDpi:!helpers!private! !
!

