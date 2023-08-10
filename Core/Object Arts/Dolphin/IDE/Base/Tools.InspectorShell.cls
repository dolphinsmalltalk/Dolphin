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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground 518 #{Graphics.Point} 1161 921 519 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 192 nil nil nil 519 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 192 6 #{Graphics.Color} #default 8 1853287488 550 #{Core.IdentityDictionary} 5 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 432 nil nil nil 7 nil nil nil 432 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Edit_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 130 1 51 130 247 51 432 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 8 #() 130 193 193 nil 27 8 'editTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 752 nil nil nil 7 nil nil nil 752 498 #{UI.Toolbar} #resource_Image_tools nil 530 50 1 578 #createAt:extent: 50 2 130 1 1 130 63 51 752 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 704 720 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 976 nil nil nil 7 nil nil nil 976 498 #{UI.Toolbar} #resource_Search_tools nil 530 50 1 578 #createAt:extent: 50 2 130 615 1 130 437 51 976 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 704 720 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 1200 nil nil nil 7 nil nil nil 1200 498 #{UI.Toolbar} #resource_Workspace_tools nil 530 50 1 578 #createAt:extent: 50 2 130 247 51 130 247 51 1200 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 246 0 0 0 50 0 0 0] 704 720 nil 27 8 'workspaceTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 1424 nil nil nil 7 nil nil nil 1424 498 #{UI.Toolbar} #resource_Smalltalk_tools nil 530 50 1 578 #createAt:extent: 50 2 130 63 1 130 553 51 1424 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 704 720 nil 27 8 'smalltalkTools' nil nil nil 402 0 550 #{Core.OrderedCollection} 0 nil nil 1 nil 130 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 530 50 1 578 #createAt:extent: 50 2 130 1 1 130 1129 101 192 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 50 5 752 1424 976 432 1200 720 nil 29 nil nil nil nil 402 1 192 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 6 2886 4 #{UI.Menu} nil true 50 8 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileNew 8 '&New Workspace' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 2018 1 2050 #fileOpen 8 '&Open Workspace…' 9375 1 2098 nil true 2130 8 'OpenWorkspace.ico' 2192 65541 nil nil nil 2018 1 2050 #fileFileIn 8 '&File In…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2018 1 2050 #saveImage 8 'Sa&ve Image' 1 1 2098 nil true 2130 8 'Snapshot.ico' 2192 65541 nil nil nil 2018 1 2050 #smalltalkExit 8 'E&xit Dolphin' 1 1 2098 nil true 2130 8 'PowerSwitch.ico' 2192 65541 nil nil nil 2370 4097 2018 1 2050 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 48775 nil nil 1970 nil true 50 12 2018 1 2050 #undo 8 '&Undo' 9397 1 2098 nil true 2130 8 'EditUndo.ico' 2192 65541 nil nil nil 2018 1 2050 #redo 8 'R&edo' 9395 1 2098 nil true 2130 8 'EditRedo.ico' 2192 65541 nil nil nil 2370 4097 2018 1 2050 #cutSelection 8 'Cu&t' 9393 1 2098 nil true 2130 8 'EditCut.ico' 2192 65541 nil nil nil 2018 1 2050 #copySelection 8 '&Copy' 9351 1 2098 nil true 2130 8 'EditCopy.ico' 2192 65541 nil nil nil 2018 1 2050 #pasteClipboard 8 '&Paste' 9389 1 2098 nil true 2130 8 'EditPaste.ico' 2192 65541 nil nil nil 2018 1 2050 #clearSelection 8 '&Delete' 1 1 2098 nil true 2130 8 'EditClear.ico' 2192 65541 nil nil nil 2018 1 2050 #selectAll 8 'Select &All' 9347 1 nil nil nil 2370 4097 2018 1 2050 #editFind 8 '&Find…' 9357 1 2098 nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 2018 1 2050 #findNext 8 'Find &Next' 1253 1 2098 nil true 2130 8 'FindNext.ico' 2192 65541 nil nil nil 2018 1 2050 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 48797 nil nil 1970 nil true 50 14 2018 1 2050 #browseIt 8 '&Browse It' 9349 1 2098 nil true 2130 8 'ClassBrowserShell.ico' 2192 65541 nil nil nil 2018 1 2050 #displayIt 8 '&Display It' 9353 1 2098 nil true 2130 8 'DisplayIt.ico' 2192 65541 nil nil nil 2018 1 2050 #printIt 8 '&Print It' 9377 1 2098 nil true 2130 8 'PrintIt.ico' 2192 65541 nil nil nil 2018 1 2050 #evaluateIt 8 '&Evaluate It' 9355 1 2098 nil true 2130 8 'EvaluateIt.ico' 2192 65541 nil nil nil 2018 1 2050 #inspectIt 8 '&Inspect It' 9363 1 2098 nil true 2130 8 'BasicInspector.ico' 2192 65541 nil nil nil 2018 1 2050 #debugIt 8 'Deb&ug It' 1269 1 2098 nil true 2130 8 'Debugger.ico' 2192 65541 nil nil nil 2018 1 2050 #fileItIn 8 '&File It In' 1 1 nil nil nil 2370 4097 2018 1 2050 #accept 8 '&Accept' 9383 1 nil nil nil 2370 4097 2018 1 2050 #browseDefinitions 8 'Defi&nitions…' 1271 1 nil nil nil 2018 1 2050 #browseReferences 8 '&References…' 5367 1 nil nil nil 2370 4097 1970 nil true 50 9 2018 1 2050 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2018 1 2050 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2018 1 2050 #toggleLineEndings 8 'Line &Endings' 1 1 2658 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 2018 1 2050 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2018 1 2050 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2018 1 2050 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2018 1 2050 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 2370 4097 1970 nil true 50 3 2018 1 2050 518 #{Core.Message} #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 2018 1 2050 5026 #language: 8 #(#text) 8 '&Text' 1 1 nil nil nil 2018 1 2050 5026 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 48839 nil nil 8 '&Options' nil 134217729 2098 nil true 2130 8 'Preferences.ico' 2192 65541 nil nil 48841 nil nil 8 '&Workspace' nil 134217729 nil nil 48843 nil nil 1970 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 48845 nil nil 1970 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 48847 nil nil 1970 nil true 50 15 2018 1 2050 #helpContents 8 '&Contents' 1025 1 2098 nil true 2130 8 'Help.ico' 2192 65541 nil nil nil 2018 1 2050 #help 8 'On this &Tool' 1249 1 nil nil nil 2018 1 2050 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2370 4097 2018 1 2050 #learnSmalltalk 8 'Learn Smalltalk' 1 1 2658 8 $🎓 nil 354 #orchid 354 #white nil nil 1 nil nil nil nil 2370 4097 2018 1 2050 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2018 1 2050 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2018 1 2050 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2370 4097 2018 1 2050 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 2098 nil true 2130 8 '!!APPLICATION' 2192 65541 nil nil nil 2018 1 2050 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2018 1 2050 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2370 4097 2018 1 2050 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2658 8 $🐬 nil nil 354 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 48871 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 530 50 1 578 #createAt:extent: 50 2 130 6143 21 130 1161 921 32 658 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 67 14 0 0 214 1 0 0] 50 1 192 720 nil 27)! !
!Tools.InspectorShell class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
!

