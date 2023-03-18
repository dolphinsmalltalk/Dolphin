"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest
	subclass: #'Graphics.Gdiplus.Tests.FontFamilyTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.FontFamilyTest guid: (Core.GUID fromString: '{9858b020-07a1-4aad-9b28-35376d1d4f62}')!
Graphics.Gdiplus.Tests.FontFamilyTest comment: ''!
!Graphics.Gdiplus.Tests.FontFamilyTest methodsFor!

createCanonicalSubject
	^FontFamily name: 'Cambria'!

subjectClass
	^FontFamily!

testGenericMonospace
	| rehydrated |
	model := FontFamily genericMonospace.
	self verifyGenericMonospace: model.
	rehydrated := self assertPersistedValid.
	self verifyGenericMonospace: rehydrated.
	rehydrated free.
	self assertClonedValid free!

testGenericSansSerif
	| rehydrated |
	model := FontFamily genericSansSerif.
	self verifyGenericSansSerif: model.
	rehydrated := self assertPersistedValid.
	self verifyGenericSansSerif: rehydrated.
	rehydrated free!

testGenericSerif
	| rehydrated |
	model := FontFamily genericSerif.
	self verifyGenericSerif: model.
	rehydrated := self assertPersistedValid.
	self verifyGenericSerif: rehydrated.
	rehydrated free!

testIsStyleAvailable
	model := FontFamily genericMonospace.
	self assert: (model isStyleAvailable: Gdiplus.FontStyleRegular).
	self assert: (model isStyleAvailable: Gdiplus.FontStyleBold).
	self assert: (model isStyleAvailable: Gdiplus.FontStyleItalic).
	self assert: (model isStyleAvailable: Gdiplus.FontStyleBoldItalic)!

verifyEqualToModel: aFontFamily
	self assert: aFontFamily equals: model.
	self assert: aFontFamily hash equals: model hash.
	self assert: model equals: aFontFamily.
	self assert: aFontFamily name equals: model name.
	self assert: aFontFamily emHeight equals: model emHeight.
	self assert: aFontFamily lineSpacing equals: model lineSpacing.
	self assert: aFontFamily cellAscent equals: model cellAscent.
	self assert: aFontFamily cellDescent equals: model cellDescent!

verifyGenericMonospace: aFontFamily
	self assert: aFontFamily name equals: 'Courier New'.
	self assert: aFontFamily emHeight equals: 2048.
	self assert: aFontFamily lineSpacing equals: 2320.
	self assert: aFontFamily cellAscent equals: 1705.
	self assert: aFontFamily cellDescent equals: 615!

verifyGenericSansSerif: aFontFamily
	self assert: aFontFamily name equals: 'Microsoft Sans Serif'.
	self assert: aFontFamily emHeight equals: 2048.
	self assert: aFontFamily lineSpacing equals: 2318.
	self assert: aFontFamily cellAscent equals: 1888.
	self assert: aFontFamily cellDescent equals: 430!

verifyGenericSerif: aFontFamily
	self assert: aFontFamily name equals: 'Times New Roman'.
	self assert: aFontFamily emHeight equals: 2048.
	self assert: aFontFamily lineSpacing equals: 2355.
	self assert: aFontFamily cellAscent equals: 1825.
	self assert: aFontFamily cellDescent equals: 443! !
!Graphics.Gdiplus.Tests.FontFamilyTest categoriesForMethods!
createCanonicalSubject!helpers!private! !
subjectClass!constants!private! !
testGenericMonospace!public!unit tests! !
testGenericSansSerif!public!unit tests! !
testGenericSerif!public!unit tests! !
testIsStyleAvailable!public!unit tests! !
verifyEqualToModel:!helpers!private! !
verifyGenericMonospace:!helpers!private! !
verifyGenericSansSerif:!helpers!private! !
verifyGenericSerif:!helpers!private! !
!

