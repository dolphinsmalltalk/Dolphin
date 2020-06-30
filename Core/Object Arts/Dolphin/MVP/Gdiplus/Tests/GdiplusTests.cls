"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #GdiplusTests
	instanceVariableNames: 'model'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusTests guid: (GUID fromString: '{ea227fda-3570-490b-b8cf-4973dc534043}')!
GdiplusTests isAbstract: true!
GdiplusTests comment: ''!
!GdiplusTests categoriesForClass!Unclassified! !
!GdiplusTests methodsFor!

assertPersistedValid
	| recreated |
	recreated := Object fromBinaryStoreBytes: model binaryStoreBytes.
	"Asking recreated for it's handle should find any errors"
	self assert: recreated handle class identicalTo: ExternalHandle!

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
		color1: Color red
		color2: Color red!

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

resources
	^Array with: GdiplusFileResource! !
!GdiplusTests class categoriesFor: #resources!accessing!public! !

