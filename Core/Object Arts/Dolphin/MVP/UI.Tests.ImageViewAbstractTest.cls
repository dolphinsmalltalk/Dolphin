"Filed out from Dolphin Smalltalk 7"!

UI.Tests.PresenterTest subclass: #'UI.Tests.ImageViewAbstractTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ImageViewAbstractTest guid: (Core.GUID fromString: '{ed83beab-fa00-4772-a8d4-fcf6e16c948a}')!
UI.Tests.ImageViewAbstractTest isNonInstantiable: true!
UI.Tests.ImageViewAbstractTest comment: ''!
!UI.Tests.ImageViewAbstractTest categoriesForClass!Unclassified! !
!UI.Tests.ImageViewAbstractTest methodsFor!

image
	^self subclassResponsibility!

setUp
	super setUp.
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
!UI.Tests.ImageViewAbstractTest categoriesFor: #image!private!Running! !
!UI.Tests.ImageViewAbstractTest categoriesFor: #setUp!private!Running! !
!UI.Tests.ImageViewAbstractTest categoriesFor: #testInvalidateOnResize!public! !

