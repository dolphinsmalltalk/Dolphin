"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #StsMethodComparisonShell
	instanceVariableNames: 'comparisonModel sourcePresenter1 sourcePresenter2 status1 status2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsMethodComparisonShell guid: (GUID fromString: '{2826F051-3F9D-11D4-B102-000000000000}')!
StsMethodComparisonShell comment: ''!
!StsMethodComparisonShell categoriesForClass!Unclassified! !
!StsMethodComparisonShell methodsFor!

buttonDiffBrowser
	(DifferencesPresenter show)
		beforeTitle: status1 model value;
		afterTitle: status2 model value;
		compare: sourcePresenter1 text with: sourcePresenter2 text!

buttonNextDifference
	| diff |
	(diff := comparisonModel nextDifference) isNil ifTrue: [^self].
	sourcePresenter1 view selectionRange: (comparisonModel getRange1: diff).
	sourcePresenter2 view selectionRange: (comparisonModel getRange2: diff)!

createComponents
	super createComponents.
	sourcePresenter1 := self add: SmalltalkWorkspace new name: 'sourcePresenter1'.
	sourcePresenter2 := self add: SmalltalkWorkspace new name: 'sourcePresenter2'.
	status1 := self add: TextPresenter new name: 'errors1'.
	status2 := self add: TextPresenter new name: 'errors2'!

defaultHelpId
	^10903!

setMethod1: methodEdition1 method2: methodEdition2 
	comparisonModel := StsSourceComparisonModel new compare: methodEdition1 source
				with: methodEdition2 source.
	sourcePresenter1
		text: methodEdition1 source;
		evaluationContext: methodEdition1 methodClass.
	sourcePresenter2
		text: methodEdition2 source;
		evaluationContext: methodEdition2 methodClass.
	status1 value: methodEdition1.
	status2 value: methodEdition2! !
!StsMethodComparisonShell categoriesFor: #buttonDiffBrowser!private! !
!StsMethodComparisonShell categoriesFor: #buttonNextDifference!private! !
!StsMethodComparisonShell categoriesFor: #createComponents!private! !
!StsMethodComparisonShell categoriesFor: #defaultHelpId!public! !
!StsMethodComparisonShell categoriesFor: #setMethod1:method2:!public! !

!StsMethodComparisonShell class methodsFor!

displayOn: aStream 
	aStream nextPutAll: 'Method Comparison Browser'!

icon
	^StsMethodEdition icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851500 131137 560 0 482 512 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 560 482 512 8 4294902647 234 256 98 4 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 832 0 0 0 7 0 0 0 832 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 738 63 1 738 991 51 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 738 193 193 0 27 8 'smalltalkTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1216 0 0 0 7 0 0 0 1216 914 576 8 #resource_Image_tools 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 63 51 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1168 1184 0 27 8 'imageTools' 234 256 1168 98 0 234 240 1168 0 1 0 738 33 31 738 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 962 202 208 98 2 1026 1056 98 2 738 1 1 738 1249 51 560 1026 8 #updateSizePosted 1168 560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 98 2 1216 832 1184 0 27 0 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 1776 0 482 512 0 7 0 0 0 1776 1180166 ##(Smalltalk.ProportionalLayout) 234 240 1168 16 234 256 1168 0 962 202 208 98 1 1026 1056 98 2 738 1 51 738 1249 793 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 165 1 0 0] 98 3 410 1792 98 15 0 1776 98 2 8 1140850688 131073 2096 0 482 512 0 7 0 0 0 2096 530 1 1 0 410 8 ##(Smalltalk.StatusBar) 98 18 0 2096 98 2 8 1140850700 1 2192 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 658 0 16 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 738 193 193 0 2192 0 8 4294902455 234 256 98 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 2192 0 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors1' 202 208 98 1 2432 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2192 0 0 962 202 208 98 1 1026 1056 98 2 738 1 347 738 1249 45 2192 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 0 0 0 112 2 0 0 195 0 0 0] 98 0 1184 0 27 0 0 410 848 98 14 0 2096 98 2 8 1140916224 131073 2752 0 0 0 23 0 0 0 2752 914 8 ##(Smalltalk.SmalltalkWorkspace) 8 #resource_Default_view 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 1249 347 2752 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 173 0 0 0] 1168 1184 0 27 234 256 98 2 2752 8 'sourcePresenter1' 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 1249 391 2096 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 195 0 0 0] 98 2 2752 2192 1184 0 27 410 8 ##(Smalltalk.Splitter) 98 12 0 1776 98 2 8 1140850688 1 3216 0 482 512 0 519 0 0 0 3216 962 202 208 98 1 1026 1056 98 2 738 1 391 738 1249 11 3216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 195 0 0 0 112 2 0 0 200 0 0 0] 98 0 1184 0 27 410 1792 98 15 0 1776 98 2 8 1140850688 131073 3472 0 482 512 0 7 0 0 0 3472 530 1 1 410 1792 98 15 0 3472 98 2 8 1140850688 131073 3568 0 0 0 7 0 0 0 3568 530 1 1 0 0 410 8 ##(Smalltalk.PushButton) 98 20 0 3568 98 2 8 1140924416 1 3648 0 482 8 4278190080 0 7 0 0 0 3648 0 8 4294902067 1180998 4 ##(Smalltalk.CommandDescription) 8 #buttonDiffBrowser 8 '&Browse differences' 1 1 0 0 32 0 0 0 962 202 208 98 3 1026 1056 98 2 738 1009 1 738 241 39 3648 1026 8 #isEnabled: 98 1 32 3648 1026 8 #text: 98 1 8 '&Browse differences' 3648 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 248 1 0 0 0 0 0 0 112 2 0 0 19 0 0 0] 98 0 1184 0 29 0 410 3664 98 20 0 3568 98 2 8 1140924416 1 4112 0 482 3744 0 7 0 0 0 4112 0 8 4294902067 3778 8 #buttonNextDifference 8 '&Next difference' 1 1 0 0 32 0 0 0 962 202 208 98 3 1026 1056 98 2 738 1 1 738 1009 39 4112 1026 3968 98 1 32 4112 1026 4016 98 1 8 '&Next difference' 4112 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 248 1 0 0 19 0 0 0] 98 0 1184 0 29 234 256 1168 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 1249 39 3568 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 19 0 0 0] 98 2 4112 3648 1184 0 27 410 2208 98 18 0 3472 98 2 8 1140850956 1 4672 0 2274 31 0 7 0 658 0 16 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 738 193 193 0 4672 0 8 4294902455 234 256 98 2 2418 1 -1 4672 0 2448 2464 2496 8 'errors2' 202 208 98 1 4864 2562 513 1 4672 0 0 962 202 208 98 1 1026 1056 98 2 738 1 349 738 1249 45 4672 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 174 0 0 0 112 2 0 0 196 0 0 0] 98 0 1184 0 27 0 0 410 848 98 14 0 3472 98 2 8 1140916224 131073 5104 0 0 0 23 0 0 0 5104 914 2832 2848 0 962 202 208 98 1 1026 1056 98 2 738 1 39 738 1249 311 5104 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 112 2 0 0 174 0 0 0] 1168 1184 0 27 234 256 98 2 5104 8 'sourcePresenter2' 0 962 202 208 98 1 1026 1056 98 2 738 1 401 738 1249 393 3472 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 200 0 0 0 112 2 0 0 140 1 0 0] 98 3 3568 5104 4672 1184 0 27 1184 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 6 265030 4 ##(Smalltalk.Menu) 0 16 98 9 984134 2 ##(Smalltalk.CommandMenuItem) 1 3778 8 #fileNew 8 '&New' 8349 1 0 0 0 5682 1 3778 8 #fileOpen 8 '&Open...' 8351 1 0 0 0 5682 1 3778 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5682 1 3778 8 #saveImage 8 'Sa&ve Image' 1 1 0 0 0 5682 1 3778 8 #saveImageAs 8 'Save Image As...' 1 1 0 0 0 5682 1 3778 8 #compressChanges 8 '&Compress Changes' 1 1 0 0 0 5890 4097 5682 1 3778 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 0 0 0 8 '&File' 0 1 0 0 21583 0 0 5634 0 16 98 11 5682 1 3778 8 #undo 8 '&Undo' 8373 1 0 0 0 5890 4097 5682 1 3778 8 #cutSelection 8 'Cu&t' 8369 1 0 0 0 5682 1 3778 8 #copySelection 8 '&Copy' 8327 1 0 0 0 5682 1 3778 8 #pasteClipboard 8 '&Paste' 8365 1 0 0 0 5682 1 3778 8 #clearSelection 8 '&Delete' 1 1 0 0 0 5682 1 3778 8 #selectAll 8 'Select &All' 1 1 0 0 0 5890 4097 5682 1 3778 8 #find 8 '&Find...' 8333 1 0 0 0 5682 1 3778 8 #findNext 8 'Find &Next' 229 1 0 0 0 5682 1 3778 8 #findReplace 8 '&Replace...' 8337 1 0 0 0 8 '&Edit' 0 1 0 0 21603 0 0 5634 0 16 98 7 5682 1 3778 8 #browseIt 8 '&Browse It' 8325 1 0 0 0 5682 1 3778 8 #displayIt 8 '&Display It' 8329 1 0 0 0 5682 1 3778 8 #evaluateIt 8 '&Evaluate It' 8331 1 0 0 0 5682 1 3778 8 #inspectIt 8 '&Inspect It' 8339 1 0 0 0 5682 1 3778 8 #fileItIn 8 '&File It In' 1 1 0 0 0 5890 4097 5682 1 3778 8 #accept 8 '&Accept' 8359 1 0 0 0 8 '&Workspace' 0 1 0 0 21617 0 0 5634 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 21619 0 0 5634 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 21621 0 0 5634 0 16 98 16 5682 1 3778 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) 0 0 5682 1 3778 8 #help 8 'On this &Tool' 1249 1 0 0 0 5682 1 3778 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5890 4097 5682 1 3778 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 5890 4097 5682 1 3778 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 5682 1 3778 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 5682 1 3778 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5634 0 16 98 4 5682 2097153 3778 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 7538 0 16 7584 8 'TipOfTheDay.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 5682 1 3778 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 7538 0 16 7584 8 'TipOfTheDay.ico' 8192 0 0 5890 4097 5682 1 3778 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 21643 0 0 5890 4097 5682 1 3778 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 5682 1 3778 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 5682 1 3778 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5890 4097 5682 1 3778 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7538 0 16 7584 8 '!!APPLICATION' 8192 0 0 8 '&Help' 0 134217729 0 0 21653 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 962 202 208 98 3 1026 1056 98 2 738 4999 21 738 1281 961 416 1026 4016 98 1 8 'Method Comparison Browser' 416 1026 8 #updateMenuBar 1168 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 9 0 0 10 0 0 0 67 12 0 0 234 1 0 0] 98 2 560 1776 1184 0 27)! !
!StsMethodComparisonShell class categoriesFor: #displayOn:!public! !
!StsMethodComparisonShell class categoriesFor: #icon!public! !
!StsMethodComparisonShell class categoriesFor: #resource_Default_view!public!resources-views! !

