"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Graphics.Tests.StockFontTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.StockFontTest guid: (Core.GUID fromString: '{8ade05f3-900f-4abf-8af5-897d4843196b}')!

Graphics.Tests.StockFontTest comment: ''!

!Graphics.Tests.StockFontTest methodsFor!

testCopy
	| subject copy |
	subject := Font system.
	copy := subject copy.
	self assert: copy logFont equals: subject logFont.
	self deny: copy logFont identicalTo: subject logFont.
	self assert: copy class identicalTo: Font.
	self deny: copy handle equals: subject handle.
	subject free.
	self assert: copy isRealized.
	copy free!

testSystem
	| subject |
	subject := Font system.
	self assert: subject isKindOf: StockFont.
	self assert: subject name equals: 'System'.
	self assert: subject pointSize equals: 12.
	self deny: subject isItalic.
	self deny: subject isUnderlined.
	subject free! !

!Graphics.Tests.StockFontTest categoriesForMethods!
testCopy!public! !
testSystem!public! !
!

