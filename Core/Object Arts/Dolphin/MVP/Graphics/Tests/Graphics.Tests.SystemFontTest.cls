"Filed out from Dolphin Smalltalk"!

Graphics.Tests.AbstractFontTest
	subclass: #'Graphics.Tests.SystemFontTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.SystemFontTest guid: (Core.GUID fromString: '{7464ed86-a2f8-4db4-aafa-9e785a01bec3}')!

Graphics.Tests.SystemFontTest isNonInstantiable: true!

Graphics.Tests.SystemFontTest comment: ''!

!Graphics.Tests.SystemFontTest methodsFor!

testComparing
	| subject comperand |
	subject := self canonicalSubject.
	comperand := subject copy.
	self assert: comperand class identicalTo: Font.
	self assert: comperand equals: subject.
	self assert: subject equals: comperand.
	self assert: subject hash equals: comperand hash.
	comperand := (Font name: 'Arial' pointSize: 12) beBold.
	self deny: subject equals: comperand.
	self deny: comperand equals: subject.
	subject := Font default.
	comperand := subject atDpi: subject dpi * 1.5.
	self assert: subject equals: comperand.
	self assert: comperand equals: subject.
	self assert: subject hash equals: comperand hash.
	comperand := comperand copy.
	self assert: subject equals: comperand.
	self assert: comperand equals: subject.
	self assert: subject hash equals: comperand hash!

testCopy
	| subject copy |
	subject := self canonicalSubject.
	copy := subject copy.
	self assert: (copy logFont equalExcludingSize: subject logFont).
	self deny: copy logFont identicalTo: subject logFont.
	self assert: copy class identicalTo: Font.
	self deny: copy handle equals: subject handle.
	self assert: copy isRealized.
	copy free! !

!Graphics.Tests.SystemFontTest categoriesForMethods!
testComparing!public!unit tests! !
testCopy!public!unit tests! !
!

