"Filed out from Dolphin Smalltalk"!

UI.ListPresenter
	subclass: #'Tools.ResourceListPresenter'
	instanceVariableNames: 'filterBlock resourcesPresenter previewPresenter resourceIdModel'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.ResourceListPresenter guid: (Core.GUID fromString: '{87b4c6c8-026e-11d3-9fd7-00a0cc3e4a32}')!

Tools.ResourceListPresenter comment: 'ResourceListPresenter implements a <listPresenter> used to display a list of <ResourceIdentifier>s. It adds the ability to source drag and drop operations for resources, and various commands to operate on resources such as showing them, editing them, browsing their owning class, etc.

Instance Variables:
	filterBlock			<monadicValuable> used as a discrimator to select resources for inclusion in the list.
	resourcesPresenter	<listPresenter>
	previewPresenter	<ImagePresenter> used to display a thumbnail preview of the resource.
	resourceIdModel	<ValueHolder>


'!

!Tools.ResourceListPresenter categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools!MVP-Resources-Misc! !

!Tools.ResourceListPresenter methodsFor!

browseClass
	"Open a new class browser, of the users preferred type, on the owning class of the selected
	resource."

	<commandQuery: #queryBrowseOwningClass:>
	self developmentSystem browseClass: self resourceIdentifier owningClass!

browseHierarchy
	"Open a new class browser on the hierarchy at the same point as the receiver."

	<commandQuery: #queryBrowseOwningClass:>
	self developmentSystem browseHierarchy: self resourceIdentifier owningClass!

browseIt
	"Open a new browser (i.e. a view composer) on the selected resource."

	<commandQuery: #hasSingleSelection>
	self resourceIdentifier browse!

browseReferences
	<commandQuery: #hasSingleSelection>
	<acceleratorKey: 'Shift+F12'>
	self developmentSystem browseResourcesReferencingView: self resourceIdentifier!

browseSystem
	"Open a new system browser on the hierarchy at the same point as the receiver."

	<commandQuery: #queryBrowseOwningClass:>
	self developmentSystem browseSystem: self resourceIdentifier owningClass!

caption
	^''!

clear
	"Empty the resource list."

	filterBlock := [:each | false].
	self list: #()
	!

clearSelection
	"Remove the selected resource from the ResourceManager."

	<commandQuery: #hasSelection>
	self deleteResource!

confirmMoveResource: aResourceIdentifier toPackage: aPackage
	"Private - Move aResourceIdentifier from its existing package to the specified
	<Package> if the user confirms."

	| resourcePackage |
	resourcePackage := aResourceIdentifier owningPackage.
	(MessageBox new
		headline: 'Move resource to new package?';
		confirm: 'The resource ''<1p>'' is currently owned by the <2p> package<n><n>Are you sure you would like to move it to <3p>?'
					<< { aResourceIdentifier. resourcePackage name. aPackage name })
			ifTrue: [aPackage addResourceIdentifier: aResourceIdentifier]!

createComponents
	super createComponents.
	resourcesPresenter := self add: ListPresenter new name: 'resources'.
	previewPresenter := self add: ImagePresenter new name: 'preview'.
	resourceIdModel := ValueHolder new.
	previewPresenter model: (ValueConverter subject: resourceIdModel
				typeConverter: (PluggableTypeConverter
						leftToRight: [:resourceId | self imageFromResource: resourceId]))!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self selectableItems
		when: #drag:
			send: #onDragResource:
			to: self;
		when: #actionPerformed
			send: #editResource
			to: self;
		when: #selectionChanged
			send: #onResourceSelected
			to: self.
	self developmentSystem packageManager
		when: #resourceRepackaged:from:to:
			send: #onResourceRepackaged:from:to:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self;
		when: #methodAdded:
			send: #onMethodAdded:
			to: self	";
		when: #resourceUpdated:
			send: #onResourceUpdated:
			to: self"!

defaultSortBlock
	"Private - Answer a default sort block to use when the receiver is sorted"

	^ResourceIdentifier!

deleteResource
	"Remove the selected resources from the system."

	<commandQuery: #hasSelection>
	self selections do: [:each | self developmentSystem deleteResource: each]!

developmentSystem
	^SmalltalkSystem current!

editResource
	"Invoke an appropriate editor on the selected resource."

	<commandQuery: #hasSingleSelection>
	self developmentSystem openViewComposerOn: self resourceIdentifier!

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
	shell := DesignDesktopView forSystemDpi.
	resourceView := [shell loadViewResource: aResourceIdentifier resource forEdit: false] on: Error
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
	| method rid |
	method := aCompilationResult method.
	method isResourceMethod ifFalse: [^self].
	rid := ResourceIdentifier class: method methodClass instanceClass selector: method selector.
	(self passesFilter: rid) ifTrue: [self model add: rid]!

onMethodRemoved: aCompiledMethod
	aCompiledMethod isResourceMethod
		ifTrue: 
			[self model remove: (ResourceIdentifier class: aCompiledMethod methodClass instanceClass
						selector: aCompiledMethod selector)
				ifAbsent: nil]!

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

queryBrowseOwningClass: aCommandQuery
	| rid |
	rid := self resourceIdentifier.
	rid isNil ifTrue: [^self].
	aCommandQuery
		beEnabled;
		expandMenuTextWith: rid owningClass!

queryShowResource: aCommandQuery
	| rid |
	rid := self resourceIdentifier.
	aCommandQuery isEnabled: (rid notNil and: [rid canShow])!

refresh
	"Private - Re-display the receiver's contents"

	| rids |
	rids := self systemModel allResourceIdentifiers.
	filterBlock notNil ifTrue: [rids := rids select: filterBlock].
	self list: rids!

resourceIdentifier
	"Answer the selected <ResourceIdentifier> iff there is exactly one selection."

	^self selectionOrNil!

resourcePackage
	"Prompt for the user to repackage the selected resource."

	<commandQuery: #hasSingleSelection>
	| pkg newPkg rid |
	rid := self resourceIdentifier.
	pkg := rid owningPackage.
	newPkg := PackagePrompter
				showModalOn: pkg asValue
				caption: 'Package of <d>…' << rid
				default: rid owningClass owningPackage.
	(newPkg notNil and: [newPkg ~= pkg]) ifTrue: [self confirmMoveResource: rid toPackage: newPkg]!

selectableItems
	"Private - Answer the name of the <selectableItems> component that actually handles the selectable items in the receiver"

	^resourcesPresenter!

showAllResources
	"Set the receiver's filter block to display all resources, except those in Test classes"

	| testCase |
	testCase := #{XProgramming.SUnit.TestCase} valueOrNil.
	self filterBlock: (testCase ifNotNil: [:resId | (resId owningClass inheritsFrom: testCase) not])!

showResource
	"Display the selected resource in whatever manner is appropriate for it."

	<commandQuery: #queryShowResource:>
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
						and: [each viewClass == ReferenceView and: [(each instVars at: idIndex) = aResourceIdentifier]]]]! !

!Tools.ResourceListPresenter categoriesForMethods!
browseClass!commands-actions!public! !
browseHierarchy!commands-actions!public! !
browseIt!commands-actions!public! !
browseReferences!commands-actions!public! !
browseSystem!commands-actions!public! !
caption!accessing!public! !
clear!commands-actions!public! !
clearSelection!commands-actions!public! !
confirmMoveResource:toPackage:!accessing!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultSortBlock!constants!private!sorting! !
deleteResource!commands-actions!public! !
developmentSystem!accessing!private! !
editResource!commands-actions!public! !
filterBlock:!accessing!public! !
imageFromResource:!helpers!private! !
initialize!initializing!private! !
model:!accessing!public! !
onDragResource:!event handling!private! !
onMethodAdded:!event handling!private! !
onMethodRemoved:!event handling!private! !
onResourceRepackaged:from:to:!event handling!private! !
onResourceSelected!event handling!private! !
passesFilter:!event handling!private! !
queryBrowseOwningClass:!commands-queries!private! !
queryShowResource:!commands-queries!private! !
refresh!operations!public! !
resourceIdentifier!accessing!public! !
resourcePackage!commands-actions!public! !
selectableItems!accessing!private! !
showAllResources!filtering!public! !
showResource!commands-actions!public! !
showResourcesOwnedByPackages:!filtering!public! !
showResourcesReferencingView:!helpers!private! !
!

!Tools.ResourceListPresenter class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409351680 131073 32 nil nil nil 5 2886 4 #{UI.Menu} nil true 50 11 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #browseHierarchy 8 '&Browse <1s>' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'ClassBrowserShell.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 162 1 194 #browseReferences 8 'Browse &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 162 1 194 #editResource 8 '&Edit' 9349 1 242 nil true 274 8 'ViewComposer.ico' 336 65541 nil nil nil 162 1 194 #showResource 8 '&Show' 1 1 nil nil nil 162 1 194 #newView 8 '&New…' 1 1 nil nil nil 418 4097 162 1 194 #deleteResource 8 '&Delete…' 1 1 242 nil true 274 8 'EditClear.ico' 336 65541 nil nil nil 418 4097 162 1 194 #resourcePackage 8 '&Package…' 1 1 nil nil nil 162 1 194 #categoryResource 8 'Categories…' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 2 518 #{Core.Association} 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140854861 1025 992 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 13 nil nil nil 992 nil nil 518 #{Core.Message} #displayString 8 #() 1186 #iconImageIndex 1216 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 1090 1 3142 5 #{UI.ListViewColumn} 8 'View Name' 561 #left nil 1186 #<= 8 #() nil nil 992 1232 3 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 1490 561 463 992 1442 #text: 50 1 8 'View Name' 992 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 24 1 0 0 231 0 0 0] 8 #() 1490 193 193 nil 35 518 #{Core.Fraction} 7 11 962 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 393217 1712 nil nil nil 5 nil nil nil 1712 1798 #{UI.BorderLayout} 1 1 18 #{UI.StaticText} 50 16 nil 1712 50 2 8 1140850944 1 1808 nil nil nil 5 nil nil nil 1808 nil nil 518 #{UI.NullConverter} nil nil nil 1394 50 2 1442 #createAt:extent: 50 2 1490 11 11 1490 537 39 1808 1442 #text: 50 1 8 ' Preview' 1808 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 17 1 0 0 24 0 0 0] 8 #() 1648 nil 27 nil nil nil 18 #{UI.ImageView} 50 21 nil 1712 50 2 8 1140850944 262209 2096 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 1186 #= 8 #() 1186 #hash 8 #() nil 1154 #applicationWorkspace nil 5 nil nil nil 2096 nil nil 1874 nil nil nil nil #scaleBestFit 1 518 #{Graphics.Rectangle} 1490 21 21 1490 21 21 nil 1394 50 1 1442 #createAt:extent: 50 2 1490 11 49 1490 537 247 2096 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 24 0 0 0 17 1 0 0 147 0 0 0] 8 #() 1648 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 2096 8 'preview' 2322 1490 11 11 1490 11 11 1394 50 1 1442 #createAt:extent: 50 2 1490 1 473 1490 561 309 1712 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 236 0 0 0 24 1 0 0 134 1 0 0] 50 2 1808 2096 1648 nil 27 1666 5 11 true 2530 #{Core.IdentityDictionary} 50 2 992 8 'resources' nil 1394 50 1 1442 #createAt:extent: 50 2 1490 6143 21 1490 561 781 32 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 23 13 0 0 144 1 0 0] 50 3 992 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 2992 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2992 nil 1 #left nil nil nil 1490 1 1 1490 9 9 nil 3088 nil 1394 50 1 1442 #createAt:extent: 50 2 1490 1 463 1490 561 11 2992 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 231 0 0 0 24 1 0 0 236 0 0 0] 8 #() 1648 nil 27 1712 1648 nil 27)!

resource_Package_view
	"Answer the literal data from which the 'Package view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Package_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409351680 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 2 518 #{Core.Association} 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140854857 1025 224 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 13 nil nil nil 224 nil nil 518 #{Core.Message} #displayString 8 #() 418 #iconImageIndex 448 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 322 2 3142 5 #{UI.ListViewColumn} 8 'View Name' 389 #left nil 418 #<= 8 #() nil nil 224 464 3 nil nil 530 8 'Package' 387 #left 432 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 656 7 513 nil 418 #owningPackage 8 #() nil 224 nil 3 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 898 775 651 224 850 #text: 50 1 8 'View Name' 224 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 131 1 0 0 69 1 0 0] 8 #() 898 193 193 nil 35 518 #{Core.Fraction} 205 155 194 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 393217 1120 nil nil nil 5 nil nil nil 1120 1798 #{UI.BorderLayout} 1 1 18 #{UI.StaticText} 50 16 nil 1120 50 2 8 1140850944 1 1216 nil nil nil 5 nil nil nil 1216 nil nil 518 #{UI.NullConverter} nil nil nil 802 50 2 850 #createAt:extent: 50 2 898 1 1 898 393 39 1216 850 #text: 50 1 8 '   Preview' 1216 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 196 0 0 0 19 0 0 0] 8 #() 1056 nil 27 nil nil nil 18 #{UI.ImageView} 50 21 nil 1120 50 2 8 1140850944 262209 1504 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 418 #= 8 #() 418 #hash 8 #() nil 386 #applicationWorkspace nil 5 nil nil nil 1504 nil nil 1282 nil nil nil nil #scaleBestFit 1 518 #{Graphics.Rectangle} 898 21 21 898 21 21 nil 802 50 1 850 #createAt:extent: 50 2 898 1 39 898 393 609 1504 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 196 0 0 0 67 1 0 0] 8 #() 1056 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 1504 8 'preview' nil 802 50 1 850 #createAt:extent: 50 2 898 785 1 898 397 651 1120 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 0 0 0 0 78 2 0 0 69 1 0 0] 50 2 1216 1504 1056 nil 27 1074 105 155 false 1938 #{Core.IdentityDictionary} 50 2 224 8 'resources' nil 802 50 1 850 #createAt:extent: 50 2 898 6143 21 898 1181 651 32 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 77 14 0 0 79 1 0 0] 50 3 224 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 2352 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2352 nil 1 #left nil nil nil 898 1 1 898 9 9 nil 2448 nil 802 50 1 850 #createAt:extent: 50 2 898 775 1 898 11 651 2352 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 131 1 0 0 0 0 0 0 136 1 0 0 69 1 0 0] 8 #() 1056 nil 27 1120 1056 nil 27)!

showResourcesReferencingView: aResourceIdentifier
	| browser |
	browser := self show.
	browser showResourcesReferencingView: aResourceIdentifier.
	browser topShell caption: ('Resources referencing <1p>' expandMacrosWith: aResourceIdentifier).
	^browser! !

!Tools.ResourceListPresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Package_view!public!resources-views! !
showResourcesReferencingView:!instance creation!public! !
!

