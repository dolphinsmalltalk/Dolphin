"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.ResourceBrowser'
	instanceVariableNames: 'resourceToolboxPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ResourceBrowser guid: (Core.GUID fromString: '{87b4c6c2-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.ResourceBrowser comment: 'ResourceBrowser is a <SmalltalkToolShell> that implements the Resource Browser tool. This provides an interface onto all the <Resource>s held by the current <ResourceManager>.

Instance Variables:
	resourceListPresenter		<ResourceListPresenter> displaying the current list of resources.
	resourceTree			<UndefinedObject> not used.
	packagesPresenter			<ListPresenter> displaying a list of all the current packages.
'!
!Tools.ResourceBrowser categoriesForClass!MVP-Presenters! !
!Tools.ResourceBrowser methodsFor!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	resourceToolboxPresenter := self add: ResourceToolboxPresenter new name: 'resourceToolbox'!

defaultHelpId
	^10847!

newView
	"Open the ViewComposer on an new default view resource for the
	selected class. If there are several possibilities allow the user to select
	the one to edit"

	| selection |
	(selection := self resource) notNil 
		ifTrue: [self model openViewComposerOnNewViewFor: selection owningClass]
		ifFalse: [self model openViewComposer]
 !

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	super onViewOpened.

	"Enable view mode pulldown"
	(self view viewNamed: 'viewTools' ifNone: nil)
		ifNotNil: 
			[:toolbar |
			toolbar presenterConnectionPoint
				when: #dropDown:
				send: #onDropDown:
				to: resourceToolboxPresenter categoriesPresenter view]!

resource
	"Answer the selected resource identifier in the receiver or nil if there
	is none"

	^resourceToolboxPresenter selectionOrNil!

resource: aResourceIdentifierOrNil 
	resourceToolboxPresenter selectionOrNil: aResourceIdentifierOrNil!

resourceToolboxPresenter
	^resourceToolboxPresenter!

saveStateOn: aWriteStream
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	aWriteStream nextPutAll: '[ :aResourceBrowser | aResourceBrowser resource: '.
	self resource storeOn: aWriteStream.
	aWriteStream
		nextPut: $.;
		cr.
	super saveStateOn: aWriteStream.
	aWriteStream nextPutAll: ' value: aResourceBrowser.'.
	aWriteStream nextPutAll: ']'!

selectCategory: aString 
	^resourceToolboxPresenter selectCategory: aString!

setInitialFocus
	resourceToolboxPresenter view tabFirst!

shortCaption
	^'Views'!

showResourcesReferencingView: aResourceIdentifier
	resourceToolboxPresenter showResourcesReferencingView: aResourceIdentifier.
	self caption: ('Views referencing <1p>' expandMacrosWith: aResourceIdentifier)! !
!Tools.ResourceBrowser categoriesForMethods!
canSaveState!private!saved state! !
createComponents!**auto generated**!initializing!private! !
defaultHelpId!public! !
newView!commands!public! !
onViewOpened!event handling!private! !
resource!accessing!public! !
resource:!accessing!public! !
resourceToolboxPresenter!private! !
saveStateOn:!private!saved state! !
selectCategory:!public! !
setInitialFocus!operations!public! !
shortCaption!accessing!public! !
showResourcesReferencingView:!public! !
!

!Tools.ResourceBrowser class methodsFor!

defaultOptionFlags
	^##(ReuseIfOpenMask | CanUseIdeaSpaceMask)!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'View Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Register the receiver with SmalltalkSystem.
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 39 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 528 917510 #{Graphics.Color} #default 8 1815075056 170 192 34 10 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Search_tools nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 674 615 1 674 437 51 784 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'searchTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1104 nil nil nil 7 nil nil nil 1104 850 #{UI.Toolbar} #resource_Image_tools nil 882 34 1 930 #createAt:extent: 34 2 674 1 1 674 63 51 1104 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1056 1072 nil 27 8 'imageTools' 410 #{UI.Toolbar} 34 28 nil 528 34 2 8 1140853612 131137 1328 nil nil nil 519 nil nil nil 1328 720 8 1815075056 170 192 1056 nil nil nil 170 192 34 2 55401 1311814 1 #{UI.ToolbarIconButton} 1328 17 1377606 4 #{UI.CommandDescription} #viewModeSelect 8 'Views' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'ViewMode.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil 55401 34 1 1472 nil nil 1 nil nil nil nil nil 882 34 1 930 #createAt:extent: 34 2 674 1159 1 674 77 51 1328 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 2 0 0 0 0 0 0 105 2 0 0 25 0 0 0] 8 #() 1072 nil 29 8 'viewTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1840 nil nil nil 7 nil nil nil 1840 850 #{UI.Toolbar} #resource_Resource_tools nil 882 34 1 930 #createAt:extent: 34 2 674 1051 1 674 109 51 1840 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 67 2 0 0 25 0 0 0] 1056 1072 nil 27 8 'resourceTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 2064 nil nil nil 7 nil nil nil 2064 850 #{UI.Toolbar} #resource_Smalltalk_tools nil 882 34 1 930 #createAt:extent: 34 2 674 63 1 674 553 51 2064 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 1056 1072 nil 27 8 'smalltalkTools' nil nil nil 170 192 1056 8 #() nil nil 1 nil 674 33 33 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 882 34 1 930 #createAt:extent: 34 2 674 1 1 674 1399 51 528 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 187 2 0 0 25 0 0 0] 34 5 1104 2064 784 1840 1328 1072 nil 29 nil nil nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 2512 nil nil nil 15 nil nil nil 2512 850 #{Tools.ResourceToolboxPresenter} #resource_Default_view nil 882 34 1 930 #createAt:extent: 34 2 674 1 51 674 1399 1053 2512 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 187 2 0 0 39 2 0 0] 1056 1072 nil 27 170 192 34 4 528 8 'toolbar' 2512 8 'resourceToolbox' nil 658246 4 #{UI.MenuBar} nil true 34 4 461638 4 #{UI.Menu} nil true 34 9 1180742 2 #{UI.CommandMenuItem} 1 1490 #browseHierarchy 8 '&Browse <1s>' 1 1 1538 nil true 1570 8 'ClassBrowserShell.ico' 1632 65541 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 2882 1 1490 #newView 8 '&New' 1 1 nil nil nil 2882 1 1490 #deleteResource 8 '&Delete…' 1 1 1538 nil true 1570 8 'EditClear.ico' 1632 65541 nil nil nil 2994 4097 2882 1 1490 #editResource 8 '&Open' 9349 1 1538 nil true 1570 8 'ViewComposer.ico' 1632 65541 nil nil nil 2994 4097 2882 1 1490 #resourcePackage 8 '&Package…' 1 1 1538 nil true 1570 8 'Package.ico' 1632 65541 nil nil nil 2882 1 1490 #categorizeResource 8 'Category…' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil 55415 nil nil 2834 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 55417 nil nil 2834 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 55419 nil nil 2834 nil true 34 15 2882 1 1490 #helpContents 8 '&Contents' 1025 1 1538 nil true 1570 8 'Help.ico' 1632 65541 nil nil nil 2882 1 1490 #help 8 'On this &Tool' 1249 1 nil nil nil 2882 1 1490 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2994 4097 2882 1 1490 #learnSmalltalk 8 'Learn Smalltalk' 1 1 1378630 2 #{Graphics.TextTileIcon} $\x1F393 nil 706 #orchid 706 #white nil nil 1 nil nil nil nil 2994 4097 2882 1 1490 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2882 1 1490 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2882 1 1490 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2994 4097 2882 1 1490 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1538 nil true 1570 8 '!!APPLICATION' 1632 65541 nil nil nil 2882 1 1490 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2882 1 1490 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2994 4097 2882 1 1490 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3842 $\x1F42C nil nil 706 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 55443 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 882 34 2 930 #createAt:extent: 34 2 674 12287 21 674 1431 1221 416 930 #text: 34 1 8 'View Browser' 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 202 26 0 0 108 2 0 0] 34 2 528 2512 1072 nil 27)!

showAsToolboxFor: aView at: aPoint
	"Creates an instance of the receiver in a toolbox view attached to aView
	and displayed at aPoint relative to the origin of this view"

	| toolbox toolboxView position |
	toolboxView := (self loadViewResource: 'Toolbox' inContext: View desktop) bePopupFor: aView.
	position := aView mapPointToScreen: aPoint.
	toolboxView position: position.

	toolbox := self new.
	toolbox view: toolboxView.

	^toolbox show!

toolsFolderHelpId
	^10594! !
!Tools.ResourceBrowser class categoriesForMethods!
defaultOptionFlags!constants!options!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
showAsToolboxFor:at:!instance creation!public! !
toolsFolderHelpId!public! !
!

