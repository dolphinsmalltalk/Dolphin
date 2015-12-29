"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #InspectorShell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InspectorShell guid: (GUID fromString: '{87B4C6BE-026E-11D3-9FD7-00A0CC3E4A32}')!
InspectorShell comment: 'InspectorShell is a <SmalltalkToolShell> that implements the various inspector tools. Note that this is really just a "shell" around the real functionality which is obtained by embedding one of a number of <Inspector> presenters. The particular <Inspector> subclass chosen is determined by the type of the object being inspected.


'!
!InspectorShell categoriesForClass!Development!MVP-Presenters! !
!InspectorShell methodsFor!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self hasCommandHistory: true! !
!InspectorShell categoriesFor: #initialize!initializing!private! !

!InspectorShell class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Inspector'
!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 328198 ##(Smalltalk.Point)  1161 921 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851532 131073 592 0 482 512 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 530 193 193 0 592 482 512 8 4294902647 234 256 98 8 410 8 ##(Smalltalk.ReferenceView)  98 14 0 592 98 2 8 1140850688 131073 848 0 0 0 7 0 0 0 848 1180166 ##(Smalltalk.ResourceIdentifier)  608 8 #resource_Edit_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 530 1 51 530 247 51 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 98 0 530 193 193 0 27 8 'editTools' 410 864 98 14 0 592 98 2 8 1140850688 131073 1232 0 0 0 7 0 0 0 1232 930 608 8 #resource_Image_tools 0 978 202 208 98 1 1042 1072 98 2 530 1 1 530 63 51 1232 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1184 1200 0 27 8 'imageTools' 410 864 98 14 0 592 98 2 8 1140850688 131073 1488 0 0 0 7 0 0 0 1488 930 608 8 #resource_Workspace_tools 0 978 202 208 98 1 1042 1072 98 2 530 247 51 530 155 51 1488 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 200 0 0 0 50 0 0 0] 1184 1200 0 27 8 'workspaceTools' 410 864 98 14 0 592 98 2 8 1140850688 131073 1744 0 0 0 7 0 0 0 1744 930 608 8 #resource_Smalltalk_tools 0 978 202 208 98 1 1042 1072 98 2 530 63 1 530 991 51 1744 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1184 1200 0 27 8 'smalltalkTools' 234 256 1184 202 208 1184 234 240 1184 0 1 0 530 33 33 530 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 978 202 208 98 2 1042 1072 98 2 530 1 1 530 1129 101 592 1042 8 #updateSizePosted 1184 592 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 98 4 1232 1744 848 1488 1200 0 27 0 0 0 0 234 256 98 2 592 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 6 265030 4 ##(Smalltalk.Menu)  0 16 98 8 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FileNew.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr7.dll' 0 0 0 2450 1 2482 8 #fileOpen 8 '&Open...' 9375 1 2546 0 16 2592 8 'FileOpen.ico' 2640 0 0 2450 1 2482 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 2450 1 2482 8 #saveImage 8 'Sa&ve Image' 1 1 2546 0 16 2592 8 'Snapshot.ico' 2640 0 0 2450 1 2482 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 2546 0 16 2592 8 'PowerSwitch.ico' 2640 0 0 2834 4097 2450 1 2482 8 #exit 8 '&Close' 17639 1 2546 0 16 2592 8 'CloseWindow.ico' 2640 0 0 8 '&File' 0 134217729 0 0 14795 0 0 2402 0 16 98 12 2450 1 2482 8 #undo 8 '&Undo' 9397 1 2546 0 16 2592 8 'EditUndo.ico' 2640 0 0 2450 1 2482 8 #redo 8 'R&edo' 9395 1 2546 0 16 2592 8 'EditRedo.ico' 2640 0 0 2834 4097 2450 1 2482 8 #cutSelection 8 'Cu&t' 9393 1 2546 0 16 2592 8 'EditCut.ico' 2640 0 0 2450 1 2482 8 #copySelection 8 '&Copy' 9351 1 2546 0 16 2592 8 'EditCopy.ico' 2640 0 0 2450 1 2482 8 #pasteClipboard 8 '&Paste' 9389 1 2546 0 16 2592 8 'EditPaste.ico' 2640 0 0 2450 1 2482 8 #clearSelection 8 '&Delete' 1 1 2546 0 16 2592 8 'EditClear.ico' 2640 0 0 2450 1 2482 8 #selectAll 8 'Select &All' 9347 1 0 0 0 2834 4097 2450 1 2482 8 #editFind 8 '&Find...' 9357 1 2546 0 16 2592 47 786694 ##(Smalltalk.ShellLibrary)  0 0 2450 1 2482 8 #findNext 8 'Find &Next' 1253 1 2546 0 16 2592 8 'FindNext.ico' 2640 0 0 2450 1 2482 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 14817 0 0 2402 0 16 98 13 2450 1 2482 8 #browseIt 8 '&Browse It' 9349 1 2546 0 16 2592 8 'ClassBrowserShell.ico' 2640 0 0 2450 1 2482 8 #displayIt 8 '&Display It' 9353 1 2546 0 16 2592 8 'DisplayIt.ico' 2640 0 0 2450 1 2482 8 #evaluateIt 8 '&Evaluate It' 9355 1 2546 0 16 2592 8 'EvaluateIt.ico' 2640 0 0 2450 1 2482 8 #inspectIt 8 '&Inspect It' 9363 1 2546 0 16 2592 8 'BasicInspector.ico' 2640 0 0 2450 1 2482 8 #debugIt 8 'Deb&ug It' 1269 1 2546 0 16 2592 8 'Debugger.ico' 2640 0 0 2450 1 2482 8 #fileItIn 8 '&File It In' 1 1 0 0 0 2834 4097 2450 1 2482 8 #accept 8 '&Accept' 9383 1 0 0 0 2834 4097 2450 1 2482 8 #browseDefinitions 8 'Defi&nitions...' 1271 1 0 0 0 2450 1 2482 8 #browseReferences 8 '&References...' 5367 1 0 0 0 2834 4097 2402 0 16 98 9 2450 1 2482 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 2450 1 2482 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 2450 1 2482 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 2450 1 2482 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 2450 1 2482 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 2450 1 2482 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 2450 1 2482 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 2834 4097 2402 0 16 98 3 2450 1 2482 459270 ##(Smalltalk.Message)  8 #language: 98 1 8 #container 8 '&Smalltalk' 1 1 0 0 0 2450 1 2482 5554 5584 98 1 8 #text 8 '&Text' 1 1 0 0 0 2450 1 2482 5554 5584 98 1 8 #xml 8 '&Xml' 1 1 0 0 0 8 '&Language' 0 134217729 0 0 14857 0 0 8 '&Options' 0 134217729 0 0 14859 0 0 8 '&Workspace' 0 134217729 0 0 14861 0 0 2402 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 14863 0 0 2402 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 14865 0 0 2402 0 16 98 16 2450 1 2482 8 #helpContents 8 '&Contents' 1025 1 2546 0 16 2592 49 3984 0 0 2450 1 2482 8 #help 8 'On this &Tool' 1249 1 0 0 0 2450 1 2482 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 2834 4097 2450 1 2482 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 2834 4097 2450 1 2482 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2450 1 2482 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2450 1 2482 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 2402 0 16 98 4 2450 2097153 2482 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 2546 0 16 2592 8 'TipOfTheDay.ico' 2640 0 0 2450 1 2482 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 2546 0 16 2592 8 'TipOfTheDay.ico' 2640 0 0 2834 4097 2450 1 2482 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 14887 0 0 2834 4097 2450 1 2482 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2450 1 2482 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2450 1 2482 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 2834 4097 2450 1 2482 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2546 0 16 2592 8 '!!APPLICATION' 2640 0 0 8 '&Help' 0 134217729 0 0 14897 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 978 202 208 98 2 1042 1072 98 2 530 4999 21 530 1161 921 416 1042 8 #updateMenuBar 1184 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 9 0 0 10 0 0 0 7 12 0 0 214 1 0 0] 98 1 592 1200 0 27 )! !
!InspectorShell class categoriesFor: #displayOn:!displaying!public! !
!InspectorShell class categoriesFor: #icon!constants!public! !
!InspectorShell class categoriesFor: #resource_Default_view!public!resources-views! !

