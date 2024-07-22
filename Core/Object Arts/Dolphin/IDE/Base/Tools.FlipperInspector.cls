"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.FlipperInspector'
	instanceVariableNames: 'cards'
	classVariableNames: 'Renderers'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.FlipperInspector guid: (Core.GUID fromString: '{8dc9ca40-c164-11d5-9849-0800460222f0}')!

Tools.FlipperInspector comment: ''!

!Tools.FlipperInspector categoriesForClass!MVP-Presenters! !

!Tools.FlipperInspector methodsFor!

addToCommandRoute: route
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer self to have the command policy decide where
	to go next."

	route
		appendTarget: self developmentSystem;
		appendPresenter: cards view currentCard;
		appendPresenter: self!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	cards := self add: Presenter new name: 'cards'.
!

createRenderers
	"Private - Create the presenters used to render view of the receiver's model"

	| firstRendition |
	self class renderers do: 
			[:each | 
			| presenter |
			presenter := each createIn: cards on: self model.
			firstRendition isNil ifTrue: [firstRendition := presenter].
			presenter view arrangement: presenter ].
	firstRendition notNil ifTrue: [firstRendition ensureVisible]!

model: anObject
	"Set the model of the receiver to be a value model on anObject. Usually anObject is expected
	to be a ValueModel itself. If not, it is automatically wrapped in a valueHolder. 
	Register with it's #valueChanged event"

	| valueModel |
	valueModel := anObject asValue.
	super model: valueModel.
	valueModel when: #valueChanged send: #onValueChanged to: self!

object
	"Answer the object inspected by the receiver."

	^self model value!

object: anObject
	"Set the object which is inspected by the receiver."

	self value: anObject
!

onValueChanged
	"Private - The value held by the receiver's model has changed.
	The default is to trigger a #valueChanged event off the receiver"

	self trigger: #valueChanged.
	self updateCaption!

onViewOpened
	super onViewOpened.
	self createRenderers!

renderers
	"Answers the <OrderedCollection> of renderers held by the receiver"
	
	^cards subPresenters!

setInitialFocus
	cards view tabFirst!

setValue: anObject
	"Private - Set the model data of the receiver to be anObject but without propagating
	any change triggers"

	self model setValue: anObject.
!

shortCaption
	^'Inspector'!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	self caption: 'Inspecting ' , self value basicPrintString!

value
	"Answer the model value of the receiver. 
	Any view changes may first need to be flushed"

	self view notNil ifTrue: [ self view updateModel ].
	^self model value!

value: anObject
	"Set the model value of the receiver to be anObject"

	self model value: anObject.
! !

!Tools.FlipperInspector categoriesForMethods!
addToCommandRoute:!commands!public! !
createComponents!initializing!private! !
createRenderers!initializing!private! !
model:!accessing!public! !
object!accessing!public! !
object:!accessing!public! !
onValueChanged!event handling!private! !
onViewOpened!event handling!private! !
renderers!accessing!public! !
setInitialFocus!public! !
setValue:!accessing!private! !
shortCaption!accessing!public! !
updateCaption!public!updating! !
value!accessing!public! !
value:!accessing!public! !
!

!Tools.FlipperInspector class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue
!

defaultOptionFlags
	^CanUseIdeaSpaceMask!

defaultRenderers
	"Private - Answers a <Array> of default  classes that will be used to render views onto an inspected object"

	^OrderedCollection
		with: PublishedAspectInspector
		with: InstVarInspector
		with: VisualObjectFinder!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Visual Inspector'!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	SmalltalkSystem current
		registerTool: self;
		addSystemFolderIcon: self toolsFolderIcon.
	Renderers := self defaultRenderers!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: ((Aspect sequenceableCollection: #renderers)
					defaultValue: [self defaultRenderers];
					yourself);
		add: self canUseIdeaSpaceAspect;
		yourself!

renderers
	"Answer an <OrderedCollection> of classes that will be used to render views of an inspected object"

	^Renderers!

renderers: anOrderedCollection
	"Sets classes that will be used to render views of an inspected object to anOrderedCollection"

	Renderers = anOrderedCollection ifTrue: [^self].
	Renderers := anOrderedCollection.
	self persistOptions!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground 518 #{Graphics.Point} 1161 921 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853612 131073 192 nil nil nil 517 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 192 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 10 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 416 nil nil nil 5 nil nil nil 416 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Edit_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 193 448 8 '' 416 3 8 #() 130 193 193 nil 27 8 'editTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 752 nil nil nil 5 nil nil nil 752 482 #{UI.Toolbar} #resource_Image_tools nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 784 8 '' 752 3 704 130 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 992 nil nil nil 5 nil nil nil 992 482 #{UI.Toolbar} #resource_Search_tools nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1024 8 '' 992 3 704 130 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 1232 nil nil nil 5 nil nil nil 1232 482 #{UI.Toolbar} #resource_Smalltalk_tools nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1264 8 '' 1232 3 704 130 193 193 nil 27 8 'smalltalkTools' 18 #{UI.ReferenceView} 50 14 nil 192 50 2 8 1140850688 131073 1472 nil nil nil 5 nil nil nil 1472 482 #{UI.Toolbar} #resource_Workspace_tools nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[123 0 0 0 25 0 0 0 246 0 0 0 50 0 0 0] 193 1504 8 '' 1472 3 704 130 193 193 nil 27 8 'workspaceTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 9 1589 #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 514 50 1 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 193 224 8 '' 192 3 50 6 752 1232 992 416 1472 18 #{UI.Toolbar} 50 28 nil 192 50 2 8 1140853580 131137 1920 nil nil nil 517 nil nil nil 1920 352 nil 370 #{Core.IdentityDictionary} 704 nil nil nil nil 50 1 1094 1 #{UI.ToolbarIconButton} 1920 1 1350 4 #{UI.CommandDescription} #refresh 8 'Refresh' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'Refresh.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil nil 9 nil #smallIcons nil nil 1746 1 1 1 514 50 1 562 #createWindow: 50 1 610 642 8 #[246 0 0 0 25 0 0 0 15 1 0 0 50 0 0 0] 193 1952 8 '' 1920 3 8 #() 130 193 193 nil 31 130 193 193 nil 31 nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2416 nil nil nil 5 nil nil nil 2416 162 1 1 nil nil nil nil 18 #{UI.CardContainer} 50 16 nil 2416 50 2 8 1140850688 131073 2496 nil nil nil 5 2886 4 #{UI.Menu} nil true 50 2 2562 nil true 50 4 1094 2 #{UI.CommandMenuItem} 1025 2050 518 #{Core.Message} #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 2642 1025 2050 2690 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 2642 1025 2050 2690 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 2642 1025 2050 2690 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 2562 nil true 50 5 2642 1025 2050 2690 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 2642 1025 2050 2690 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 2642 1025 2050 2690 #viewMode: 8 #(#mediumIcons) 8 'Medium Icons' 1 1 nil nil nil 2642 1025 2050 2690 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 2642 1025 2050 2690 #viewMode: 8 #(#tileIcons) 8 'Tile Icons' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2496 1350 1 #{UI.CardLayout} 1714 0 nil nil nil nil 550 #{Core.IdentityDictionary} 0 nil 18 #{UI.TabViewXP} 50 28 nil 2496 50 2 8 1140916736 1 3552 838 2 #{UI.ListModel} 1714 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 1 nil nil nil 3552 nil nil #{UI.BasicListAbstract} #{UI.IconicListAbstract} 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #smallIcons nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 193 3584 8 '' 3552 562 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3552 3 8 #() 130 193 193 nil 27 514 50 2 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 193 2528 8 '' 2496 562 #contextMenu: 50 1 2576 2496 3 50 1 3552 130 193 193 nil 27 370 3520 50 2 2496 8 'cards' nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[0 0 0 0 50 0 0 0 52 2 0 0 145 1 0 0] 193 2448 8 '' 2416 3 50 1 2496 130 193 193 nil 27 370 3520 50 2 192 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 6 2562 nil true 50 8 2642 1 2050 #fileNew 8 '&New Workspace' 9373 1 2098 nil true 2130 8 'NewWorkspace.ico' 2192 65541 nil nil nil 2642 1 2050 #fileOpen 8 '&Open Workspace...' 9375 1 2098 nil true 2130 8 'OpenWorkspace.ico' 2192 65541 nil nil nil 2642 1 2050 #fileFileIn 8 '&File In...' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2642 1 2050 #saveImage 8 'Sa&ve Image' 1 1 2098 nil true 2130 8 'Snapshot.ico' 2192 65541 nil nil nil 2642 1 2050 #smalltalkExit 8 'E&xit Dolphin' 1 1 2098 nil true 2130 8 'PowerSwitch.ico' 2192 65541 nil nil nil 4690 4097 2642 1 2050 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 2562 nil true 50 12 2642 1 2050 #undo 8 '&Undo' 9397 1 2098 nil true 2130 8 'EditUndo.ico' 2192 65541 nil nil nil 2642 1 2050 #redo 8 'R&edo' 9395 1 2098 nil true 2130 8 'EditRedo.ico' 2192 65541 nil nil nil 4690 4097 2642 1 2050 #cutSelection 8 'Cu&t' 9393 1 2098 nil true 2130 8 'EditCut.ico' 2192 65541 nil nil nil 2642 1 2050 #copySelection 8 '&Copy' 9351 1 2098 nil true 2130 8 'EditCopy.ico' 2192 65541 nil nil nil 2642 1 2050 #pasteClipboard 8 '&Paste' 9389 1 2098 nil true 2130 8 'EditPaste.ico' 2192 65541 nil nil nil 2642 1 2050 #clearSelection 8 '&Delete' 1 1 2098 nil true 2130 8 'EditClear.ico' 2192 65541 nil nil nil 2642 1 2050 #selectAll 8 'Select &All' 9347 1 nil nil nil 4690 4097 2642 1 2050 #editFind 8 '&Find...' 9357 1 2098 nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 2642 1 2050 #findNext 8 'Find &Next' 1253 1 2098 nil true 2130 8 'FindNext.ico' 2192 65541 nil nil nil 2642 1 2050 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2562 nil true 50 14 2642 1 2050 #browseIt 8 '&Browse It' 9349 1 2098 nil true 2130 8 'ClassBrowserShell.ico' 2192 65541 nil nil nil 2642 1 2050 #displayIt 8 '&Display It' 9353 1 2098 nil true 2130 8 'DisplayIt.ico' 2192 65541 nil nil nil 2642 1 2050 #printIt 8 '&Print It' 9377 1 2098 nil true 2130 8 'PrintIt.ico' 2192 65541 nil nil nil 2642 1 2050 #evaluateIt 8 '&Evaluate It' 9355 1 2098 nil true 2130 8 'EvaluateIt.ico' 2192 65541 nil nil nil 2642 1 2050 #inspectIt 8 '&Inspect It' 9363 1 2098 nil true 2130 8 'BasicInspector.ico' 2192 65541 nil nil nil 2642 1 2050 #debugIt 8 'Deb&ug It' 1269 1 2098 nil true 2130 8 'Debugger.ico' 2192 65541 nil nil nil 2642 1 2050 #fileItIn 8 '&File It In' 1 1 nil nil nil 4690 4097 2642 1 2050 #accept 8 '&Accept' 9383 1 nil nil nil 4690 4097 2642 1 2050 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 2642 1 2050 #browseReferences 8 '&References...' 5367 1 nil nil nil 4690 4097 2562 nil true 50 9 2642 1 2050 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2642 1 2050 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2642 1 2050 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 2642 1 2050 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2642 1 2050 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2642 1 2050 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2642 1 2050 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 4690 4097 2562 nil true 50 2 2642 1 2050 2690 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 2642 1 2050 2690 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 2562 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 2562 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 2562 nil true 50 15 2642 1 2050 #helpContents 8 '&Contents' 1025 1 2098 nil true 2130 8 'Help.ico' 2192 65541 nil nil nil 2642 1 2050 #help 8 'On this &Tool' 1249 1 nil nil nil 2642 1 2050 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4690 4097 2642 1 2050 #learnSmalltalk 8 'Learn Smalltalk' 1 1 4978 8 $🎓 nil 338 #orchid 338 #white nil nil 1 nil nil nil nil 4690 4097 2642 1 2050 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2642 1 2050 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2642 1 2050 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4690 4097 2642 1 2050 #dolphinHomePage 8 'Dolphin Homepage' 1 1 2098 nil true 2130 8 '!!APPLICATION' 2192 65541 nil nil nil 2642 1 2050 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2642 1 2050 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4690 4097 2642 1 2050 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4978 8 $🐬 nil nil 338 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 130 883 661 1 nil 193 514 50 1 562 #createWindow: 50 1 610 642 8 #[255 11 0 0 10 0 0 0 67 14 0 0 214 1 0 0] 193 80 8 'Flipper Inspector' 32 1 50 2 192 2416 130 193 193 nil 27)!

shellOn: anObject
	"Open an instance of the receiver displaying anObject. 
	Answer the new inspector."

	^(self show)
		value: anObject;
		yourself!

toolsFolderHelpId
	^10600! !

!Tools.FlipperInspector class categoriesForMethods!
defaultModel!models!public! !
defaultOptionFlags!constants!options!private! !
defaultRenderers!constants!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
renderers!accessing!public! !
renderers:!accessing!public! !
resource_Default_view!public!resources-views! !
shellOn:!instance creation!public! !
toolsFolderHelpId!public! !
!

