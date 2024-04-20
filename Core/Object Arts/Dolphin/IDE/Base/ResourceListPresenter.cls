"Filed out from Dolphin Smalltalk"!

ListPresenter subclass: #ResourceListPresenter
	instanceVariableNames: 'filterBlock resourcesPresenter previewPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ResourceListPresenter guid: (GUID fromString: '{87b4c6c8-026e-11d3-9fd7-00a0cc3e4a32}')!

ResourceListPresenter comment: 'ResourceListPresenter implements a <listPresenter> used to display a list of <ResourceIdentifier>s. It adds the ability to source drag and drop operations for resources, and various commands to operate on resources such as showing them, editing them, browsing their owning class, etc.

Instance Variables:
	filterBlock			<monadicValuable> used as a discrimator to select resources for inclusion in the list.
	resourcesPresenter	<listPresenter>
	previewPresenter	<ImagePresenter> used to display a thumbnail preview of the resource.
	resourceIdModel	<ValueHolder>


'!

!ResourceListPresenter categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools!MVP-Resources-Misc! !

!ResourceListPresenter methodsFor!

browseClass
	"Open a new class browser, of the users preferred type, on the owning class of the selected
	resource."
	
	self systemModel browseClass: self resourceIdentifier owningClass!

browseHierarchy
	"Open a new class browser on the hierarchy at the same point as the receiver."

	self systemModel browseHierarchy: self resourceIdentifier owningClass!

browseIt
	"Open a new browser (i.e. a view composer) on the selected resource."

	self resourceIdentifier browse!

browseReferences
	self systemModel browseResourcesReferencingView: self resourceIdentifier!

browseSystem
	"Open a new system browser on the hierarchy at the same point as the receiver."
	
	self systemModel browseSystem: self resourceIdentifier owningClass!

caption
	^''!

clear
	"Empty the resource list."

	filterBlock := [:each | false].
	self list: #()
	!

clearSelection
	"Remove the selected resource from the ResourceManager."

	self deleteResource!

createComponents
	super createComponents.
	resourcesPresenter := self add: ListPresenter new name: 'resources'.
	previewPresenter := self add: ValuePresenter new name: 'preview'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self selectableItems)
		when: #drag:
			send: #onDragResource:
			to: self;
		when: #actionPerformed
			send: #editResource
			to: self;
		when: #selectionChanged
			send: #onResourceSelected
			to: self.
	self systemModel packageManager 
		when: #resourceRepackaged:from:to:
		send: #onResourceRepackaged:from:to:
		to: self.
	(self systemModel )
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self;
		when: #methodAdded:
			send: #onMethodAdded:
			to: self";
		when: #resourceUpdated:
			send: #onResourceUpdated:
			to: self"!

defaultSortBlock
	"Private - Answer a default sort block to use when the receiver is sorted"

	^ResourceIdentifier!

deleteResource
	"Remove the selected resources from the system."

	self selections do: [:each | self systemModel deleteResource: each]!

editResource
	"Invoke an appropriate editor on the selected resource."
	self systemModel openViewComposerOn: self resourceIdentifier!

filterBlock: monadicValuable 
	"Set the receiver's filterBlock inst var to monadicValuable. The monadicValuable is used as a
	disciminator to select from all potential <ResourceIdentifier>s only those of interest to the receiver."

	| sels |
	filterBlock := monadicValuable.
	sels := self selections.
	self refresh.
	self selections: sels ifAbsent: []!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self basicBeSorted!

model: aListModel
	"Set the receiver's model to aListModel of CompiledMethods"

	super model: aListModel.
	self selectableItems model: aListModel.
!

onDragResource: aDragDropSession 
	"Private - This is where the receiver specifies which object(s) the <DragDropSession>
	session is to drag using #addDragObject: or #dragObjects:."

	| resId ddObject |
	resId := aDragDropSession suggestedSource.
	ddObject := aDragDropSession newDragObject: resId resource copy.
	ddObject
		format: #ResourceIdentifier data: resId;
		format: #STLViewResource data: resId resource.
	aDragDropSession
		dragObjects: (OrderedCollection with: ddObject);
		defaultOperation: #copy!

onMethodAdded: aCompilationResult 
	(aCompilationResult method selector beginsWith: ResourceIdentifier.SelectorPrefix) 
		ifTrue: 
			[| rid |
			rid := ResourceIdentifier class: aCompilationResult method methodClass instanceClass
						selector: aCompilationResult method selector.
			(self passesFilter: rid) ifTrue: [self model add: rid]]!

onMethodRemoved: aCompiledMethod 
	(aCompiledMethod selector beginsWith: ResourceIdentifier.SelectorPrefix) 
		ifTrue: 
			[self model remove: (ResourceIdentifier class: aCompiledMethod methodClass instanceClass
						selector: aCompiledMethod selector)
				ifAbsent: []]!

onResourceRepackaged: aResourceIdentifier from: aPackage to: aPackage2 
	| index |
	index := self model indexOf: aResourceIdentifier.
	(self passesFilter: aResourceIdentifier) 
		ifTrue: 
			[index = 0 ifTrue: [self model add: aResourceIdentifier] ifFalse: [self model refreshAtIndex: index]]
		ifFalse: [index ~= 0 ifTrue: [self model removeAtIndex: index]]!

onResourceSelected
	previewPresenter value: self resourceIdentifier!

passesFilter: aResourceIdentifier
	^filterBlock isNil or: [filterBlock value: aResourceIdentifier]!

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	(#(#clearSelection #deleteResource) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery isEnabled: self selections notEmpty.
			^true].
	#showResource == selector
		ifTrue: 
			[| rid |
			rid := self resourceIdentifier.
			aCommandQuery isEnabled: (rid notNil and: [rid canShow]).
			^true].
	(#(#properties #resourcePackage #browseIt #editResource #browseReferences)
		identityIncludes: selector)
			ifTrue: 
				[aCommandQuery isEnabled: self resourceIdentifier notNil.
				^true].
	(#(#browseHierarchy #browseSystem #browseClass) identityIncludes: selector)
		ifTrue: 
			[| name rid |
			rid := self resourceIdentifier.
			name := rid isNil ifTrue: ['Classes'] ifFalse: [rid owningClass name].
			aCommandQuery
				isEnabled: self resourceIdentifier notNil;
				text: (aCommandQuery commandDescription menuText expandMacrosWith: name).
			^true].
	^super queryCommand: aCommandQuery!

queryMoveResource: aResourceIdentifier toPackage: aPackage 
	"Private - Move aResourceIdentifier from its existing package to the specified
	<Package> if the user confirms."

	| resourcePackage |
	resourcePackage := aResourceIdentifier owningPackage.
	(MessageBox 
		confirm: ('The resource ''<1p>'' is currently owned by the <2p> package<n><n>Are you sure you would like to move it to <3p>?' 
				expandMacrosWith: aResourceIdentifier
				with: resourcePackage name
				with: aPackage name)
		caption: 'Move resource to new package...') 
			ifTrue: [aPackage addResourceIdentifier: aResourceIdentifier]!

refresh
	"Private - Re-display the receiver's contents"

	| rids |
	rids := self systemModel allResourceIdentifiers.
	filterBlock notNil ifTrue: [rids := rids select: filterBlock].
	self list: rids!

resourceIdentifier
	"Answer the selected <ResourceIdentifier> iff there is exactly one selection."

	| rids |
	rids := self selections.
	^rids size = 1 ifTrue: [rids first]!

resourcePackage
	"Prompt for the user to repackage the selected resource."

	| pkg newPkg rid |
	rid := self resourceIdentifier.
	pkg := rid owningPackage.
	newPkg := PackagePrompter 
				showModalOn: pkg asValue
				caption: ('Package of <1d>...' expandMacrosWith: rid)
				default: rid owningClass owningPackage.
	(newPkg notNil and: [newPkg ~= pkg]) ifTrue: [self queryMoveResource: rid toPackage: newPkg]!

selectableItems
	"Private - Answer the name of the <selectableItems> component that actually handles the selectable items in the receiver"

	^resourcesPresenter!

showAllResources
	"Set the receiver's filter block to display all resources."

	self filterBlock: nil!

showResource
	"Display the selected resource in whatever manner is appropriate for it."

	self resourceIdentifier show!

showResourcesOwnedByPackages: aPackageCollection
	"Set the receiver's filter block to display resources owned by aPackage"

	| packages |
	packages := aPackageCollection asIdentitySet.
	self filterBlock: [:resID | packages includes: resID owningPackage]!

showResourcesReferencingView: aResourceIdentifier 
	| idIndex |
	idIndex := AbstractDelegatingView superclass instSize + 1.
	self filterBlock: 
			[:resID | 
			resID hiddenObjects anySatisfy: 
					[:each | 
					(each isKindOf: STBViewProxy) 
						and: [each viewClass == ReferenceView and: [(each instVars at: idIndex) = aResourceIdentifier]]]]!

systemModel
	"Private - Answer the development system model."

	^Smalltalk developmentSystem! !

!ResourceListPresenter categoriesForMethods!
browseClass!commands!public! !
browseHierarchy!commands!public! !
browseIt!commands!public! !
browseReferences!commands!public! !
browseSystem!commands!public! !
caption!accessing!public! !
clear!commands!public! !
clearSelection!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultSortBlock!constants!private!sorting! !
deleteResource!commands!public! !
editResource!commands!public! !
filterBlock:!accessing!public! !
initialize!initializing!private! !
model:!accessing!public! !
onDragResource:!event handling!private! !
onMethodAdded:!event handling!private! !
onMethodRemoved:!event handling!private! !
onResourceRepackaged:from:to:!event handling!private! !
onResourceSelected!event handling!private! !
passesFilter:!event handling!private! !
queryCommand:!commands!private! !
queryMoveResource:toPackage:!accessing!private! !
refresh!operations!public! !
resourceIdentifier!accessing!public! !
resourcePackage!commands!public! !
selectableItems!accessing!private! !
showAllResources!filtering!public! !
showResource!commands!public! !
showResourcesOwnedByPackages:!filtering!public! !
showResourcesReferencingView:!helpers!private! !
systemModel!commands!private! !
!

!ResourceListPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel newEquality!

icon
	"Answers an Icon that can be used to represent this class"

	^ResourceBrowser icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409351680 131073 416 nil nil nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 11 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #browseHierarchy 8 '&Browse <1s>' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 530 1 562 #browseReferences 8 'Browse &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 530 1 562 #editResource 8 '&Edit' 9349 1 610 nil true 656 8 'ViewComposer.ico' 704 nil nil 530 1 562 #showResource 8 '&Show' 1 1 nil nil nil 530 1 562 #newView 8 '&New...' 1 1 nil nil nil 786 4097 530 1 562 #deleteResource 8 '&Delete...' 1 1 610 nil true 656 8 'EditClear.ico' 704 nil nil 786 4097 530 1 562 #resourcePackage 8 '&Package...' 1 1 nil nil nil 530 1 562 #categoryResource 8 'Categories...' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140854861 1025 1280 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 13 nil nil nil 1280 nil 8 1797996720 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'View Name' 553 #left nil 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 1280 ##(Smalltalk.IconicListAbstract) 3 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 24 1 0 0 231 0 0 0] 193 1312 8 'View Name' 1280 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 35 524806 ##(Smalltalk.Fraction) 7 11 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 393217 1952 nil nil nil 4101 nil nil nil 1952 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 1952 34 2 8 1140850944 1 2048 nil nil nil 5 nil nil nil 2048 nil 8 1798140960 852486 ##(Smalltalk.NullConverter) nil nil nil 1666 138 144 34 2 1730 #createWindow: 34 1 1778 1810 8 #[5 0 0 0 5 0 0 0 17 1 0 0 24 0 0 0] 193 2080 nil 2048 1730 #text: 34 1 8 ' Preview' 2048 3 8 #() 1890 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ResourcePreview) 34 21 nil 1952 34 2 8 1140850944 262209 2368 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 1602 #= 8 #() 1602 #hash 8 #() nil 1442 #applicationWorkspace nil 5 nil nil nil 2368 nil nil 2130 nil nil nil nil #scaleBestFit 3 590342 ##(Smalltalk.Rectangle) 1890 21 21 1890 21 21 nil 1666 138 144 34 2 1730 #createWindow: 34 1 1769990 ##(Smalltalk.CreateInDpiAwarenessContext) 1778 1810 8 #[5 0 0 0 24 0 0 0 17 1 0 0 147 0 0 0] 193 2400 nil -9 2368 1730 #text: 34 1 8 '' 2368 3 8 #() 1890 193 193 nil 27 170 192 34 2 2368 8 'preview' 2594 1890 11 11 1890 11 11 1666 138 144 34 1 1730 #createWindow: 34 1 1179910 ##(Smalltalk.CreateMixedDpiHost) 1778 1810 8 #[0 0 0 0 236 0 0 0 24 1 0 0 134 1 0 0] 193 1984 8 '' 1952 3 34 2 2048 2368 1890 193 193 nil 27 1922 5 11 true 170 192 34 2 1280 8 'resources' nil 1666 138 144 34 2 1730 #createWindow: 34 1 1778 1810 8 #[255 9 0 0 10 0 0 0 23 11 0 0 144 1 0 0] 193 448 8 '' 416 1730 #contextMenu: 34 1 496 416 3 34 3 1280 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 3456 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3456 nil 1 #left nil nil nil 1890 1 1 1890 9 9 nil 3552 nil 1666 138 144 34 1 1730 #createWindow: 34 1 1778 1810 8 #[0 0 0 0 231 0 0 0 24 1 0 0 236 0 0 0] 193 3488 8 '' 3456 3 8 #() 1890 193 193 nil 27 1952 1890 193 193 nil 27 )!

resource_Package_view
	"Answer the literal data from which the 'Package view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Package_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409351680 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 393217 544 nil nil nil 4101 nil nil nil 544 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 544 34 2 8 1140850944 1 640 nil nil nil 5 nil nil nil 640 nil 8 1798140960 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 196 0 0 0 19 0 0 0] 193 672 nil 640 818 #text: 34 1 8 '   Preview' 640 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ResourcePreview) 34 21 nil 544 34 2 8 1140850944 262209 1040 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 1170 #hash 8 #() nil 327686 ##(Smalltalk.Color) #applicationWorkspace nil 5 nil nil nil 1040 nil nil 722 nil nil nil nil #scaleBestFit 3 590342 ##(Smalltalk.Rectangle) 1010 21 21 1010 21 21 nil 754 138 144 34 2 818 #createWindow: 34 1 1769990 ##(Smalltalk.CreateInDpiAwarenessContext) 866 898 8 #[0 0 0 0 20 0 0 0 196 0 0 0 68 1 0 0] 289 1072 nil -3 1040 818 #text: 34 1 8 '' 1040 3 8 #() 1010 289 289 nil 27 170 192 34 2 1040 8 'preview' nil 754 138 144 34 1 818 #createWindow: 34 1 1179910 ##(Smalltalk.CreateMixedDpiHost) 866 898 8 #[136 1 0 0 0 0 0 0 78 2 0 0 69 1 0 0] 193 576 8 '' 544 3 34 2 640 1040 1010 193 193 nil 27 524806 ##(Smalltalk.Fraction) 105 155 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140854857 1025 1888 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1250 #default nil 13 nil nil nil 1888 nil 8 1797996720 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'View Name' 385 #left nil 1170 #<= 8 #() nil nil 1888 ##(Smalltalk.IconicListAbstract) 3 nil nil 2146 8 'Package' 383 #left ##(Smalltalk.BasicListAbstract) 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 2272 7 513 nil 1170 #owningPackage 8 #() nil 1888 nil 3 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 754 138 144 34 1 818 #createWindow: 34 1 866 898 8 #[0 0 0 0 0 0 0 0 131 1 0 0 69 1 0 0] 193 1920 8 'View Name' 1888 3 8 #() 1010 193 193 nil 35 1858 205 155 false 170 192 34 2 1888 8 'resources' nil 754 138 144 34 1 818 #createWindow: 34 1 866 898 8 #[255 9 0 0 10 0 0 0 77 12 0 0 79 1 0 0] 193 448 8 '' 416 3 34 3 1888 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2816 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2816 nil 1 #left nil nil nil 1010 1 1 1010 9 9 nil 2912 nil 754 138 144 34 1 818 #createWindow: 34 1 866 898 8 #[131 1 0 0 0 0 0 0 136 1 0 0 69 1 0 0] 193 2848 8 '' 2816 3 8 #() 1010 193 193 nil 27 544 1010 193 193 nil 27 )!

showResourcesReferencingView: aResourceIdentifier 
	| browser |
	browser := self show.
	browser showResourcesReferencingView: aResourceIdentifier.
	browser topShell caption: ('Resources referencing <1p>' expandMacrosWith: aResourceIdentifier).
	^browser! !

!ResourceListPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Package_view!public!resources-views! !
showResourcesReferencingView:!instance creation!public! !
!

