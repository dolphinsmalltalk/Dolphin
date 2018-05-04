"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #ClassHierarchyDiagram
	instanceVariableNames: 'classesPresenter commentPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassHierarchyDiagram guid: (GUID fromString: '{493664d4-3394-11d3-93bd-00a024ca708a}')!
ClassHierarchyDiagram comment: 'ClassHierarchyDiagram is a <SmalltalkToolShell> that displays the current class hierarchy in a graphical format using a <MoenTreeView>.

Instance Variables:
	classesPresenter	<TreePresenter> displaying the class hierarchy.
	commentPresenter	<SmalltalkWorkspace> displaying the comment of the selected class.

'!
!ClassHierarchyDiagram categoriesForClass!Development!MVP-Presenters! !
!ClassHierarchyDiagram methodsFor!

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
!ClassHierarchyDiagram categoriesFor: #canSaveState!private!saved state! !
!ClassHierarchyDiagram categoriesFor: #createComponents!initializing!private! !
!ClassHierarchyDiagram categoriesFor: #createSchematicWiring!initializing!private! !
!ClassHierarchyDiagram categoriesFor: #defaultHelpId!public! !
!ClassHierarchyDiagram categoriesFor: #onClassSelected!event handling!public! !
!ClassHierarchyDiagram categoriesFor: #onViewOpened!event handling!private! !
!ClassHierarchyDiagram categoriesFor: #searchForClass:!private! !

!ClassHierarchyDiagram class methodsFor!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators 
		, #(#(#findClass 'Ctrl+Shift+F') #(#browseClassReferences 'Shift+F12') #(#browseIt 'Ctrl+B') #(#inspectIt 'Ctrl+I'))!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Class Diagram'!

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

	^(super publishedAspects)
		add: (Aspect boolean: #reuseIfOpen);
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB) 8 4294967295 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851532 131073 560 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 0 560 642 672 8 4294903529 234 256 98 4 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 864 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 864 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 770 1 1 770 63 51 864 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 98 0 770 193 193 0 27 8 'imageTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1280 0 946 31 0 7 0 0 0 1280 978 576 8 #resource_Smalltalk_tools 0 1026 202 208 98 1 1090 1120 98 2 770 63 1 770 991 51 1280 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1232 1248 0 27 8 'smalltalkTools' 234 256 1232 202 208 1232 234 240 1232 0 1 0 770 33 33 770 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1026 202 208 98 2 1090 1120 98 2 770 1 1 770 2369 51 560 1090 8 #updateSizePosted 1232 560 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 98 2 864 1280 1248 0 27 0 0 0 410 880 98 14 0 416 98 2 8 1140850688 131073 1856 0 0 0 7 0 0 0 1856 978 8 ##(Smalltalk.ClassHierarchySelector) 8 #resource_Moen_view 0 1026 202 208 98 1 1090 1120 98 2 770 1 51 770 2369 1485 1856 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 255 2 0 0] 1232 1248 0 27 234 256 98 4 1856 8 'classes' 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 4 265030 4 ##(Smalltalk.Menu) 0 16 98 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FileNew.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 2274 1 2306 8 #fileOpen 8 '&Open...' 9375 1 2370 0 16 2416 8 'FileOpen.ico' 2464 0 0 2274 1 2306 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2274 1 2306 8 #saveImage 8 'Sa&ve Image' 1 1 2370 0 16 2416 8 'Snapshot.ico' 2464 0 0 2274 1 2306 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 2370 0 16 2416 8 'PowerSwitch.ico' 2464 0 0 2658 4097 2274 1 2306 8 #exit 8 '&Close' 17639 1 2370 0 16 2416 8 'CloseWindow.ico' 2464 0 0 8 '&File' 0 134217729 0 0 14659 0 0 2226 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 14661 0 0 2226 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 14663 0 0 2226 0 16 98 15 2274 1 2306 8 #helpContents 8 '&Contents' 1025 1 2370 0 16 2416 49 786694 ##(Smalltalk.ShellLibrary) 0 0 2274 1 2306 8 #help 8 'On this &Tool' 1249 1 0 0 0 2274 1 2306 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 2658 4097 2274 1 2306 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 2658 4097 2274 1 2306 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2274 1 2306 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2274 1 2306 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 2658 4097 2274 1 2306 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2274 1 2306 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2274 1 2306 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 2658 4097 2274 1 2306 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2370 0 16 2416 8 '!!APPLICATION' 2464 0 0 8 '&Help' 0 134217729 0 0 14687 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1026 202 208 98 3 1090 1120 98 2 770 3839 21 770 2401 1653 416 1090 8 #text: 98 1 8 'Class Hierarchy Diagram' 416 1090 8 #updateMenuBar 1232 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 47 12 0 0 68 3 0 0] 98 2 560 1856 1248 0 27 )!

toolsFolderHelpId
	^10590!

uninitialize
	"Private - Uninitialize the receiver prior to remove from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!ClassHierarchyDiagram class categoriesFor: #defaultAdditionalAccelerators!initializing!private! !
!ClassHierarchyDiagram class categoriesFor: #displayOn:!displaying!public! !
!ClassHierarchyDiagram class categoriesFor: #icon!constants!public! !
!ClassHierarchyDiagram class categoriesFor: #initialize!initializing!private! !
!ClassHierarchyDiagram class categoriesFor: #publishedAspects!development!public! !
!ClassHierarchyDiagram class categoriesFor: #resource_Default_view!public!resources-views! !
!ClassHierarchyDiagram class categoriesFor: #toolsFolderHelpId!public! !
!ClassHierarchyDiagram class categoriesFor: #uninitialize!class hierarchy-removing!private! !

