"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.AbstractCustomLineCapTest
	subclass: #'Graphics.Gdiplus.Tests.CustomLineCapTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.CustomLineCapTest guid: (Core.GUID fromString: '{11ce56c0-847e-11d7-b609-00e0987e8081}')!

Graphics.Gdiplus.Tests.CustomLineCapTest comment: ''!

!Graphics.Gdiplus.Tests.CustomLineCapTest methodsFor!

createCanonicalSubject
	^self subjectClass strokePath: self ellipticalStrokePath!

createFullSubject
	^self createCanonicalSubject
		strokeJoin: Gdiplus.LineJoinRound;
		widthScale: 3;
		startCap: Gdiplus.LineCapRound endCap: Gdiplus.LineCapTriangle;
		yourself!

ellipticalStrokePath
	^GraphicsPath ellipse: (0 @ 0 extent: 200 @ 100)!

getStrokeCaps: aCustomLineCap
	^aCustomLineCap initializer strokeCapsOf: aCustomLineCap!

subjectClass
	^CustomLineCap!

testBaseCap
	self newCanonicalModel.
	self assert: model baseCap equals: LineCapFlat.
	"Only the first 4 constants (0 through 3) work.  Don't know why only those. [bmcg: because the other constants are anchor flags/masks, and the custom cap mask which obviously is not applicable for the baseCap of a custom cap]"
	{LineCapFlat. LineCapSquare. LineCapRound. LineCapTriangle} do: 
			[:each |
			model baseCap: each.
			self assert: model baseCap equals: each.
			model free.
			self assert: model baseCap equals: each]!

testBaseInset
	self newCanonicalModel.
	self assert: model baseInset equals: 0.
	model baseInset: 9 / 2.
	self assert: model baseInset equals: 4.5.
	model
		baseInset: 3.25;
		free.
	self assert: model baseInset equals: 3.25!

testComparing
	| model2 |
	super testComparing.
	model2 := self createCanonicalSubject.
	model2 strokeJoin: LineJoinRound.
	self deny: model2 equals: model.
	self deny: model2 hash equals: model hash.
	model strokeJoin: LineJoinRound.
	self assert: model2 equals: model.
	self assert: model2 hash equals: model hash.
	model2 widthScale: 2.
	self deny: model2 equals: model.
	self deny: model2 hash equals: model hash.
	model widthScale: 2.
	self assert: model2 equals: model.
	self assert: model2 hash equals: model hash.
	model2 startCap: Gdiplus.LineCapRound endCap: Gdiplus.LineCapTriangle.
	self deny: model2 equals: model.
	self deny: model2 hash equals: model hash.
	model startCap: Gdiplus.LineCapRound endCap: Gdiplus.LineCapTriangle!

testEndCap
	self newCanonicalModel.
	self assert: model endCap equals: LineCapFlat.
	{LineCapSquare. LineCapRound. LineCapTriangle} do: 
			[:each |
			model endCap: each.
			self assert: model endCap equals: each.
			self assert: model startCap equals: LineCapFlat.
			self assert: (self getStrokeCaps: model) equals: {LineCapFlat. each}.
			model free.
			self assert: model endCap equals: each.
			self assert: model startCap equals: LineCapFlat.
			self assert: (self getStrokeCaps: model) equals: {LineCapFlat. each}].
	self should: [model startCap: Gdiplus.LineCapRoundAnchor] raise: Gdiplus.GdiplusError!

testPrintString
	| expr |
	self newCanonicalModel.
	expr := model printString.
	self assert: expr
		equals: '(Gdiplus.CustomLineCap strokePath: (Gdiplus.GraphicsPath points: {(200@50). (200@78). (155@100). (100@100). (45@100). (0@78). (0@50). (0@22). (45@0). (100@0). (155@0). (200@22). (200@50)} types: {Gdiplus.PathPointTypeStart. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier|Gdiplus.PathPointTypeCloseSubpath}) baseCap: Gdiplus.LineCapFlat baseInset: 0)'.
	self assert: (Compiler evaluate: expr) equals: model.
	model startCap: LineCapRound.
	self assert: model printString
		equals: 'a Gdiplus.CustomLineCap(strokePath: (Gdiplus.GraphicsPath points: {(200@50). (200@78). (155@100). (100@100). (45@100). (0@78). (0@50). (0@22). (45@0). (100@0). (155@0). (200@22). (200@50)} types: {Gdiplus.PathPointTypeStart. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier|Gdiplus.PathPointTypeCloseSubpath}) baseCap: Gdiplus.LineCapFlat baseInset: 0; startCap: Gdiplus.LineCapRound endCap: Gdiplus.LineCapFlat)'!

testStartCap
	self newCanonicalModel.
	self assert: model startCap equals: LineCapFlat.
	{LineCapSquare. LineCapRound. LineCapTriangle} do: 
			[:each |
			model startCap: each.
			self assert: model startCap equals: each.
			self assert: model endCap equals: LineCapFlat.
			self assert: (self getStrokeCaps: model) equals: {each. LineCapFlat}.
			model free.
			self assert: model startCap equals: each.
			self assert: model endCap equals: LineCapFlat.
			self assert: (self getStrokeCaps: model) equals: {each. LineCapFlat}].
	self should: [model startCap: Gdiplus.LineCapRoundAnchor] raise: Gdiplus.GdiplusError!

testStlUpgradeFromD7
	model := Object
				fromLiteralStoreArray: #(#'!!STL' 4 1311494 ##(Smalltalk.GdiplusCustomLineCap) nil true 2032902 ##(Smalltalk.GdiplusCustomLineCapInitializer) nil nil 1245958 ##(Smalltalk.GdiplusGraphicsPath) nil true 2622470 ##(Smalltalk.GdiplusGraphicsPathFromPointsInitializer) nil 34 3 328198 ##(Point) -29 -29 546 1 1 546 31 -29 8 #[0 1 1] 1 1 1).
	self assert: model strokePath points equals: {-15 @ -15. 0 @ 0. 15 @ -15}.
	self assert: model strokePath types equals: #[0 1 1].
	self assert: model strokePath fillMode equals: FillModeAlternate.
	"D7 did not persist the start/endCaps"
	self deny: model startCap equals: LineCapTriangle.
	self deny: model endCap equals: LineCapRound!

testStrokeCaps
	self newCanonicalModel.
	self assert: model strokeCaps equals: {LineCapFlat. LineCapFlat}.
	self assert: (self getStrokeCaps: model) equals: {LineCapFlat. LineCapFlat}.
	"Only the first 4 constants (0 through 3) work.  Don't know why only those. [bmcg: See my comment in testBaseCap]"
	{LineCapFlat. LineCapSquare. LineCapRound. LineCapTriangle} do: 
			[:each |
			model startCap: each endCap: each.
			self assert: model strokeCaps equals: {each. each}.
			self assert: (self getStrokeCaps: model) equals: {each. each}.
			model free.
			self assert: model startCap equals: each.
			self assert: model endCap equals: each.
			self assert: (self getStrokeCaps: model) equals: {each. each}].
	self should: [model startCap: Gdiplus.LineCapRoundAnchor endCap: Gdiplus.LineCapRoundAnchor]
		raise: Gdiplus.GdiplusError!

testStrokePath
	self newCanonicalModel.
	self assert: model strokePath equals: self ellipticalStrokePath!

verifyEqualToModel: aGdiplusObject
	super verifyEqualToModel: aGdiplusObject.
	self assert: aGdiplusObject baseCap equals: model baseCap.
	self assert: aGdiplusObject baseInset equals: model baseInset.
	self assert: aGdiplusObject endCap equals: model endCap.
	self assert: aGdiplusObject fillPath equals: model fillPath.
	self assert: aGdiplusObject startCap equals: model startCap.
	self assert: aGdiplusObject strokeCaps equals: model strokeCaps.
	self assert: aGdiplusObject strokePath equals: model strokePath! !

!Graphics.Gdiplus.Tests.CustomLineCapTest categoriesForMethods!
createCanonicalSubject!private!running! !
createFullSubject!helpers!private! !
ellipticalStrokePath!constants!private! !
getStrokeCaps:!helpers!private! !
subjectClass!constants!private! !
testBaseCap!public!unit tests! !
testBaseInset!public!unit tests! !
testComparing!public!unit tests! !
testEndCap!public!unit tests! !
testPrintString!public!unit tests! !
testStartCap!public!unit tests! !
testStlUpgradeFromD7!public!unit tests! !
testStrokeCaps!public!unit tests! !
testStrokePath!public!unit tests! !
verifyEqualToModel:!helpers!private! !
!

