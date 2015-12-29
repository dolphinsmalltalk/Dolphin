"Filed out from Dolphin Smalltalk X6"!

Object subclass: #NewsArchive
	instanceVariableNames: 'articles'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NewsArchive guid: (GUID fromString: '{06451A5E-4CD6-4F45-A972-72EF4F8F91C0}')!
NewsArchive comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!NewsArchive categoriesForClass!IDB Goodies! !
!NewsArchive methodsFor!

allSelected
	^self articles select: [:each | each isSelected]!

articles
	articles isNil ifTrue: [Cursor wait showWhile: [self loadArticles]].
	^articles!

articlesInConversation: aNewsArchiveArticle 
	^self articles select: [:each | each isInConversation: aNewsArchiveArticle]!

copySelectedTo: aStream 
	self allSelected do: [:each | each copyTo: aStream]!

countArticles
	^self articles size!

hasAnySelected
	^self articles anySatisfy: [:each | each isSelected]!

loadArticles
	| filenames |
	articles := OrderedCollection new.
	filenames := OrderedCollection new.
	
	[File for: (File composePath: NewsArchiveBrowser archiveFolder subPath: '*.txt')
		do: [:each | filenames add: (File composePath: NewsArchiveBrowser archiveFolder subPath: each fileName)]] 
			on: Win32Error
			do: [:e | ^MessageBox warning: 'The specified folder does not exist (see Tools/Options)'].
	self trigger: #percentageLoaded: with: 0.
	filenames asSortedCollection keysAndValuesDo: 
			[:index :each | 
			self readArticlesFromFile: each.	"Transcript nextPutAll: each; tab; print: articles size; cr."
			self trigger: #percentageLoaded: with: index / filenames size * 100].
	self trigger: #percentageLoaded: with: 0!

readArticleIn: aString from: startInteger to: stopInteger skip: skipInteger 
	| start |
	start := startInteger = 1 ifTrue: [1] ifFalse: [startInteger + skipInteger].
	^NewsArchiveArticle forString: (aString copyFrom: start to: stopInteger)!

readArticlesFromFile: aString 
	| stream |
	stream := FileStream read: aString.
	[self readArticlesFromStream: stream] ensure: [stream close]!

readArticlesFromStream: aStream 
	| text start delimiter |
	text := aStream contents.
	delimiter := ##(String lineDelimiter , '----------' , String lineDelimiter , 'From: ').
	start := 1.
	[start < text size] whileTrue: 
			[| stop |
			stop := text indexOfSubCollection: delimiter startingAt: start + 1.
			stop = 0 ifTrue: [stop := text size + 1].
			articles add: (self 
						readArticleIn: text
						from: start
						to: stop - 1
						skip: delimiter size - 6).	"From: "
			start := stop]! !
!NewsArchive categoriesFor: #allSelected!accessing!public! !
!NewsArchive categoriesFor: #articles!accessing!public! !
!NewsArchive categoriesFor: #articlesInConversation:!public!selection! !
!NewsArchive categoriesFor: #copySelectedTo:!operations!public! !
!NewsArchive categoriesFor: #countArticles!accessing!public! !
!NewsArchive categoriesFor: #hasAnySelected!public!testing! !
!NewsArchive categoriesFor: #loadArticles!operations!public! !
!NewsArchive categoriesFor: #readArticleIn:from:to:skip:!operations!public! !
!NewsArchive categoriesFor: #readArticlesFromFile:!operations!public! !
!NewsArchive categoriesFor: #readArticlesFromStream:!operations!public! !

