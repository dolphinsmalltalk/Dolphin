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
	commandHistory := HistoryList new! !

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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground 518 #{Graphics.Point} 1161 921 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 192 nil nil nil 517 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 192 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 10 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 416 nil nil nil 5 nil nil nil 416 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Edit_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 193 448 8 '' 416 3 8 #() 130 193 193 nil 27 8 'editTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 752 nil nil nil 5 nil nil nil 752 482 #{UI.Toolbar} #resource_Image_tools nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 784 8 '' 752 3 704 130 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 992 nil nil nil 5 nil nil nil 992 482 #{UI.Toolbar} #resource_Search_tools nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1024 8 '' 992 3 704 130 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 1232 nil nil nil 5 nil nil nil 1232 482 #{UI.Toolbar} #resource_Smalltalk_tools nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1264 8 '' 1232 3 704 130 193 193 nil 27 8 'smalltalkTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 1472 nil nil nil 5 nil nil nil 1472 482 #{UI.Toolbar} #resource_Workspace_tools nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[123 0 0 0 25 0 0 0 246 0 0 0 50 0 0 0] 193 1504 8 '' 1472 3 704 130 193 193 nil 27 8 'workspaceTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 9 1539 #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 514 50 1 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 193 224 8 '' 192 3 50 5 752 1232 992 416 1472 130 193 193 nil 31 nil nil nil nil 370 #{Core.IdentityDictionary} 50 2 192 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 6 2886 4 #{UI.Menu} nil true 50 8 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileNew 8 '&New Workspace' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 2082 1 2114 #fileOpen 8 '&Open Workspace...' 9375 1 2162 nil true 2194 8 'OpenWorkspace.ico' 2256 65541 nil nil nil 2082 1 2114 #fileFileIn 8 '&File In...' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2082 1 2114 #saveImage 8 'Sa&ve Image' 1 1 2162 nil true 2194 8 'Snapshot.ico' 2256 65541 nil nil nil 2082 1 2114 #smalltalkExit 8 'E&xit Dolphin' 1 1 2162 nil true 2194 8 'PowerSwitch.ico' 2256 65541 nil nil nil 2434 4097 2082 1 2114 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 2034 nil true 50 12 2082 1 2114 #undo 8 '&Undo' 9397 1 2162 nil true 2194 8 'EditUndo.ico' 2256 65541 nil nil nil 2082 1 2114 #redo 8 'R&edo' 9395 1 2162 nil true 2194 8 'EditRedo.ico' 2256 65541 nil nil nil 2434 4097 2082 1 2114 #cutSelection 8 'Cu&t' 9393 1 2162 nil true 2194 8 'EditCut.ico' 2256 65541 nil nil nil 2082 1 2114 #copySelection 8 '&Copy' 9351 1 2162 nil true 2194 8 'EditCopy.ico' 2256 65541 nil nil nil 2082 1 2114 #pasteClipboard 8 '&Paste' 9389 1 2162 nil true 2194 8 'EditPaste.ico' 2256 65541 nil nil nil 2082 1 2114 #clearSelection 8 '&Delete' 1 1 2162 nil true 2194 8 'EditClear.ico' 2256 65541 nil nil nil 2082 1 2114 #selectAll 8 'Select &All' 9347 1 nil nil nil 2434 4097 2082 1 2114 #editFind 8 '&Find...' 9357 1 2162 nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 2082 1 2114 #findNext 8 'Find &Next' 1253 1 2162 nil true 2194 8 'FindNext.ico' 2256 65541 nil nil nil 2082 1 2114 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2034 nil true 50 14 2082 1 2114 #browseIt 8 '&Browse It' 9349 1 2162 nil true 2194 8 'ClassBrowserShell.ico' 2256 65541 nil nil nil 2082 1 2114 #displayIt 8 '&Display It' 9353 1 2162 nil true 2194 8 'DisplayIt.ico' 2256 65541 nil nil nil 2082 1 2114 #printIt 8 '&Print It' 9377 1 2162 nil true 2194 8 'PrintIt.ico' 2256 65541 nil nil nil 2082 1 2114 #evaluateIt 8 '&Evaluate It' 9355 1 2162 nil true 2194 8 'EvaluateIt.ico' 2256 65541 nil nil nil 2082 1 2114 #inspectIt 8 '&Inspect It' 9363 1 2162 nil true 2194 8 'BasicInspector.ico' 2256 65541 nil nil nil 2082 1 2114 #debugIt 8 'Deb&ug It' 1269 1 2162 nil true 2194 8 'Debugger.ico' 2256 65541 nil nil nil 2082 1 2114 #fileItIn 8 '&File It In' 1 1 nil nil nil 2434 4097 2082 1 2114 #accept 8 '&Accept' 9383 1 nil nil nil 2434 4097 2082 1 2114 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 2082 1 2114 #browseReferences 8 '&References...' 5367 1 nil nil nil 2434 4097 2034 nil true 50 9 2082 1 2114 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2082 1 2114 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2082 1 2114 #toggleLineEndings 8 'Line &Endings' 1 1 2722 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 2082 1 2114 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2082 1 2114 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2082 1 2114 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2082 1 2114 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 2434 4097 2034 nil true 50 3 2082 1 2114 518 #{Core.Message} #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 2082 1 2114 5090 #language: 8 #(#text) 8 '&Text' 1 1 nil nil nil 2082 1 2114 5090 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 2162 nil true 2194 8 'Preferences.ico' 2256 65541 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 2034 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 2034 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 2034 nil true 50 15 2082 1 2114 #helpContents 8 '&Contents' 1025 1 2162 nil true 2194 8 'Help.ico' 2256 65541 nil nil nil 2082 1 2114 #help 8 'On this &Tool' 1249 1 nil nil nil 2082 1 2114 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2434 4097 2082 1 2114 #learnSmalltalk 8 'Learn Smalltalk' 1 1 2722 8 $🎓 nil 338 #orchid 338 #white nil nil 1 nil nil nil nil 2434 4097 2082 1 2114 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2082 1 2114 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2082 1 2114 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2434 4097 2082 1 2114 #dolphinHomePage 8 'Dolphin Homepage' 1 1 2162 nil true 2194 8 '!!APPLICATION' 2256 65541 nil nil nil 2082 1 2114 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2082 1 2114 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2434 4097 2082 1 2114 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2722 8 $🐬 nil nil 338 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 514 50 1 562 #createWindow: 50 1 610 642 8 #[255 11 0 0 10 0 0 0 67 14 0 0 214 1 0 0] 193 80 8 '' 32 1 50 1 192 130 193 193 nil 27)! !

!Tools.InspectorShell class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
!

