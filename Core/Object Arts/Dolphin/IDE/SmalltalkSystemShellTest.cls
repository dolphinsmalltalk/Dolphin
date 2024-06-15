"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #SmalltalkSystemShellTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SmalltalkSystemShellTest guid: (GUID fromString: '{6d373cd5-f02e-4adb-bce9-f0755886a74b}')!

SmalltalkSystemShellTest comment: ''!

!SmalltalkSystemShellTest categoriesForClass!Unclassified! !

!SmalltalkSystemShellTest methodsFor!

classToTest
	^SmalltalkSystemShell!

destroyPresenter
	presenter == self classToTest default ifFalse: [super destroyPresenter]!

initializePresenter
	presenter := self classToTest default!

systemFolderPresenter
	^presenter instVarNamed: 'systemFolderPresenter'!

testIconOrdering
	| initialContents sampleApps finalContents |
	"1782"
	initialContents := self systemFolderPresenter contents asArray.
	sampleApps := initialContents detect: [:each | each description = 'Sample Applications'].
	self systemFolderPresenter selection: sampleApps.
	self systemFolderPresenter onActionPerformed.
	self systemFolderPresenter up.
	finalContents := self systemFolderPresenter contents asArray.
	self assert: finalContents equals: initialContents!

testReset
	| oldView |
	oldView := presenter view.
	self classToTest reset.
	presenter := self classToTest default.
	self deny: oldView identicalTo: presenter view.
	self assert: (DisplayMonitor active effectiveWorkArea contains: presenter view rectangle)!

viewClass
	^ShellView! !

!SmalltalkSystemShellTest categoriesForMethods!
classToTest!helpers!private! !
destroyPresenter!public!Running! !
initializePresenter!public!Running! !
systemFolderPresenter!private!unit tests! !
testIconOrdering!public!unit tests! !
testReset!public!unit tests! !
viewClass!constants!private! !
!

!SmalltalkSystemShellTest class methodsFor!

resource_Default_view_D6

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4294967295 0 39 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851524 131073 560 0 482 8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 560 482 8 4278190080 8 4294903595 234 256 98 6 410 8 ##(Smalltalk.ReferenceView)  98 14 0 560 98 2 8 1140850688 131073 864 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 864 1180166 ##(Smalltalk.ResourceIdentifier)  576 8 #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 1 1 754 63 51 864 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 98 0 754 193 193 0 27 8 'imageTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1280 0 946 31 0 7 0 0 0 1280 978 576 8 #resource_Smalltalk_tools 0 1026 202 208 98 1 1090 1120 98 2 754 63 1 754 991 51 1280 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1232 1248 0 27 8 'smalltalkTools' 410 576 98 25 0 560 98 2 8 1140853572 65 1552 0 482 656 754 251 51 519 0 674 0 16 706 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 754 193 193 0 1552 482 800 8 4294903595 234 256 1232 234 256 98 8 51471 1115910 ##(Smalltalk.ToolbarIconButton)  51471 0 1552 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #up 8 'Up' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'Up.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 395334 3 ##(Smalltalk.Bitmap)  0 16 0 0 0 0 3 754 33 33 1 51473 1794 51473 0 1552 1 1826 8 #historyBack 8 'Back' 1 1 1890 0 16 1936 8 'HistoryBack.ico' 1984 2018 0 16 0 0 0 0 3 754 33 33 1 51475 1794 51475 0 1552 1 1826 8 #historyForward 8 'Forward' 1 1 1890 0 16 1936 8 'HistoryForward.ico' 1984 2018 0 16 0 0 0 0 3 754 33 33 1 51477 853766 ##(Smalltalk.ToolbarButton)  51477 0 1552 17 1826 8 #viewModeSelect 8 'Views' 1 1 0 2018 0 16 1936 8 'ViewBar.bmp' 1984 0 7 754 129 33 3 98 6 1808 2064 2192 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 1552 3 0 1 2336 2466 0 0 1552 3 0 1 234 240 98 8 2288 5 2032 1 2160 3 2400 7 0 1 0 754 33 33 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 1026 202 208 98 2 1090 1120 98 2 754 1053 1 754 251 51 1552 1090 8 #updateSize 1232 1552 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 139 2 0 0 25 0 0 0] 98 0 1248 0 27 8 'systemShellTools' 234 256 1232 202 208 1232 234 240 1232 0 1 0 754 33 33 754 45 45 0 2578 1 1 1 1026 202 208 98 2 1090 1120 98 2 754 1 1 754 1311 51 560 1090 2736 1232 560 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 143 2 0 0 25 0 0 0] 98 3 864 1280 1552 1248 0 27 0 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 3088 0 482 8 4278190080 0 7 0 0 0 3088 530 1 1 0 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 3088 98 2 8 1140932940 1 3216 590662 2 ##(Smalltalk.ListModel)  202 208 1232 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 3 984134 2 ##(Smalltalk.CommandMenuItem)  1 1826 8 #properties 8 '&Properties' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 3458 1 1826 8 #whatsThis 8 '&What''s This?' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3216 0 8 4294903801 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 170 8 'Dolphin List Presenter' 8 'BasicListAbstract' 8 'doIt' 8 '[:item | item description]' 8 #[30 105 17 158 106] 8 #description 3680 7 257 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 754 65 65 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Column 1' 1119 8 #left 3666 0 0 3698 2 1 3728 8 'doIt' 8 '[:item | item description]' 8 #[30 105 17 158 106] 3824 4000 7 257 0 8 ##(Smalltalk.SortedCollection)  459270 ##(Smalltalk.Message)  8 #yourself 98 0 0 3216 3936 3 0 0 8 #largeIcons 1232 0 97 0 0 1026 202 208 98 3 1090 1120 98 2 754 1 1 754 1311 573 3216 1090 8 #contextMenu: 98 1 3424 3216 1090 8 #text: 98 1 8 'Column 1' 3216 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 143 2 0 0 30 1 0 0] 98 0 1248 0 27 234 256 98 2 3216 8 'systemFolder' 0 1026 202 208 98 1 1090 1120 98 2 754 1 51 754 1311 573 3088 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 143 2 0 0 55 1 0 0] 98 1 3216 1248 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 5 3410 0 16 98 10 3458 1 1826 8 #newWorkspace 8 '&New Workspace' 9373 1 1890 0 16 1936 8 'SmalltalkWorkspace.ico' 1984 0 0 3458 1 1826 8 #openWorkspace 8 '&Open Workspace...' 9375 1 1890 0 16 1936 8 'FileOpen.ico' 1984 0 0 3458 1 1826 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 3538 4097 3458 1 1826 8 #saveImage 8 'Sa&ve Image' 1 1 1890 0 16 1936 8 'Snapshot.ico' 1984 0 0 3458 1 1826 8 #saveImageAs 8 'Save Image As...' 1 1 0 0 0 3458 1 1826 8 #compressChanges 8 '&Compress Changes...' 1 1 0 0 0 3458 1 1826 8 #compressSources 8 'Co&mpress Sources...' 1 1 0 0 0 3538 4097 3458 1 1826 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 1890 0 16 1936 8 'PowerSwitch.ico' 1984 0 0 8 '&File' 0 134217729 0 0 51369 0 0 3410 0 16 98 12 3458 1 1826 8 #browseHierarchy 8 '&Classes' 1 1 1890 0 16 1936 8 'ClassBrowserShell.ico' 1984 0 0 3458 1 1826 8 #browsePackages 8 '&Packages' 1 1 1890 0 16 1936 8 'Package.ico' 1984 0 0 3458 1 1826 8 #browseProtocols 8 'Pr&otocols' 1 1 1890 0 16 1936 8 'ProtocolBrowserShell.ico' 1984 0 0 3458 1 1826 8 #browseResources 8 '&Resources' 1 1 1890 0 16 1936 8 'Resource.ico' 1984 0 0 3458 1 1826 8 #browseSystem 8 'S&ystem' 1 1 1890 0 16 1936 8 'SystemBrowserShell.ico' 1984 0 0 3538 4097 3458 1 1826 8 #browseMessageDefinitions 8 'All &Definitions Of...' 1 1 0 0 0 3458 1 1826 8 #browseMessageReferences 8 'All Re&ferences To...' 1 1 0 0 0 3458 1 1826 4098 8 #browseReferencesToGlobal: 98 1 8 '' 8 'References to Global...' 1 1 0 0 0 3458 1 1826 8 #browseContainingText 8 'Containing &Text...' 1 1 1890 0 16 1936 47 786694 ##(Smalltalk.ShellLibrary)  0 0 3458 1 1826 8 #browseAllUnimplementedSelectors 8 'All &Unimplemented' 1 1 0 0 0 3410 0 16 98 5 3458 1 1826 8 #browseCompilationFailures 8 '&Compilation Failures' 1 1 0 0 0 3458 1 1826 8 #browseDeprecatedMethods 8 '&Deprecated' 1 1 0 0 0 3458 1 1826 8 #browseNotYetImplemented 8 '&Not Yet Implemented' 1 1 0 0 0 3458 1 1826 8 #browseUnclassifiedMethods 8 '&Unclassified' 1 1 0 0 0 3458 1 1826 8 #browseMethodCategory 8 '&Other...' 1 1 0 0 0 8 'Method Cate&gory' 0 134217729 0 0 51401 0 0 8 '&Browse' 0 134217729 0 0 51403 0 0 3410 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 51405 0 0 3410 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 51407 0 0 3410 0 16 98 19 3458 1 1826 8 #helpContents 8 '&Contents' 1025 1 1890 0 16 1936 49 6336 0 0 3458 1 1826 8 #help 8 'On this &Tool' 1249 1 0 0 0 3458 1 1826 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 3538 4097 3458 1 1826 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 3538 4097 3458 1 1826 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3458 1 1826 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3458 1 1826 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3410 0 16 98 4 3458 2097153 1826 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 1890 0 16 1936 8 'TipOfTheDay.ico' 1984 0 0 3458 1 1826 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 1890 0 16 1936 8 'TipOfTheDay.ico' 1984 0 0 3538 4097 3458 1 1826 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 51429 0 0 3538 4097 3458 1 1826 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3458 1 1826 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3458 1 1826 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3458 1 1826 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 3538 4097 3458 1 1826 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 1890 0 16 1936 8 'LiveUpdate.ico' 1984 0 0 3538 4097 3458 1 1826 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 1890 0 16 1936 8 '!!APPLICATION' 1984 0 0 8 '&Help' 0 134217729 0 0 51443 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 754 2049 2049 0 1 0 0 1026 202 208 98 3 1090 1120 98 2 754 2799 21 754 1327 731 416 1090 4352 98 1 8 'Dolphin Smalltalk' 416 1090 8 #updateMenuBar 1232 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 14 8 0 0 119 1 0 0] 98 2 560 3088 1248 0 27 )! !

!SmalltalkSystemShellTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
!

