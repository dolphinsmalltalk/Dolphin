"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusTest
	subclass: #'Graphics.Gdiplus.Tests.InitializerTests'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.InitializerTests guid: (Core.GUID fromString: '{6547b0a9-3786-40b7-bacc-48ed66bf651d}')!

Graphics.Gdiplus.Tests.InitializerTests isNonInstantiable: true!

Graphics.Gdiplus.Tests.InitializerTests comment: ''!

!Graphics.Gdiplus.Tests.InitializerTests methodsFor!

createHandle
	| messages |
	self mockGdip.
	[model createHandle] ensure: [messages := self unmockGdip].
	^messages!

mockGdip
	| binding |
	binding := #{Gdip} binding.
	GdiplusLibrary default == binding value ifFalse: [^self].
	binding setValue: MockGdiplusLibrary new!

setUp
	super setUp.
	self newCanonicalModel!

tearDown
	self unmockGdip.
	super tearDown!

testIsPersistent
	"By default initializers can be persisted"

	self assert: model isPersistent!

unmockGdip
	| binding messages |
	binding := #{Gdip} binding.
	GdiplusLibrary default == binding value ifTrue: [^self].
	messages := binding value messages.
	binding setValue: GdiplusLibrary default.
	^messages! !

!Graphics.Gdiplus.Tests.InitializerTests categoriesForMethods!
createHandle!private!unit tests! !
mockGdip!private!running! !
setUp!public!running! !
tearDown!public!running! !
testIsPersistent!public!unit tests! !
unmockGdip!private!running! !
!

