"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #DifferencesPresenterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DifferencesPresenterTest guid: (GUID fromString: '{ff71a471-024e-4959-8607-399cdf4faf2a}')!
DifferencesPresenterTest comment: ''!
!DifferencesPresenterTest categoriesForClass!Unclassified! !
!DifferencesPresenterTest methodsFor!

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
!DifferencesPresenterTest categoriesForMethods!
classToTest!helpers!private! !
testItemsFrom!public! !
!

