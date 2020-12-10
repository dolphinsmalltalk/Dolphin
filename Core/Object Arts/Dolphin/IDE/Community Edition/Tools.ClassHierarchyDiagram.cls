"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.ClassHierarchyDiagram'
	instanceVariableNames: 'classesPresenter commentPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ClassHierarchyDiagram guid: (Core.GUID fromString: '{493664d4-3394-11d3-93bd-00a024ca708a}')!
Tools.ClassHierarchyDiagram comment: 'ClassHierarchyDiagram is a <SmalltalkToolShell> that displays the current class hierarchy in a graphical format using a <MoenTreeView>.

Instance Variables:
	classesPresenter	<TreePresenter> displaying the class hierarchy.
	commentPresenter	<SmalltalkWorkspace> displaying the comment of the selected class.

'!
!Tools.ClassHierarchyDiagram categoriesForClass!MVP-Presenters! !
!Tools.ClassHierarchyDiagram methodsFor!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	classesPresenter := self add: ClassHierarchySelector new name: 'classes'.
	commentPresenter := self add: self workspaceClass new name: 'comment'!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"
	
	super createSchematicWiring.

	classesPresenter 
		when: #actionPerformed send: #browseIt to: classesPresenter;
		when: #selectionChanged send: #onClassSelected to: self!

defaultHelpId
	^10892!

onClassSelected
	"A new class has been selected. Refresh the comment pane"

	commentPresenter clear.
	classesPresenter hasSelection ifTrue: [
		commentPresenter text: classesPresenter selection comment ]!

onViewOpened
	"Private - Received when the receiver's view is been connected. Since the complete hierarchy
	is large, let's occupy most of the available screen area."

	super onViewOpened.
	self view rectangle: (View desktop workArea insetBy: 50).
	classesPresenter expandAll: nil!

searchForClass: aClass 
	classesPresenter selection: aClass instanceClass ifAbsent: [super searchForClass: aClass]! !
!Tools.ClassHierarchyDiagram categoriesFor: #canSaveState!private!saved state! !
!Tools.ClassHierarchyDiagram categoriesFor: #createComponents!initializing!private! !
!Tools.ClassHierarchyDiagram categoriesFor: #createSchematicWiring!initializing!private! !
!Tools.ClassHierarchyDiagram categoriesFor: #defaultHelpId!public! !
!Tools.ClassHierarchyDiagram categoriesFor: #onClassSelected!event handling!public! !
!Tools.ClassHierarchyDiagram categoriesFor: #onViewOpened!event handling!private! !
!Tools.ClassHierarchyDiagram categoriesFor: #searchForClass:!private! !

!Tools.ClassHierarchyDiagram class methodsFor!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators 
		, #(#(#findClass 'Ctrl+Shift+F') #(#browseClassReferences 'Shift+F12') #(#browseIt 'Ctrl+B') #(#inspectIt 'Ctrl+I'))!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Class Diagram'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 517 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1801306032 170 192 34 6 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Smalltalk_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 63 1 882 553 51 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(UI.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 615 1 882 437 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 976 992 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(UI.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 63 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 976 992 nil 27 8 'imageTools' 170 192 976 138 144 976 nil nil 1 nil 882 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 2369 51 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 34 3 1264 672 1024 992 nil 27 nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1744 nil nil nil 7 nil nil nil 1744 738 ##(Tools.ClassHierarchySelector) #resource_Moen_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 2369 1485 1744 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 255 2 0 0] 976 992 nil 27 170 192 34 4 1744 8 'classes' 528 8 'toolbar' nil 658246 4 ##(UI.MenuBar) nil true 34 4 461638 4 ##(UI.Menu) nil true 34 8 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #fileNew 8 '&New Workspace' 9373 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2130 1 2162 #fileOpen 8 '&Open Workspace...' 9375 1 2210 nil true 2256 8 'OpenWorkspace.ico' 2304 nil nil 2130 1 2162 #fileFileIn 8 '&File In...' 1 1 2210 nil true 2256 8 'FileIn.ico' 2304 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 2130 1 2162 #saveImage 8 'Sa&ve Image' 1 1 2210 nil true 2256 8 'Snapshot.ico' 2304 nil nil 2130 1 2162 #smalltalkExit 8 'E&xit Dolphin' 1 1 2210 nil true 2256 8 'PowerSwitch.ico' 2304 nil nil 2498 4097 2130 1 2162 #exit 8 '&Close' 17639 1 1378630 1 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 51399 nil nil 2082 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 51401 nil nil 2082 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 51403 nil nil 2082 nil true 34 15 2130 1 2162 #helpContents 8 '&Contents' 1025 1 2210 nil true 2256 8 'Help.ico' 2304 nil nil 2130 1 2162 #help 8 'On this &Tool' 1249 1 nil nil nil 2130 1 2162 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2498 4097 2130 1 2162 #learnSmalltalk 8 'Learn Smalltalk' 1 1 2754 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 2498 4097 2130 1 2162 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2130 1 2162 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2130 1 2162 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2498 4097 2130 1 2162 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 2210 nil true 2256 8 '!!APPLICATION' 2304 nil nil 2130 1 2162 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2130 1 2162 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2498 4097 2130 1 2162 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2754 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 51427 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 6143 21 882 2401 1653 416 834 #text: 34 1 8 'Class Hierarchy Diagram' 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 175 16 0 0 68 3 0 0] 34 2 528 1744 992 nil 27 )!

toolsFolderHelpId
	^10590! !
!Tools.ClassHierarchyDiagram class categoriesFor: #defaultAdditionalAccelerators!initializing!private! !
!Tools.ClassHierarchyDiagram class categoriesFor: #displayOn:!displaying!public! !
!Tools.ClassHierarchyDiagram class categoriesFor: #icon!constants!public! !
!Tools.ClassHierarchyDiagram class categoriesFor: #initialize!initializing!private! !
!Tools.ClassHierarchyDiagram class categoriesFor: #publishedAspects!public! !
!Tools.ClassHierarchyDiagram class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.ClassHierarchyDiagram class categoriesFor: #toolsFolderHelpId!public! !

