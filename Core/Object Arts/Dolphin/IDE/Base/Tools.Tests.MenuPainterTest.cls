"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.MenuPainterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.MenuPainterTest guid: (Core.GUID fromString: '{3118e3fb-ce52-409f-9738-275074c5c9a6}')!
Tools.Tests.MenuPainterTest comment: ''!
!Tools.Tests.MenuPainterTest categoriesForClass!Unclassified! !
!Tools.Tests.MenuPainterTest methodsFor!

subjectClass
	^PopupMenuPainter!

testSplitMenuText
	| subject |
	subject := self subjectClass new.
	self assert: (subject splitMenuText: '&') equals: #('&' '' '').
	self assert: (subject splitMenuText: '&&') equals: #('&&' '' '').
	self assert: (subject splitMenuText: '&&a') equals: #('&&a' '' '').
	self assert: (subject splitMenuText: '&a') equals: #('' 'a' '').
	self assert: (subject splitMenuText: '&a&&') equals: #('' 'a' '&&').
	self assert: (subject splitMenuText: '&&&a&&') equals: #('&&' 'a' '&&').
	self assert: (subject splitMenuText: '&ab') equals: #('' 'a' 'b').
	self assert: (subject splitMenuText: 'c&ab') equals: #('c' 'a' 'b').
	self assert: (subject splitMenuText: 'c&&ab') equals: #('c&&ab' '' '').
	self assert: (subject splitMenuText: '🐬&&&🍺🐬') equals: #('🐬&&' '🍺' '🐬').
	self assert: (subject splitMenuText: '') equals: #('' '' '')! !
!Tools.Tests.MenuPainterTest categoriesFor: #subjectClass!constants!private! !
!Tools.Tests.MenuPainterTest categoriesFor: #testSplitMenuText!public! !

