"Filed out from Dolphin Smalltalk"!

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

!TutorialPlayer categoriesForMethods!
createComponents!accessing!private! !
currentLesson!accessing!public! !
displayIt!commands!public! !
evaluateIt!commands!public! !
first!navigation!public! !
inspectIt!commands!public! !
last!navigation!public! !
model:!accessing!private! !
next!navigation!public! !
onViewOpened!accessing!private! !
previous!navigation!public! !
printIt!commands!public! !
reload!navigation!public! !
rewind!navigation!public! !
size!accessing!public! !
tutorial!accessing!public! !
tutorial:!accessing!public! !
tutorialPosition!accessing!public! !
tutorialPosition:!accessing!public! !
updateLesson!accessing!private! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1321 1321 517 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 84 0 114 0 101 0 98 0 117 0 99 0 104 0 101 0 116 0 32 0 77 0 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil 466 #orchid nil 5 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.GdiplusImageView) 34 28 nil 640 34 2 8 1140850944 1 784 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 788806 1 ##(Smalltalk.TextTileIcon) $🎓 nil 704 466 #white nil nil 1 nil nil nil nil 5 nil nil nil 784 nil 8 4294902331 852486 ##(Smalltalk.NullConverter) nil nil nil 928 #scaleToFit 1 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 nil nil #none nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[38 2 0 0 3 0 0 0 102 2 0 0 67 0 0 0] 193 816 nil 784 1138 #text: 34 1 8 '' 784 3 8 #() 498 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentRight -147 1378 #fixedViewLeft 129 1378 #fixedParentTop -37 1378 #fixedViewTop 129 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 1456 nil nil nil 5 nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 84 0 114 0 101 0 98 0 117 0 99 0 104 0 101 0 116 0 32 0 77 0 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1456 944 8 1759212608 978 nil nil nil 1074 138 144 34 2 1138 #createWindow: 34 1 1186 1218 8 #[10 0 0 0 22 0 0 0 28 2 0 0 70 0 0 0] 193 1488 nil 1456 1138 #text: 34 1 8 'Title' 1456 3 8 #() 498 193 193 nil 27 1346 1378 #fixedParentLeft 1 1392 -167 1424 1 1440 97 170 192 34 4 784 8 'badge' 1456 8 'title' 1010 498 21 45 498 1 1 1074 138 144 34 1 1138 #createWindow: 34 1 1186 1218 8 #[10 0 0 0 10 0 0 0 122 2 0 0 80 0 0 0] 193 672 8 '' 640 3 34 2 1456 784 498 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2128 nil 704 nil 5 nil 530 nil true 562 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2128 722 170 176 34 12 410 ##(Smalltalk.LinkButton) 34 15 nil 2128 34 2 8 1140850688 65 2288 nil nil nil 517 nil nil nil 2288 480 8 1758846304 1180998 4 ##(Smalltalk.CommandDescription) #evaluateIt 8 'Evaluate It' 1 1 nil 1074 138 144 34 2 1138 #createWindow: 34 1 1186 1218 8 #[10 0 0 0 11 0 0 0 110 0 0 0 27 0 0 0] 193 2320 8 '<a>Evaluate It</a>' 2288 1138 #isEnabled: 8 #(false) 2288 3 8 #() 498 193 193 nil 27 1346 1824 1 1408 201 1424 1 1440 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2128 34 2 8 1140850688 65 2640 nil nil nil 517 nil nil nil 2640 480 8 1758846304 2370 #previous 8 'Previous' 1 1 nil 1074 138 144 34 2 1138 #createWindow: 34 1 1186 1218 8 #[163 1 0 0 12 0 0 0 223 1 0 0 32 0 0 0] 193 2672 8 '<a>Previous</a>' 2640 1138 #isEnabled: 8 #(false) 2640 3 8 #() 498 193 193 nil 27 1346 1392 -409 1408 121 1424 3 1440 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2128 34 2 8 1140850688 65 2976 nil nil nil 517 nil nil nil 2976 480 8 1758846304 2370 #displayIt 8 'Display It' 1 1 nil 1074 138 144 34 2 1138 #createWindow: 34 1 1186 1218 8 #[110 0 0 0 11 0 0 0 210 0 0 0 27 0 0 0] 193 3008 8 '<a>Display It</a>' 2976 1138 #isEnabled: 8 #(false) 2976 3 8 #() 498 193 193 nil 27 1346 1824 201 1408 201 1424 1 1440 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2128 34 2 8 1140850688 65 3312 nil nil nil 517 nil nil nil 3312 480 8 1758846304 2370 #next 8 'Next' 1 1 nil 1074 138 144 34 2 1138 #createWindow: 34 1 1186 1218 8 #[248 1 0 0 12 0 0 0 52 2 0 0 32 0 0 0] 193 3344 8 '<a>Next</a>' 3312 1138 #isEnabled: 8 #(false) 3312 3 8 #() 498 193 193 nil 27 1346 1392 -239 1408 121 1424 3 1440 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2128 34 2 8 1140850688 65 3648 nil nil nil 517 nil nil nil 3648 480 8 1758846304 2370 #reload 8 'Reload' 1 1 nil 1074 138 144 34 2 1138 #createWindow: 34 1 1186 1218 8 #[52 2 0 0 12 0 0 0 97 2 0 0 32 0 0 0] 193 3680 8 '<a>Reload</a>' 3648 1138 #isEnabled: 8 #(false) 3648 3 8 #() 498 193 193 nil 27 1346 1392 -119 1408 91 1424 3 1440 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2128 34 2 8 1140850688 65 3984 nil nil nil 517 nil nil nil 3984 480 8 1758846304 2370 #inspectIt 8 'Inspect It' 1 1 nil 1074 138 144 34 2 1138 #createWindow: 34 1 1186 1218 8 #[210 0 0 0 11 0 0 0 54 1 0 0 27 0 0 0] 193 4016 8 '<a>Inspect It</a>' 3984 1138 #isEnabled: 8 #(false) 3984 3 8 #() 498 193 193 nil 27 1346 1824 401 1408 201 1424 1 1440 33 170 192 8 #() 1010 498 21 23 498 1 1 1074 138 144 34 1 1138 #createWindow: 34 1 1186 1218 8 #[10 0 0 0 59 2 0 0 122 2 0 0 99 2 0 0] 193 2160 8 '' 2128 3 34 6 2288 2976 3984 2640 3312 3648 498 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 4576 nil nil nil 5 nil nil nil 4576 610 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 4576 34 2 8 1411387716 1 4656 850 nil false 896 nil 944 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 2370 #cutSelection 8 'Cu&t' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditCut.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4786 1 2370 #copySelection 8 '&Copy' 1 1 4850 nil true 4896 8 'EditCopy.ico' 4944 nil nil 4786 1 2370 #pasteClipboard 8 '&Paste' 1 1 4850 nil true 4896 8 'EditPaste.ico' 4944 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4786 1 2370 #browseIt 8 'Bro&wse It' 1 1 4850 nil true 4896 8 'ClassBrowserShell.ico' 4944 nil nil 4786 1 2370 #displayIt 8 '&Display It' 1 1 4850 nil true 4896 8 'DisplayIt.ico' 4944 nil nil 4786 1 2370 #printIt 8 'P&rint It' 1 1 4850 nil true 4896 8 'PrintIt.ico' 4944 nil nil 4786 1 2370 #evaluateIt 8 'E&valuate It' 1 1 4850 nil true 4896 8 'EvaluateIt.ico' 4944 nil nil 4786 1 2370 #inspectIt 8 '&Inspect It' 1 1 4850 nil true 4896 8 'InspectIt.ico' 4944 nil nil 4786 1 2370 #debugIt 8 'Deb&ug It' 1 1 4850 nil true 4896 8 'Debugger.ico' 4944 nil nil 5138 4097 4738 nil true 34 9 4786 1 2370 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4786 1 2370 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4786 1 2370 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 4786 1 2370 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4786 1 2370 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4786 1 2370 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4786 1 2370 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5138 4097 4738 nil true 34 2 4786 1 2370 459270 ##(Smalltalk.Message) #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4786 1 2370 6114 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 4656 nil 8 1504001512 978 nil nil 9 68811217 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 466 #gray 944 1 nil nil nil nil #callTip nil nil nil #normal 6418 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 4336 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 4656 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 4336 nil 170 176 4336 9215 nil nil nil nil 466 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 6384 nil nil nil nil 208 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 4656 466 #blue 3 false #Warning nil nil nil nil nil nil #Error 6802 21 4656 466 #red 3 false #Error nil nil nil nil nil nil #Notification 6802 17 4656 466 #commonGreen 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 6418 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 6418 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 6418 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1074 138 144 34 10 1138 #createWindow: 34 1 1186 1218 8 #[10 0 0 0 10 0 0 0 102 2 0 0 225 1 0 0] 193 4688 nil 4656 1138 #contextMenu: 34 1 4752 4656 1138 #hoverTime: 8 #(500) 4656 1138 #caretPeriod: 8 #(530) 4656 1138 #wordWrap: 8 #(true) 4656 1138 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 4656 1 3 nil nil 5 nil 7378 3 4656 1 nil nil 67108863 5 nil 7378 5 4656 1 nil nil nil 5 nil 4656 1138 #tabWidth: 8 #(4) 4656 1138 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 4656 1138 #maxCompletionListHeight: 8 #(9) 4656 1138 #edgeColumn: 8 #(1) 4656 3 8 #() 498 193 193 nil 33 170 192 34 2 4656 8 'workspace' 1010 498 21 21 498 21 21 1074 138 144 34 1 1138 #createWindow: 34 1 1186 1218 8 #[10 0 0 0 80 0 0 0 122 2 0 0 59 2 0 0] 193 4608 8 '' 4576 3 34 1 4656 498 193 193 nil 27 170 192 34 6 4576 8 'content' 640 8 'header' 2128 8 'footer' 1010 498 21 21 498 21 21 nil nil nil nil 1 nil nil nil 498 1071 711 1 nil 193 1074 138 144 34 1 1138 #createWindow: 34 1 1186 1010 498 1 1 498 1321 1321 193 448 8 '' 416 1 34 3 640 4576 2128 498 193 193 nil 27 )! !

!TutorialPlayer class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

