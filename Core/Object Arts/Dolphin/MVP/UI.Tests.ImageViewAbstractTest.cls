"Filed out from Dolphin Smalltalk"!

UI.Tests.StaticViewTest subclass: #'UI.Tests.ImageViewAbstractTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ImageViewAbstractTest guid: (Core.GUID fromString: '{ed83beab-fa00-4772-a8d4-fcf6e16c948a}')!
UI.Tests.ImageViewAbstractTest isNonInstantiable: true!
UI.Tests.ImageViewAbstractTest comment: ''!
!UI.Tests.ImageViewAbstractTest methodsFor!

image
	^self subclassResponsibility!

initializePresenter
	super initializePresenter.
	presenter
		viewMode: #center;
		model: self image asValue!

testInvalidateOnResize
	"We can test that the whole view is invalidated on resize"

	| rect extent retries |
	presenter topView layoutManager: ProportionalLayout new.
	presenter layout: #center.
	rect := RECTL newBuffer.
	retries := 0.
	
	[presenter validate.
	(User32
		getUpdateRect: presenter handle
		lpRect: rect
		bErase: false) and: [retries < 5]]
			whileTrue: [retries := retries + 1].
	self assert: rect extent equals: 0 @ 0.
	extent := presenter extent.
	presenter topView extent: presenter topView extent + extent.
	self assert: (User32
				getUpdateRect: presenter handle
				lpRect: rect
				bErase: false).
	self assert: rect extent equals: extent * 2.
	presenter validate.
	presenter topView extent: presenter topView extent - (50 @ 100).
	self assert: (User32
				getUpdateRect: presenter handle
				lpRect: rect
				bErase: false).
	self assert: rect extent equals: extent * 2 - (50 @ 100)! !
!UI.Tests.ImageViewAbstractTest categoriesForMethods!
image!private!Running! !
initializePresenter!public!Running! !
testInvalidateOnResize!public!unit tests! !
!

