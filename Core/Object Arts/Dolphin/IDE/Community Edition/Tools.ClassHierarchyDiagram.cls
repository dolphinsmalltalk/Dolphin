"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.ClassHierarchyDiagram'
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
!Tools.ClassHierarchyDiagram categoriesForMethods!
canSaveState!private!saved state! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
defaultHelpId!public! !
onClassSelected!event handling!public! !
onViewOpened!event handling!private! !
searchForClass:!private! !
!

!Tools.ClassHierarchyDiagram class methodsFor!

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

	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	(aspects at: #reuseIfOpen) defaultValue: true.
	aspects add: self canUseIdeaSpaceAspect.
	^aspects!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 519 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 519 nil nil nil 160 6 #{Graphics.Color} #default 8 1853287488 550 #{Core.IdentityDictionary} 3 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 7 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Smalltalk_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 63 1 498 553 51 304 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'smalltalkTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 370 #{UI.Toolbar} #resource_Image_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 63 51 640 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 592 608 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 864 nil nil nil 7 nil nil nil 864 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createAt:extent: 50 2 498 615 1 498 437 51 864 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 592 608 nil 27 8 'searchTools' nil nil nil 274 0 550 #{Core.OrderedCollection} 0 nil nil 1 nil 498 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 2369 51 160 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 50 3 640 304 864 608 nil 29 nil nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1328 nil nil nil 7 nil nil nil 1328 370 #{Tools.ClassHierarchySelector} #resource_Moen_view nil 402 50 1 450 #createAt:extent: 50 2 498 1 51 498 2369 1485 1328 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 255 2 0 0] 592 608 nil 27 274 2 1328 8 'classes' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 4 2886 4 #{UI.Menu} nil true 50 8 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileNew 8 '&New Workspace' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1682 1 1714 #fileOpen 8 '&Open Workspace…' 9375 1 1762 nil true 1794 8 'OpenWorkspace.ico' 1856 65541 nil nil nil 1682 1 1714 #fileFileIn 8 '&File In…' 1 1 1762 nil true 1794 8 'FileIn.ico' 1856 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1682 1 1714 #saveImage 8 'Sa&ve Image' 1 1 1762 nil true 1794 8 'Snapshot.ico' 1856 65541 nil nil nil 1682 1 1714 #smalltalkExit 8 'E&xit Dolphin' 1 1 1762 nil true 1794 8 'PowerSwitch.ico' 1856 65541 nil nil nil 2082 4097 1682 1 1714 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 47995 nil nil 1634 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 47997 nil nil 1634 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 47999 nil nil 1634 nil true 50 15 1682 1 1714 #helpContents 8 '&Contents' 1025 1 1762 nil true 1794 8 'Help.ico' 1856 65541 nil nil nil 1682 1 1714 #help 8 'On this &Tool' 1249 1 nil nil nil 1682 1 1714 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2082 4097 1682 1 1714 #learnSmalltalk 8 'Learn Smalltalk' 1 1 2370 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 2082 4097 1682 1 1714 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 1682 1 1714 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 1682 1 1714 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2082 4097 1682 1 1714 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1762 nil true 1794 8 '!!APPLICATION' 1856 65541 nil nil nil 1682 1 1714 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 1682 1 1714 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2082 4097 1682 1 1714 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2370 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 48023 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 402 50 2 450 #createAt:extent: 50 2 498 6143 21 498 2401 1653 32 450 #text: 50 1 8 'Class Hierarchy Diagram' 32 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 175 16 0 0 68 3 0 0] 50 2 160 1328 608 nil 27)!

toolsFolderHelpId
	^10590! !
!Tools.ClassHierarchyDiagram class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!public! !
!

