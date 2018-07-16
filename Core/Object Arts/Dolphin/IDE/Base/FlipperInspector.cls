"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #FlipperInspector
	instanceVariableNames: 'cards'
	classVariableNames: 'Renderers'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FlipperInspector guid: (GUID fromString: '{8dc9ca40-c164-11d5-9849-0800460222f0}')!
FlipperInspector comment: ''!
!FlipperInspector categoriesForClass!Development! !
!FlipperInspector methodsFor!

addToCommandRoute: route
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer self to have the command policy decide where
	to go next."

	route
		appendTarget: self systemModel;
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
!FlipperInspector categoriesFor: #addToCommandRoute:!commands!public! !
!FlipperInspector categoriesFor: #createComponents!initializing!private! !
!FlipperInspector categoriesFor: #createRenderers!initializing!private! !
!FlipperInspector categoriesFor: #model:!accessing!public! !
!FlipperInspector categoriesFor: #object!accessing!public! !
!FlipperInspector categoriesFor: #object:!accessing!public! !
!FlipperInspector categoriesFor: #onValueChanged!event handling!private! !
!FlipperInspector categoriesFor: #onViewOpened!event handling!private! !
!FlipperInspector categoriesFor: #renderers!accessing!public! !
!FlipperInspector categoriesFor: #setInitialFocus!public! !
!FlipperInspector categoriesFor: #setValue:!accessing!private! !
!FlipperInspector categoriesFor: #shortCaption!accessing!public! !
!FlipperInspector categoriesFor: #updateCaption!public!updating! !
!FlipperInspector categoriesFor: #value!accessing!public! !
!FlipperInspector categoriesFor: #value:!accessing!public! !

!FlipperInspector class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue
!

defaultRenderers
	"Private - Answers a <Array> of default  classes that will be used to render views onto an inspected object"

	^OrderedCollection 
		with: PublishedAspectInspector
		with: InstVarInspector
		with: VisualObjectFinder!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Visual Inspector'!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	(Smalltalk developmentSystem)
		registerTool: self;
		addSystemFolderIcon: self toolsFolderIcon.
	self renderers: self defaultRenderers.
	self canUseIdeaSpace: true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: ((Aspect sequenceableCollection: #renderers)
					isNullable: false;
					yourself);
		add: (Aspect boolean: #reuseIfOpen);
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

renderers
	"Answer an <OrderedCollection> of classes that will be used to render views of an inspected object"

	^Renderers!

renderers: anOrderedCollection
	"Sets classes that will be used to render views of an inspected object to anOrderedCollection"

	Renderers := anOrderedCollection!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground 328198 ##(Smalltalk.Point) 1161 921 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853612 131073 560 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 560 524550 ##(Smalltalk.ColorRef) 8 4278190080 8 1912794480 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 816 nil nil nil 7 nil nil nil 816 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 63 1 498 599 51 816 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 74 1 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1152 nil nil nil 7 nil nil nil 1152 882 ##(Smalltalk.Toolbar) #resource_Search_tools nil 914 138 144 34 1 978 #createAt:extent: 34 2 498 661 1 498 433 51 1152 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 1 0 0 0 0 0 0 34 2 0 0 25 0 0 0] 1104 1120 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1392 nil nil nil 7 nil nil nil 1392 882 ##(Smalltalk.Toolbar) #resource_Image_tools nil 914 138 144 34 1 978 #createAt:extent: 34 2 498 1 1 498 63 51 1392 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1104 1120 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1632 nil nil nil 7 nil nil nil 1632 882 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 914 138 144 34 1 978 #createAt:extent: 34 2 498 1 51 498 247 51 1632 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 1104 1120 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 560 34 2 8 1140850688 131073 1872 nil nil nil 7 nil nil nil 1872 882 ##(Smalltalk.Toolbar) #resource_Workspace_tools nil 914 138 144 34 1 978 #createAt:extent: 34 2 498 247 51 498 201 51 1872 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 223 0 0 0 50 0 0 0] 1104 1120 nil 27 8 'workspaceTools' 170 192 1104 138 144 1104 170 176 1104 nil 1 nil 498 33 33 498 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 914 138 144 34 2 978 #createAt:extent: 34 2 498 1 1 498 1129 101 560 978 #updateSizePosted 1104 560 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 50 0 0 0] 34 6 1392 816 1152 1632 1872 410 ##(Smalltalk.Toolbar) 34 25 nil 560 34 2 8 1140853580 131137 2400 nil nil nil 519 nil 626 nil true 658 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 2400 722 752 8 1912794480 170 192 1104 170 192 34 2 29109 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 2400 1 1180998 4 ##(Smalltalk.CommandDescription) #refresh 8 'Refresh' 1 1 nil 29109 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Tools.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 71 498 1857 33 85 34 1 2624 170 176 34 2 2704 1 nil 1 nil 498 33 33 498 45 45 nil 2194 1 1 1 914 138 144 34 2 978 #createAt:extent: 34 2 498 447 51 498 51 51 2400 978 #updateSizePosted 1104 2400 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 223 0 0 0 25 0 0 0 248 0 0 0 50 0 0 0] 8 #() 1120 nil 27 1120 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3104 nil nil nil 7 nil nil nil 3104 530 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 3104 34 2 8 1140850688 131073 3184 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 2 3250 nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1025 2642 459270 ##(Smalltalk.Message) #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 3330 1025 2642 3378 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 3330 1025 2642 3378 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 3330 1025 2642 3378 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 3250 nil true 34 5 3330 1025 2642 3378 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 3330 1025 2642 3378 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 3330 1025 2642 3378 #viewMode: 8 #(#mediumIcons) 8 'Medium Icons' 1 1 nil nil nil 3330 1025 2642 3378 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 3330 1 2642 3378 #viewMode: 8 #(#tileIcons) 8 'Tile Icons' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3184 655878 ##(Smalltalk.CardLayout) 138 144 1104 nil 170 192 1104 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3184 34 2 8 1140916736 1 4224 590662 2 ##(Smalltalk.ListModel) 138 144 1104 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4224 nil 8 1912616880 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #smallIcons nil nil nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 1 1 498 1129 703 4224 978 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4224 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 8 #() 1120 nil 27 914 138 144 34 2 978 #createAt:extent: 34 2 498 1 1 498 1129 703 3184 978 #contextMenu: 34 1 3264 3184 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 52 2 0 0 95 1 0 0] 34 1 4224 1120 nil 27 170 192 34 2 3184 8 'cards' nil 914 138 144 34 1 978 #createAt:extent: 34 2 498 1 101 498 1129 703 3104 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 52 2 0 0 145 1 0 0] 34 1 3184 1120 nil 27 170 192 34 2 560 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 3250 nil true 34 8 3330 1 2642 #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 2736 8 'FileNew.ico' 2784 nil nil 3330 1 2642 #fileOpen 8 '&Open...' 9375 1 5186 nil true 2736 8 'FileOpen.ico' 2784 nil nil 3330 1 2642 #fileFileIn 8 '&File In...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3330 1 2642 #saveImage 8 'Sa&ve Image' 1 1 5186 nil true 2736 8 'Snapshot.ico' 2784 nil nil 3330 1 2642 #smalltalkExit 8 'E&xit Dolphin' 1 1 5186 nil true 2736 8 'PowerSwitch.ico' 2784 nil nil 5362 4097 3330 1 2642 #exit 8 '&Close' 17639 1 5186 nil true 2736 8 'CloseWindow.ico' 2784 nil nil 8 '&File' nil 134217729 nil nil 28969 nil nil 3250 nil true 34 12 3330 1 2642 #undo 8 '&Undo' 9397 1 5186 nil true 2736 8 'EditUndo.ico' 2784 nil nil 3330 1 2642 #redo 8 'R&edo' 9395 1 5186 nil true 2736 8 'EditRedo.ico' 2784 nil nil 5362 4097 3330 1 2642 #cutSelection 8 'Cu&t' 9393 1 5186 nil true 2736 8 'EditCut.ico' 2784 nil nil 3330 1 2642 #copySelection 8 '&Copy' 9351 1 5186 nil true 2736 8 'EditCopy.ico' 2784 nil nil 3330 1 2642 #pasteClipboard 8 '&Paste' 9389 1 5186 nil true 2736 8 'EditPaste.ico' 2784 nil nil 3330 1 2642 #clearSelection 8 '&Delete' 1 1 5186 nil true 2736 8 'EditClear.ico' 2784 nil nil 3330 1 2642 #selectAll 8 'Select &All' 9347 1 nil nil nil 5362 4097 3330 1 2642 #editFind 8 '&Find...' 9357 1 5186 nil true 2736 47 786694 ##(Smalltalk.ShellLibrary) nil nil 3330 1 2642 #findNext 8 'Find &Next' 1253 1 5186 nil true 2736 8 'FindNext.ico' 2784 nil nil 3330 1 2642 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 28991 nil nil 3250 nil true 34 13 3330 1 2642 #browseIt 8 '&Browse It' 9349 1 5186 nil true 2736 8 'ClassBrowserShell.ico' 2784 nil nil 3330 1 2642 #displayIt 8 '&Display It' 9353 1 5186 nil true 2736 8 'DisplayIt.ico' 2784 nil nil 3330 1 2642 #evaluateIt 8 '&Evaluate It' 9355 1 5186 nil true 2736 8 'EvaluateIt.ico' 2784 nil nil 3330 1 2642 #inspectIt 8 '&Inspect It' 9363 1 5186 nil true 2736 8 'BasicInspector.ico' 2784 nil nil 3330 1 2642 #debugIt 8 'Deb&ug It' 1269 1 5186 nil true 2736 8 'Debugger.ico' 2784 nil nil 3330 1 2642 #fileItIn 8 '&File It In' 1 1 nil nil nil 5362 4097 3330 1 2642 #accept 8 '&Accept' 9383 1 nil nil nil 5362 4097 3330 1 2642 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 3330 1 2642 #browseReferences 8 '&References...' 5367 1 nil nil nil 5362 4097 3250 nil true 34 9 3330 1 2642 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3330 1 2642 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3330 1 2642 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 3330 1 2642 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3330 1 2642 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3330 1 2642 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3330 1 2642 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 5362 4097 3250 nil true 34 2 3330 1 2642 3378 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 3330 1 2642 3378 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 29029 nil nil 8 '&Options' nil 134217729 nil nil 29031 nil nil 8 '&Workspace' nil 134217729 nil nil 29033 nil nil 3250 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 29035 nil nil 3250 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 29037 nil nil 3250 nil true 34 15 3330 1 2642 #helpContents 8 '&Contents' 1025 1 5186 nil true 2736 49 6336 nil nil 3330 1 2642 #help 8 'On this &Tool' 1249 1 nil nil nil 3330 1 2642 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5362 4097 3330 1 2642 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 5362 4097 3330 1 2642 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3330 1 2642 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3330 1 2642 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5362 4097 3330 1 2642 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 3330 1 2642 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3330 1 2642 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5362 4097 3330 1 2642 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5186 nil true 2736 8 '!!APPLICATION' 2784 nil nil 8 '&Help' nil 134217729 nil nil 29061 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 498 883 661 1 nil nil 914 138 144 34 3 978 #createAt:extent: 34 2 498 3839 21 498 1161 921 416 978 #text: 34 1 8 'Flipper Inspector' 416 978 #updateMenuBar 1104 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 195 9 0 0 214 1 0 0] 34 2 560 3104 1120 nil 27 )!

shellOn: anObject
	"Open an instance of the receiver displaying anObject. 
	Answer the new inspector."

	^(self show)
		value: anObject;
		yourself!

toolsFolderHelpId
	^10600!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	(Smalltalk developmentSystem)
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!FlipperInspector class categoriesFor: #defaultModel!models!public! !
!FlipperInspector class categoriesFor: #defaultRenderers!constants!private! !
!FlipperInspector class categoriesFor: #displayOn:!displaying!public! !
!FlipperInspector class categoriesFor: #icon!constants!public! !
!FlipperInspector class categoriesFor: #initialize!initializing!private! !
!FlipperInspector class categoriesFor: #publishedAspects!development!public! !
!FlipperInspector class categoriesFor: #renderers!accessing!public! !
!FlipperInspector class categoriesFor: #renderers:!accessing!public! !
!FlipperInspector class categoriesFor: #resource_Default_view!public!resources-views! !
!FlipperInspector class categoriesFor: #shellOn:!instance creation!public! !
!FlipperInspector class categoriesFor: #toolsFolderHelpId!public! !
!FlipperInspector class categoriesFor: #uninitialize!class hierarchy-removing!private! !

