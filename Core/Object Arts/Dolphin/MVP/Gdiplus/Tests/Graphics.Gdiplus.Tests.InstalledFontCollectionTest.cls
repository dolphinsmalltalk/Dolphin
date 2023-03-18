"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.FontCollectionTest
	subclass: #'Graphics.Gdiplus.Tests.InstalledFontCollectionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.InstalledFontCollectionTest guid: (Core.GUID fromString: '{154f4bf0-a043-403f-91b5-e1e132279d81}')!
Graphics.Gdiplus.Tests.InstalledFontCollectionTest comment: ''!
!Graphics.Gdiplus.Tests.InstalledFontCollectionTest methodsFor!

assertClonedValid
	| cloned |
	cloned := model clone.
	self assert: cloned equals: model.
	self assert: cloned initializer identicalTo: model initializer.
	self verifyEqualToModel: cloned!

subjectClass
	^InstalledFontCollection!

testFamilies
	| families |
	families := FontCollection installedFamilies.
	#('Segoe UI' 'Courier New' 'Times New Roman' 'Microsoft Sans Serif' 'Arial')
		do: [:each | self assert: (families at: each) equals: (FontFamily name: each)]!

verifyEqualToModel: anInstalledFontCollection
	self assert: anInstalledFontCollection equals: model.
	self assert: anInstalledFontCollection hash equals: model hash.
	self assert: model equals: anInstalledFontCollection.
	self assert: anInstalledFontCollection handle equals: model handle! !
!Graphics.Gdiplus.Tests.InstalledFontCollectionTest categoriesForMethods!
assertClonedValid!public! !
subjectClass!constants!private! !
testFamilies!public!unit tests! !
verifyEqualToModel:!public! !
!

