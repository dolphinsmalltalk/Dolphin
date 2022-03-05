"Filed out from Dolphin Smalltalk"!

GdiplusTests subclass: #GdiplusCustomLineCapTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusCustomLineCapTest guid: (GUID fromString: '{11ce56c0-847e-11d7-b609-00e0987e8081}')!
GdiplusCustomLineCapTest comment: ''!
!GdiplusCustomLineCapTest categoriesForClass!Unclassified! !
!GdiplusCustomLineCapTest methodsFor!

setUp
	super setUp.
	model := GdiplusCustomLineCap 
				strokePath: (GdiplusGraphicsPath new addEllipse: (Point zero extent: 200 @ 100))!

testBaseCap
	self assert: model baseCap equals: 0.
	"Only the first 4 constants (0 through 3) work.  Don't know why only those."
	model class enumsLineCap do: 
			[:e |
			e value <= 3
				ifTrue: 
					[model baseCap: e value.
					self assert: model baseCap equals: e value]
				ifFalse: [self should: [model baseCap: e value] raise: GdiplusError]]!

testBaseInset
	self assert: model baseInset equals: 0.
	model baseInset: 4.5.
	self assert: model baseInset equals: 4.5!

testClone
	"force realize"

	| clone |
	model handle.
	clone := model clone.
	self assert: model initializer identicalTo: clone initializer.
	self denyIsNil: clone basicHandle!

testStrokeCaps
	self assert: model strokeCaps equals: #(0 0).
	"Only the first 4 constants (0 through 3) work.  Don't know why only those."
	model class enumsLineCap do: 
			[:e |
			e value <= 3
				ifTrue: 
					[model startCap: e value endCap: e value.
					self assert: model strokeCaps equals: (Array with: e value with: e value).
					self assert: model startCap equals: e value.
					self assert: model endCap equals: e value]
				ifFalse: [self should: [model startCap: e value endCap: e value] raise: GdiplusError]]!

testStrokeJoin
	self assert: model strokeJoin equals: 0.
	model class enumsLineJoin do: 
			[:e |
			model strokeJoin: e value.
			self assert: model strokeJoin equals: e value]!

testWidthScale
	self assert: model widthScale equals: 1.
	model widthScale: 2.5.
	self assert: model widthScale equals: 2.5! !
!GdiplusCustomLineCapTest categoriesForMethods!
setUp!public!setup! !
testBaseCap!public!unit tests! !
testBaseInset!public!unit tests! !
testClone!public!unit tests! !
testStrokeCaps!public!unit tests! !
testStrokeJoin!public!unit tests! !
testWidthScale!public!unit tests! !
!

