"Filed out from Dolphin Smalltalk 7"!

GdiplusTests subclass: #GdiplusCustomLineCapTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusCustomLineCapTest guid: (GUID fromString: '{11CE56C0-847E-11D7-B609-00E0987E8081}')!
GdiplusCustomLineCapTest comment: ''!
!GdiplusCustomLineCapTest categoriesForClass!Unclassified! !
!GdiplusCustomLineCapTest methodsFor!

setUp
	super setUp.
	model := GdiplusCustomLineCap 
				strokePath: (GdiplusGraphicsPath new addEllipse: (Point zero extent: 200 @ 100))!

testBaseCap
	self assert: model baseCap = 0.
	"Only the first 4 constants (0 through 3) work.  Don't know why only those."
	model class enumsLineCap do: 
			[:e | 
			e value <= 3 
				ifTrue: 
					[model baseCap: e value.
					self assert: model baseCap = e value]
				ifFalse: [self should: [model baseCap: e value] raise: GdiplusError]]!

testBaseInset
	self assert: model baseInset = 0.
	model baseInset: 4.5.
	self assert: model baseInset = 4.5!

testClone
	"force realize"

	| clone |
	model handle.
	clone := model clone.
	self assert: model initializer == clone initializer.
	self assert: clone basicHandle notNil!

testStrokeCaps
	self assert: model strokeCaps = #(0 0).
	"Only the first 4 constants (0 through 3) work.  Don't know why only those."
	model class enumsLineCap do: 
			[:e | 
			e value <= 3 
				ifTrue: 
					[model startCap: e value endCap: e value.
					self assert: model strokeCaps = (Array with: e value with: e value).
					self assert: model startCap = e value.
					self assert: model endCap = e value]
				ifFalse: [self should: [model startCap: e value endCap: e value] raise: GdiplusError]]!

testStrokeJoin
	self assert: model strokeJoin = 0.
	model class enumsLineJoin do: 
			[:e | 
			model strokeJoin: e value.
			self assert: model strokeJoin = e value]!

testWidthScale
	self assert: model widthScale = 1.
	model widthScale: 2.5.
	self assert: model widthScale = 2.5! !
!GdiplusCustomLineCapTest categoriesFor: #setUp!public!setup! !
!GdiplusCustomLineCapTest categoriesFor: #testBaseCap!public!unit tests! !
!GdiplusCustomLineCapTest categoriesFor: #testBaseInset!public!unit tests! !
!GdiplusCustomLineCapTest categoriesFor: #testClone!public!unit tests! !
!GdiplusCustomLineCapTest categoriesFor: #testStrokeCaps!public!unit tests! !
!GdiplusCustomLineCapTest categoriesFor: #testStrokeJoin!public!unit tests! !
!GdiplusCustomLineCapTest categoriesFor: #testWidthScale!public!unit tests! !

