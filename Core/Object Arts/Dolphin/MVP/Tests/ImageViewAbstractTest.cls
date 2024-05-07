"Filed out from Dolphin Smalltalk"!

StaticViewTest subclass: #ImageViewAbstractTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ImageViewAbstractTest guid: (GUID fromString: '{ed83beab-fa00-4772-a8d4-fcf6e16c948a}')!

ImageViewAbstractTest isAbstract: true!

ImageViewAbstractTest comment: ''!

!ImageViewAbstractTest categoriesForClass!Unclassified! !

!ImageViewAbstractTest methodsFor!

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
	rect := RECTL new.
	retries := 0.
	
	[presenter validate.
	(UserLibrary default
		getUpdateRect: presenter handle
		lpRect: rect
		bErase: false) and: [retries < 5]]
			whileTrue: [retries := retries + 1].
	self assert: rect extent equals: 0 @ 0.
	extent := presenter extent.
	presenter topView extent: presenter topView extent + extent.
	self assert: (UserLibrary default
				getUpdateRect: presenter handle
				lpRect: rect
				bErase: false).
	self assert: rect extent equals: extent * 2.
	presenter validate.
	presenter topView extent: presenter topView extent - (50 @ 100).
	self assert: (UserLibrary default
				getUpdateRect: presenter handle
				lpRect: rect
				bErase: false).
	self assert: rect extent equals: extent * 2 - (50 @ 100)! !

!ImageViewAbstractTest categoriesForMethods!
image!private!Running! !
initializePresenter!public!Running! !
testInvalidateOnResize!public!unit tests! !
!

