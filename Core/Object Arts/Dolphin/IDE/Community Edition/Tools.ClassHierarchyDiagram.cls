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
	self view rectangle: (self view monitor effectiveWorkArea insetBy: 50).
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil nil nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 6 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 5 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 336 8 '' 304 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 688 8 '' 656 3 592 610 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 928 8 '' 896 3 592 610 193 193 nil 27 8 'smalltalkTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 9 1047 #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 193 192 8 '' 160 3 50 3 304 896 656 610 193 193 nil 31 nil nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1360 nil nil nil 5 nil nil nil 1360 370 #{Tools.ClassHierarchySelector} #resource_Moen_view nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 25 0 0 0 160 4 0 0 255 2 0 0] 193 1392 8 '' 1360 3 592 610 193 193 nil 27 258 #{Core.IdentityDictionary} 50 4 1360 8 'classes' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 4 2886 4 #{UI.Menu} nil true 50 8 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileNew 8 '&New Workspace' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1746 1 1778 #fileOpen 8 '&Open Workspace…' 9375 1 1826 nil true 1858 8 'OpenWorkspace.ico' 1920 65541 nil nil nil 1746 1 1778 #fileFileIn 8 '&File In…' 1 1 1826 nil true 1858 8 'FileIn.ico' 1920 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1746 1 1778 #saveImage 8 'Sa&ve Image' 1 1 1826 nil true 1858 8 'Snapshot.ico' 1920 65541 nil nil nil 1746 1 1778 #smalltalkExit 8 'E&xit Dolphin' 1 1 1826 nil true 1858 8 'PowerSwitch.ico' 1920 65541 nil nil nil 2146 4097 1746 1 1778 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 1698 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 1698 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 1698 nil true 50 15 1746 1 1778 #helpContents 8 '&Contents' 1025 1 1826 nil true 1858 8 'Help.ico' 1920 65541 nil nil nil 1746 1 1778 #help 8 'On this &Tool' 1249 1 nil nil nil 1746 1 1778 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2146 4097 1746 1 1778 #learnSmalltalk 8 'Learn Smalltalk' 1 1 2434 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 2146 4097 1746 1 1778 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 1746 1 1778 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 1746 1 1778 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2146 4097 1746 1 1778 #dolphinHomePage 8 'Object Arts Homepage' 1 1 1826 nil true 1858 8 '!!APPLICATION' 1920 65541 nil nil nil 1746 1 1778 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 1746 1 1778 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2146 4097 1746 1 1778 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2434 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 402 50 1 450 #createWindow: 50 1 498 518 #{Graphics.Rectangle} 610 7679 21 610 10079 1673 193 80 8 'Class Hierarchy Diagram' 32 1 50 2 160 1360 610 193 193 nil 27)!

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

