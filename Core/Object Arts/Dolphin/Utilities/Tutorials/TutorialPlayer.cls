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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 328198 ##(Smalltalk.Point) 1321 1321 517 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 514 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 672 nil 196934 1 ##(Smalltalk.RGB) 18393531 nil 5 nil nil nil 672 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 672 34 2 8 1140850944 1 832 nil nil nil 5 nil 546 nil true 578 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 514 193 193 nil 832 786694 ##(Smalltalk.IndexedColor) 33554471 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 514 21 45 514 1061 97 832 1106 #text: 34 1 8 'Title' 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 22 0 0 0 28 2 0 0 70 0 0 0] 8 #() 514 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1346 #fixedParentRight -167 1346 #fixedParentTop 1 1346 #fixedViewTop 97 410 ##(Smalltalk.GdiplusImageView) 34 28 nil 672 34 2 8 1140850944 1 1424 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 738 18393531 262406 ##(Smalltalk.ARGB) 8 4294967295 nil nil 1 nil nil nil nil 5 nil nil nil 1424 nil 8 4294902331 1010 nil nil nil 1568 #scaleToFit 1 590342 ##(Smalltalk.Rectangle) 514 1 1 514 1 1 nil nil #none nil nil nil nil nil 1042 138 144 34 1 1106 #createAt:extent: 34 2 514 1101 7 514 129 129 1424 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 2 0 0 3 0 0 0 102 2 0 0 67 0 0 0] 8 #() 1296 nil 29 1314 1376 -147 1346 #fixedViewLeft 129 1392 -37 1408 129 170 192 34 4 832 8 'title' 1424 8 'badge' 1682 514 21 45 514 1 1 1042 138 144 34 1 1106 #createAt:extent: 34 2 514 21 21 514 1249 141 672 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 122 2 0 0 80 0 0 0] 34 2 832 1424 1296 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2208 nil 738 18393531 nil 5 nil 546 nil true 578 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 514 193 193 nil 2208 770 170 176 34 12 410 ##(Smalltalk.LinkButton) 34 15 nil 2208 34 2 8 1140850688 65 2400 nil nil nil 517 nil nil nil 2400 480 8 1915775360 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 'Inspect It' 1 1 nil 1042 138 144 34 3 1106 #createAt:extent: 34 2 514 421 23 514 201 33 2400 1106 #isEnabled: 8 #(false) 2400 1106 #text: 34 1 8 '<a>Inspect It</a>' 2400 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 11 0 0 0 54 1 0 0 27 0 0 0] 8 #() 1296 nil 27 1314 1360 401 1920 201 1392 1 1408 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2208 34 2 8 1140850688 65 2784 nil nil nil 517 nil nil nil 2784 480 8 1915775360 2482 #next 8 'Next' 1 1 nil 1042 138 144 34 3 1106 #createAt:extent: 34 2 514 1009 25 514 121 41 2784 1106 #isEnabled: 8 #(false) 2784 1106 #text: 34 1 8 '<a>Next</a>' 2784 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 248 1 0 0 12 0 0 0 52 2 0 0 32 0 0 0] 8 #() 1296 nil 27 1314 1376 -239 1920 121 1392 3 1408 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2208 34 2 8 1140850688 65 3152 nil nil nil 517 nil nil nil 3152 480 8 1915775360 2482 #evaluateIt 8 'Evaluate It' 1 1 nil 1042 138 144 34 3 1106 #createAt:extent: 34 2 514 21 23 514 201 33 3152 1106 #isEnabled: 8 #(false) 3152 1106 #text: 34 1 8 '<a>Evaluate It</a>' 3152 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 110 0 0 0 27 0 0 0] 8 #() 1296 nil 27 1314 1360 1 1920 201 1392 1 1408 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2208 34 2 8 1140850688 65 3520 nil nil nil 517 nil nil nil 3520 480 8 1915775360 2482 #reload 8 'Reload' 1 1 nil 1042 138 144 34 3 1106 #createAt:extent: 34 2 514 1129 25 514 91 41 3520 1106 #isEnabled: 8 #(false) 3520 1106 #text: 34 1 8 '<a>Reload</a>' 3520 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 2 0 0 12 0 0 0 97 2 0 0 32 0 0 0] 8 #() 1296 nil 27 1314 1376 -119 1920 91 1392 3 1408 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2208 34 2 8 1140850688 65 3888 nil nil nil 517 nil nil nil 3888 480 8 1915775360 2482 #displayIt 8 'Display It' 1 1 nil 1042 138 144 34 3 1106 #createAt:extent: 34 2 514 221 23 514 201 33 3888 1106 #isEnabled: 8 #(false) 3888 1106 #text: 34 1 8 '<a>Display It</a>' 3888 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 11 0 0 0 210 0 0 0 27 0 0 0] 8 #() 1296 nil 27 1314 1360 201 1920 201 1392 1 1408 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2208 34 2 8 1140850688 65 4256 nil nil nil 517 nil nil nil 4256 480 8 1915775360 2482 #previous 8 'Previous' 1 1 nil 1042 138 144 34 3 1106 #createAt:extent: 34 2 514 839 25 514 121 41 4256 1106 #isEnabled: 8 #(false) 4256 1106 #text: 34 1 8 '<a>Previous</a>' 4256 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 1 0 0 12 0 0 0 223 1 0 0 32 0 0 0] 8 #() 1296 nil 27 1314 1376 -409 1920 121 1392 3 1408 41 170 192 8 #() 1682 514 21 23 514 1 1 1042 138 144 34 1 1106 #createAt:extent: 34 2 514 21 1143 514 1249 81 2208 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 59 2 0 0 122 2 0 0 99 2 0 0] 34 6 3152 3888 2400 4256 2784 3520 1296 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 4864 nil nil nil 5 nil nil nil 4864 642 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 4864 34 2 8 1411387716 1 4944 1490 nil false 1536 nil 976 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 11 984134 2 ##(Smalltalk.CommandMenuItem) 1 2482 #cutSelection 8 'Cu&t' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditCut.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 5074 1 2482 #copySelection 8 '&Copy' 1 1 5138 nil true 5184 8 'EditCopy.ico' 5232 nil nil 5074 1 2482 #pasteClipboard 8 '&Paste' 1 1 5138 nil true 5184 8 'EditPaste.ico' 5232 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5074 1 2482 #browseIt 8 'Bro&wse It' 1 1 5138 nil true 5184 8 'ClassBrowserShell.ico' 5232 nil nil 5074 1 2482 #displayIt 8 '&Display It' 1 1 5138 nil true 5184 8 'DisplayIt.ico' 5232 nil nil 5074 1 2482 #evaluateIt 8 'E&valuate It' 1 1 5138 nil true 5184 8 'EvaluateIt.ico' 5232 nil nil 5074 1 2482 #inspectIt 8 '&Inspect It' 1 1 5138 nil true 5184 8 'InspectIt.ico' 5232 nil nil 5074 1 2482 #debugIt 8 'Deb&ug It' 1 1 5138 nil true 5184 8 'Debugger.ico' 5232 nil nil 5426 4097 5026 nil true 34 9 5074 1 2482 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5074 1 2482 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5074 1 2482 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 5074 1 2482 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5074 1 2482 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5074 1 2482 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5074 1 2482 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5426 4097 5026 nil true 34 2 5074 1 2482 459270 ##(Smalltalk.Message) #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 5074 1 2482 6322 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 546 nil true 578 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 514 193 193 nil 4944 nil 8 1825558121 1010 nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 6642 77 962 33554457 976 1 nil nil nil nil #callTip nil nil nil 34 40 6656 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 4640 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 4944 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 4640 nil 170 176 4640 9215 nil nil nil nil 962 33554447 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 6608 nil nil nil nil 130003 nil 170 192 34 6 #Notification 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 4944 33554437 11 false #Notification nil nil nil nil nil nil #Warning 7042 19 4944 33554465 3 false #Warning nil nil nil nil nil nil #Error 7042 21 4944 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 6642 1029 nil 738 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 6642 1027 738 60239 738 31326207 1 nil nil nil nil #Warning nil nil nil #Error 6642 1031 738 335 738 31317503 1 nil nil nil nil #Error nil nil nil nil 1042 138 144 34 10 1106 #createAt:extent: 34 2 514 21 21 514 1209 943 4944 1106 #contextMenu: 34 1 5040 4944 1106 #textLimit: 8 #(1073741823) 4944 1106 #modificationEventMask: 8 #(4607) 4944 1106 #hoverTime: 8 #(500) 4944 1106 #caretPeriod: 8 #(530) 4944 1106 #wordWrap: 8 #(true) 4944 1106 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 4944 1 3 nil nil 5 nil 7618 3 4944 1 nil nil 67108863 5 nil 7618 5 4944 1 nil nil nil 5 nil 4944 1106 #tabWidth: 8 #(4) 4944 1106 #maxCompletionListHeight: 8 #(9) 4944 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 102 2 0 0 225 1 0 0] 8 #() 1296 nil 29 170 192 34 2 4944 8 'workspace' 1682 514 21 21 514 21 21 1042 138 144 34 1 1106 #createAt:extent: 34 2 514 21 161 514 1249 983 4864 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 80 0 0 0 122 2 0 0 59 2 0 0] 34 1 4944 1296 nil 27 170 192 34 6 2208 8 'footer' 4864 8 'content' 672 8 'header' 1682 514 21 21 514 21 21 nil nil nil nil 1 nil nil nil 514 1071 711 1 nil nil 1042 138 144 34 2 1106 #createAt:extent: 34 2 514 105 105 514 1321 1321 416 1106 #updateMenuBar 4640 416 1234 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 0 0 0 52 0 0 0 200 2 0 0 200 2 0 0] 34 3 672 4864 2208 1296 nil 27 )! !
!TutorialPlayer class categoriesFor: #defaultModel!public! !
!TutorialPlayer class categoriesFor: #icon!constants!public! !
!TutorialPlayer class categoriesFor: #resource_Default_view!public!resources-views! !

