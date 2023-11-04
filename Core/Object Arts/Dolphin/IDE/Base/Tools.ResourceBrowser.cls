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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 10 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 416 nil nil nil 5 nil nil nil 416 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 306 1 1 306 63 51 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 306 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 736 nil nil nil 5 nil nil nil 736 482 #{UI.Toolbar} #resource_Resource_tools nil 514 50 1 562 #createAt:extent: 50 2 306 1051 1 306 109 51 736 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 67 2 0 0 25 0 0 0] 688 704 nil 27 8 'resourceTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 482 #{UI.Toolbar} #resource_Search_tools nil 514 50 1 562 #createAt:extent: 50 2 306 615 1 306 437 51 960 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 688 704 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1184 nil nil nil 5 nil nil nil 1184 482 #{UI.Toolbar} #resource_Smalltalk_tools nil 514 50 1 562 #createAt:extent: 50 2 306 63 1 306 553 51 1184 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 688 704 nil 27 8 'smalltalkTools' 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1140853612 131137 1408 nil nil nil 517 nil nil nil 1408 352 nil 370 #{Core.IdentityDictionary} 688 nil nil nil nil 50 1 1094 1 #{UI.ToolbarIconButton} 1408 17 1350 4 #{UI.CommandDescription} #viewModeSelect 8 'Views' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'ViewMode.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil nil 1 nil nil nil nil nil 514 50 1 562 #createAt:extent: 50 2 306 1159 1 306 77 51 1408 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 2 0 0 0 0 0 0 105 2 0 0 25 0 0 0] 8 #() 704 nil 29 8 'viewTools' nil nil nil nil 8 #() nil nil 1 nil 306 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 514 50 1 562 #createAt:extent: 50 2 306 1 1 306 1399 51 160 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 187 2 0 0 25 0 0 0] 50 5 416 1184 960 736 1408 704 nil 29 nil nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 2080 nil nil nil 13 nil nil nil 2080 482 #{Tools.ResourceToolboxPresenter} #resource_Default_view nil 514 50 1 562 #createAt:extent: 50 2 306 1 51 306 1399 1053 2080 642 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 187 2 0 0 39 2 0 0] 688 704 nil 27 370 #{Core.IdentityDictionary} 50 4 2080 8 'resourceToolbox' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 4 2886 4 #{UI.Menu} nil true 50 9 1094 2 #{UI.CommandMenuItem} 1 1538 #browseHierarchy 8 '&Browse <1s>' 1 1 1586 nil true 1618 8 'ClassBrowserShell.ico' 1680 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2450 1 1538 #newView 8 '&New' 1 1 nil nil nil 2450 1 1538 #deleteResource 8 '&Delete…' 1 1 1586 nil true 1618 8 'EditClear.ico' 1680 65541 nil nil nil 2562 4097 2450 1 1538 #editResource 8 '&Open' 9349 1 1586 nil true 1618 8 'ViewComposer.ico' 1680 65541 nil nil nil 2562 4097 2450 1 1538 #resourcePackage 8 '&Package…' 1 1 1586 nil true 1618 8 'Package.ico' 1680 65541 nil nil nil 2450 1 1538 #categorizeResource 8 'Category…' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 2402 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 2402 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 2402 nil true 50 15 2450 1 1538 #helpContents 8 '&Contents' 1025 1 1586 nil true 1618 8 'Help.ico' 1680 65541 nil nil nil 2450 1 1538 #help 8 'On this &Tool' 1249 1 nil nil nil 2450 1 1538 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2562 4097 2450 1 1538 #learnSmalltalk 8 'Learn Smalltalk' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $🎓 nil 338 #orchid 338 #white nil nil 1 nil nil nil nil 2562 4097 2450 1 1538 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2450 1 1538 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2450 1 1538 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2562 4097 2450 1 1538 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1586 nil true 1618 8 '!!APPLICATION' 1680 65541 nil nil nil 2450 1 1538 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2450 1 1538 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2562 4097 2450 1 1538 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3410 8 $🐬 nil nil 338 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 514 50 2 562 #createAt:extent: 50 2 306 6143 21 306 1431 1221 32 562 #text: 50 1 8 'View Browser' 32 642 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 202 14 0 0 108 2 0 0] 50 2 160 2080 704 nil 27)!

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

