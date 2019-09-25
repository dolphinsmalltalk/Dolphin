"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #TutorialPlayer
	instanceVariableNames: 'tutorialPosition tutorial title workspace'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1321 1321 549 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil 466 #orchid nil 7 nil nil nil 656 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.GdiplusImageView) 34 28 nil 656 34 2 8 1140850944 1 800 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 466 #orchid 466 #white nil nil 1 nil nil nil nil 7 nil nil nil 800 nil 8 4294902331 852486 ##(Smalltalk.NullConverter) nil nil nil 944 #scaleToFit 1 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 nil nil #none nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1101 7 498 129 129 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 2 0 0 3 0 0 0 102 2 0 0 67 0 0 0] 8 #() 498 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentRight -147 1362 #fixedViewLeft 129 1362 #fixedParentTop -37 1362 #fixedViewTop 129 410 ##(Smalltalk.StaticText) 34 16 nil 656 34 2 8 1140850944 1 1440 nil nil nil 7 nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 1440 976 8 1903849936 1010 nil nil nil 1106 138 144 34 2 1170 #createAt:extent: 34 2 498 21 45 498 1061 97 1440 1170 #text: 34 1 8 'Title' 1440 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 22 0 0 0 28 2 0 0 70 0 0 0] 8 #() 1312 nil 27 1330 1362 #fixedParentLeft 1 1376 -167 1408 1 1424 97 170 192 34 4 800 8 'badge' 1440 8 'title' 1042 498 21 45 498 1 1 1106 138 144 34 1 1170 #createAt:extent: 34 2 498 21 21 498 1249 141 656 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 122 2 0 0 80 0 0 0] 34 2 1440 800 1312 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2112 nil 466 #orchid nil 7 nil 530 nil true 562 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 2112 738 170 176 34 12 410 ##(Smalltalk.LinkButton) 34 15 nil 2112 34 2 8 1140850688 65 2304 nil nil nil 519 nil nil nil 2304 480 8 1904508208 1180998 4 ##(Smalltalk.CommandDescription) #reload 8 'Reload' 1 1 nil 1106 138 144 34 3 1170 #createAt:extent: 34 2 498 1129 25 498 91 41 2304 1170 #isEnabled: 8 #(false) 2304 1170 #text: 34 1 8 '<a>Reload</a>' 2304 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 2 0 0 12 0 0 0 97 2 0 0 32 0 0 0] 8 #() 1312 nil 27 1330 1376 -119 1392 91 1408 3 1424 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2112 34 2 8 1140850688 65 2688 nil nil nil 519 nil nil nil 2688 480 8 1904508208 2386 #next 8 'Next' 1 1 nil 1106 138 144 34 3 1170 #createAt:extent: 34 2 498 1009 25 498 121 41 2688 1170 #isEnabled: 8 #(false) 2688 1170 #text: 34 1 8 '<a>Next</a>' 2688 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 248 1 0 0 12 0 0 0 52 2 0 0 32 0 0 0] 8 #() 1312 nil 27 1330 1376 -239 1392 121 1408 3 1424 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2112 34 2 8 1140850688 65 3056 nil nil nil 519 nil nil nil 3056 480 8 1904508208 2386 #inspectIt 8 'Inspect It' 1 1 nil 1106 138 144 34 3 1170 #createAt:extent: 34 2 498 421 23 498 201 33 3056 1170 #isEnabled: 8 #(false) 3056 1170 #text: 34 1 8 '<a>Inspect It</a>' 3056 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 11 0 0 0 54 1 0 0 27 0 0 0] 8 #() 1312 nil 27 1330 1824 401 1392 201 1408 1 1424 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2112 34 2 8 1140850688 65 3424 nil nil nil 519 nil nil nil 3424 480 8 1904508208 2386 #evaluateIt 8 'Evaluate It' 1 1 nil 1106 138 144 34 3 1170 #createAt:extent: 34 2 498 21 23 498 201 33 3424 1170 #isEnabled: 8 #(false) 3424 1170 #text: 34 1 8 '<a>Evaluate It</a>' 3424 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 110 0 0 0 27 0 0 0] 8 #() 1312 nil 27 1330 1824 1 1392 201 1408 1 1424 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2112 34 2 8 1140850688 65 3792 nil nil nil 519 nil nil nil 3792 480 8 1904508208 2386 #displayIt 8 'Display It' 1 1 nil 1106 138 144 34 3 1170 #createAt:extent: 34 2 498 221 23 498 201 33 3792 1170 #isEnabled: 8 #(false) 3792 1170 #text: 34 1 8 '<a>Display It</a>' 3792 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 11 0 0 0 210 0 0 0 27 0 0 0] 8 #() 1312 nil 27 1330 1824 201 1392 201 1408 1 1424 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2112 34 2 8 1140850688 65 4160 nil nil nil 519 nil nil nil 4160 480 8 1904508208 2386 #previous 8 'Previous' 1 1 nil 1106 138 144 34 3 1170 #createAt:extent: 34 2 498 839 25 498 121 41 4160 1170 #isEnabled: 8 #(false) 4160 1170 #text: 34 1 8 '<a>Previous</a>' 4160 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 1 0 0 12 0 0 0 223 1 0 0 32 0 0 0] 8 #() 1312 nil 27 1330 1376 -409 1392 121 1408 3 1424 41 170 192 8 #() 1042 498 21 23 498 1 1 1106 138 144 34 1 1170 #createAt:extent: 34 2 498 21 1143 498 1249 81 2112 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 59 2 0 0 122 2 0 0 99 2 0 0] 34 6 3424 3792 3056 4160 2688 2304 1312 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 4768 nil nil nil 7 nil nil nil 4768 626 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 4768 34 2 8 1411387716 1 4848 866 nil false 912 nil 976 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 11 984134 2 ##(Smalltalk.CommandMenuItem) 1 2386 #cutSelection 8 'Cu&t' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditCut.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4978 1 2386 #copySelection 8 '&Copy' 1 1 5042 nil true 5088 8 'EditCopy.ico' 5136 nil nil 4978 1 2386 #pasteClipboard 8 '&Paste' 1 1 5042 nil true 5088 8 'EditPaste.ico' 5136 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4978 1 2386 #browseIt 8 'Bro&wse It' 1 1 5042 nil true 5088 8 'ClassBrowserShell.ico' 5136 nil nil 4978 1 2386 #displayIt 8 '&Display It' 1 1 5042 nil true 5088 8 'DisplayIt.ico' 5136 nil nil 4978 1 2386 #evaluateIt 8 'E&valuate It' 1 1 5042 nil true 5088 8 'EvaluateIt.ico' 5136 nil nil 4978 1 2386 #inspectIt 8 '&Inspect It' 1 1 5042 nil true 5088 8 'InspectIt.ico' 5136 nil nil 4978 1 2386 #debugIt 8 'Deb&ug It' 1 1 5042 nil true 5088 8 'Debugger.ico' 5136 nil nil 5330 4097 4930 nil true 34 9 4978 1 2386 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4978 1 2386 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4978 1 2386 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 4978 1 2386 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4978 1 2386 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4978 1 2386 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4978 1 2386 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5330 4097 4930 nil true 34 2 4978 1 2386 459270 ##(Smalltalk.Message) #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4978 1 2386 6226 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 4848 nil 8 1560924607 1010 nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 6546 77 466 #gray 976 1 nil nil nil nil #callTip nil nil nil 34 256 6560 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 6576 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 4544 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 4848 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 4544 nil 170 176 4544 9215 nil nil nil nil 466 #silver nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' 8 '' 3 170 192 34 2 #container 6512 nil nil nil nil 130003 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 4848 466 #blue 3 false #Warning nil nil nil nil nil nil #Error 6946 21 4848 466 #red 3 false #Error nil nil nil nil nil nil #Notification 6946 17 4848 466 #commonGreen 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 6546 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 6546 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 6546 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 1106 138 144 34 10 1170 #createAt:extent: 34 2 498 21 21 498 1209 943 4848 1170 #contextMenu: 34 1 4944 4848 1170 #textLimit: 8 #(1073741823) 4848 1170 #hoverTime: 8 #(500) 4848 1170 #caretPeriod: 8 #(530) 4848 1170 #wordWrap: 8 #(true) 4848 1170 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 4848 1 3 nil nil 5 nil 7538 3 4848 1 nil nil 67108863 5 nil 7538 5 4848 1 nil nil nil 5 nil 4848 1170 #tabWidth: 8 #(4) 4848 1170 #maxCompletionListHeight: 8 #(9) 4848 1170 #edgeColumn: 8 #(1) 4848 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 102 2 0 0 225 1 0 0] 8 #() 1312 nil 29 170 192 34 2 4848 8 'workspace' 1042 498 21 21 498 21 21 1106 138 144 34 1 1170 #createAt:extent: 34 2 498 21 161 498 1249 983 4768 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 80 0 0 0 122 2 0 0 59 2 0 0] 34 1 4848 1312 nil 27 170 192 34 6 4768 8 'content' 2112 8 'footer' 656 8 'header' 1042 498 21 21 498 21 21 nil nil nil nil 1 nil nil nil 498 1071 711 1 nil nil 1106 138 144 34 2 1170 #createAt:extent: 34 2 498 3839 21 498 1321 1321 416 1170 #updateMenuBar 4544 416 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 19 10 0 0 158 2 0 0] 34 3 656 4768 2112 1312 nil 27 )! !
!TutorialPlayer class categoriesFor: #defaultModel!public! !
!TutorialPlayer class categoriesFor: #icon!constants!public! !
!TutorialPlayer class categoriesFor: #resource_Default_view!public!resources-views! !

