"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'Tools.Tests.SmalltalkWorkspaceDocumentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.SmalltalkWorkspaceDocumentTest guid: (Core.GUID fromString: '{bfbd6640-c076-4597-81ac-28c7c2216d37}')!

Tools.Tests.SmalltalkWorkspaceDocumentTest comment: ''!

!Tools.Tests.SmalltalkWorkspaceDocumentTest methodsFor!

classToTest
	^SmalltalkWorkspaceDocument!

testDefaultPositioning
	"Test that newly opened workspaces, which usually have a saved default extent, open with expected extent and in a cascade."

	| workspaces |
	#nocreate.
	workspaces := OrderedCollection new.
	
	[| shell monitor i defaultExtent nextShell |
	shell := (workspaces add: self classToTest show) view.
	monitor := shell monitor.
	self assert: monitor identicalTo: DisplayMonitor active.
	defaultExtent := self classToTest defaultExtent
				ifNil: [monitor defaultWindowExtent]
				ifNotNil: [:ext | ext * monitor dpi // USER_DEFAULT_SCREEN_DPI].
	self assert: shell extent equals: defaultExtent.
	i := 1.
	
	[(i := i + 1) < 20 and: 
			[nextShell := (workspaces add: self classToTest show) view.
			nextShell position > shell position]]
			whileTrue: 
				[self assert: nextShell monitor identicalTo: monitor.
				self assert: nextShell extent equals: defaultExtent.
				self assert: nextShell position equals: shell position + monitor cascadeOffset.
				shell := nextShell].
	"Should have wrapped"
	self assert: nextShell position equals: monitor cascadeOffset]
			ensure: [workspaces do: [:each | each destroy]]!

viewClass
	^ShellView! !

!Tools.Tests.SmalltalkWorkspaceDocumentTest categoriesForMethods!
classToTest!helpers!private! !
testDefaultPositioning!public!unit tests! !
viewClass!constants!private! !
!

!Tools.Tests.SmalltalkWorkspaceDocumentTest class methodsFor!

resource_Default_view_D6

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4294967295 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851532 131073 560 0 482 8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point)  193 193 0 560 482 656 8 4294904369 234 256 98 4 410 8 ##(Smalltalk.ReferenceView)  98 14 0 560 98 2 8 1140850688 131073 848 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 848 1180166 ##(Smalltalk.ResourceIdentifier)  576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 63 1 754 991 51 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 754 193 193 0 27 8 'smalltalkTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1264 0 930 31 0 7 0 0 0 1264 962 576 8 #resource_Image_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 63 51 1264 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1216 1232 0 27 8 'imageTools' 234 256 1216 202 208 1216 234 240 1216 0 1 0 754 33 33 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 1010 202 208 98 2 1074 1104 98 2 754 1 1 754 1059 51 560 1074 8 #updateSize 1216 560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 17 2 0 0 25 0 0 0] 98 2 1264 848 1232 0 27 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140850956 1 1840 0 482 656 0 7 0 674 0 16 706 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 754 193 193 0 1840 0 8 4294904919 234 256 98 4 853766 ##(Smalltalk.StatusBarItem)  1 37 1840 0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association)  8 #Smalltalk 48 8 #developmentSystem 8 #changedIcon 8 #imageIndex 2096 7 257 0 0 8 'modified' 2050 1 -1 1840 0 459270 ##(Smalltalk.Message)  8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  8 'errors' 98 2 2064 2320 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 1840 0 0 1010 202 208 98 1 1074 1104 98 2 754 1 765 754 1059 45 1840 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 126 1 0 0 17 2 0 0 148 1 0 0] 98 0 1232 0 27 410 576 98 25 0 416 98 2 8 1140851596 131073 2672 0 482 656 0 7 0 674 0 16 706 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 754 193 193 0 2672 482 656 8 4294904369 234 256 98 8 410 864 98 14 0 2672 98 2 8 1140850688 131073 2880 0 0 0 7 0 0 0 2880 962 576 8 #resource_Edit_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 449 754 49 237 2880 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 224 0 0 0 24 0 0 0 86 1 0 0] 1216 1232 0 27 8 'edit tools' 410 864 98 14 0 2672 98 2 8 1140850688 131073 3136 0 0 0 7 0 0 0 3136 962 576 8 #resource_File_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 51 151 3136 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 25 0 0 0 75 0 0 0] 1216 1232 0 27 8 'file tools' 410 864 98 14 0 2672 98 2 8 1140850688 131073 3392 0 0 0 7 0 0 0 3392 962 576 8 #resource_Workspace_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 151 754 49 195 3392 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 75 0 0 0 24 0 0 0 172 0 0 0] 1216 1232 0 27 8 'workspace tools' 410 864 98 14 0 2672 98 2 8 1140850688 131073 3648 0 0 0 7 0 0 0 3648 962 576 8 #resource_Find_tools 0 1010 202 208 98 1 1074 1104 98 2 754 1 345 754 51 105 3648 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 172 0 0 0 25 0 0 0 224 0 0 0] 1216 1232 0 27 8 'find tools' 234 256 1216 98 0 234 240 1216 0 1 0 754 33 33 754 45 45 0 1618 1 1 1 1010 202 208 98 2 1074 1104 98 2 754 1009 51 754 51 715 2672 1074 1776 1216 2672 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 248 1 0 0 25 0 0 0 17 2 0 0 126 1 0 0] 98 4 3136 3392 3648 2880 1232 0 27 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 4176 0 0 0 7 0 0 0 4176 530 1 1 0 0 0 0 410 864 98 14 0 4176 98 2 8 1140916224 131073 4272 0 0 0 23 0 0 0 4272 962 8 ##(Smalltalk.SmalltalkWorkspace)  8 #resource_Default_view 0 1010 202 208 98 1 1074 1104 98 2 754 1 1 754 1009 715 4272 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 248 1 0 0 101 1 0 0] 1216 1232 0 27 234 256 98 2 4272 8 'workspace' 0 1010 202 208 98 1 1074 1104 98 2 754 1 51 754 1009 715 4176 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 248 1 0 0 126 1 0 0] 98 1 4272 1232 0 27 234 256 98 6 2672 8 'toolbar2' 1840 8 'statusbar' 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 6 265030 4 ##(Smalltalk.Menu)  0 16 98 12 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'DocumentShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 4914 1 4946 8 #fileOpen 8 '&Open...' 9375 1 5010 0 16 5056 8 'FileOpen.ico' 5104 0 0 4914 1 4946 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 4914 1 4946 8 #fileSave 8 '&Save' 9383 1 5010 0 16 5056 8 'FileSave.ico' 5104 0 0 4914 1 4946 8 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 4914 1 4946 8 #fileRevert 8 '&Revert' 1 1 5010 0 16 5056 8 'Revert.ico' 5104 0 0 5298 4097 4914 1 4946 8 #saveImage 8 'Sa&ve Image' 1 1 5010 0 16 5056 8 'Snapshot.ico' 5104 0 0 4914 1 4946 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 5010 0 16 5056 8 'PowerSwitch.ico' 5104 0 0 5298 4097 4914 1 4946 8 #exit 8 '&Close' 17639 1 5010 0 16 5056 8 'CloseWindow.ico' 5104 0 0 8 '&File' 0 134217729 0 0 22275 0 0 4866 0 16 98 12 4914 1 4946 8 #undo 8 '&Undo' 9397 1 5010 0 16 5056 8 'EditUndo.ico' 5104 0 0 4914 1 4946 8 #redo 8 'R&edo' 9395 1 5010 0 16 5056 8 'EditRedo.ico' 5104 0 0 5298 4097 4914 1 4946 8 #cutSelection 8 'Cu&t' 9393 1 5010 0 16 5056 8 'EditCut.ico' 5104 0 0 4914 1 4946 8 #copySelection 8 '&Copy' 9351 1 5010 0 16 5056 8 'EditCopy.ico' 5104 0 0 4914 1 4946 8 #pasteClipboard 8 '&Paste' 9389 1 5010 0 16 5056 8 'EditPaste.ico' 5104 0 0 4914 1 4946 8 #clearSelection 8 '&Delete' 1 1 5010 0 16 5056 8 'EditClear.ico' 5104 0 0 4914 1 4946 8 #selectAll 8 'Select &All' 9347 1 0 0 0 5298 4097 4914 1 4946 8 #editFind 8 '&Find...' 9357 1 5010 0 16 5056 47 786694 ##(Smalltalk.ShellLibrary)  0 0 4914 1 4946 8 #findNext 8 'Find &Next' 1253 1 5010 0 16 5056 8 'FindNext.ico' 5104 0 0 4914 1 4946 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 22297 0 0 4866 0 16 98 16 4914 1 4946 8 #browseIt 8 '&Browse It' 9349 1 5010 0 16 5056 8 'ClassBrowserShell.ico' 5104 0 0 4914 1 4946 8 #displayIt 8 '&Display It' 9353 1 5010 0 16 5056 8 'DisplayIt.ico' 5104 0 0 4914 1 4946 8 #evaluateIt 8 '&Evaluate It' 9355 1 5010 0 16 5056 8 'EvaluateIt.ico' 5104 0 0 4914 1 4946 8 #inspectIt 8 '&Inspect It' 9363 1 5010 0 16 5056 8 'InspectIt.ico' 5104 0 0 4914 1 4946 8 #debugIt 8 'Deb&ug It' 1269 1 5010 0 16 5056 8 'Debugger.ico' 5104 0 0 4914 1 4946 8 #fileItIn 8 '&File it In' 1 1 0 0 0 5298 4097 4914 1 4946 8 #chooseEvaluationPools 8 '&Pools...' 1 1 5010 0 16 5056 8 'Dictionary.ico' 5104 0 0 4914 1 4946 8 #inspectWorkspacePool 8 '&Variables' 1 1 0 0 0 5298 4097 4914 1 4946 8 #browseDefinitions 8 'Defi&nitions...' 1271 1 0 0 0 4914 1 4946 8 #browseReferences 8 '&References...' 5367 1 0 0 0 5298 4097 4914 1 4946 8 #clear 8 'C&lear' 1 1 5010 0 16 5056 8 'ClearDocument.ico' 5104 0 0 5298 4097 4866 0 16 98 9 4914 1 4946 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 4914 1 4946 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 4914 1 4946 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 4914 1 4946 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 4914 1 4946 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 4914 1 4946 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 4914 1 4946 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 5298 4097 4866 0 16 98 3 4914 1 4946 2338 8 #language: 98 1 8 #container 8 '&Smalltalk' 1 1 0 0 0 4914 1 4946 2338 8512 98 1 8 #text 8 '&Text' 1 1 0 0 0 4914 1 4946 2338 8512 98 1 8 #xml 8 '&Xml' 1 1 0 0 0 8 '&Language' 0 134217729 0 0 22341 0 0 8 '&Options' 0 134217729 0 0 22343 0 0 8 '&Workspace' 0 134217729 0 0 22345 0 0 4866 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 22347 0 0 4866 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 22349 0 0 4866 0 16 98 19 4914 1 4946 8 #helpContents 8 '&Contents' 1025 1 5010 0 16 5056 49 6720 0 0 4914 1 4946 8 #help 8 'On this &Tool' 1249 1 0 0 0 4914 1 4946 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5298 4097 4914 1 4946 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 5298 4097 4914 1 4946 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 4914 1 4946 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 4914 1 4946 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 4866 0 16 98 4 4914 2097153 4946 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 5010 0 16 5056 8 'TipOfTheDay.ico' 5104 0 0 4914 1 4946 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 5010 0 16 5056 8 'TipOfTheDay.ico' 5104 0 0 5298 4097 4914 1 4946 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 22371 0 0 5298 4097 4914 1 4946 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 4914 1 4946 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 4914 1 4946 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 4914 1 4946 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 5298 4097 4914 1 4946 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 5010 0 16 5056 8 'LiveUpdate.ico' 5104 0 0 5298 4097 4914 1 4946 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5010 0 16 5056 8 '!!APPLICATION' 5104 0 0 8 '&Help' 0 134217729 0 0 22385 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1010 202 208 98 2 1074 1104 98 2 754 2799 21 754 1091 921 416 1074 8 #updateMenuBar 1216 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 152 7 0 0 214 1 0 0] 98 4 560 2672 4176 1840 1232 0 27 )! !

!Tools.Tests.SmalltalkWorkspaceDocumentTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
!

