"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.FontCollectionTest subclass: #'Graphics.Gdiplus.Tests.PrivateFontCollectionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.PrivateFontCollectionTest guid: (Core.GUID fromString: '{10aa387a-cbce-4795-9c99-556a0ec7548e}')!
Graphics.Gdiplus.Tests.PrivateFontCollectionTest comment: ''!
!Graphics.Gdiplus.Tests.PrivateFontCollectionTest methodsFor!

subjectClass
	^PrivateFontCollection!

testClone
	model := self createFullSubject.
	self
		should: [model clone]
		raise: Error
		matching: [:ex | ex description = 'Gdiplus.PrivateFontCollectionInitializer class should not implement #cloneHandle:']!

testFamilies
	| families |
	families := FontCollection installedFamilies.
	#('Segoe UI' 'Courier New' 'Times New Roman' 'Microsoft Sans Serif' 'Arial')
		do: [:each | self assert: (families at: each) equals: (FontFamily name: each)]!

testIsPersistent
	self newCanonicalModel.
	self deny: model isPersistent! !
!Graphics.Gdiplus.Tests.PrivateFontCollectionTest categoriesForMethods!
subjectClass!constants!private! !
testClone!public! !
testFamilies!public!unit tests! !
testIsPersistent!public! !
!

