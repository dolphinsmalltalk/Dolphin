﻿"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractContainerViewTest
	subclass: #'UI.Tests.StyledContainerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.StyledContainerTest guid: (Core.GUID fromString: '{c2d30af9-3ddd-440f-add5-535cd0e410a9}')!

UI.Tests.StyledContainerTest comment: ''!

!UI.Tests.StyledContainerTest methodsFor!

classToTest
	^Smalltalk.StyledContainer!

parentBackcolor
	^Color green!

styledBorderColor
	^Color blue!

test1PixDottedBorderPaint
	"Tests the validity of WM_PAINT of a 1 pixel styled dotted border"

	<namespace: Smalltalk>
	| containerView bitmap rect |
	self skip: 'Known failing test'.
	containerView := self view.
	containerView hasBorder: true.
	containerView styledPen: (Smalltalk.StyledPen 
				color: self styledBorderColor
				width: 1
				style: #dotted).
	containerView parentView backcolor: self parentBackcolor.
	self waitForScreenUpdate.
	bitmap := self bitmapOfPaintView: containerView.
	rect := self borderRectangleOf: containerView.
	self 
		checkPoints: (Array 
				with: rect topRight
				with: rect bottomLeft
				with: rect topLeft)
		inBitmap: bitmap
		color: self styledBorderColor.
	self 
		checkPoints: (Array with: rect bottomRight)
		inBitmap: bitmap
		color: self parentBackcolor.
	self 
		checkRectangle: ((self borderRectangleOf: containerView) insetBy: 1 asPoint)
		inBitmap: bitmap
		color: self backgroundColor!

test1PixDottedBorderPrint
	"Tests the validity of WM_PRINT of a 1 pixel styled dotted border"

	<namespace: Smalltalk>
	| containerView bitmap rect |
	self skip: 'Known failing test'.
	containerView := self view.
	containerView hasBorder: true.
	containerView styledPen: (Smalltalk.StyledPen 
				color: self styledBorderColor
				width: 1
				style: #dotted).
	containerView parentView backcolor: self parentBackcolor.
	self waitForScreenUpdate.
	bitmap := self bitmapOfPrintView: containerView.
	rect := self borderRectangleOf: containerView.
	self 
		checkPoints: (Array with: rect topRight with: rect bottomLeft)
		inBitmap: bitmap
		color: self styledBorderColor.

	"Not sure why this test is failing .. appears to work okay in VC"
	self 
		checkPoints: (Array with: rect topLeft with: rect bottomRight)
		inBitmap: bitmap
		color: self parentBackcolor.
	self 
		checkRectangle: ((self borderRectangleOf: containerView) insetBy: 1 asPoint)
		inBitmap: bitmap
		color: self backgroundColor! !

!UI.Tests.StyledContainerTest categoriesForMethods!
classToTest!helpers!private! !
parentBackcolor!private! !
styledBorderColor!private! !
test1PixDottedBorderPaint!public!unit tests! !
test1PixDottedBorderPrint!public!unit tests! !
!

