"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #TutorialPlayer
	instanceVariableNames: 'tutorialPosition tutorial title workspace'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TutorialPlayer guid: (GUID fromString: '{0ba31b85-7347-43e6-87d6-5f582babde3d}')!
TutorialPlayer comment: 'I can navigate through an AbstractTutorial subclass. With #next and #previous you can go forward and backward through the tutorial.'!
!TutorialPlayer categoriesForClass!Unclassified! !
!TutorialPlayer methodsFor!

createComponents
	super createComponents.
	title := self add: TextPresenter new name: 'title'.
	workspace := self add: SmalltalkWorkspace new name: 'workspace'.
!

currentLesson
	^ self tutorial lessonAt: self tutorialPosition.
!

displayIt
	workspace
		setFocus;
		displayIt!

evaluateIt
	workspace
		setFocus;
		evaluateIt!

first
	self rewind.
	^self updateLesson
!

inspectIt
	workspace
		setFocus;
		inspectIt!

last
	tutorialPosition := self size.
	^ self updateLesson
!

model: aTutorial
	super model: aTutorial.
	self updateLesson
!

next
	self tutorialPosition < self size
		ifTrue: [tutorialPosition := tutorialPosition + 1].
	
	^ self updateLesson
!

onViewOpened
	super onViewOpened.

	"Workspaces font is set by system options, Override this here."
	workspace view font: self view font.

	self updateLesson
!

previous
	tutorialPosition >  1 ifTrue: [tutorialPosition := tutorialPosition  - 1].
	^ self updateLesson
!

printIt
	workspace
		setFocus;
		printIt!

reload
	^self updateLesson!

rewind
	tutorialPosition := 1.
	^self updateLesson
!

size
	^ self tutorial size
!

tutorial
	^self model
!

tutorial: aTutorial
	self model: aTutorial.
	self updateLesson
!

tutorialPosition 
	^ tutorialPosition  ifNil: [
		self rewind.
		tutorialPosition.
	].
!

tutorialPosition: aTutorialPosition 
	tutorialPosition := aTutorialPosition
!

updateLesson
	| lesson |
	lesson := self currentLesson.
	title value: lesson title.
	workspace text: lesson contents.
	self caption: ('<1d> - Lesson <2d>/<3d>' 
				expandMacrosWith: self tutorial name
				with: self tutorialPosition
				with: self tutorial tableOfContents size).
	^lesson! !
!TutorialPlayer categoriesFor: #createComponents!accessing!private! !
!TutorialPlayer categoriesFor: #currentLesson!accessing!public! !
!TutorialPlayer categoriesFor: #displayIt!commands!public! !
!TutorialPlayer categoriesFor: #evaluateIt!commands!public! !
!TutorialPlayer categoriesFor: #first!navigation!public! !
!TutorialPlayer categoriesFor: #inspectIt!commands!public! !
!TutorialPlayer categoriesFor: #last!navigation!public! !
!TutorialPlayer categoriesFor: #model:!accessing!private! !
!TutorialPlayer categoriesFor: #next!navigation!public! !
!TutorialPlayer categoriesFor: #onViewOpened!accessing!private! !
!TutorialPlayer categoriesFor: #previous!navigation!public! !
!TutorialPlayer categoriesFor: #printIt!commands!public! !
!TutorialPlayer categoriesFor: #reload!navigation!public! !
!TutorialPlayer categoriesFor: #rewind!navigation!public! !
!TutorialPlayer categoriesFor: #size!accessing!public! !
!TutorialPlayer categoriesFor: #tutorial!accessing!public! !
!TutorialPlayer categoriesFor: #tutorial:!accessing!public! !
!TutorialPlayer categoriesFor: #tutorialPosition!accessing!public! !
!TutorialPlayer categoriesFor: #tutorialPosition:!accessing!public! !
!TutorialPlayer categoriesFor: #updateLesson!accessing!private! !

!TutorialPlayer class methodsFor!

defaultModel 	
	^AbstractTutorial new!

icon
	^AbstractTutorial icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1321 1321 517 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil 466 #orchid nil 7 nil nil nil 656 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.GdiplusImageView) 34 28 nil 656 34 2 8 1140850944 1 800 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 720 466 #white nil nil 1 nil nil nil nil 7 nil nil nil 800 nil 8 4294902331 852486 ##(Smalltalk.NullConverter) nil nil nil 944 #scaleToFit 1 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 nil nil #none nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1101 7 498 129 129 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 2 0 0 3 0 0 0 102 2 0 0 67 0 0 0] 8 #() 498 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentRight -147 1346 #fixedViewLeft 129 1346 #fixedParentTop -37 1346 #fixedViewTop 129 410 ##(Smalltalk.StaticText) 34 16 nil 656 34 2 8 1140850944 1 1424 nil nil nil 7 nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 1424 960 8 1867478992 994 nil nil nil 1090 138 144 34 2 1154 #createAt:extent: 34 2 498 21 45 498 1061 97 1424 1154 #text: 34 1 8 'Title' 1424 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 22 0 0 0 28 2 0 0 70 0 0 0] 8 #() 1296 nil 27 1314 1346 #fixedParentLeft 1 1360 -167 1392 1 1408 97 170 192 34 4 800 8 'badge' 1424 8 'title' 1026 498 21 45 498 1 1 1090 138 144 34 1 1154 #createAt:extent: 34 2 498 21 21 498 1249 141 656 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 122 2 0 0 80 0 0 0] 34 2 1424 800 1296 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2096 nil 720 nil 7 nil 530 nil true 562 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 2096 738 170 176 34 12 410 ##(Smalltalk.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 2272 nil nil nil 519 nil nil nil 2272 480 8 1868135504 1180998 4 ##(Smalltalk.CommandDescription) #displayIt 8 'Display It' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 221 23 498 201 33 2272 1154 #isEnabled: 8 #(false) 2272 1154 #text: 34 1 8 '<a>Display It</a>' 2272 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 11 0 0 0 210 0 0 0 27 0 0 0] 8 #() 1296 nil 27 1314 1808 201 1376 201 1392 1 1408 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 2656 nil nil nil 519 nil nil nil 2656 480 8 1868135504 2354 #inspectIt 8 'Inspect It' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 421 23 498 201 33 2656 1154 #isEnabled: 8 #(false) 2656 1154 #text: 34 1 8 '<a>Inspect It</a>' 2656 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 11 0 0 0 54 1 0 0 27 0 0 0] 8 #() 1296 nil 27 1314 1808 401 1376 201 1392 1 1408 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 3024 nil nil nil 519 nil nil nil 3024 480 8 1868135504 2354 #next 8 'Next' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 1009 25 498 121 41 3024 1154 #isEnabled: 8 #(false) 3024 1154 #text: 34 1 8 '<a>Next</a>' 3024 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 248 1 0 0 12 0 0 0 52 2 0 0 32 0 0 0] 8 #() 1296 nil 27 1314 1360 -239 1376 121 1392 3 1408 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 3392 nil nil nil 519 nil nil nil 3392 480 8 1868135504 2354 #evaluateIt 8 'Evaluate It' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 21 23 498 201 33 3392 1154 #isEnabled: 8 #(false) 3392 1154 #text: 34 1 8 '<a>Evaluate It</a>' 3392 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 110 0 0 0 27 0 0 0] 8 #() 1296 nil 27 1314 1808 1 1376 201 1392 1 1408 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 3760 nil nil nil 519 nil nil nil 3760 480 8 1868135504 2354 #previous 8 'Previous' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 839 25 498 121 41 3760 1154 #isEnabled: 8 #(false) 3760 1154 #text: 34 1 8 '<a>Previous</a>' 3760 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 1 0 0 12 0 0 0 223 1 0 0 32 0 0 0] 8 #() 1296 nil 27 1314 1360 -409 1376 121 1392 3 1408 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2096 34 2 8 1140850688 65 4128 nil nil nil 519 nil nil nil 4128 480 8 1868135504 2354 #reload 8 'Reload' 1 1 nil 1090 138 144 34 3 1154 #createAt:extent: 34 2 498 1129 25 498 91 41 4128 1154 #isEnabled: 8 #(false) 4128 1154 #text: 34 1 8 '<a>Reload</a>' 4128 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 2 0 0 12 0 0 0 97 2 0 0 32 0 0 0] 8 #() 1296 nil 27 1314 1360 -119 1376 91 1392 3 1408 41 170 192 8 #() 1026 498 21 23 498 1 1 1090 138 144 34 1 1154 #createAt:extent: 34 2 498 21 1143 498 1249 81 2096 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 59 2 0 0 122 2 0 0 99 2 0 0] 34 6 3392 2272 2656 3760 3024 4128 1296 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 4736 nil nil nil 7 nil nil nil 4736 626 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 4736 34 2 8 1411387716 1 4816 866 nil false 912 nil 960 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 2354 #cutSelection 8 'Cu&t' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditCut.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4946 1 2354 #copySelection 8 '&Copy' 1 1 5010 nil true 5056 8 'EditCopy.ico' 5104 nil nil 4946 1 2354 #pasteClipboard 8 '&Paste' 1 1 5010 nil true 5056 8 'EditPaste.ico' 5104 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4946 1 2354 #browseIt 8 'Bro&wse It' 1 1 5010 nil true 5056 8 'ClassBrowserShell.ico' 5104 nil nil 4946 1 2354 #displayIt 8 '&Display It' 1 1 5010 nil true 5056 8 'DisplayIt.ico' 5104 nil nil 4946 1 2354 #printIt 8 'P&rint It' 1 1 5010 nil true 5056 8 'PrintIt.ico' 5104 nil nil 4946 1 2354 #evaluateIt 8 'E&valuate It' 1 1 5010 nil true 5056 8 'EvaluateIt.ico' 5104 nil nil 4946 1 2354 #inspectIt 8 '&Inspect It' 1 1 5010 nil true 5056 8 'InspectIt.ico' 5104 nil nil 4946 1 2354 #debugIt 8 'Deb&ug It' 1 1 5010 nil true 5056 8 'Debugger.ico' 5104 nil nil 5298 4097 4898 nil true 34 9 4946 1 2354 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4946 1 2354 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4946 1 2354 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 4946 1 2354 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4946 1 2354 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4946 1 2354 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4946 1 2354 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5298 4097 4898 nil true 34 2 4946 1 2354 459270 ##(Smalltalk.Message) #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4946 1 2354 6274 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 4816 nil 8 1533163101 994 nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 6594 77 466 #gray 960 1 nil nil nil nil #callTip nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 4512 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 4816 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 4512 nil 170 176 4512 9215 nil nil nil nil 466 #silver nil nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 6560 nil nil nil nil 130003 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 4816 466 #blue 3 false #Warning nil nil nil nil nil nil #Notification 6978 17 4816 466 #commonGreen 11 false #Notification nil nil nil nil nil nil #Error 6978 21 4816 466 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 6594 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Notification 6594 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Error 6594 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1090 138 144 34 11 1154 #createAt:extent: 34 2 498 21 21 498 1209 943 4816 1154 #contextMenu: 34 1 4912 4816 1154 #textLimit: 8 #(1073741823) 4816 1154 #hoverTime: 8 #(500) 4816 1154 #caretPeriod: 8 #(530) 4816 1154 #wordWrap: 8 #(true) 4816 1154 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 4816 1 3 nil nil 5 nil 7570 3 4816 1 nil nil 67108863 5 nil 7570 5 4816 1 nil nil nil 5 nil 4816 1154 #tabWidth: 8 #(4) 4816 1154 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 4816 1154 #maxCompletionListHeight: 8 #(9) 4816 1154 #edgeColumn: 8 #(1) 4816 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 102 2 0 0 225 1 0 0] 8 #() 1296 nil 29 170 192 34 2 4816 8 'workspace' 1026 498 21 21 498 21 21 1090 138 144 34 1 1154 #createAt:extent: 34 2 498 21 161 498 1249 983 4736 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 80 0 0 0 122 2 0 0 59 2 0 0] 34 1 4816 1296 nil 27 170 192 34 6 4736 8 'content' 2096 8 'footer' 656 8 'header' 1026 498 21 21 498 21 21 nil nil nil nil 1 nil nil nil 498 1071 711 1 nil nil 1090 138 144 34 2 1154 #createAt:extent: 34 2 498 7039 21 498 1321 1321 416 1154 #updateMenuBar 4512 416 1234 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 83 16 0 0 158 2 0 0] 34 3 656 4736 2096 1296 nil 27 )! !
!TutorialPlayer class categoriesFor: #defaultModel!public! !
!TutorialPlayer class categoriesFor: #icon!constants!public! !
!TutorialPlayer class categoriesFor: #resource_Default_view!public!resources-views! !

