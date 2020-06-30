"Filed out from Dolphin Smalltalk 7"!

GdiplusTests subclass: #GdiplusGraphicsPathTest
	instanceVariableNames: 'fillMode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusGraphicsPathTest guid: (GUID fromString: '{fcef1a10-834c-11d7-b609-00e0987e8081}')!
GdiplusGraphicsPathTest comment: ''!
!GdiplusGraphicsPathTest categoriesForClass!Unclassified! !
!GdiplusGraphicsPathTest methodsFor!

setSample3Points
	model := GdiplusGraphicsPath 
				points: (Array 
						with: 100 @ 0
						with: 200 @ 150
						with: 0 @ 150)
				types: (ByteArray new: 3 withAll: PathPointTypeLine)
				fillMode: nil!

setSampleEllipse
	model := GdiplusGraphicsPath new addEllipse: (Point zero extent: 200 @ 100)!

setSampleNew
	model := GdiplusGraphicsPath new!

testBounds
	self setSample3Points.
	self assert: (Point zero extent: model bounds extent - 1) equals: (Point zero extent: 200 @ 150)!

testConstructor3Points
	self setSample3Points.
	model asParameter.
	self assertPersistedValid!

testConstructorPoints
	self setSample3Points.
	model asParameter.
	self assertPersistedValid!

testFillMode
	self setSampleNew.
	self assert: model fillMode equals: 0.
	model class enumsFillMode do: 
			[:e |
			model fillMode: e value.
			self assert: model fillMode equals: e value]!

testPointCount
	self setSample3Points.
	self assert: model pointCount equals: 3! !
!GdiplusGraphicsPathTest categoriesFor: #setSample3Points!public! !
!GdiplusGraphicsPathTest categoriesFor: #setSampleEllipse!public! !
!GdiplusGraphicsPathTest categoriesFor: #setSampleNew!public! !
!GdiplusGraphicsPathTest categoriesFor: #testBounds!public! !
!GdiplusGraphicsPathTest categoriesFor: #testConstructor3Points!public! !
!GdiplusGraphicsPathTest categoriesFor: #testConstructorPoints!public! !
!GdiplusGraphicsPathTest categoriesFor: #testFillMode!public! !
!GdiplusGraphicsPathTest categoriesFor: #testPointCount!public! !

