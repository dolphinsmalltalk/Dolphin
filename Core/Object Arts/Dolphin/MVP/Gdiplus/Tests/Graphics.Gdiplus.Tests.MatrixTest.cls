"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest
	subclass: #'Graphics.Gdiplus.Tests.MatrixTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.MatrixTest guid: (Core.GUID fromString: '{3d97e3f4-09ba-4a98-bd9e-4e8546ee6c75}')!
Graphics.Gdiplus.Tests.MatrixTest comment: ''!
!Graphics.Gdiplus.Tests.MatrixTest methodsFor!

subjectClass
	^Matrix!

testClone
	| clone |
	model := Matrix new.
	clone := model clone.
	self deny: clone identicalTo: model.
	self assert: clone isIdentity.
	self assert: clone equals: model.
	self deny: clone initializer identicalTo: model initializer.
	clone free.
	model shear: 20 @ 30.
	clone := model clone.
	self deny: clone identicalTo: model.
	self deny: clone isIdentity.
	self assert: clone equals: model.
	self deny: clone initializer identicalTo: model initializer.
	self assert: model elements equals: #(1 30 20 1 0 0)!

testCloseTo
	| matrix2 |
	model := Matrix identity.
	model
		translate: 15 @ 25;
		rotate: 45.
	matrix2 := Gdiplus.Matrix fromArray: #(0.7071067 0.7071067 -0.7071067 0.7071067 15.0 25.0).
	self deny: matrix2 equals: model.
	self assert: (model closeTo: matrix2).
	self assert: (matrix2 closeTo: model)!

testComparing
	| model2 elements array |
	model := Matrix fromArray: #(1 2 3 4 5 6).
	self assert: model equals: model.
	self assert: model hash equals: model hash.
	model2 := Matrix fromArray: #(1 2 3 4 5 6).
	self assert: model2 equals: model.
	self assert: model2 hash equals: model hash.
	model2 rotate: 30.
	self deny: model2 equals: model.
	self deny: model2 hash equals: model hash.
	model rotate: 30.
	self assert: model2 equals: model.
	self assert: model2 hash equals: model hash.
	"Test that a required behaviour of ExternalArray is maintained"
	elements := model2 elements.
	array := elements asArray.
	self assert: elements equals: array.
	self assert: array equals: elements.
	self assert: elements hash equals: array hash.
	model2 free!

testDisplayString
	| expr |
	model := Matrix identity.
	self assert: model displayString equals: '(1.0, 0.0, 0.0, 1.0, 0.0, 0.0)'.
	model
		translate: 15 @ 25;
		rotate: 45.
	self assert: model displayString equals: '(0.707107, 0.707107, -0.707107, 0.707107, 15.0, 25.0)'!

testFromArrayOfNumbers
	model := Gdiplus.Matrix fromArray: {1 / 2. 10s. 20s. 3 / 4. 150. 200}.
	self assert: model equals: (Gdiplus.Matrix fromArray: #(0.5 10.0 20.0 0.75 150.0 200.0)).
	self assert: model printString
		equals: '(Gdiplus.Matrix fromArray: #(0.5 10.0 20.0 0.75 150.0 200.0))'!

testIdentity
	| clone |
	model := Matrix new.
	self assert: model isIdentity.
	self assert: model basicHandle isNil.
	self assert: model printString equals: 'Gdiplus.Matrix identity'.
	self assert: model basicHandle isNil.
	self assertNotNil: model handle.
	self assert: model isIdentity.
	self assert: model printString equals: 'Gdiplus.Matrix identity'.
	model scale: 1 @ 2.
	self deny: model isIdentity.
	model elements: #(1 0 0 1 0 0).
	self assert: model isIdentity.
	clone := model clone.
	self assert: clone isIdentity.
	clone free!

testIsSelfEvaluating
	self newCanonicalModel.
	self assert: model isSelfEvaluating.
	self verifyEqualToModel: (Compiler evaluate: model printString).
	model
		translate: 15 @ 25;
		rotate: 45.
	self assert: model isSelfEvaluating.
	self assert: (Compiler evaluate: model printString) equals: model!

testPrintString
	| expr |
	model := Matrix identity.
	self assert: model printString equals: 'Gdiplus.Matrix identity'.
	model
		translate: 15 @ 25;
		rotate: 45.
	expr := model printString.
	self assert: expr
		equals: '(Gdiplus.Matrix fromArray: #(0.707106769 0.707106709 -0.707106709 0.707106769 15.0 25.0))'.
	self assert: (Compiler evaluate: expr) equals: model!

testRotate
	model := Matrix identity.
	model rotate: 90.
	"GdipMatrixEquals seems to use too much precision"
	self assert: (model closeTo: (Matrix fromArray: #(0 1 -1 0 0 0))).
	model rotate: -90.
	self assert: model isIdentity!

testScale
	model := Matrix identity.
	model scale: 2 @ 4.
	self deny: model isIdentity.
	self assert: model equals: (Matrix fromArray: #(2 0 0 4 0 0)).
	model scale: (1 / 2) @ (1 / 4).
	self assert: model isIdentity!

testShear
	model := Matrix identity.
	model shear: (3 / 4) @ (1 / 4).
	self assert: model equals: (Matrix fromArray: #(1 0.25 0.75 1 0 0))!

testStbRoundTrip
	| reconstituted |
	model := Matrix new.
	model handle.
	reconstituted := Object fromBinaryStoreBytes: model binaryStoreBytes.
	self assert: reconstituted equals: model.
	self assert: reconstituted isIdentity.
	reconstituted free.
	model
		translate: 3 @ 4;
		shear: 15 @ 20;
		rotate: 30.
	reconstituted := Object fromBinaryStoreBytes: model binaryStoreBytes.
	self assert: reconstituted equals: model.
	reconstituted free.
	reconstituted := Object fromBinaryStoreBytes: model binaryStoreBytes.
	self assert: reconstituted equals: model.
	reconstituted free!

testTranslate
	| bool |
	model := Matrix identity.
	model translate: 2 @ 3.
	self assert: model equals: (Matrix fromArray: #(1 0 0 1 2 3)).
	model translate: -2 @ -3.
	"The result should be an identity matrix, but the GdipIsMatrixIdentity call says it isn't. It is arguably a GDI+ bug that a precisely representable reverse translation should result in negative zero offsets AND that negative zero offsets should disqualify the value from being an identity matrix (which numerically they do not). I think the bug is really that GdipIsMatrixIdentity does not consider negative zero equivalent to zero."
	bool := UInt32Bytes new.
	Gdip gdipIsMatrixIdentity: model asParameter result: bool.
	self assert: model isIdentity equals: bool asBoolean! !
!Graphics.Gdiplus.Tests.MatrixTest categoriesForMethods!
subjectClass!constants!private! !
testClone!public!unit tests! !
testCloseTo!public!unit tests! !
testComparing!public!unit tests! !
testDisplayString!public!unit tests! !
testFromArrayOfNumbers!public!unit tests! !
testIdentity!public!unit tests! !
testIsSelfEvaluating!public!unit tests! !
testPrintString!public!unit tests! !
testRotate!public!unit tests! !
testScale!public!unit tests! !
testShear!public!unit tests! !
testStbRoundTrip!public!unit tests! !
testTranslate!public!unit tests! !
!

