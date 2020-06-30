"Filed out from Dolphin Smalltalk 7"!

AbstractContainerViewTest subclass: #ContainerViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
ContainerViewTest guid: (GUID fromString: '{4e892cf1-595a-44ad-9a6d-0c319b32d174}')!
ContainerViewTest comment: ''!
!ContainerViewTest categoriesForClass!Unclassified! !
!ContainerViewTest methodsFor!

containerClass
	^ContainerView!

test1PixBorderPrint
	"Tests the validity of WM_PRINT of a 1 pixel border"

	| printBitmap |
	containerView hasBorder: false.
	self waitForScreenUpdate.
	printBitmap := self bitmapOfPrintView: containerView.
	self 
		checkRectangle: (self borderRectangleOf: containerView)
		inBitmap: printBitmap
		color: self backgroundColor.
	self 
		checkRectangle: ((self borderRectangleOf: containerView) insetBy: 1 asPoint)
		inBitmap: printBitmap
		color: self backgroundColor.
	containerView hasBorder: true.
	self waitForScreenUpdate.
	printBitmap := self bitmapOfPrintView: containerView.
	self 
		checkRectangle: (self borderRectangleOf: containerView)
		inBitmap: printBitmap
		color: self borderColor.
	self 
		checkRectangle: ((self borderRectangleOf: containerView) insetBy: 1 asPoint)
		inBitmap: printBitmap
		color: self backgroundColor! !
!ContainerViewTest categoriesFor: #containerClass!private! !
!ContainerViewTest categoriesFor: #test1PixBorderPrint!public! !

