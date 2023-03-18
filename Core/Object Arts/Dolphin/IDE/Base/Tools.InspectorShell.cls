"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.InspectorShell'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.InspectorShell guid: (Core.GUID fromString: '{87b4c6be-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.InspectorShell comment: 'InspectorShell is a <SmalltalkToolShell> that implements the various inspector tools. Note that this is really just a "shell" around the real functionality which is obtained by embedding one of a number of <Inspector> presenters. The particular <Inspector> subclass chosen is determined by the type of the object being inspected.


'!
!Tools.InspectorShell categoriesForClass!MVP-Presenters! !
!Tools.InspectorShell methodsFor!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self hasCommandHistory: true! !
!Tools.InspectorShell categoriesForMethods!
initialize!initializing!private! !
!

!Tools.InspectorShell class methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Inspector'!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground 918022 #{Graphics.Point} 1161 921 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853580 131073 560 nil nil nil 519 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 560 917510 #{Graphics.Color} #default 8 1815075056 170 192 34 10 410 #{UI.ReferenceView} 34 14 nil 560 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Workspace_tools nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 247 51 498 247 51 800 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 246 0 0 0 50 0 0 0] 8 #() 498 193 193 nil 27 8 'workspaceTools' 410 #{UI.ReferenceView} 34 14 nil 560 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 866 #{UI.Toolbar} #resource_Image_tools nil 898 34 1 946 #createAt:extent: 34 2 498 1 1 498 63 51 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1072 1088 nil 27 8 'imageTools' 410 #{UI.ReferenceView} 34 14 nil 560 34 2 8 1140850688 131073 1344 nil nil nil 7 nil nil nil 1344 866 #{UI.Toolbar} #resource_Edit_tools nil 898 34 1 946 #createAt:extent: 34 2 498 1 51 498 247 51 1344 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 1072 1088 nil 27 8 'editTools' 410 #{UI.ReferenceView} 34 14 nil 560 34 2 8 1140850688 131073 1568 nil nil nil 7 nil nil nil 1568 866 #{UI.Toolbar} #resource_Search_tools nil 898 34 1 946 #createAt:extent: 34 2 498 615 1 498 437 51 1568 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'searchTools' 410 #{UI.ReferenceView} 34 14 nil 560 34 2 8 1140850688 131073 1792 nil nil nil 7 nil nil nil 1792 866 #{UI.Toolbar} #resource_Smalltalk_tools nil 898 34 1 946 #createAt:extent: 34 2 498 63 1 498 553 51 1792 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 1072 1088 nil 27 8 'smalltalkTools' nil nil nil 170 192 1072 138 144 1072 nil nil 1 nil 498 33 33 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 898 34 1 946 #createAt:extent: 34 2 498 1 1 498 1129 101 560 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 34 5 1120 1792 1568 1344 800 1088 nil 29 nil nil nil nil 170 192 34 2 560 8 'toolbar' nil 658246 4 #{UI.MenuBar} nil true 34 6 461638 4 #{UI.Menu} nil true 34 8 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #fileNew 8 '&New Workspace' 9373 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 2386 1 2418 #fileOpen 8 '&Open Workspace…' 9375 1 2466 nil true 2498 8 'OpenWorkspace.ico' 2560 65541 nil nil nil 2386 1 2418 #fileFileIn 8 '&File In…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 2386 1 2418 #saveImage 8 'Sa&ve Image' 1 1 2466 nil true 2498 8 'Snapshot.ico' 2560 65541 nil nil nil 2386 1 2418 #smalltalkExit 8 'E&xit Dolphin' 1 1 2466 nil true 2498 8 'PowerSwitch.ico' 2560 65541 nil nil nil 2738 4097 2386 1 2418 #exit 8 '&Close' 17639 1 1378630 2 #{Graphics.TextTileIcon} $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 57039 nil nil 2338 nil true 34 12 2386 1 2418 #undo 8 '&Undo' 9397 1 2466 nil true 2498 8 'EditUndo.ico' 2560 65541 nil nil nil 2386 1 2418 #redo 8 'R&edo' 9395 1 2466 nil true 2498 8 'EditRedo.ico' 2560 65541 nil nil nil 2738 4097 2386 1 2418 #cutSelection 8 'Cu&t' 9393 1 2466 nil true 2498 8 'EditCut.ico' 2560 65541 nil nil nil 2386 1 2418 #copySelection 8 '&Copy' 9351 1 2466 nil true 2498 8 'EditCopy.ico' 2560 65541 nil nil nil 2386 1 2418 #pasteClipboard 8 '&Paste' 9389 1 2466 nil true 2498 8 'EditPaste.ico' 2560 65541 nil nil nil 2386 1 2418 #clearSelection 8 '&Delete' 1 1 2466 nil true 2498 8 'EditClear.ico' 2560 65541 nil nil nil 2386 1 2418 #selectAll 8 'Select &All' 9347 1 nil nil nil 2738 4097 2386 1 2418 #editFind 8 '&Find…' 9357 1 2466 nil true 2425862 #{Graphics.ImageFromResourceInitializer} 47 983302 #{OS.ShellLibrary} 65541 nil nil nil 2386 1 2418 #findNext 8 'Find &Next' 1253 1 2466 nil true 2498 8 'FindNext.ico' 2560 65541 nil nil nil 2386 1 2418 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 57061 nil nil 2338 nil true 34 14 2386 1 2418 #browseIt 8 '&Browse It' 9349 1 2466 nil true 2498 8 'ClassBrowserShell.ico' 2560 65541 nil nil nil 2386 1 2418 #displayIt 8 '&Display It' 9353 1 2466 nil true 2498 8 'DisplayIt.ico' 2560 65541 nil nil nil 2386 1 2418 #printIt 8 '&Print It' 9377 1 2466 nil true 2498 8 'PrintIt.ico' 2560 65541 nil nil nil 2386 1 2418 #evaluateIt 8 '&Evaluate It' 9355 1 2466 nil true 2498 8 'EvaluateIt.ico' 2560 65541 nil nil nil 2386 1 2418 #inspectIt 8 '&Inspect It' 9363 1 2466 nil true 2498 8 'BasicInspector.ico' 2560 65541 nil nil nil 2386 1 2418 #debugIt 8 'Deb&ug It' 1269 1 2466 nil true 2498 8 'Debugger.ico' 2560 65541 nil nil nil 2386 1 2418 #fileItIn 8 '&File It In' 1 1 nil nil nil 2738 4097 2386 1 2418 #accept 8 '&Accept' 9383 1 nil nil nil 2738 4097 2386 1 2418 #browseDefinitions 8 'Defi&nitions…' 1271 1 nil nil nil 2386 1 2418 #browseReferences 8 '&References…' 5367 1 nil nil nil 2738 4097 2338 nil true 34 9 2386 1 2418 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2386 1 2418 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2386 1 2418 #toggleLineEndings 8 'Line &Endings' 1 1 3026 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 2386 1 2418 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2386 1 2418 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2386 1 2418 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2386 1 2418 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 2738 4097 2338 nil true 34 3 2386 1 2418 786950 #{Core.Message} #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 2386 1 2418 5378 #language: 8 #(#text) 8 '&Text' 1 1 nil nil nil 2386 1 2418 5378 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 57103 nil nil 8 '&Options' nil 134217729 2466 nil true 2498 8 'Preferences.ico' 2560 65541 nil nil 57105 nil nil 8 '&Workspace' nil 134217729 nil nil 57107 nil nil 2338 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 57109 nil nil 2338 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 57111 nil nil 2338 nil true 34 15 2386 1 2418 #helpContents 8 '&Contents' 1025 1 2466 nil true 2498 8 'Help.ico' 2560 65541 nil nil nil 2386 1 2418 #help 8 'On this &Tool' 1249 1 nil nil nil 2386 1 2418 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2738 4097 2386 1 2418 #learnSmalltalk 8 'Learn Smalltalk' 1 1 3026 $\x1F393 nil 722 #orchid 722 #white nil nil 1 nil nil nil nil 2738 4097 2386 1 2418 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2386 1 2418 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2386 1 2418 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2738 4097 2386 1 2418 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 2466 nil true 2498 8 '!!APPLICATION' 2560 65541 nil nil nil 2386 1 2418 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2386 1 2418 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2738 4097 2386 1 2418 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3026 $\x1F42C nil nil 722 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 57135 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 34 1 946 #createAt:extent: 34 2 498 12287 21 498 1161 921 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 67 26 0 0 214 1 0 0] 34 1 560 1088 nil 27)! !
!Tools.InspectorShell class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
!

