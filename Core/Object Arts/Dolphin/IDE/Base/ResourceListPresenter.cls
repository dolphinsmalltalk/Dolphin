"Filed out from Dolphin Smalltalk 7"!

ListPresenter subclass: #ResourceListPresenter
	instanceVariableNames: 'filterBlock resourcesPresenter previewPresenter resourceIdModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResourceListPresenter guid: (GUID fromString: '{87B4C6C8-026E-11D3-9FD7-00A0CC3E4A32}')!
ResourceListPresenter comment: 'ResourceListPresenter implements a <listPresenter> used to display a list of <ResourceIdentifier>s. It adds the ability to source drag and drop operations for resources, and various commands to operate on resources such as showing them, editing them, browsing their owning class, etc.

Instance Variables:
	filterBlock			<monadicValuable> used as a discrimator to select resources for inclusion in the list.
	resourcesPresenter	<listPresenter>
	previewPresenter	<ImagePresenter> used to display a thumbnail preview of the resource.
	resourceIdModel	<ValueHolder>


'!
!ResourceListPresenter categoriesForClass!Development!MVP-Presenters!MVP-Resources-IDE Tools!MVP-Resources-Misc! !
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
	(aCompilationResult method selector beginsWith: ResourceIdentifier selectorPrefix) 
		ifTrue: 
			[| rid |
			rid := ResourceIdentifier class: aCompilationResult method methodClass instanceClass
						selector: aCompilationResult method selector.
			(self passesFilter: rid) ifTrue: [self model add: rid]]!

onMethodRemoved: aCompiledMethod 
	(aCompiledMethod selector beginsWith: ResourceIdentifier selectorPrefix) 
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
	(#(#properties #resourcePackage #browseIt #editResource) identityIncludes: selector) 
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
	rids := ResourceIdentifier allResourceIdentifiers.
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

	self filterBlock: 
			[:resID | 
			aPackageCollection includes: (Package manager packageOfResourceIdentifierOrItsClass: resID)]!

showResourcesReferencingView: aResourceIdentifier 
	| idIndex |
	idIndex := ReferenceView superclass instSize + 1.
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409351680 131073 416 0 0 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #browseHierarchy 8 '&Browse <1s>' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 546 1 578 8 #browseReferences 8 'Browse &References' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 546 1 578 8 #newView 8 '&New' 1 1 0 0 0 546 1 578 8 #deleteResource 8 '&Delete...' 1 1 0 0 0 834 4097 546 1 578 8 #editResource 8 '&Open' 9349 1 0 0 0 834 4097 546 1 578 8 #resourcePackage 8 '&Package...' 1 1 0 0 0 546 1 578 8 #categoryResource 8 'Categories...' 1 1 0 0 0 8 '&View' 0 134217729 0 0 0 0 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140854861 1 1296 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  0 0 13 0 0 0 1296 0 8 4294903801 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'View Name' 561 8 #left 0 8 ##(Smalltalk.SortedCollection)  0 0 1296 1504 3 0 0 8 #report 1424 0 133221 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1810 561 463 1296 1746 8 #text: 98 1 8 'View Name' 1296 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 24 1 0 0 231 0 0 0] 98 0 1810 193 193 0 27 524806 ##(Smalltalk.Fraction)  7 11 410 432 98 15 0 416 98 2 8 1140850688 131073 2032 0 721158 ##(Smalltalk.SystemColor)  31 0 5 0 0 0 2032 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.StaticText)  98 16 0 2032 98 2 8 1140850944 1 2160 0 2098 31 0 5 0 0 0 2160 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 0 1682 202 208 98 2 1746 1776 98 2 1810 11 11 1810 541 39 2160 1746 1872 98 1 8 ' Preview' 2160 1922 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 19 1 0 0 24 0 0 0] 98 0 1984 0 27 0 0 0 410 8 ##(Smalltalk.ImageView)  98 21 0 2032 98 2 8 1140850944 262209 2512 721990 2 ##(Smalltalk.ValueHolder)  0 0 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 2658 8 #hash 98 0 0 196934 1 ##(Smalltalk.RGB)  23845879 0 5 0 0 0 2512 0 0 2274 0 0 0 0 8 #scaleToFit 1 590342 ##(Smalltalk.Rectangle)  1810 21 21 1810 21 21 0 1682 202 208 98 1 1746 1776 98 2 1810 11 49 1810 541 251 2512 1922 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 24 0 0 0 19 1 0 0 149 0 0 0] 98 0 1984 0 27 234 256 98 2 2512 8 'preview' 2834 1810 11 11 1810 11 11 1682 202 208 98 1 1746 1776 98 2 1810 1 473 1810 561 309 2032 1922 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 236 0 0 0 24 1 0 0 134 1 0 0] 98 2 2160 2512 1984 0 27 2002 5 11 16 234 256 98 2 1296 8 'resources' 0 1682 202 208 98 2 1746 1776 98 2 1810 2799 21 1810 561 781 416 1746 8 #contextMenu: 98 1 512 416 1922 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 143 6 0 0 144 1 0 0] 98 3 1296 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 3584 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 517 0 0 0 3584 1682 202 208 98 1 1746 1776 98 2 1810 1 463 1810 561 11 3584 1922 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 231 0 0 0 24 1 0 0 236 0 0 0] 98 0 1984 0 27 2032 1984 0 27 )!

resource_Package_view
	"Answer the literal data from which the 'Package view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Package_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409351680 131073 416 0 0 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140854861 1 560 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  0 0 13 0 0 0 560 0 8 4294903801 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'View Name' 389 8 #left 0 8 ##(Smalltalk.SortedCollection)  0 0 560 768 3 0 0 850 8 'Package' 387 896 752 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 8 #name 976 7 513 0 459270 ##(Smalltalk.Message)  8 #owningPackage 98 0 0 560 0 3 0 0 8 #report 688 0 133221 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1314 775 651 560 1250 8 #text: 98 1 8 'View Name' 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 131 1 0 0 69 1 0 0] 98 0 1314 193 193 0 27 524806 ##(Smalltalk.Fraction)  205 155 410 432 98 15 0 416 98 2 8 1140850688 131073 1536 0 196934 1 ##(Smalltalk.RGB)  23845879 0 5 0 0 0 1536 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.StaticText)  98 16 0 1536 98 2 8 1140850944 1 1664 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 1664 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 0 1186 202 208 98 2 1250 1280 98 2 1314 1 1 1314 397 39 1664 1250 1376 98 1 8 '   Preview' 1664 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 198 0 0 0 19 0 0 0] 98 0 1488 0 27 0 0 0 410 8 ##(Smalltalk.ImageView)  98 21 0 1536 98 2 8 1140850944 262209 2048 721990 2 ##(Smalltalk.ValueHolder)  0 0 1376774 ##(Smalltalk.PluggableSearchPolicy)  1106 8 #= 98 0 1106 8 #hash 98 0 0 0 0 5 0 0 0 2048 0 0 1810 0 0 0 0 8 #scaleToFit 1 590342 ##(Smalltalk.Rectangle)  1314 21 21 1314 21 21 0 1186 202 208 98 1 1250 1280 98 2 1314 1 39 1314 397 613 2048 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 198 0 0 0 69 1 0 0] 98 0 1488 0 27 234 256 98 2 2048 8 'preview' 0 1186 202 208 98 1 1250 1280 98 2 1314 785 1 1314 397 651 1536 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 0 0 0 0 78 2 0 0 69 1 0 0] 98 2 1664 2048 1488 0 27 1506 105 155 32 234 256 98 2 560 8 'resources' 0 1186 202 208 98 1 1250 1280 98 2 1314 2799 21 1314 1181 651 416 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 197 7 0 0 79 1 0 0] 98 3 560 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 2976 0 1746 8 4278190080 0 517 0 0 0 2976 1186 202 208 98 1 1250 1280 98 2 1314 775 1 1314 11 651 2976 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 131 1 0 0 0 0 0 0 136 1 0 0 69 1 0 0] 98 0 1488 0 27 1536 1488 0 27 )!

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

