"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #ImageViewAbstractTest
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

setUp
	super setUp.
	presenter
		viewMode: #center;
		model: self image asValue!

testInvalidateOnResize
	"We can test that the whole view is invalidated on resize"

	| rect extent |
	presenter topView layoutManager: ProportionalLayout new.
	presenter layout: #center.
	presenter validate.
	rect := RECT new.
	self deny: (UserLibrary default
				getUpdateRect: presenter handle
				lpRect: rect
				bErase: false).
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
!ImageViewAbstractTest categoriesFor: #image!private!Running! !
!ImageViewAbstractTest categoriesFor: #setUp!private!Running! !
!ImageViewAbstractTest categoriesFor: #testInvalidateOnResize!public! !

