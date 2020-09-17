"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #BitmapTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: #()
	classInstanceVariableNames: ''!
BitmapTest guid: (GUID fromString: '{e775dfbb-e3db-47cd-aec2-8b0ebe5b7498}')!
BitmapTest comment: ''!
!BitmapTest categoriesForClass!Unclassified! !
!BitmapTest methodsFor!

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
!BitmapTest categoriesFor: #testAsColorKeyedBitmap!private!unit tests! !

