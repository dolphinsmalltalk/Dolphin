"Filed out from Dolphin Smalltalk"!

SmalltalkToolShell subclass: #InspectorShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

InspectorShell guid: (GUID fromString: '{87b4c6be-026e-11d3-9fd7-00a0cc3e4a32}')!

InspectorShell comment: 'InspectorShell is a <SmalltalkToolShell> that implements the various inspector tools. Note that this is really just a "shell" around the real functionality which is obtained by embedding one of a number of <Inspector> presenters. The particular <Inspector> subclass chosen is determined by the type of the object being inspected.


'!

!InspectorShell categoriesForClass!MVP-Presenters! !

!InspectorShell methodsFor!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self hasCommandHistory: true! !

!InspectorShell categoriesForMethods!
initialize!initializing!private! !
!

!InspectorShell class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Inspector'
!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		removeKey: #reuseIfOpen;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground 328198 ##(Smalltalk.Point) 1161 921 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 560 nil nil nil 517 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 560 327686 ##(Smalltalk.Color) #default 8 1759112192 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 784 nil nil nil 5 nil nil nil 784 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 816 8 '' 784 3 8 #() 498 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1136 nil nil nil 5 nil nil nil 1136 850 ##(Smalltalk.Toolbar) #resource_Workspace_tools nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[123 0 0 0 25 0 0 0 246 0 0 0 50 0 0 0] 193 1168 8 '' 1136 3 1088 498 193 193 nil 27 8 'workspaceTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1392 nil nil nil 5 nil nil nil 1392 850 ##(Smalltalk.Toolbar) #resource_Search_tools nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1424 8 '' 1392 3 1088 498 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1648 nil nil nil 5 nil nil nil 1648 850 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 193 1680 8 '' 1648 3 1088 498 193 193 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1904 nil nil nil 5 nil nil nil 1904 850 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1936 8 '' 1904 3 1088 498 193 193 nil 27 8 'smalltalkTools' nil nil nil 170 192 1088 138 144 1088 nil nil 9 1539 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 193 592 8 '' 560 3 34 5 784 1904 1392 1648 1136 498 193 193 nil 31 nil nil nil nil 170 192 34 2 560 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 265030 4 ##(Smalltalk.Menu) nil true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New Workspace' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2546 1 2578 #fileOpen 8 '&Open Workspace...' 9375 1 2626 nil true 2672 8 'OpenWorkspace.ico' 2720 nil nil 2546 1 2578 #fileFileIn 8 '&File In...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2546 1 2578 #saveImage 8 'Sa&ve Image' 1 1 2626 nil true 2672 8 'Snapshot.ico' 2720 nil nil 2546 1 2578 #smalltalkExit 8 'E&xit Dolphin' 1 1 2626 nil true 2672 8 'PowerSwitch.ico' 2720 nil nil 2882 4097 2546 1 2578 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 13355 nil nil 2498 nil true 34 12 2546 1 2578 #undo 8 '&Undo' 9397 1 2626 nil true 2672 8 'EditUndo.ico' 2720 nil nil 2546 1 2578 #redo 8 'R&edo' 9395 1 2626 nil true 2672 8 'EditRedo.ico' 2720 nil nil 2882 4097 2546 1 2578 #cutSelection 8 'Cu&t' 9393 1 2626 nil true 2672 8 'EditCut.ico' 2720 nil nil 2546 1 2578 #copySelection 8 '&Copy' 9351 1 2626 nil true 2672 8 'EditCopy.ico' 2720 nil nil 2546 1 2578 #pasteClipboard 8 '&Paste' 9389 1 2626 nil true 2672 8 'EditPaste.ico' 2720 nil nil 2546 1 2578 #clearSelection 8 '&Delete' 1 1 2626 nil true 2672 8 'EditClear.ico' 2720 nil nil 2546 1 2578 #selectAll 8 'Select &All' 9347 1 nil nil nil 2882 4097 2546 1 2578 #editFind 8 '&Find...' 9357 1 2626 nil true 2672 47 786694 ##(Smalltalk.ShellLibrary) nil nil 2546 1 2578 #findNext 8 'Find &Next' 1253 1 2626 nil true 2672 8 'FindNext.ico' 2720 nil nil 2546 1 2578 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 13377 nil nil 2498 nil true 34 14 2546 1 2578 #browseIt 8 '&Browse It' 9349 1 2626 nil true 2672 8 'ClassBrowserShell.ico' 2720 nil nil 2546 1 2578 #displayIt 8 '&Display It' 9353 1 2626 nil true 2672 8 'DisplayIt.ico' 2720 nil nil 2546 1 2578 #printIt 8 '&Print It' 9377 1 2626 nil true 2672 8 'PrintIt.ico' 2720 nil nil 2546 1 2578 #evaluateIt 8 '&Evaluate It' 9355 1 2626 nil true 2672 8 'EvaluateIt.ico' 2720 nil nil 2546 1 2578 #inspectIt 8 '&Inspect It' 9363 1 2626 nil true 2672 8 'BasicInspector.ico' 2720 nil nil 2546 1 2578 #debugIt 8 'Deb&ug It' 1269 1 2626 nil true 2672 8 'Debugger.ico' 2720 nil nil 2546 1 2578 #fileItIn 8 '&File It In' 1 1 nil nil nil 2882 4097 2546 1 2578 #accept 8 '&Accept' 9383 1 nil nil nil 2882 4097 2546 1 2578 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 2546 1 2578 #browseReferences 8 '&References...' 5367 1 nil nil nil 2882 4097 2498 nil true 34 9 2546 1 2578 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2546 1 2578 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2546 1 2578 #toggleLineEndings 8 'Line &Endings' 1 1 3138 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 2546 1 2578 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2546 1 2578 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2546 1 2578 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2546 1 2578 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 2882 4097 2498 nil true 34 3 2546 1 2578 459270 ##(Smalltalk.Message) #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 2546 1 2578 5250 #language: 8 #(#text) 8 '&Text' 1 1 nil nil nil 2546 1 2578 5250 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 13419 nil nil 8 '&Options' nil 134217729 2626 nil true 2672 8 'Preferences.ico' 2720 nil 13421 nil nil 8 '&Workspace' nil 134217729 nil nil 13423 nil nil 2498 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 13425 nil nil 2498 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 13427 nil nil 2498 nil true 34 15 2546 1 2578 #helpContents 8 '&Contents' 1025 1 2626 nil true 2672 8 'Help.ico' 2720 nil nil 2546 1 2578 #help 8 'On this &Tool' 1249 1 nil nil nil 2546 1 2578 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2882 4097 2546 1 2578 #learnSmalltalk 8 'Learn Smalltalk' 1 1 3138 $🎓 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 2882 4097 2546 1 2578 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2546 1 2578 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2546 1 2578 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2882 4097 2546 1 2578 #dolphinHomePage 8 'Dolphin Homepage' 1 1 2626 nil true 2672 8 '!!APPLICATION' 2720 nil nil 2546 1 2578 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2546 1 2578 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2882 4097 2546 1 2578 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3138 $🐬 nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 13451 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 882 138 144 34 1 946 #createWindow: 34 1 994 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1161 921 193 448 8 '' 416 1 34 1 560 498 193 193 nil 27 )! !

!InspectorShell class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
!

