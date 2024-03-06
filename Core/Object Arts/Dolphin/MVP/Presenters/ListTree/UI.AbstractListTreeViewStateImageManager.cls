"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.AbstractListTreeViewStateImageManager'
	instanceVariableNames: 'imageLists'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.AbstractListTreeViewStateImageManager guid: (Core.GUID fromString: '{1f513dc6-92fb-4c94-b79b-be4d4ead1437}')!

UI.AbstractListTreeViewStateImageManager isNonInstantiable: true!

UI.AbstractListTreeViewStateImageManager comment: ''!

!UI.AbstractListTreeViewStateImageManager categoriesForClass!Graphics-Tools! !

!UI.AbstractListTreeViewStateImageManager methodsFor!

addExpandos: aWinImageList forDpi: anInteger
	self subclassResponsibility!

buildImageListWithExtent: aPoint
	| imageList |
	imageList := ImageList
				newExtent: aPoint
				initialSize: 3
				masked: true.
	imageList addBitmap: (Bitmap displayCompatibleWithExtent: aPoint) mask: Color black.
	self addExpandos: imageList
		forDpi: aPoint y * Win32Constants.USER_DEFAULT_SCREEN_DPI // SystemMetrics default smallIconExtent y.
	imageLists at: aPoint put: imageList.
	^imageList!

imageListWithExtent: aPoint
	"Answer the image list for the receiver that has an extent that matches the <Point> argument. "

	| imageList |
	imageList := imageLists lookup: aPoint.
	(imageList isNil or: [imageList isRealized not])
		ifTrue: [imageList := self buildImageListWithExtent: aPoint].
	^imageList!

initialize
	imageLists := LookupTable new! !

!UI.AbstractListTreeViewStateImageManager categoriesForMethods!
addExpandos:forDpi:!helpers!private! !
buildImageListWithExtent:!helpers!private! !
imageListWithExtent:!accessing!public! !
initialize!public! !
!

!UI.AbstractListTreeViewStateImageManager class methodsFor!

new
	^self basicNew initialize! !

!UI.AbstractListTreeViewStateImageManager class categoriesForMethods!
new!instance creation!public! !
!

