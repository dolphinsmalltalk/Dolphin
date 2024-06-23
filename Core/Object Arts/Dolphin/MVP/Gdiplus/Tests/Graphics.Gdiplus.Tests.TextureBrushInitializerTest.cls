"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests
	subclass: #'Graphics.Gdiplus.Tests.TextureBrushInitializerTest'
	instanceVariableNames: 'image'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.TextureBrushInitializerTest guid: (Core.GUID fromString: '{b30c98b3-eb64-42b3-a608-c748d44095d9}')!

Graphics.Gdiplus.Tests.TextureBrushInitializerTest comment: ''!

!Graphics.Gdiplus.Tests.TextureBrushInitializerTest methodsFor!

setUp
	super setUp.
	image := Image fromFile: self fileResource pafEyeJpg.
	model
		image: image
		wrapMode: WrapModeClamp
		rectangle: nil!

subjectClass
	^TextureBrushInitializer!

tearDown
	image := nil.
	super tearDown!

testCreateHandle
	| constructor messages |
	model
		image: image
		wrapMode: WrapModeTile
		rectangle: nil.
	messages := self createHandle.
	self assert: image basicHandle notNil.
	constructor := messages last.
	self assert: constructor selector identicalTo: #gdipCreateTexture:wrapMode:texture:.
	self assert: constructor arguments size equals: 3.
	self assert: constructor arguments first identicalTo: image basicHandle.
	self assert: constructor arguments second identicalTo: WrapModeTile.
	self assert: constructor arguments last isKindOf: Handle!

testCreateHandleWithBounds
	| constructor messages |
	model
		image: image
		wrapMode: WrapModeTile
		rectangle: (1 @ 2 extent: 10 @ 20).
	messages := self createHandle.
	self assert: image basicHandle notNil.
	constructor := messages last.
	self assert: constructor selector
		identicalTo: #gdipCreateTexture2I:wrapMode:x:y:width:height:texture:.
	self assert: constructor arguments size equals: 7.
	self assert: constructor arguments first identicalTo: image basicHandle.
	self assert: constructor arguments second identicalTo: WrapModeTile.
	self assert: constructor arguments third identicalTo: 1.
	self assert: constructor arguments fourth identicalTo: 2.
	self assert: constructor arguments fifth identicalTo: 10.
	self assert: constructor arguments sixth identicalTo: 20.
	self assert: constructor arguments last isKindOf: Handle! !

!Graphics.Gdiplus.Tests.TextureBrushInitializerTest categoriesForMethods!
setUp!public!running! !
subjectClass!constants!private! !
tearDown!public!running! !
testCreateHandle!public!unit tests! !
testCreateHandleWithBounds!public!unit tests! !
!

