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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 1321 1321 517 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 84 0 114 0 101 0 98 0 117 0 99 0 104 0 101 0 116 0 32 0 77 0 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil 466 #orchid nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 784 nil nil nil 7 nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 84 0 114 0 101 0 98 0 117 0 99 0 104 0 101 0 116 0 32 0 77 0 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 784 466 #white 8 1795912768 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[10 0 0 0 22 0 0 0 28 2 0 0 70 0 0 0] 193 816 nil 784 1026 #text: 34 1 8 'Title' 784 3 8 #() 498 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1266 #fixedParentRight -167 1266 #fixedParentTop 1 1266 #fixedViewTop 97 410 ##(Smalltalk.GdiplusImageView) 34 28 nil 640 34 2 8 1140850944 1 1344 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 788806 2 ##(Smalltalk.TextTileIcon) $🎓 nil 704 896 nil nil 1 nil nil nil nil 7 nil nil nil 1344 nil 8 4294902331 930 nil nil nil 1488 #scaleToFit 1 nil nil nil #none nil nil nil nil nil 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[38 2 0 0 3 0 0 0 102 2 0 0 67 0 0 0] 193 1376 nil 1344 1026 #text: 34 1 8 '' 1344 3 8 #() 498 193 193 nil 29 1234 1296 -147 1266 #fixedViewLeft 129 1312 -37 1328 129 170 192 34 4 784 8 'title' 1344 8 'badge' 590342 ##(Smalltalk.Rectangle) 498 21 45 498 1 1 962 138 144 34 1 1026 #createWindow: 34 1 1074 1106 8 #[10 0 0 0 10 0 0 0 122 2 0 0 80 0 0 0] 193 672 8 '' 640 3 34 2 784 1344 498 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2080 nil 704 nil 7 nil 530 nil true 562 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2080 722 170 176 34 12 410 ##(Smalltalk.LinkButton) 34 15 nil 2080 34 2 8 1140850688 65 2240 nil nil nil 519 nil nil nil 2240 480 8 1795546464 1180998 4 ##(Smalltalk.CommandDescription) #displayIt 8 'Display It' 1 1 nil 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[110 0 0 0 11 0 0 0 210 0 0 0 27 0 0 0] 193 2272 8 '<a>Display It</a>' 2240 1026 #isEnabled: 8 #(false) 2240 3 8 #() 498 193 193 nil 27 1234 1280 201 1760 201 1312 1 1328 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2080 34 2 8 1140850688 65 2592 nil nil nil 519 nil nil nil 2592 480 8 1795546464 2322 #next 8 'Next' 1 1 nil 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[248 1 0 0 12 0 0 0 52 2 0 0 32 0 0 0] 193 2624 8 '<a>Next</a>' 2592 1026 #isEnabled: 8 #(false) 2592 3 8 #() 498 193 193 nil 27 1234 1296 -239 1760 121 1312 3 1328 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2080 34 2 8 1140850688 65 2928 nil nil nil 519 nil nil nil 2928 480 8 1795546464 2322 #reload 8 'Reload' 1 1 nil 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[52 2 0 0 12 0 0 0 97 2 0 0 32 0 0 0] 193 2960 8 '<a>Reload</a>' 2928 1026 #isEnabled: 8 #(false) 2928 3 8 #() 498 193 193 nil 27 1234 1296 -119 1760 91 1312 3 1328 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2080 34 2 8 1140850688 65 3264 nil nil nil 519 nil nil nil 3264 480 8 1795546464 2322 #previous 8 'Previous' 1 1 nil 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[163 1 0 0 12 0 0 0 223 1 0 0 32 0 0 0] 193 3296 8 '<a>Previous</a>' 3264 1026 #isEnabled: 8 #(false) 3264 3 8 #() 498 193 193 nil 27 1234 1296 -409 1760 121 1312 3 1328 41 410 ##(Smalltalk.LinkButton) 34 15 nil 2080 34 2 8 1140850688 65 3600 nil nil nil 519 nil nil nil 3600 480 8 1795546464 2322 #evaluateIt 8 'Evaluate It' 1 1 nil 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[10 0 0 0 11 0 0 0 110 0 0 0 27 0 0 0] 193 3632 8 '<a>Evaluate It</a>' 3600 1026 #isEnabled: 8 #(false) 3600 3 8 #() 498 193 193 nil 27 1234 1280 1 1760 201 1312 1 1328 33 410 ##(Smalltalk.LinkButton) 34 15 nil 2080 34 2 8 1140850688 65 3936 nil nil nil 519 nil nil nil 3936 480 8 1795546464 2322 #inspectIt 8 'Inspect It' 1 1 nil 962 138 144 34 2 1026 #createWindow: 34 1 1074 1106 8 #[210 0 0 0 11 0 0 0 54 1 0 0 27 0 0 0] 193 3968 8 '<a>Inspect It</a>' 3936 1026 #isEnabled: 8 #(false) 3936 3 8 #() 498 193 193 nil 27 1234 1280 401 1760 201 1312 1 1328 33 170 192 8 #() 1842 498 21 23 498 1 1 962 138 144 34 1 1026 #createWindow: 34 1 1074 1106 8 #[10 0 0 0 59 2 0 0 122 2 0 0 99 2 0 0] 193 2112 8 '' 2080 3 34 6 3600 2240 3936 3264 2592 2928 498 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 4528 nil nil nil 7 nil nil nil 4528 610 1 1 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 4528 34 2 8 1411387716 1 4608 1410 nil false 1456 nil 896 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 2322 #cutSelection 8 'Cu&t' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditCut.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4738 1 2322 #copySelection 8 '&Copy' 1 1 4802 nil true 4848 8 'EditCopy.ico' 4896 nil nil 4738 1 2322 #pasteClipboard 8 '&Paste' 1 1 4802 nil true 4848 8 'EditPaste.ico' 4896 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4738 1 2322 #browseIt 8 'Bro&wse It' 1 1 4802 nil true 4848 8 'ClassBrowserShell.ico' 4896 nil nil 4738 1 2322 #displayIt 8 '&Display It' 1 1 4802 nil true 4848 8 'DisplayIt.ico' 4896 nil nil 4738 1 2322 #printIt 8 'P&rint It' 1 1 4802 nil true 4848 8 'PrintIt.ico' 4896 nil nil 4738 1 2322 #evaluateIt 8 'E&valuate It' 1 1 4802 nil true 4848 8 'EvaluateIt.ico' 4896 nil nil 4738 1 2322 #inspectIt 8 '&Inspect It' 1 1 4802 nil true 4848 8 'InspectIt.ico' 4896 nil nil 4738 1 2322 #debugIt 8 'Deb&ug It' 1 1 4802 nil true 4848 8 'Debugger.ico' 4896 nil nil 5090 4097 4690 nil true 34 9 4738 1 2322 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4738 1 2322 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4738 1 2322 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 4738 1 2322 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4738 1 2322 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4738 1 2322 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4738 1 2322 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5090 4097 4690 nil true 34 2 4738 1 2322 459270 ##(Smalltalk.Message) #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4738 1 2322 6066 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 530 nil true 562 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 4608 nil 8 1537949160 930 nil nil 9 1418429905 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 466 #gray 896 1 nil nil nil nil #callTip nil nil nil #normal 6370 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 4288 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 4608 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 4288 nil 170 176 4288 9215 nil nil nil nil 466 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 6336 nil nil nil nil 208 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 4608 466 #blue 3 false #Warning nil nil nil nil nil nil #Error 6754 21 4608 466 #red 3 false #Error nil nil nil nil nil nil #Notification 6754 17 4608 466 #commonGreen 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 6370 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 6370 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 6370 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 962 138 144 34 10 1026 #createWindow: 34 1 1074 1106 8 #[10 0 0 0 10 0 0 0 102 2 0 0 225 1 0 0] 193 4640 nil 4608 1026 #contextMenu: 34 1 4704 4608 1026 #hoverTime: 8 #(500) 4608 1026 #caretPeriod: 8 #(530) 4608 1026 #wordWrap: 8 #(true) 4608 1026 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 4608 1 3 nil nil 5 nil 7330 3 4608 1 nil nil 67108863 5 nil 7330 5 4608 1 nil nil nil 5 nil 4608 1026 #tabWidth: 8 #(4) 4608 1026 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 4608 1026 #maxCompletionListHeight: 8 #(9) 4608 1026 #edgeColumn: 8 #(1) 4608 3 8 #() 498 193 193 nil 33 170 192 34 2 4608 8 'workspace' 1842 498 21 21 498 21 21 962 138 144 34 1 1026 #createWindow: 34 1 1074 1106 8 #[10 0 0 0 80 0 0 0 122 2 0 0 59 2 0 0] 193 4560 8 '' 4528 3 34 1 4608 498 193 193 nil 27 170 192 34 6 4528 8 'content' 2080 8 'footer' 640 8 'header' 1842 498 21 21 498 21 21 nil nil nil nil 1 nil nil nil 498 1071 711 1 nil 193 962 138 144 34 1 1026 #createWindow: 34 1 1074 1842 498 6143 21 498 7463 1341 193 448 8 '' 416 1 34 3 640 4528 2080 498 193 193 nil 27 )! !

!TutorialPlayer class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

