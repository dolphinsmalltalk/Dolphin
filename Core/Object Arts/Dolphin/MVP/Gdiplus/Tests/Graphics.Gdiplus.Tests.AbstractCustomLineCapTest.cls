"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest subclass: #'Graphics.Gdiplus.Tests.AbstractCustomLineCapTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.AbstractCustomLineCapTest guid: (Core.GUID fromString: '{7469b42b-9046-4226-a093-df3a8adda033}')!
Graphics.Gdiplus.Tests.AbstractCustomLineCapTest isNonInstantiable: true!
Graphics.Gdiplus.Tests.AbstractCustomLineCapTest comment: ''!
!Graphics.Gdiplus.Tests.AbstractCustomLineCapTest methodsFor!

testStrokeJoin
	self newCanonicalModel.
	self assert: model strokeJoin equals: LineJoinMiter.
	{LineJoinMiter. LineJoinBevel. LineJoinRound. LineJoinMiterClipped} do: 
			[:each |
			model strokeJoin: each.
			self assert: model strokeJoin equals: each.
			model free.
			self assert: model strokeJoin equals: each]
	"The API doesn't actually validate the line join constant"
	"self should: [model strokeJoin: LineJoinMiterClipped + 1] raise: Gdiplus.GdiplusError"!

testWidthScale
	self newCanonicalModel.
	self assert: model widthScale equals: 1.
	model widthScale: 5 / 2.
	self assert: model widthScale equals: 2.5.
	model free.
	self assert: model widthScale equals: 2.5!

verifyEqualToModel: aGdiplusObject
	super verifyEqualToModel: aGdiplusObject.
	self assert: aGdiplusObject strokeJoin equals: model strokeJoin.
	self assert: aGdiplusObject widthScale equals: model widthScale! !
!Graphics.Gdiplus.Tests.AbstractCustomLineCapTest categoriesForMethods!
testStrokeJoin!public!unit tests! !
testWidthScale!public!unit tests! !
verifyEqualToModel:!asserting!private! !
!

