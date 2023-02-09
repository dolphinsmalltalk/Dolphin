"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell subclass: #'Tools.FlipperInspector'
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground 918022 #{Graphics.Point} 1161 921 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853612 131073 560 nil nil nil 519 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 560 917510 #{Graphics.Color} #default 8 1815075056 170 192 34 10 410 #{UI.ReferenceView} 34 14 nil 560 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 1 1 498 63 51 800 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'imageTools' 410 #{UI.ReferenceView} 34 14 nil 560 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 866 #{UI.Toolbar} #resource_Smalltalk_tools nil 898 34 1 946 #createAt:extent: 34 2 498 63 1 498 553 51 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 1072 1088 nil 27 8 'smalltalkTools' 410 #{UI.ReferenceView} 34 14 nil 560 34 2 8 1140850688 131073 1344 nil nil nil 7 nil nil nil 1344 866 #{UI.Toolbar} #resource_Search_tools nil 898 34 1 946 #createAt:extent: 34 2 498 615 1 498 437 51 1344 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1072 1088 nil 27 8 'searchTools' 410 #{UI.ReferenceView} 34 14 nil 560 34 2 8 1140850688 131073 1568 nil nil nil 7 nil nil nil 1568 866 #{UI.Toolbar} #resource_Workspace_tools nil 898 34 1 946 #createAt:extent: 34 2 498 247 51 498 247 51 1568 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 246 0 0 0 50 0 0 0] 1072 1088 nil 27 8 'workspaceTools' 410 #{UI.ReferenceView} 34 14 nil 560 34 2 8 1140850688 131073 1792 nil nil nil 7 nil nil nil 1792 866 #{UI.Toolbar} #resource_Edit_tools nil 898 34 1 946 #createAt:extent: 34 2 498 1 51 498 247 51 1792 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 1072 1088 nil 27 8 'editTools' nil nil nil 170 192 1072 138 144 1072 nil nil 1 nil 498 33 33 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 898 34 1 946 #createAt:extent: 34 2 498 1 1 498 1129 101 560 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 34 6 800 1120 1344 1792 1568 410 #{UI.Toolbar} 34 28 nil 560 34 2 8 1140853580 131137 2240 nil nil nil 519 nil nil nil 2240 736 8 1815075056 170 192 1072 nil nil nil 170 192 34 2 52779 1311814 1 #{UI.ToolbarIconButton} 2240 1 1377606 4 #{UI.CommandDescription} #refresh 8 'Refresh' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'Refresh.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil 52779 34 1 2384 nil nil 1 nil nil nil nil 2066 1 1 1 898 34 1 946 #createAt:extent: 34 2 498 493 51 498 51 51 2240 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 246 0 0 0 25 0 0 0 15 1 0 0 50 0 0 0] 8 #() 1088 nil 29 1088 nil 29 nil nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 2752 nil nil nil 7 nil nil nil 2752 530 1 1 nil nil nil nil 410 #{UI.CardContainer} 34 16 nil 2752 34 2 8 1140850688 131073 2832 nil nil nil 7 461638 4 #{UI.Menu} nil true 34 2 2898 nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1025 2402 786950 #{Core.Message} #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 2978 1025 2402 3026 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 2978 1025 2402 3026 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 2978 1025 2402 3026 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 2898 nil true 34 5 2978 1025 2402 3026 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 2978 1025 2402 3026 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 2978 1025 2402 3026 #viewMode: 8 #(#mediumIcons) 8 'Medium Icons' 1 1 nil nil nil 2978 1025 2402 3026 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 2978 1025 2402 3026 #viewMode: 8 #(#tileIcons) 8 'Tile Icons' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2832 853318 1 #{UI.CardLayout} 138 144 1072 nil nil nil nil 170 192 1072 nil 410 #{UI.TabViewXP} 34 28 nil 2832 34 2 8 1140916736 1 3872 787270 2 #{UI.ListModel} 138 144 1072 nil 1769478 #{Kernel.IdentitySearchPolicy} nil nil 1 nil nil nil 3872 nil 8 1814862704 3026 #displayString 1072 3026 #iconImageIndex 1072 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil #smallIcons nil nil nil nil nil 898 34 2 946 #createAt:extent: 34 2 498 1 1 498 1129 703 3872 946 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3872 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 8 #() 1088 nil 27 898 34 2 946 #createAt:extent: 34 2 498 1 1 498 1129 703 2832 946 #contextMenu: 34 1 2912 2832 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 34 1 3872 1088 nil 27 170 192 34 2 2832 8 'cards' nil 898 34 1 946 #createAt:extent: 34 2 498 1 101 498 1129 703 2752 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 52 2 0 0 145 1 0 0] 34 1 2832 1088 nil 27 170 192 34 2 560 8 'toolbar' nil 658246 4 #{UI.MenuBar} nil true 34 6 2898 nil true 34 8 2978 1 2402 #fileNew 8 '&New Workspace' 9373 1 2450 nil true 2482 8 'NewWorkspace.ico' 2544 65541 nil nil nil 2978 1 2402 #fileOpen 8 '&Open Workspace…' 9375 1 2450 nil true 2482 8 'OpenWorkspace.ico' 2544 65541 nil nil nil 2978 1 2402 #fileFileIn 8 '&File In…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 2978 1 2402 #saveImage 8 'Sa&ve Image' 1 1 2450 nil true 2482 8 'Snapshot.ico' 2544 65541 nil nil nil 2978 1 2402 #smalltalkExit 8 'E&xit Dolphin' 1 1 2450 nil true 2482 8 'PowerSwitch.ico' 2544 65541 nil nil nil 5010 4097 2978 1 2402 #exit 8 '&Close' 17639 1 1378630 2 #{Graphics.TextTileIcon} $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 52793 nil nil 2898 nil true 34 12 2978 1 2402 #undo 8 '&Undo' 9397 1 2450 nil true 2482 8 'EditUndo.ico' 2544 65541 nil nil nil 2978 1 2402 #redo 8 'R&edo' 9395 1 2450 nil true 2482 8 'EditRedo.ico' 2544 65541 nil nil nil 5010 4097 2978 1 2402 #cutSelection 8 'Cu&t' 9393 1 2450 nil true 2482 8 'EditCut.ico' 2544 65541 nil nil nil 2978 1 2402 #copySelection 8 '&Copy' 9351 1 2450 nil true 2482 8 'EditCopy.ico' 2544 65541 nil nil nil 2978 1 2402 #pasteClipboard 8 '&Paste' 9389 1 2450 nil true 2482 8 'EditPaste.ico' 2544 65541 nil nil nil 2978 1 2402 #clearSelection 8 '&Delete' 1 1 2450 nil true 2482 8 'EditClear.ico' 2544 65541 nil nil nil 2978 1 2402 #selectAll 8 'Select &All' 9347 1 nil nil nil 5010 4097 2978 1 2402 #editFind 8 '&Find…' 9357 1 2450 nil true 2425862 #{Graphics.ImageFromResourceInitializer} 47 983302 #{OS.ShellLibrary} 65541 nil nil nil 2978 1 2402 #findNext 8 'Find &Next' 1253 1 2450 nil true 2482 8 'FindNext.ico' 2544 65541 nil nil nil 2978 1 2402 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 52815 nil nil 2898 nil true 34 14 2978 1 2402 #browseIt 8 '&Browse It' 9349 1 2450 nil true 2482 8 'ClassBrowserShell.ico' 2544 65541 nil nil nil 2978 1 2402 #displayIt 8 '&Display It' 9353 1 2450 nil true 2482 8 'DisplayIt.ico' 2544 65541 nil nil nil 2978 1 2402 #printIt 8 '&Print It' 9377 1 2450 nil true 2482 8 'PrintIt.ico' 2544 65541 nil nil nil 2978 1 2402 #evaluateIt 8 '&Evaluate It' 9355 1 2450 nil true 2482 8 'EvaluateIt.ico' 2544 65541 nil nil nil 2978 1 2402 #inspectIt 8 '&Inspect It' 9363 1 2450 nil true 2482 8 'BasicInspector.ico' 2544 65541 nil nil nil 2978 1 2402 #debugIt 8 'Deb&ug It' 1269 1 2450 nil true 2482 8 'Debugger.ico' 2544 65541 nil nil nil 2978 1 2402 #fileItIn 8 '&File It In' 1 1 nil nil nil 5010 4097 2978 1 2402 #accept 8 '&Accept' 9383 1 nil nil nil 5010 4097 2978 1 2402 #browseDefinitions 8 'Defi&nitions…' 1271 1 nil nil nil 2978 1 2402 #browseReferences 8 '&References…' 5367 1 nil nil nil 5010 4097 2898 nil true 34 9 2978 1 2402 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2978 1 2402 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2978 1 2402 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 2978 1 2402 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2978 1 2402 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2978 1 2402 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2978 1 2402 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5010 4097 2898 nil true 34 2 2978 1 2402 3026 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 2978 1 2402 3026 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 52855 nil nil 8 '&Options' nil 134217729 nil nil 52857 nil nil 8 '&Workspace' nil 134217729 nil nil 52859 nil nil 2898 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 52861 nil nil 2898 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 52863 nil nil 2898 nil true 34 15 2978 1 2402 #helpContents 8 '&Contents' 1025 1 2450 nil true 2482 8 'Help.ico' 2544 65541 nil nil nil 2978 1 2402 #help 8 'On this &Tool' 1249 1 nil nil nil 2978 1 2402 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5010 4097 2978 1 2402 #learnSmalltalk 8 'Learn Smalltalk' 1 1 5298 $\x1F393 nil 722 #orchid 722 #white nil nil 1 nil nil nil nil 5010 4097 2978 1 2402 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2978 1 2402 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2978 1 2402 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5010 4097 2978 1 2402 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 2450 nil true 2482 8 '!!APPLICATION' 2544 65541 nil nil nil 2978 1 2402 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2978 1 2402 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5010 4097 2978 1 2402 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5298 $\x1F42C nil nil 722 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 52887 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 498 883 661 1 nil nil 898 34 2 946 #createAt:extent: 34 2 498 12287 21 498 1161 921 416 946 #text: 34 1 8 'Flipper Inspector' 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 67 26 0 0 214 1 0 0] 34 2 560 2752 1088 nil 27)!

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

