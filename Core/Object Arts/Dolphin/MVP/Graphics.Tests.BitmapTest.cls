"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Graphics.Tests.BitmapTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.BitmapTest guid: (Core.GUID fromString: '{e775dfbb-e3db-47cd-aec2-8b0ebe5b7498}')!
Graphics.Tests.BitmapTest comment: ''!
!Graphics.Tests.BitmapTest categoriesForClass!Unclassified! !
!Graphics.Tests.BitmapTest methodsFor!

testAsColorKeyedBitmap
	| subject colorKeyed result canvas |
	subject := Bitmap fromFile: 'Resources\IdeaSpaceBackdrop.bmp'
				usingLocator: FileLocator installRelative.
	colorKeyed := subject asColorKeyedBitmap.
	result := Bitmap displayCompatibleWithExtent: subject extent.
	canvas := result canvas.
	canvas backcolor: Color red.
	canvas erase.
	colorKeyed drawOn: canvas.
	self assert: (canvas pixelAt: Point zero) equals: Color black! !
!Graphics.Tests.BitmapTest categoriesFor: #testAsColorKeyedBitmap!private!unit tests! !

