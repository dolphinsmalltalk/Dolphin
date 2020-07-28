"Filed out from Dolphin Smalltalk 7"!

ListPresenter subclass: #ResourceListPresenter
	instanceVariableNames: 'filterBlock resourcesPresenter previewPresenter resourceIdModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
	previewPresenter := self add: ImagePresenter new name: 'preview'.
	resourceIdModel := ValueHolder new.
	previewPresenter model: (ValueConverter subject: resourceIdModel
				typeConverter: (PluggableTypeConverter 
						leftToRight: [:resourceId | self imageFromResource: resourceId]
						rightToLeft: [:image | nil]))!

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

imageFromResource: aResourceIdentifier 
	| shell resourceView |
	shell := View desktop.
	resourceView := [self systemModel loadViewResource: aResourceIdentifier resource inContext: shell] 
				on: Error
				do: [:x | ].
	^resourceView notNil 
		ifTrue: 
			[resourceView invalidateLayoutDeeply.
			[Bitmap fromView: resourceView] ensure: [resourceView destroy]]
		ifFalse: [Error icon]!

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
	resourceIdModel value: self resourceIdentifier!

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
!ResourceListPresenter categoriesFor: #browseClass!commands!public! !
!ResourceListPresenter categoriesFor: #browseHierarchy!commands!public! !
!ResourceListPresenter categoriesFor: #browseIt!commands!public! !
!ResourceListPresenter categoriesFor: #browseReferences!commands!public! !
!ResourceListPresenter categoriesFor: #browseSystem!commands!public! !
!ResourceListPresenter categoriesFor: #caption!accessing!public! !
!ResourceListPresenter categoriesFor: #clear!commands!public! !
!ResourceListPresenter categoriesFor: #clearSelection!commands!public! !
!ResourceListPresenter categoriesFor: #createComponents!initializing!public! !
!ResourceListPresenter categoriesFor: #createSchematicWiring!initializing!public! !
!ResourceListPresenter categoriesFor: #defaultSortBlock!constants!private!sorting! !
!ResourceListPresenter categoriesFor: #deleteResource!commands!public! !
!ResourceListPresenter categoriesFor: #editResource!commands!public! !
!ResourceListPresenter categoriesFor: #filterBlock:!accessing!public! !
!ResourceListPresenter categoriesFor: #imageFromResource:!helpers!private! !
!ResourceListPresenter categoriesFor: #initialize!initializing!private! !
!ResourceListPresenter categoriesFor: #model:!accessing!public! !
!ResourceListPresenter categoriesFor: #onDragResource:!event handling!private! !
!ResourceListPresenter categoriesFor: #onMethodAdded:!event handling!private! !
!ResourceListPresenter categoriesFor: #onMethodRemoved:!event handling!private! !
!ResourceListPresenter categoriesFor: #onResourceRepackaged:from:to:!event handling!private! !
!ResourceListPresenter categoriesFor: #onResourceSelected!event handling!private! !
!ResourceListPresenter categoriesFor: #passesFilter:!event handling!private! !
!ResourceListPresenter categoriesFor: #queryCommand:!commands!private! !
!ResourceListPresenter categoriesFor: #queryMoveResource:toPackage:!accessing!private! !
!ResourceListPresenter categoriesFor: #refresh!operations!public! !
!ResourceListPresenter categoriesFor: #resourceIdentifier!accessing!public! !
!ResourceListPresenter categoriesFor: #resourcePackage!commands!public! !
!ResourceListPresenter categoriesFor: #selectableItems!accessing!private! !
!ResourceListPresenter categoriesFor: #showAllResources!filtering!public! !
!ResourceListPresenter categoriesFor: #showResource!commands!public! !
!ResourceListPresenter categoriesFor: #showResourcesOwnedByPackages:!filtering!public! !
!ResourceListPresenter categoriesFor: #showResourcesReferencingView:!helpers!private! !
!ResourceListPresenter categoriesFor: #systemModel!commands!private! !

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409351680 131073 416 nil nil nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 11 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #browseHierarchy 8 '&Browse <1s>' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 530 1 562 #browseReferences 8 'Browse &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 530 1 562 #editResource 8 '&Edit' 9349 1 610 nil true 656 8 'ViewComposer.ico' 704 nil nil 530 1 562 #showResource 8 '&Show' 1 1 nil nil nil 530 1 562 #newView 8 '&New...' 1 1 nil nil nil 786 4097 530 1 562 #deleteResource 8 '&Delete...' 1 1 610 nil true 656 8 'EditClear.ico' 704 nil nil 786 4097 530 1 562 #resourcePackage 8 '&Package...' 1 1 nil nil nil 530 1 562 #categoryResource 8 'Categories...' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140854861 1025 1280 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 13 nil nil nil 1280 nil 8 1883852064 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'View Name' 561 #left nil 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 1280 ##(Smalltalk.IconicListAbstract) 3 nil nil #report 1392 nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1762 561 463 1280 1714 #text: 34 1 8 'View Name' 1280 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 24 1 0 0 231 0 0 0] 8 #() 1762 193 193 nil 35 524806 ##(Smalltalk.Fraction) 7 11 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 393217 1968 nil nil nil 5 nil nil nil 1968 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 1968 34 2 8 1140850944 1 2064 nil nil nil 5 nil nil nil 2064 nil 8 1883797456 852486 ##(Smalltalk.NullConverter) nil nil nil 1650 138 144 34 2 1714 #createAt:extent: 34 2 1762 11 11 1762 537 39 2064 1714 #text: 34 1 8 ' Preview' 2064 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 17 1 0 0 24 0 0 0] 8 #() 1920 nil 27 nil nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 1968 34 2 8 1140850944 262209 2384 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 1602 #= 8 #() 1602 #hash 8 #() nil 1442 #applicationWorkspace nil 5 nil nil nil 2384 nil nil 2146 nil nil nil nil #scaleBestFit 1 590342 ##(Smalltalk.Rectangle) 1762 21 21 1762 21 21 nil 1650 138 144 34 1 1714 #createAt:extent: 34 2 1762 11 49 1762 537 247 2384 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 24 0 0 0 17 1 0 0 147 0 0 0] 8 #() 1920 nil 27 170 192 34 2 2384 8 'preview' 2610 1762 11 11 1762 11 11 1650 138 144 34 1 1714 #createAt:extent: 34 2 1762 1 473 1762 561 309 1968 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 236 0 0 0 24 1 0 0 134 1 0 0] 34 2 2064 2384 1920 nil 27 1938 5 11 true 170 192 34 2 1280 8 'resources' nil 1650 138 144 34 2 1714 #createAt:extent: 34 2 1762 7039 21 1762 561 781 416 1714 #contextMenu: 34 1 496 416 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 215 14 0 0 144 1 0 0] 34 3 1280 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 3344 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3344 nil 1 #left nil nil nil 1762 1 1 1762 9 9 nil 3440 nil 1650 138 144 34 1 1714 #createAt:extent: 34 2 1762 1 463 1762 561 11 3344 1858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 231 0 0 0 24 1 0 0 236 0 0 0] 8 #() 1920 nil 27 1968 1920 nil 27 )!

resource_Package_view
	"Answer the literal data from which the 'Package view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Package_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409351680 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 393217 544 nil nil nil 5 nil nil nil 544 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 544 34 2 8 1140850944 1 640 nil nil nil 5 nil nil nil 640 nil 8 1883797456 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 866 393 39 640 818 #text: 34 1 8 '   Preview' 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 196 0 0 0 19 0 0 0] 8 #() 866 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 544 34 2 8 1140850944 262209 1040 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 1170 #hash 8 #() nil 327686 ##(Smalltalk.Color) #applicationWorkspace nil 5 nil nil nil 1040 nil nil 722 nil nil nil nil #scaleBestFit 1 590342 ##(Smalltalk.Rectangle) 866 21 21 866 21 21 nil 754 138 144 34 1 818 #createAt:extent: 34 2 866 1 39 866 393 609 1040 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 196 0 0 0 67 1 0 0] 8 #() 1024 nil 27 170 192 34 2 1040 8 'preview' nil 754 138 144 34 1 818 #createAt:extent: 34 2 866 785 1 866 397 651 544 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 0 0 0 0 78 2 0 0 69 1 0 0] 34 2 640 1040 1024 nil 27 524806 ##(Smalltalk.Fraction) 105 155 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140854857 1025 1760 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1250 #default nil 13 nil nil nil 1760 nil 8 1883852064 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'View Name' 389 #left nil 1170 #<= 8 #() nil nil 1760 ##(Smalltalk.IconicListAbstract) 3 nil nil 2018 8 'Package' 387 #left ##(Smalltalk.BasicListAbstract) 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 2144 7 513 nil 1170 #owningPackage 8 #() nil 1760 nil 3 nil nil #report 1872 nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 754 138 144 34 2 818 #createAt:extent: 34 2 866 1 1 866 775 651 1760 818 #text: 34 1 8 'View Name' 1760 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 131 1 0 0 69 1 0 0] 8 #() 1024 nil 35 1730 205 155 false 170 192 34 2 1760 8 'resources' nil 754 138 144 34 1 818 #createAt:extent: 34 2 866 7039 21 866 1181 651 416 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 13 16 0 0 79 1 0 0] 34 3 1760 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2704 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2704 nil 1 #left nil nil nil 866 1 1 866 9 9 nil 2800 nil 754 138 144 34 1 818 #createAt:extent: 34 2 866 775 1 866 11 651 2704 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 131 1 0 0 0 0 0 0 136 1 0 0 69 1 0 0] 8 #() 1024 nil 27 544 1024 nil 27 )!

showResourcesReferencingView: aResourceIdentifier
	| browser |
	browser := self show.
	browser showResourcesReferencingView: aResourceIdentifier.
	browser topShell caption: ('Resources referencing <1p>' expandMacrosWith: aResourceIdentifier).
	^browser! !
!ResourceListPresenter class categoriesFor: #defaultModel!models!public! !
!ResourceListPresenter class categoriesFor: #icon!constants!public! !
!ResourceListPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!ResourceListPresenter class categoriesFor: #resource_Package_view!public!resources-views! !
!ResourceListPresenter class categoriesFor: #showResourcesReferencingView:!instance creation!public! !

