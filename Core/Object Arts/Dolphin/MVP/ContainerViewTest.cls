"Filed out from Dolphin Smalltalk 7"!

AbstractContainerViewTest subclass: #ContainerViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
ContainerViewTest guid: (GUID fromString: '{4E892CF1-595A-44AD-9A6D-0C319B32D174}')!
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

