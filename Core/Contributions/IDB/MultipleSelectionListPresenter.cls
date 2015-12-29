"Filed out from Dolphin Smalltalk X6"!

ListPresenter subclass: #MultipleSelectionListPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultipleSelectionListPresenter guid: (GUID fromString: '{02BA912A-4818-4891-9166-4199AAF6C0A5}')!
MultipleSelectionListPresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!MultipleSelectionListPresenter categoriesForClass!IDB Goodies!MVP-Presenters! !
!MultipleSelectionListPresenter methodsFor!

hasSingleSelection
	^self hasSelection and: [self selection size = 1]!

singleSelection
	^self selection first!

singleSelection: anObject 
	self selection: (OrderedCollection with: anObject)!

singleSelectionIndex
	^self selectionByIndex first! !
!MultipleSelectionListPresenter categoriesFor: #hasSingleSelection!public!testing! !
!MultipleSelectionListPresenter categoriesFor: #singleSelection!public!selection! !
!MultipleSelectionListPresenter categoriesFor: #singleSelection:!public!selection! !
!MultipleSelectionListPresenter categoriesFor: #singleSelectionIndex!public!selection! !

