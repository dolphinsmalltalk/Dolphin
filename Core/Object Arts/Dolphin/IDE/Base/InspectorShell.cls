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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground 328198 ##(Smalltalk.Point) 1161 921 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 560 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 560 327686 ##(Smalltalk.Color) #default 8 1877912960 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 63 1 498 553 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1136 nil nil nil 7 nil nil nil 1136 866 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 498 1 51 498 247 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 1088 1104 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 866 ##(Smalltalk.Toolbar) #resource_Image_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 498 1 1 498 63 51 1376 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1088 1104 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1616 nil nil nil 7 nil nil nil 1616 866 ##(Smalltalk.Toolbar) #resource_Workspace_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 498 247 51 498 247 51 1616 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 246 0 0 0 50 0 0 0] 1088 1104 nil 27 8 'workspaceTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1856 nil nil nil 7 nil nil nil 1856 866 ##(Smalltalk.Toolbar) #resource_Search_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 498 615 1 498 437 51 1856 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'searchTools' 170 192 1088 138 144 1088 nil nil 1 nil 498 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 498 1 1 498 1129 101 560 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 34 5 1376 800 1856 1136 1616 1104 nil 27 nil nil nil nil 170 192 34 2 560 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 265030 4 ##(Smalltalk.Menu) nil true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New Workspace' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2482 1 2514 #fileOpen 8 '&Open Workspace...' 9375 1 2562 nil true 2608 8 'OpenWorkspace.ico' 2656 nil nil 2482 1 2514 #fileFileIn 8 '&File In...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2482 1 2514 #saveImage 8 'Sa&ve Image' 1 1 2562 nil true 2608 8 'Snapshot.ico' 2656 nil nil 2482 1 2514 #smalltalkExit 8 'E&xit Dolphin' 1 1 2562 nil true 2608 8 'PowerSwitch.ico' 2656 nil nil 2818 4097 2482 1 2514 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 56895 nil nil 2434 nil true 34 12 2482 1 2514 #undo 8 '&Undo' 9397 1 2562 nil true 2608 8 'EditUndo.ico' 2656 nil nil 2482 1 2514 #redo 8 'R&edo' 9395 1 2562 nil true 2608 8 'EditRedo.ico' 2656 nil nil 2818 4097 2482 1 2514 #cutSelection 8 'Cu&t' 9393 1 2562 nil true 2608 8 'EditCut.ico' 2656 nil nil 2482 1 2514 #copySelection 8 '&Copy' 9351 1 2562 nil true 2608 8 'EditCopy.ico' 2656 nil nil 2482 1 2514 #pasteClipboard 8 '&Paste' 9389 1 2562 nil true 2608 8 'EditPaste.ico' 2656 nil nil 2482 1 2514 #clearSelection 8 '&Delete' 1 1 2562 nil true 2608 8 'EditClear.ico' 2656 nil nil 2482 1 2514 #selectAll 8 'Select &All' 9347 1 nil nil nil 2818 4097 2482 1 2514 #editFind 8 '&Find...' 9357 1 2562 nil true 2608 47 786694 ##(Smalltalk.ShellLibrary) nil nil 2482 1 2514 #findNext 8 'Find &Next' 1253 1 2562 nil true 2608 8 'FindNext.ico' 2656 nil nil 2482 1 2514 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 56917 nil nil 2434 nil true 34 14 2482 1 2514 #browseIt 8 '&Browse It' 9349 1 2562 nil true 2608 8 'ClassBrowserShell.ico' 2656 nil nil 2482 1 2514 #displayIt 8 '&Display It' 9353 1 2562 nil true 2608 8 'DisplayIt.ico' 2656 nil nil 2482 1 2514 #printIt 8 '&Print It' 9377 1 2562 nil true 2608 8 'PrintIt.ico' 2656 nil nil 2482 1 2514 #evaluateIt 8 '&Evaluate It' 9355 1 2562 nil true 2608 8 'EvaluateIt.ico' 2656 nil nil 2482 1 2514 #inspectIt 8 '&Inspect It' 9363 1 2562 nil true 2608 8 'BasicInspector.ico' 2656 nil nil 2482 1 2514 #debugIt 8 'Deb&ug It' 1269 1 2562 nil true 2608 8 'Debugger.ico' 2656 nil nil 2482 1 2514 #fileItIn 8 '&File It In' 1 1 nil nil nil 2818 4097 2482 1 2514 #accept 8 '&Accept' 9383 1 nil nil nil 2818 4097 2482 1 2514 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 2482 1 2514 #browseReferences 8 '&References...' 5367 1 nil nil nil 2818 4097 2434 nil true 34 9 2482 1 2514 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2482 1 2514 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2482 1 2514 #toggleLineEndings 8 'Line &Endings' 1 1 3074 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 2482 1 2514 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2482 1 2514 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2482 1 2514 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2482 1 2514 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 2818 4097 2434 nil true 34 3 2482 1 2514 459270 ##(Smalltalk.Message) #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 2482 1 2514 5186 #language: 8 #(#text) 8 '&Text' 1 1 nil nil nil 2482 1 2514 5186 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 56959 nil nil 8 '&Options' nil 134217729 2562 nil true 2608 8 'Preferences.ico' 2656 nil 56961 nil nil 8 '&Workspace' nil 134217729 nil nil 56963 nil nil 2434 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 56965 nil nil 2434 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 56967 nil nil 2434 nil true 34 15 2482 1 2514 #helpContents 8 '&Contents' 1025 1 2562 nil true 2608 8 'Help.ico' 2656 nil nil 2482 1 2514 #help 8 'On this &Tool' 1249 1 nil nil nil 2482 1 2514 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2818 4097 2482 1 2514 #learnSmalltalk 8 'Learn Smalltalk' 1 1 3074 $\x1F393 nil 722 #orchid 722 #white nil nil 1 nil nil nil nil 2818 4097 2482 1 2514 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2482 1 2514 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2482 1 2514 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2818 4097 2482 1 2514 #dolphinHomePage 8 'Dolphin Homepage' 1 1 2562 nil true 2608 8 '!!APPLICATION' 2656 nil nil 2482 1 2514 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2482 1 2514 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2818 4097 2482 1 2514 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3074 $\x1F42C nil nil 722 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 498 6143 21 498 1161 921 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 67 14 0 0 214 1 0 0] 34 1 560 1104 nil 27)! !

!InspectorShell class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
!

