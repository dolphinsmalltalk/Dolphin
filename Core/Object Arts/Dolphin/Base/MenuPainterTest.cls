"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #MenuPainterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MenuPainterTest guid: (GUID fromString: '{3118e3fb-ce52-409f-9738-275074c5c9a6}')!
MenuPainterTest comment: ''!
!MenuPainterTest categoriesForClass!Unclassified! !
!MenuPainterTest methodsFor!

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
!MenuPainterTest categoriesForMethods!
subjectClass!constants!private! !
testSplitMenuText!public! !
!

