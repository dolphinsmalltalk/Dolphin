"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.TransformableBrushTest subclass: #'Graphics.Gdiplus.Tests.TextureBrushTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.TextureBrushTest guid: (Core.GUID fromString: '{22d063de-5e81-404d-83b0-0731f325a82f}')!
Graphics.Gdiplus.Tests.TextureBrushTest comment: ''!
!Graphics.Gdiplus.Tests.TextureBrushTest methodsFor!

brushType
	^BrushTypeTextureFill!

createCanonicalSubject
	| image |
	image := Image fromFile: self fileResource pafFish32x32png.
	^TextureBrush image: image!

createFullSubject
	^self createCanonicalSubject
		translate: 5 @ 10;
		wrapMode: WrapModeClamp;
		yourself!

gdipGetTransform: aHandle matrix: matrix
	Gdip gdipGetTextureTransform: aHandle matrix: matrix handle!

subjectClass
	^TextureBrush!

testPrintString
	| printed model2 imageFilePath |
	self newCanonicalModel.
	printed := model printString.
	imageFilePath := self fileResource resourceFileLocator localFileSpecFor: 'fish32x32.png'.
	self assert: printed
		equals: '(Gdiplus.TextureBrush image: (Gdiplus.Image fromFile: <1p>))' << imageFilePath.
	model2 := Compiler evaluate: printed.
	self assert: model2 equals: model.
	model2 free.
	model translate: 5 @ 10.
	self assert: model printString
		equals: 'a Gdiplus.TextureBrush(image: (Gdiplus.Image fromFile: <1p>); transform: (Gdiplus.Matrix fromArray: #(1.0 0.0 0.0 1.0 5.0 10.0)))'
				<< imageFilePath!

testPrintString2
	model := self createFullSubject.
	self assert: model printString
		equals: 'a Gdiplus.TextureBrush(image: (Gdiplus.Image fromFile: <1p>) wrapMode: Gdiplus.WrapModeClamp; transform: (Gdiplus.Matrix fromArray: #(1.0 0.0 0.0 1.0 5.0 10.0)))'
				<< (self fileResource resourceFileLocator localFileSpecFor: 'fish32x32.png')!

verifyEqualToModel: aGdiplusObject
	super verifyEqualToModel: aGdiplusObject.
	self assert: aGdiplusObject image equals: model image.
	self assert: aGdiplusObject bounds equals: model bounds! !
!Graphics.Gdiplus.Tests.TextureBrushTest categoriesForMethods!
brushType!constants!private! !
createCanonicalSubject!initializing!private! !
createFullSubject!private!running! !
gdipGetTransform:matrix:!private!transformations! !
subjectClass!constants!private! !
testPrintString!public!unit tests! !
testPrintString2!public!unit tests! !
verifyEqualToModel:!helpers!private! !
!

