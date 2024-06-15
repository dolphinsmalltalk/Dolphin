"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'Tools.Tests.ResourceBrowserTest'
	instanceVariableNames: 'testClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.ResourceBrowserTest guid: (Core.GUID fromString: '{8d888ba2-f5b7-402c-9bff-e88b2cde2fab}')!

Tools.Tests.ResourceBrowserTest comment: ''!

!Tools.Tests.ResourceBrowserTest methodsFor!

classToTest
	^ResourceBrowser!

getShellResource
	^(ResourceIdentifier class: Shell) resource!

resourceBrowser
	^presenter!

resourceDisplayList
	^self resourceToolboxPresenter resourcesPresenter list!

resourceList
	^self resourceToolboxPresenter list!

resourceToolboxPresenter
	^self resourceBrowser resourceToolboxPresenter!

sampleClass
	^testClass
		ifNil: 
			[testClass := Object
						subclass: #ResourceBrowserTestSampleClass
						instanceVariableNames: ''
						classVariableNames: ''
						poolDictionaries: ''
						classInstanceVariableNames: '']!

tearDown
	testClass ifNotNil: [testClass removeFromSystem].
	super tearDown!

testAddRemoveResource
	| sampleResourceId |
	
	[sampleResourceId := ResourceIdentifier class: self sampleClass.
	self resourceBrowser selectCategory: 'Misc'.
	self deny: (self resourceList includes: sampleResourceId).
	self deny: (self resourceDisplayList includes: sampleResourceId).
	sampleResourceId assign: self getShellResource.
	self assert: (self resourceList includes: sampleResourceId).
	self assert: (self resourceDisplayList includes: sampleResourceId).
	testClass class removeSelector: sampleResourceId selector.
	self deny: (self resourceList includes: sampleResourceId).
	self deny: (self resourceDisplayList includes: sampleResourceId)]
			ensure: [testClass class removeSelector: sampleResourceId selector ifAbsent: nil]!

testBasicContents
	| list |
	list := self resourceList.
	self assert: list notEmpty.
	self assert: list first isKindOf: ResourceIdentifier.
	self assert: list size > 100.
	self assert: (list includes: (ResourceIdentifier class: Shell)).
	self assert: (list includes: (ResourceIdentifier class: SystemBrowserShell))!

viewClass
	^ShellView! !

!Tools.Tests.ResourceBrowserTest categoriesForMethods!
classToTest!constants!private! !
getShellResource!helpers!private! !
resourceBrowser!accessing!private! !
resourceDisplayList!accessing!private! !
resourceList!accessing!private! !
resourceToolboxPresenter!accessing!private! !
sampleClass!accessing!private! !
tearDown!private!running! !
testAddRemoveResource!public!unit tests! !
testBasicContents!public!unit tests! !
viewClass!constants!private! !
!

!Tools.Tests.ResourceBrowserTest class methodsFor!

resource_Default_view_D6

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 39 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851532 131137 560 0 482 8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 560 482 656 8 4294903595 234 256 98 8 410 8 ##(Smalltalk.ReferenceView)  98 14 0 560 98 2 8 1140850688 131073 848 0 0 0 7 0 0 0 848 1180166 ##(Smalltalk.ResourceIdentifier)  576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 63 1 754 991 51 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 754 193 193 0 27 8 'smalltalkTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1232 0 0 0 7 0 0 0 1232 930 576 8 #resource_Resource_tools 0 978 202 208 98 1 1042 1072 98 2 754 1053 1 754 109 51 1232 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 68 2 0 0 25 0 0 0] 1184 1200 0 27 8 'resourceTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1488 0 0 0 7 0 0 0 1488 930 576 8 #resource_Image_tools 0 978 202 208 98 1 1042 1072 98 2 754 1 1 754 63 51 1488 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1184 1200 0 27 8 'imageTools' 410 576 98 25 0 560 98 2 8 1140853612 131137 1744 0 482 656 0 519 0 0 0 1744 482 656 8 4294903595 234 256 1184 234 256 98 2 49041 853766 ##(Smalltalk.ToolbarButton)  49041 0 1744 17 1180998 4 ##(Smalltalk.CommandDescription)  8 #viewModeSelect 8 'Views' 1 1 0 395334 3 ##(Smalltalk.Bitmap)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'ViewBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 7 754 129 33 3 98 1 1920 234 240 98 2 2016 1 0 1 0 754 33 33 754 45 45 0 0 978 202 208 98 2 1042 1072 98 2 754 1 51 754 73 51 1744 1042 8 #updateSize 1184 1744 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 36 0 0 0 50 0 0 0] 98 0 1200 0 27 8 'viewTools' 234 256 1184 98 0 234 240 1184 0 1 0 754 33 33 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 978 202 208 98 2 1042 1072 98 2 754 1 1 754 1215 101 560 1042 2352 1184 560 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 95 2 0 0 50 0 0 0] 98 4 1488 848 1232 1744 1200 0 27 0 0 0 410 864 98 14 0 416 98 2 8 1140850688 131073 2720 0 482 8 4278190080 0 15 0 0 0 2720 930 8 ##(Smalltalk.ResourceToolboxPresenter)  8 #resource_Default_view 0 978 202 208 98 1 1042 1072 98 2 754 1 101 754 1215 963 2720 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 95 2 0 0 19 2 0 0] 1184 1200 0 27 234 256 98 4 2720 8 'resourceToolbox' 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 4 265030 4 ##(Smalltalk.Menu)  0 16 98 9 984134 2 ##(Smalltalk.CommandMenuItem)  1 1938 8 #browseHierarchy 8 '&Browse <1s>' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 2048 8 'ClassBrowserShell.ico' 2096 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 3170 1 1938 8 #newView 8 '&New' 1 1 0 0 0 3170 1 1938 8 #deleteResource 8 '&Delete...' 1 1 0 0 0 3298 4097 3170 1 1938 8 #editResource 8 '&Open' 9349 1 0 0 0 3298 4097 3170 1 1938 8 #resourcePackage 8 '&Package...' 1 1 0 0 0 3170 1 1938 8 #categorizeResource 8 'Category...' 1 1 0 0 0 8 '&View' 0 134217729 0 0 48969 0 0 3122 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 48971 0 0 3122 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 48973 0 0 3122 0 16 98 19 3170 1 1938 8 #helpContents 8 '&Contents' 1025 1 3250 0 16 2048 49 786694 ##(Smalltalk.ShellLibrary)  0 0 3170 1 1938 8 #help 8 'On this &Tool' 1249 1 0 0 0 3170 1 1938 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 3298 4097 3170 1 1938 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 3298 4097 3170 1 1938 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3170 1 1938 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3170 1 1938 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3122 0 16 98 4 3170 2097153 1938 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 3250 0 16 2048 8 'TipOfTheDay.ico' 2096 0 0 3170 1 1938 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 3250 0 16 2048 8 'TipOfTheDay.ico' 2096 0 0 3298 4097 3170 1 1938 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 48995 0 0 3298 4097 3170 1 1938 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3170 1 1938 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3170 1 1938 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3170 1 1938 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 3298 4097 3170 1 1938 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 3250 0 16 2048 8 'LiveUpdate.ico' 2096 0 0 3298 4097 3170 1 1938 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3250 0 16 2048 8 '!!APPLICATION' 2096 0 0 8 '&Help' 0 134217729 0 0 49009 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 978 202 208 98 3 1042 1072 98 2 754 2799 21 754 1231 1171 416 1042 8 #text: 98 1 8 'View Browser' 416 1042 8 #updateMenuBar 1184 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 222 7 0 0 83 2 0 0] 98 2 560 2720 1200 0 27 )! !

!Tools.Tests.ResourceBrowserTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
!

