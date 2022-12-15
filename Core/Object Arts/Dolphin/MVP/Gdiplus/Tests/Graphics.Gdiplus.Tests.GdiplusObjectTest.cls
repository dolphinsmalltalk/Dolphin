"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusTest subclass: #'Graphics.Gdiplus.Tests.GdiplusObjectTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GdiplusObjectTest guid: (Core.GUID fromString: '{582d7c90-0a71-4d9b-a82f-d37e0ab53192}')!
Graphics.Gdiplus.Tests.GdiplusObjectTest isNonInstantiable: true!
Graphics.Gdiplus.Tests.GdiplusObjectTest comment: ''!
!Graphics.Gdiplus.Tests.GdiplusObjectTest methodsFor!

assertClonedValid
	| cloned |
	cloned := model clone.
	self assert: cloned equals: model.
	model isPersistent ifTrue: [self deny: cloned initializer identicalTo: model initializer].
	self verifyEqualToModel: cloned.
	^cloned!

assertPersistedValid
	| recreated |
	self assert: model isPersistent.
	recreated := Object fromBinaryStoreBytes: model binaryStoreBytes.
	"Asking recreated for its handle should find any errors"
	self assert: recreated handle class identicalTo: External.Handle.
	self deny: recreated initializer identicalTo: model initializer.
	self verifyEqualToModel: recreated.
	^recreated!

createFullSubject
	^self createCanonicalSubject!

freeModel
	model ifNil: [^self].
	model free.
	model := nil!

getSamplePen
	^Pen red!

tearDown
	self freeModel.
	super tearDown!

testClone
	model := self createFullSubject.
	self assertClonedValid free!

testComparing
	| model2 |
	model ifNil: [self newCanonicalModel].
	self verifyEqualToModel: model.
	model2 := self createCanonicalSubject.
	self verifyEqualToModel: model2.
	model2 free!

testIsPersistent
	self newCanonicalModel.
	self assert: model isPersistent!

testStbRoundTrip
	model := self createFullSubject.
	model isPersistent
		ifTrue: [self assertPersistedValid free]
		ifFalse: 
			[self
				should: [model binaryStoreBytes]
				raise: Error
				matching: [:ex | ex description = ('Cannot #stbSaveOn: ' , model printString)]]!

verifyEqualToModel: aGdiplusObject
	self assert: aGdiplusObject equals: model.
	self assert: aGdiplusObject hash equals: model hash.
	self assert: model equals: aGdiplusObject.
	self assert: (model == aGdiplusObject or: [aGdiplusObject handle ~= model handle])! !
!Graphics.Gdiplus.Tests.GdiplusObjectTest categoriesForMethods!
assertClonedValid!asserting!private! !
assertPersistedValid!asserting!private! !
createFullSubject!private!running! !
freeModel!helpers!private!Running! !
getSamplePen!accessing!public! !
tearDown!public!running! !
testClone!public!unit tests! !
testComparing!public!unit tests! !
testIsPersistent!public!unit tests! !
testStbRoundTrip!public!unit tests! !
verifyEqualToModel:!asserting!private! !
!

