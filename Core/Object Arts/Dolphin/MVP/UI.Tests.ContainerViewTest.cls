"Filed out from Dolphin Smalltalk 7"!

UI.Tests.AbstractContainerViewTest subclass: #'UI.Tests.ContainerViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ContainerViewTest guid: (Core.GUID fromString: '{4e892cf1-595a-44ad-9a6d-0c319b32d174}')!
UI.Tests.ContainerViewTest comment: ''!
!UI.Tests.ContainerViewTest categoriesForClass!Unclassified! !
!UI.Tests.ContainerViewTest methodsFor!

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
!UI.Tests.ContainerViewTest categoriesFor: #containerClass!private! !
!UI.Tests.ContainerViewTest categoriesFor: #test1PixBorderPrint!public! !

