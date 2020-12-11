"Filed out from Dolphin Smalltalk 7"!

UI.Tests.PresenterTest subclass: #'UI.Tests.DifferencesPresenterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.DifferencesPresenterTest guid: (Core.GUID fromString: '{ff71a471-024e-4959-8607-399cdf4faf2a}')!
UI.Tests.DifferencesPresenterTest comment: ''!
!UI.Tests.DifferencesPresenterTest categoriesForClass!Unclassified! !
!UI.Tests.DifferencesPresenterTest methodsFor!

classToTest
	^DifferencesPresenter!

testItemsFrom
	| str items |
	str := 'foo bar
baz'.
	presenter comparisonMode: #character.
	items := presenter itemsFrom: str.
	self assert: (items first: 3) asArray equals: #('f' 'o' 'o').
	items do: [:each | self assert: each size equals: 1].
	""
	presenter comparisonMode: #word.
	items := presenter itemsFrom: str.
	self assert: items asArray equals: #('foo' 'bar' 'baz').
	""
	presenter comparisonMode: #line.
	items := presenter itemsFrom: str.
	self assert: items asArray equals: #('foo bar' 'baz')! !
!UI.Tests.DifferencesPresenterTest categoriesFor: #classToTest!helpers!private! !
!UI.Tests.DifferencesPresenterTest categoriesFor: #testItemsFrom!public! !

