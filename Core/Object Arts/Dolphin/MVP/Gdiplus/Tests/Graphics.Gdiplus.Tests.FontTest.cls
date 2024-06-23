"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest
	subclass: #'Graphics.Gdiplus.Tests.FontTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.FontTest guid: (Core.GUID fromString: '{9858b020-07a1-4aad-9b28-35376d1d4f62}')!

Graphics.Gdiplus.Tests.FontTest comment: ''!

!Graphics.Gdiplus.Tests.FontTest methodsFor!

createCanonicalSubject
	^Font
		name: 'Cambria'
		emSize: 16
		style: Gdiplus.FontStyleBoldItalic | Gdiplus.FontStyleUnderline
		unit: UnitPoint!

subjectClass
	^Font!

testGenericMonospace
	| rehydrated |
	model := Font genericMonospace.
	self verifyGenericMonospace: model.
	rehydrated := self assertPersistedValid.
	self assert: rehydrated equals: model.
	self assert: rehydrated hash equals: model hash.
	self verifyGenericMonospace: rehydrated.
	rehydrated free.
	self assertClonedValid free!

testGenericSansSerif
	| rehydrated |
	model := Font genericSansSerif.
	self verifyGenericSansSerif: model.
	rehydrated := self assertPersistedValid.
	self assert: rehydrated equals: model.
	self assert: rehydrated hash equals: model hash.
	self verifyGenericSansSerif: rehydrated.
	rehydrated free!

testGenericSerif
	| rehydrated |
	model := Font genericSerif.
	self verifyGenericSerif: model.
	rehydrated := self assertPersistedValid.
	self assert: rehydrated equals: model.
	self assert: rehydrated hash equals: model hash.
	self verifyGenericSerif: rehydrated.
	rehydrated free!

verifyEqualToModel: aFont
	super verifyEqualToModel: aFont.
	self assert: aFont family equals: model family.
	self assert: aFont name equals: model name.
	self assert: aFont cellHeight equals: model cellHeight.
	self assert: aFont emSize equals: model emSize.
	self assert: aFont height equals: model height.
	self assert: aFont style equals: model style.
	self assert: aFont unit equals: model unit!

verifyGenericMonospace: aFont
	self assert: aFont unit equals: UnitPoint.
	self assert: aFont style equals: FontStyleRegular.
	self assert: aFont name equals: 'Courier New'.
	self assert: aFont family equals: FontFamily genericMonospace!

verifyGenericSansSerif: aFont
	self assert: aFont unit equals: UnitPoint.
	self assert: aFont style equals: FontStyleRegular.
	self assert: aFont name equals: 'Microsoft Sans Serif'.
	self assert: aFont family equals: FontFamily genericSansSerif!

verifyGenericSerif: aFont
	self assert: aFont unit equals: UnitPoint.
	self assert: aFont style equals: FontStyleRegular.
	self assert: aFont name equals: 'Times New Roman'.
	self assert: aFont family equals: FontFamily genericSerif! !

!Graphics.Gdiplus.Tests.FontTest categoriesForMethods!
createCanonicalSubject!helpers!private! !
subjectClass!constants!private! !
testGenericMonospace!public!unit tests! !
testGenericSansSerif!public!unit tests! !
testGenericSerif!public!unit tests! !
verifyEqualToModel:!helpers!private! !
verifyGenericMonospace:!helpers!private! !
verifyGenericSansSerif:!helpers!private! !
verifyGenericSerif:!helpers!private! !
!

