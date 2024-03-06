"Filed out from Dolphin Smalltalk"!

Object subclass: #AbstractListTreeViewStateImageManager
	instanceVariableNames: 'imageLists'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractListTreeViewStateImageManager guid: (GUID fromString: '{1f513dc6-92fb-4c94-b79b-be4d4ead1437}')!

AbstractListTreeViewStateImageManager isAbstract: true!

AbstractListTreeViewStateImageManager comment: ''!

!AbstractListTreeViewStateImageManager categoriesForClass!Graphics-Tools! !

!AbstractListTreeViewStateImageManager methodsFor!

addExpandos: aWinImageList forDpi: anInteger
	self subclassResponsibility!

buildImageListWithExtent: aPoint
	| imageList |
	imageList := WinImageList
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

!AbstractListTreeViewStateImageManager categoriesForMethods!
addExpandos:forDpi:!helpers!private! !
buildImageListWithExtent:!helpers!private! !
imageListWithExtent:!accessing!public! !
initialize!public! !
!

!AbstractListTreeViewStateImageManager class methodsFor!

new
	^self basicNew initialize! !

!AbstractListTreeViewStateImageManager class categoriesForMethods!
new!instance creation!public! !
!

