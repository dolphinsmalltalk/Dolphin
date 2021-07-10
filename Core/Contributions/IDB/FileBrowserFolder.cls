"Filed out from Dolphin Smalltalk"!

FileBrowserAbstract subclass: #FileBrowserFolder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileBrowserFolder guid: (GUID fromString: '{782ed51b-5423-11d3-998b-bca753d3b065}')!
FileBrowserFolder comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!FileBrowserFolder categoriesForClass!IDB Goodies! !
!FileBrowserFolder methodsFor!

children
	"Answers the children (folders) of the receiver"

	children isNil ifTrue: [children := self getChildren].
	^children!

files
	"Answers the children (files) of the receiver sorted in alpha order"

	| files |
	files := (File find: self searchPath) select: [:each | (each dwFileAttributes bitAnd: 16) = 0].
	files := files collect: [:each | FileBrowserFile name: each cFileName parent: self].
	^files asSortedCollection: [:a :b | a name <= b name]!

getChildren
	"Answers the cildren (folders) of the receiver sorted in alpha order"

	| folders |
	folders := (File find: self searchPath) select: [:each | (each dwFileAttributes bitAnd: 16) ~= 0].
	folders := folders reject: [:each | each cFileName first = $.].
	folders := folders collect: [:each | FileBrowserFolder name: each fileName parent: self].
	^folders asSortedCollection: [:a :b | a name <= b name]!

searchPath
	"Answers the search path, the path appended with *.*, for the receiver"

	^File 
		composePath: self path
		stem: '*'
		extension: '*'! !
!FileBrowserFolder categoriesForMethods!
children!accessing!public! !
files!accessing!public! !
getChildren!accessing!public! !
searchPath!accessing!public! !
!

