"Filed out from Dolphin Smalltalk 7"!

ODBBTreeIterator subclass: #ODBGcBTreeIterator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBGcBTreeIterator guid: (GUID fromString: '{8162ee24-0fb8-11d4-b091-000000000000}')!
ODBGcBTreeIterator comment: ''!
!ODBGcBTreeIterator categoriesForClass!No category! !
!ODBGcBTreeIterator methodsFor!

insertValue: aValue lockID: lockID 
	"Private - Insert aValue and lockID at currentKey. 
	Precondition: search path to currentKey is loaded and 
	currentKey does not exists."

	| page pageSplit |
	page := searchPath at: searchPathHeight.
	pageSplit := page 
				insertKey: currentKey
				value: aValue
				lockID: lockID.
	pageSplit isNil 
		ifTrue: [currentKeyExists := true]
		ifFalse: 
			[
			[searchPathHeight > 1 
				ifTrue: 
					[(pageSplit at: 1)
						position: page position;
						store.
					(pageSplit at: 3)
						position: stream setToEnd;
						store]
				ifFalse: 
					[(pageSplit at: 1)
						position: stream setToEnd;
						store.
					(pageSplit at: 3)
						position: stream position;
						store].
			searchPath at: searchPathHeight put: nil.
			searchPathHeight := searchPathHeight - 1.
			searchPathHeight == 0 
				ifFalse: [page := searchPath at: searchPathHeight]
				ifTrue: 
					[page := self pageClass 
								createOnFile: self
								position: rootPagePosition
								keyLength: keyLength
								valueLength: valueLength].
			pageSplit := page insertPageSplit: pageSplit.
			pageSplit isNil] 
					whileFalse: [].
			self clearSearchPath].
	page store!

pageClass
	"Private - Answer B-Tree page class."

	^ODBGcBTreePage!

put: aValue 
	self updateCurrentKey.
	currentKeyExists 
		ifTrue: 
			[(self lastPage)
				value: aValue;
				store]
		ifFalse: [self insertValue: aValue lockID: 0]! !
!ODBGcBTreeIterator categoriesFor: #insertValue:lockID:!private! !
!ODBGcBTreeIterator categoriesFor: #pageClass!public! !
!ODBGcBTreeIterator categoriesFor: #put:!public! !

