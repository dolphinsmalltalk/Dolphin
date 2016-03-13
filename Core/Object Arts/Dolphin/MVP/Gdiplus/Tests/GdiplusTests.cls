"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #GdiplusTests
	instanceVariableNames: 'model'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!
GdiplusTests guid: (GUID fromString: '{EA227FDA-3570-490B-B8CF-4973DC534043}')!
GdiplusTests comment: ''!
!GdiplusTests categoriesForClass!Unclassified! !
!GdiplusTests methodsFor!

assertPersistedValid
	| recreated |
	recreated := Object fromBinaryStoreBytes: model binaryStoreBytes.
	"Asking recreated for it's handle should find any errors"
	self assert: recreated handle class == ExternalHandle!

compare: x to: y
	"Compare that the two <Float> values are equivalent to within the specified <Float> difference."

	^self 
		compare: x
		to: y
		epsilon: 1.0e-006!

compare: x to: y epsilon: epsilon
	"Compare that the two <Float> values are equivalent to within the specified <Float> difference."

	| max |
	^(max := x abs max: y abs) <= epsilon or: [(x - y) abs < (epsilon * max)]!

fileLocator
	^self fileResource fileLocator!

fileResource
	^GdiplusFileResource current!

getSampleBrush
	#todo.	"Replace this with a solid brush"
	^self getSampleLinearGradientBrush!

getSampleGDIBitmap
	^Bitmap 
		gdipCopyOfIcon: self icon
		extent: 32 @ 32
		backcolor: Color black!

getSampleLinearGradientBrush
	^GdiplusLinearGradientBrush 
		point1: 0 @ 0
		point2: 255 @ 0
		color1: ARGB red
		color2: ARGB red!

getSamplePen
	^GdiplusPen red!

tearDown
	model 
		ifNotNil: 
			[model free.
			model := nil].
	super tearDown! !
!GdiplusTests categoriesFor: #assertPersistedValid!asserting!public! !
!GdiplusTests categoriesFor: #compare:to:!comparing!public! !
!GdiplusTests categoriesFor: #compare:to:epsilon:!comparing!public! !
!GdiplusTests categoriesFor: #fileLocator!accessing!public! !
!GdiplusTests categoriesFor: #fileResource!accessing!public! !
!GdiplusTests categoriesFor: #getSampleBrush!accessing!public! !
!GdiplusTests categoriesFor: #getSampleGDIBitmap!accessing!public! !
!GdiplusTests categoriesFor: #getSampleLinearGradientBrush!accessing!public! !
!GdiplusTests categoriesFor: #getSamplePen!accessing!public! !
!GdiplusTests categoriesFor: #tearDown!public!Running! !

!GdiplusTests class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self name asString last = $s!

resources
	^Array with: GdiplusFileResource! !
!GdiplusTests class categoriesFor: #isAbstract!public!testing! !
!GdiplusTests class categoriesFor: #resources!accessing!public! !

