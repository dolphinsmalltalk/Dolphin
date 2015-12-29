"Filed out from Dolphin Smalltalk X6.1"!

WikiDocObject subclass: #WikiDocTocNode
	instanceVariableNames: 'title pageName pagePosition children parentPageName parentNode application isLeafPage nodeIndex nodeIcon languageName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocTocNode guid: (GUID fromString: '{02DF080E-29D8-41BC-86B2-2CCF66968B17}')!
WikiDocTocNode comment: ''!
!WikiDocTocNode categoriesForClass!Unclassified! !
!WikiDocTocNode methodsFor!

addChildNode: aWikiDocTocNode 
	children isNil ifTrue: [children := SortedCollection sortBlock: self].
	children add: aWikiDocTocNode.
	aWikiDocTocNode parentNode: self!

application: aWikiDocApplication 
	application := aWikiDocApplication!

children
	^children!

forEachChildDo: aBlock 
	children isNil 
		ifFalse: 
			[children do: 
					[:eachChildNode | 
					aBlock value: eachChildNode.
					eachChildNode forEachChildDo: aBlock]]!

getLastSubNode
	^children isNilOrEmpty ifTrue: [self] ifFalse: [children last getLastSubNode]!

getNextNode
	^children isNilOrEmpty 
		ifFalse: [children first]
		ifTrue: 
			[parentNode isNil 
				ifFalse: [parentNode getNextNodeFrom: self]
				ifTrue: [application getNextTocNodeFrom: self language: languageName]]!

getNextNodeFrom: childNode 
	| index |
	children isNilOrEmpty ifTrue: [^nil].
	index := children indexOf: childNode.
	^index < children size 
		ifTrue: [children at: index + 1]
		ifFalse: 
			[parentNode isNil 
				ifFalse: [parentNode getNextNodeFrom: self]
				ifTrue: [application getNextTocNodeFrom: self language: languageName]]!

getPreviousNode
	^parentNode isNil 
		ifFalse: [parentNode getPreviousNodeFrom: self]
		ifTrue: [application getPreviousTocNodeFrom: self language: languageName]!

getPreviousNodeFrom: childNode 
	| index |
	^(children isNilOrEmpty or: [(index := children indexOf: childNode) < 2]) 
		ifTrue: [self]
		ifFalse: [(children at: index - 1) getLastSubNode]!

isEqualOrUnderNode: aWikiDocTocNode 
	self == aWikiDocTocNode ifTrue: [^true].
	self parentNode isNil ifTrue: [^false].
	^self parentNode isEqualOrUnderNode: aWikiDocTocNode!

isLeafPage
	^isLeafPage!

isLeafPage: anObject
	isLeafPage := anObject!

isLeafPageNode
	^children isNilOrEmpty and: [isLeafPage = true]!

languageName
	^languageName!

languageName: anObject
	languageName := anObject!

nodeIcon
	^nodeIcon!

nodeIcon: anObject
	nodeIcon := anObject!

nodeIndex
	^nodeIndex!

nodeIndex: anObject
	nodeIndex := anObject!

pageName
	^pageName!

pageName: anObject
	pageName := anObject!

pagePosition
	^pagePosition!

pagePosition: anObject
	pagePosition := anObject!

parentNode
	^parentNode!

parentNode: anObject
	parentNode := anObject!

parentPageName
	^parentPageName!

parentPageName: anObject
	parentPageName := anObject!

title
	^title!

title: anObject
	title := anObject!

value: a value: b 
	^a pagePosition < b pagePosition 
		or: [a pagePosition = b pagePosition and: [a title isAlphabeticalyBefore: b title]]! !
!WikiDocTocNode categoriesFor: #addChildNode:!accessing!private! !
!WikiDocTocNode categoriesFor: #application:!accessing!public! !
!WikiDocTocNode categoriesFor: #children!accessing!private! !
!WikiDocTocNode categoriesFor: #forEachChildDo:!accessing!private! !
!WikiDocTocNode categoriesFor: #getLastSubNode!accessing!public! !
!WikiDocTocNode categoriesFor: #getNextNode!accessing!public! !
!WikiDocTocNode categoriesFor: #getNextNodeFrom:!accessing!public! !
!WikiDocTocNode categoriesFor: #getPreviousNode!accessing!public! !
!WikiDocTocNode categoriesFor: #getPreviousNodeFrom:!accessing!public! !
!WikiDocTocNode categoriesFor: #isEqualOrUnderNode:!accessing!public! !
!WikiDocTocNode categoriesFor: #isLeafPage!accessing!private! !
!WikiDocTocNode categoriesFor: #isLeafPage:!accessing!private! !
!WikiDocTocNode categoriesFor: #isLeafPageNode!accessing!public! !
!WikiDocTocNode categoriesFor: #languageName!accessing!private! !
!WikiDocTocNode categoriesFor: #languageName:!accessing!private! !
!WikiDocTocNode categoriesFor: #nodeIcon!accessing!private! !
!WikiDocTocNode categoriesFor: #nodeIcon:!accessing!private! !
!WikiDocTocNode categoriesFor: #nodeIndex!accessing!private! !
!WikiDocTocNode categoriesFor: #nodeIndex:!accessing!private! !
!WikiDocTocNode categoriesFor: #pageName!accessing!private! !
!WikiDocTocNode categoriesFor: #pageName:!accessing!private! !
!WikiDocTocNode categoriesFor: #pagePosition!accessing!private! !
!WikiDocTocNode categoriesFor: #pagePosition:!accessing!private! !
!WikiDocTocNode categoriesFor: #parentNode!accessing!private! !
!WikiDocTocNode categoriesFor: #parentNode:!accessing!private! !
!WikiDocTocNode categoriesFor: #parentPageName!accessing!private! !
!WikiDocTocNode categoriesFor: #parentPageName:!accessing!private! !
!WikiDocTocNode categoriesFor: #title!accessing!private! !
!WikiDocTocNode categoriesFor: #title:!accessing!private! !
!WikiDocTocNode categoriesFor: #value:value:!accessing!private! !

