"Filed out from Dolphin Smalltalk X6"!

IdbToolShell subclass: #NewsArchiveBrowser
	instanceVariableNames: 'list text status percentageLoaded'
	classVariableNames: 'ArchiveFolder TextFont'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NewsArchiveBrowser guid: (GUID fromString: '{D1288AAC-4411-4F8B-8F61-EB4D4CBB6C1E}')!
NewsArchiveBrowser comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!NewsArchiveBrowser categoriesForClass!IDB Goodies! !
!NewsArchiveBrowser methodsFor!

about
	"Display the about view"

	self 
		idbAbout: '
News Archive Browser
for
Dolphin Smalltalk 6.x

Version 6a
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

canPrint
	^super respondsTo: #print:!

copySelected
	| stream |
	stream := String writeStream.
	Cursor wait showWhile: [self model copySelectedTo: stream].
	stream contents copyToClipboard!

createComponents
	list := self add: ListPresenter new name: 'list'.
	text := self add: TextPresenter new name: 'text'.
	status := self add: TextPresenter new name: 'status'.
	percentageLoaded := self add: NumberPresenter new name: 'percentageLoaded'!

createSchematicWiring
	super createSchematicWiring.
	list 
		when: #selectionChanged
		send: #onSelectionChanged
		to: self.
	list 
		when: #actionPerformed
		send: #onActionPerformed
		to: self.
	self model 
		when: #percentageLoaded:
		send: #onPercentageLoaded:
		to: self!

onActionPerformed
	list selection toggleSelection.
	list model refreshAtIndex: list selectionByIndex!

onPercentageLoaded: aNumber 
	percentageLoaded value: aNumber rounded!

onSelectionChanged
	text value: (list hasSelection ifTrue: [list selection text] ifFalse: [String new])!

onViewOpened
	| time |
	super onViewOpened.
	text view font: self class textFont.
	self caption: 'Archive:  ' , self class archiveFolder.
	
	["Lots of objects created so get this done first"
	MemoryManager current collectGarbage.
	time := Time millisecondsToRun: [self showAll].
	percentageLoaded view hide.
	
	[status value: time printString , ' milliseconds'.
	Processor sleep: 750.
	self setStatus] fork] 
			postToInputQueue!

print
	super print: text view!

queryCommand: aCommandQuery 
	(#(#selectAll #unSelectAll #copySelected #showSelected #searchFrom #searchSubject #searchText) 
		includes: aCommandQuery command) 
			ifTrue: 
				[aCommandQuery isEnabled: (list list notNil and: [list list notEmpty]).
				^true].
	(#(#copySelection #showConversation) includes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: list hasSelection.
			^true].
	(#(#copySelected #showSelected #unSelectAll) includes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: self model hasAnySelected.
			^true].
	(#(#print #printPreview) identityIncludes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery
				isEnabled: self canPrint;
				receiver: self.
			^true].
	^super queryCommand: aCommandQuery!

searchAllFrom
	self showAll.
	self searchFrom!

searchAllSubject
	self showAll.
	self searchSubject!

searchAllText
	self showAll.
	self searchText!

searchCaption: aString selector: aSymbol 
	| target newList |
	target := Prompter prompt: aString.
	(target isNil or: [target isEmpty]) ifTrue: [^self].
	Cursor wait 
		showWhile: [newList := list list select: [:each | each perform: aSymbol with: target asLowercase]].
	self setList: newList!

searchFrom
	self searchCaption: 'Search From field for - ' selector: #searchFromFor:!

searchSubject
	self searchCaption: 'Search Subject field for - ' selector: #searchSubjectFor:!

searchText
	self searchCaption: 'Search Text field for - ' selector: #searchTextFor:!

selectAll
	Cursor wait showWhile: [list list do: [:each | each select]].
	list view refreshContents!

setList: aCollection 
	| selection |
	selection := list selectionOrNil.
	list list: aCollection.
	(selection notNil and: [aCollection includes: selection]) 
		ifTrue: [list selection: selection]
		ifFalse: [text value: String new].	"This stops a horizontal scroll bar appearing"
	list view layout.
	self setStatus!

setStatus
	status value: ((String writeStream)
				nextPutAll: ' Showing ';
				print: list model size;
				nextPutAll: ' of ';
				print: self model countArticles;
				contents)!

showAll
	self setList: self model articles!

showConversation
	Cursor wait showWhile: [self setList: (self model articlesInConversation: list selection)]!

showSelected
	Cursor wait showWhile: [self setList: self model allSelected]!

unSelectAll
	Cursor wait showWhile: [list list do: [:each | each unSelect]].
	list view refreshContents! !
!NewsArchiveBrowser categoriesFor: #about!commands!public! !
!NewsArchiveBrowser categoriesFor: #canPrint!printing!public!testing! !
!NewsArchiveBrowser categoriesFor: #copySelected!commands!public! !
!NewsArchiveBrowser categoriesFor: #createComponents!initializing!public! !
!NewsArchiveBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!NewsArchiveBrowser categoriesFor: #onActionPerformed!event handling!public! !
!NewsArchiveBrowser categoriesFor: #onPercentageLoaded:!event handling!public! !
!NewsArchiveBrowser categoriesFor: #onSelectionChanged!event handling!public! !
!NewsArchiveBrowser categoriesFor: #onViewOpened!event handling!public! !
!NewsArchiveBrowser categoriesFor: #print!accessing!printing!public! !
!NewsArchiveBrowser categoriesFor: #queryCommand:!commands!public! !
!NewsArchiveBrowser categoriesFor: #searchAllFrom!commands!public! !
!NewsArchiveBrowser categoriesFor: #searchAllSubject!commands!public! !
!NewsArchiveBrowser categoriesFor: #searchAllText!commands!public! !
!NewsArchiveBrowser categoriesFor: #searchCaption:selector:!commands!public! !
!NewsArchiveBrowser categoriesFor: #searchFrom!commands!public! !
!NewsArchiveBrowser categoriesFor: #searchSubject!commands!public! !
!NewsArchiveBrowser categoriesFor: #searchText!commands!public! !
!NewsArchiveBrowser categoriesFor: #selectAll!commands!public! !
!NewsArchiveBrowser categoriesFor: #setList:!helpers!public! !
!NewsArchiveBrowser categoriesFor: #setStatus!helpers!public! !
!NewsArchiveBrowser categoriesFor: #showAll!commands!public! !
!NewsArchiveBrowser categoriesFor: #showConversation!commands!public! !
!NewsArchiveBrowser categoriesFor: #showSelected!commands!public! !
!NewsArchiveBrowser categoriesFor: #unSelectAll!commands!public! !

!NewsArchiveBrowser class methodsFor!

archiveFolder
	ArchiveFolder isNil ifTrue: [ArchiveFolder := self defaultArchiveFolder].
	^ArchiveFolder!

archiveFolder: aStringOrNil 
	ArchiveFolder := aStringOrNil!

defaultArchiveFolder
	^File composePath: SessionManager current idbPackageFolder subPath: 'News Archive Browser\Archive'!

defaultModel
	^NewsArchive new!

defaultTextFont
	^SmalltalkWorkspaceDocument defaultFont!

displayOn: aStream 
	aStream nextPutAll: 'News Archive Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) instanceClass defaultIcon!

publishedAspects
	^(super publishedAspects)
		add: (Aspect folder: #archiveFolder);
		add: (Aspect font: #textFont);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140850956 1 544 0 482 31 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 544 0 8 4294904209 234 256 98 4 853766 ##(Smalltalk.StatusBarItem)  1 401 544 0 8 ##(Smalltalk.BasicListAbstract)  0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.IconImageManager)  8 #current 8 'status' 410 8 ##(Smalltalk.ProgressBar)  98 15 0 544 98 2 8 1140850688 1 928 721990 2 ##(Smalltalk.ValueHolder)  0 0 858 8 ##(Smalltalk.SearchPolicy)  8 #never 1 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 928 0 8 4294904465 852486 ##(Smalltalk.NullConverter)  0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 722 17 3 722 401 41 928 1250 8 #range: 98 1 525062 ##(Smalltalk.Interval)  1 201 3 928 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 1 0 0 0 208 0 0 0 21 0 0 0] 98 0 722 193 193 0 27 8 'percentageLoaded' 98 2 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 544 0 816 1552 0 1186 202 208 98 1 1250 1280 98 2 722 1 921 722 1521 45 544 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 204 1 0 0 248 2 0 0 226 1 0 0] 98 1 928 1488 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 1728 0 482 31 0 7 0 0 0 1728 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 0 16 234 256 1872 590342 ##(Smalltalk.Rectangle)  722 1 1 722 1 1 1186 202 208 98 1 1250 1280 98 2 722 1 1 722 1521 921 1728 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 248 2 0 0 204 1 0 0] 98 3 410 1744 98 15 0 1728 98 2 8 1140850688 131073 2128 0 482 31 0 7 0 0 0 2128 514 1 1 0 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 2128 98 2 8 1140920397 1025 2224 590662 2 ##(Smalltalk.ListModel)  202 208 1872 0 858 1056 8 #identity 1090 1120 0 7 0 0 0 2224 0 8 4294904165 832 8 ##(Smalltalk.IconicListAbstract)  864 0 0 0 0 0 0 202 208 98 3 920646 5 ##(Smalltalk.ListViewColumn)  8 'Date' 401 8 #left 832 8 ##(Smalltalk.SortedCollection)  459270 ##(Smalltalk.Message)  8 #sent 98 0 0 2224 0 1 0 0 2466 8 'From' 261 2512 832 2528 2546 8 #from 98 0 0 2224 0 1 0 0 2466 8 'Subject' 837 2512 832 2528 2546 8 #subject 2672 0 2224 0 3 0 0 8 #report 1872 0 131169 0 0 1186 202 208 98 2 1250 1280 98 2 722 9 1 722 1505 451 2224 1250 8 #text: 98 1 8 'Date' 2224 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 244 2 0 0 225 0 0 0] 98 0 1488 0 27 234 256 98 2 2224 8 'list' 1906 722 9 1 722 9 5 1186 202 208 98 1 1250 1280 98 2 722 1 1 722 1521 455 2128 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 248 2 0 0 227 0 0 0] 98 1 2224 1488 0 27 410 8 ##(Smalltalk.Splitter)  98 12 0 1728 98 2 8 1140850688 1 3248 0 1090 1120 0 519 0 0 0 3248 1186 202 208 98 1 1250 1280 98 2 722 1 455 722 1521 11 3248 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 227 0 0 0 248 2 0 0 232 0 0 0] 98 0 1488 0 27 410 1744 98 15 0 1728 98 2 8 1140850688 131073 3504 0 482 31 0 7 0 0 0 3504 514 1 1 0 0 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 3504 98 2 8 1174475012 1025 3600 1010 0 32 858 1056 8 #equality 0 1090 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #copySelection 8 'Copy' 1 1 0 0 0 3810 1 3842 8 #print 8 'Print' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 3810 1 3842 8 #selectAll 8 'Select All' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3600 0 403526399 1154 0 0 11 0 234 256 98 6 8 #lineNumber 1182726 ##(Smalltalk.ScintillaTextStyle)  67 0 0 1 0 0 0 0 4128 0 0 0 8 #indentGuide 4146 75 0 0 1 0 0 0 0 4176 0 0 0 8 #normal 4146 1 0 0 1 0 0 0 0 4208 0 0 0 98 40 4224 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4160 0 0 0 4192 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler)  4208 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  0 1 786694 ##(Smalltalk.IndexedColor)  33554433 4370 33554471 3600 8 #circle 202 208 1872 0 63 0 0 0 0 0 4370 33554447 0 0 0 0 0 0 8 '' 1 234 256 1872 0 0 0 0 1 0 0 1186 202 208 98 9 1250 1280 98 2 722 9 5 722 1505 453 3600 1250 8 #contextMenu: 98 1 3776 3600 1250 8 #selectionRange: 98 1 1394 3 1 3 3600 1250 8 #isTextModified: 98 1 32 3600 1250 8 #modificationEventMask: 98 1 9215 3600 1250 8 #indicatorDefinitions: 98 1 98 3 1836038 ##(Smalltalk.ScintillaIndicatorDefinition)  1 3600 65025 3 4882 3 3600 33423361 5 4882 5 3600 511 1 3600 1250 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 3600 1 3 32 1 5010 3 3600 1 1 32 67108863 5010 5 3600 1 1 32 1 3600 1250 8 #markers: 98 1 4432 3600 1250 8 #tabIndents: 98 1 16 3600 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 2 0 0 0 244 2 0 0 228 0 0 0] 98 0 1488 0 27 234 256 98 2 3600 8 'text' 1906 722 9 5 722 9 1 1186 202 208 98 1 1250 1280 98 2 722 1 465 722 1521 457 3504 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 232 0 0 0 248 2 0 0 204 1 0 0] 98 1 3600 1488 0 27 1488 0 27 234 256 1872 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 6 3762 0 16 98 4 3810 1 3842 8 #pageSetup 8 'Page Serup...' 1 1 0 0 0 3810 1 3842 3936 8 'Print...' 1 1 0 0 0 3970 4097 3810 1 3842 8 #exit 8 'Close' 16615 1 0 0 0 8 'File' 0 1 0 0 21571 0 0 3762 0 16 98 3 3810 1 3842 8 #showAll 8 'All' 1 1 0 0 0 3810 1 3842 8 #showConversation 8 'Conversation' 1 1 0 0 0 3810 1 3842 8 #showSelected 8 'Selected' 1 1 0 0 0 8 'Show' 0 1 0 0 21579 0 0 3762 0 16 98 4 3810 1 3842 8 #copySelected 8 'Copy selected to clipboard' 1 1 0 0 0 3970 4097 3810 1 3842 4032 8 'Select all' 1 1 0 0 0 3810 1 3842 8 #unSelectAll 8 'Unselect all' 1 1 0 0 0 8 'Select' 0 1 0 0 21587 0 0 3762 0 16 98 7 3810 1 3842 8 #searchFrom 8 'From (Current)' 1 1 0 0 0 3810 1 3842 8 #searchSubject 8 'Subject (Current)' 1 1 0 0 0 3810 1 3842 8 #searchText 8 'Text (Current)' 1 1 0 0 0 3970 4097 3810 1 3842 8 #searchAllFrom 8 'From (All)' 1 1 0 0 0 3810 1 3842 8 #searchAllSubject 8 'Subject (All)' 1 1 0 0 0 3810 1 3842 8 #searchAllText 8 'Text (All)' 1 1 0 0 0 8 'Search' 0 1 0 0 21601 0 0 3762 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 21603 0 0 3762 0 16 98 19 3810 1 3842 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon)  0 16 858 8 ##(Smalltalk.ImageRelativeFileLocator)  896 49 858 8 ##(Smalltalk.ShellLibrary)  4320 0 0 3810 1 3842 8 #help 8 'On this &Tool' 1249 1 0 0 0 3810 1 3842 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 3970 4097 3810 1 3842 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 3970 4097 3810 1 3842 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3810 1 3842 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3810 1 3842 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3762 0 16 98 4 3810 2097153 3842 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 6866 0 16 6896 8 'TipOfTheDay.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 3810 1 3842 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 6866 0 16 6896 8 'TipOfTheDay.ico' 7520 0 0 3970 4097 3810 1 3842 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 0 0 0 3970 4097 3810 1 3842 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3810 1 3842 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3810 1 3842 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3810 1 3842 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 3970 4097 3810 1 3842 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 6866 0 16 6896 8 'LiveUpdate.ico' 7520 0 0 3970 4097 3810 1 3842 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6866 0 16 6896 8 '!!APPLICATION' 7520 0 0 8 '&Help' 0 134217729 0 0 0 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(Smalltalk.AcceleratorTable)  0 16 98 6 721414 ##(Smalltalk.Association)  16615 5712 8322 1025 3842 6832 8 '&Contents' 1025 1 6866 0 16 6896 49 6928 8322 1249 3842 6992 8 'On this &Tool' 1249 1 0 8322 5345 3842 7056 8 'What''s This?' 5345 1 0 8322 9441 3842 7440 8 '&Next Tip of the Day' 9441 1 6866 0 16 6896 8 'TipOfTheDay.ico' 7520 8322 13537 3842 7584 8 '&Previous Tip of the Day' 13537 1 6866 0 16 6896 8 'TipOfTheDay.ico' 7520 0 1 0 0 0 0 1 0 0 1186 202 208 98 2 1250 1280 98 2 722 6399 21 722 1537 1073 416 1250 8 #menuBar: 98 1 5504 416 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 127 15 0 0 34 2 0 0] 98 2 1728 544 1488 0 27 )!

textFont
	TextFont isNil ifTrue: [TextFont := self defaultTextFont].
	^TextFont!

textFont: aFontOrNil 
	TextFont := aFontOrNil! !
!NewsArchiveBrowser class categoriesFor: #archiveFolder!accessing!public! !
!NewsArchiveBrowser class categoriesFor: #archiveFolder:!accessing!public! !
!NewsArchiveBrowser class categoriesFor: #defaultArchiveFolder!constants!public! !
!NewsArchiveBrowser class categoriesFor: #defaultModel!constants!public! !
!NewsArchiveBrowser class categoriesFor: #defaultTextFont!constants!public! !
!NewsArchiveBrowser class categoriesFor: #displayOn:!operations!public! !
!NewsArchiveBrowser class categoriesFor: #icon!constants!public! !
!NewsArchiveBrowser class categoriesFor: #publishedAspects!accessing!public! !
!NewsArchiveBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!NewsArchiveBrowser class categoriesFor: #textFont!accessing!public! !
!NewsArchiveBrowser class categoriesFor: #textFont:!accessing!public! !

