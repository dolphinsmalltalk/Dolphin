"Filed out from Dolphin Smalltalk"!

HistoryBrowser subclass: #ClassHistoryBrowser
	instanceVariableNames: 'class list'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassHistoryBrowser guid: (GUID fromString: '{30a97c72-065a-4c23-9f8e-dc13497f6eda}')!
ClassHistoryBrowser comment: 'Searches the sources and changes files to provide a change history for a class and opens a browser on the results.

Usage:
ClassHistoryBrowser showOnClass: aClass

All methods in the class are displayed in the browser with 4 fields.

- The selector used when the method was saved.
- The status of the method
	- original......The method is in the image and only present in the sources file
	- added......The method is in the image and only present in the changes file
	- modified......The method is in the image and present in both the sources and changes file
	- deleted......The method is not in the image but is present in either the sources or changes file
- The number of times the method appears in the sources file (always 0 or 1)
- The number of times the method appears in the changes file

Double clicking in the list will open a MethodHistoryBrowser on the selection.  Note that although the ClassHistoryBrowser
might show multiple versions of a method the MethodHistoryBrowser may display fewer versions.  This is because the 
MethodHistoryBrowser automatically removes duplicate consecutive entries.

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ClassHistoryBrowser categoriesForClass!IDB Goodies! !
!ClassHistoryBrowser methodsFor!

about
	"Display the about view"

	self 
		about: '
Class History Browser
for
Dolphin Smalltalk 6.x

Version 6b
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

browseHistory
	"Private - Open up a MethodHistoryBrowser on the selected method to allow
	a previous version to be located and, optionally restored"

	MethodHistoryBrowser showOnClass: class selector: (list selection at: 1)!

browseMethod
	"Private - Open up a ClassBrowser on the selected method"

	(class includesSelector: (list selection at: 1)) 
		ifTrue: [(class compiledMethodAt: (list selection at: 1)) browse]!

createComponents
	super createComponents.
	list := self add: ListPresenter new name: 'list'!

createSchematicWiring
	super createSchematicWiring.
	list 
		when: #actionPerformed
		send: #browseHistory
		to: self.
	(SmalltalkSystem current)
		when: #methodAdded:
			send: #onMethodAdded:
			to: self;
		when: #methodUpdated:
			send: #onMethodUpdated:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self!

historyStatusFor: aSymbol in: aCollection
	| inSources inChanges |
	(class includesSelector: aSymbol) ifFalse: [^'deleted'].
	inSources := aCollection anySatisfy: [:each | each isFromSources].
	inChanges := aCollection anySatisfy: [:each | each isFromChanges].
	inSources & inChanges ifTrue: [^'modified'].
	inSources not & inChanges ifTrue: [^'added'].
	^'original'!

onImageChanged: aCompiledMethod
	"Private - The image has changed. If it is a method in the class we are displaying
	then reinitialize to catch the changes"

	| currentSelection |
	aCompiledMethod methodClass == class ifFalse: [^self].
	list hasSelection ifTrue: [currentSelection := list selection at: 1].
	self setClass: class.
	currentSelection isNil ifTrue: [^self].
	list selection: (list list detect: [:each | (each at: 1) == currentSelection])!

onMethodAdded: aCompilationResult
	self onImageChanged: aCompilationResult method!

onMethodRemoved: aCompiledMethod 
	self onImageChanged: aCompiledMethod!

onMethodUpdated: aCompilationResult 
	self onImageChanged: aCompilationResult method!

onViewClosed
	"Private - This is needed to prevent events trying to access this shell
	after it is closed but before it is garbage collected"

	super onViewClosed.
	SmalltalkSystem current removeEventsTriggeredFor: self!

queryCommand: aCommandQuery 
	aCommandQuery command = #browseHistory 
		ifTrue: 
			[aCommandQuery isEnabled: list hasSelection.
			^true].
	aCommandQuery command = #browseMethod 
		ifTrue: 
			[aCommandQuery isEnabled: (list hasSelection and: [class includesSelector: (list selection at: 1)]).
			^true].
	^super queryCommand: aCommandQuery!

setClass: aClass
	"Private - Initialize the list. This is used the first time the browser is opened and
	also whenever a method in the selected class is edivted/deleted"

	class := aClass.
	self caption: 'Method History for ' , class printString.
	self updateHistory!

updateHistory
	| chunks selectors methodHistory |
	Cursor wait showWhile: [chunks := self scanner scanForMethodVersionsInClass: class].
	selectors := (chunks collect: [:each | each selector]) asSet asSortedCollection.
	methodHistory := OrderedCollection new.
	selectors do: 
			[:eachSelector | 
			| selectorChunks |
			selectorChunks := chunks select: [:each | each selector = eachSelector].
			methodHistory add: ((Array new: 4)
						at: 1 put: eachSelector;
						at: 2 put: (self historyStatusFor: eachSelector in: selectorChunks);
						at: 3 put: (selectorChunks select: [:each | each isFromSources]) size;
						at: 4 put: (selectorChunks select: [:each | each isFromChanges]) size;
						yourself)].
	list list: methodHistory! !
!ClassHistoryBrowser categoriesForMethods!
about!commands!public! !
browseHistory!commands!public! !
browseMethod!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
historyStatusFor:in:!helpers!public! !
onImageChanged:!event handling!public! !
onMethodAdded:!event handling!public! !
onMethodRemoved:!event handling!public! !
onMethodUpdated:!event handling!public! !
onViewClosed!event handling!public! !
queryCommand:!commands!public! !
setClass:!initializing!public! !
updateHistory!initializing!public! !
!

!ClassHistoryBrowser class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 ##(Smalltalk.Color) #face3d 918022 ##(Smalltalk.Point) 1001 701 551 nil nil nil 416 984838 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140920397 1025 560 787270 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1769478 ##(Smalltalk.IdentitySearchPolicy) 466 #default nil 7 461638 4 ##(Smalltalk.Menu) nil true 34 2 1180742 2 ##(Smalltalk.CommandMenuItem) 1 1377606 4 ##(Smalltalk.CommandDescription) #browseHistory 8 'Method history' 1 1 nil nil nil 786 1 818 #browseMethod 8 'Method browser' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 560 nil 8 1882204432 ##(Smalltalk.BasicListAbstract) nil 1639750 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 4 1117254 5 ##(Smalltalk.ListViewColumn) 8 'Selector' 481 #left ##(Smalltalk.BasicListAbstract) 786950 ##(Smalltalk.Message) #<= 8 #() 1246566 3 ##(Smalltalk.BlockClosure) 0 nil 1639718 ##(Smalltalk.CompiledExpression) 2 83886081 1104 8 'doIt' 8 '[:o | o at: 1]' 8 #[29 105 17 63 148 106] 1120 #at: 7 257 nil nil 560 nil 3 nil nil 1010 8 'Status' 161 #center ##(Smalltalk.BasicListAbstract) 1058 #<= 8 #() 1106 0 nil 1138 2 83886081 1104 8 'doIt' 8 '[:o | o at: 2] ' 8 #[29 105 17 64 148 106] 1280 #at: 7 257 nil nil 560 nil 1 nil nil 1010 8 'Sources' 161 #center ##(Smalltalk.BasicListAbstract) 1058 #<= 8 #() 1106 0 nil 1138 2 83886081 1104 8 'doIt' 8 '[:o | o at: 3] ' 8 #[29 105 17 214 3 148 106] 1424 #at: 7 257 nil nil 560 nil 1 nil nil 1010 8 'Changes' 161 #center ##(Smalltalk.BasicListAbstract) 1058 #<= 8 #() 1106 0 nil 1138 2 83886081 1104 8 'doIt' 8 '[:o | o at: 4] ' 8 #[29 105 17 214 4 148 106] 1568 #at: 7 257 nil nil 560 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 1310982 ##(Smalltalk.MessageSequence) 34 2 1049350 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1 1 498 969 583 560 1714 #text: 34 1 8 'Selector' 560 1179910 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 35 1 0 0] 8 #() 498 193 193 nil 35 170 192 34 2 560 8 'list' nil 658246 4 ##(Smalltalk.MenuBar) nil true 34 2 738 nil true 34 1 786 1 818 #exit 8 '&Close' 16615 1 nil nil nil 8 '&File' nil 134217729 nil nil 33269 nil nil 786 1 818 #about 8 '&About' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1666 34 2 1714 #createAt:extent: 34 2 498 6143 21 498 1001 701 416 1714 #text: 34 1 8 'Class History' 416 1842 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 243 13 0 0 104 1 0 0] 34 1 560 1904 nil 27 )!

showOnClass: aClass
	^self show setClass: aClass! !
!ClassHistoryBrowser class categoriesForMethods!
resource_Default_view!public!resources-views! !
showOnClass:!instance creation!public! !
!

