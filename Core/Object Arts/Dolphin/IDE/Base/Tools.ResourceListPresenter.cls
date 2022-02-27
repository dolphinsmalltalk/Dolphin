"Filed out from Dolphin Smalltalk"!

UI.ListPresenter subclass: #'Tools.ResourceListPresenter'
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

a0z: method
	^method isResourceMethod!

a1z: method
	^method isResourceMethod!

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
	<acceleratorKey: 'Shift+F12'>
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
	(MessageBox new
		headline: 'Move resource to new package?';
		confirm: 'The resource ''<1p>'' is currently owned by the <2p> package<n><n>Are you sure you would like to move it to <3p>?'
					<< {aResourceIdentifier. resourcePackage name. aPackage name})
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
				caption: 'Package of <1d>…' << rid
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

	^SmalltalkSystem current! !
!Tools.ResourceListPresenter categoriesForMethods!
a0z:!event handling!private! !
a1z:!event handling!private! !
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
imageFromResource:!helpers!private! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409351680 131073 416 nil nil nil 5 461638 4 #{UI.Menu} nil true 34 11 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #browseHierarchy 8 '&Browse <1s>' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'ClassBrowserShell.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 530 1 562 #browseReferences 8 'Browse &References' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 530 1 562 #editResource 8 '&Edit' 9349 1 610 nil true 642 8 'ViewComposer.ico' 704 65541 nil nil nil 530 1 562 #showResource 8 '&Show' 1 1 nil nil nil 530 1 562 #newView 8 '&New…' 1 1 nil nil nil 786 4097 530 1 562 #deleteResource 8 '&Delete…' 1 1 610 nil true 642 8 'EditClear.ico' 704 65541 nil nil nil 786 4097 530 1 562 #resourcePackage 8 '&Package…' 1 1 nil nil nil 530 1 562 #categoryResource 8 'Categories…' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil nil nil 416 1376774 #{UI.ProportionalLayout} 170 176 34 4 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140854861 1025 1312 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 13 nil nil nil 1312 nil 8 1815049392 786950 #{Core.Message} #displayString 1424 1522 #iconImageIndex 1424 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 'View Name' 561 #left nil 1522 #<= 8 #() nil nil 1312 1552 3 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 1826 561 463 1312 1778 #text: 34 1 8 'View Name' 1312 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 24 1 0 0 231 0 0 0] 8 #() 1826 193 193 nil 35 852486 #{Core.Fraction} 7 11 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 393217 2032 nil nil nil 5 nil nil nil 2032 984838 #{UI.BorderLayout} 1 1 410 #{UI.StaticText} 34 16 nil 2032 34 2 8 1140850944 1 2128 nil nil nil 5 nil nil nil 2128 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1730 34 2 1778 #createAt:extent: 34 2 1826 11 11 1826 537 39 2128 1778 #text: 34 1 8 ' Preview' 2128 1922 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 17 1 0 0 24 0 0 0] 8 #() 1984 nil 27 nil nil nil 410 #{UI.ImageView} 34 21 nil 2032 34 2 8 1140850944 262209 2432 918598 2 #{UI.ValueHolder} nil nil 1835526 #{Kernel.PluggableSearchPolicy} 1522 #= 8 #() 1522 #hash 8 #() nil 1474 #applicationWorkspace nil 5 nil nil nil 2432 nil nil 2210 nil nil nil nil #scaleBestFit 1 1180166 #{Graphics.Rectangle} 1826 21 21 1826 21 21 nil 1730 34 1 1778 #createAt:extent: 34 2 1826 11 49 1826 537 247 2432 1922 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 24 0 0 0 17 1 0 0 147 0 0 0] 8 #() 1984 nil 27 170 192 34 2 2432 8 'preview' 2658 1826 11 11 1826 11 11 1730 34 1 1778 #createAt:extent: 34 2 1826 1 473 1826 561 309 2032 1922 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 236 0 0 0 24 1 0 0 134 1 0 0] 34 2 2128 2432 1984 nil 27 2002 5 11 true 170 192 34 2 1312 8 'resources' nil 1730 34 2 1778 #createAt:extent: 34 2 1826 12287 21 1826 561 781 416 1778 #contextMenu: 34 1 496 416 1922 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 23 25 0 0 144 1 0 0] 34 3 1312 410 #{UI.Splitter} 34 12 nil 416 34 2 8 1140850688 1 3344 nil nil nil 517 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 3344 nil 1 #left nil nil nil 1826 1 1 1826 9 9 nil 3440 nil 1730 34 1 1778 #createAt:extent: 34 2 1826 1 463 1826 561 11 3344 1922 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 231 0 0 0 24 1 0 0 236 0 0 0] 8 #() 1984 nil 27 2032 1984 nil 27)!

resource_Package_view
	"Answer the literal data from which the 'Package view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Package_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409351680 131073 416 nil nil nil 5 nil nil nil 416 1376774 #{UI.ProportionalLayout} 170 176 34 4 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 393217 544 nil nil nil 5 nil nil nil 544 984838 #{UI.BorderLayout} 1 1 410 #{UI.StaticText} 34 16 nil 544 34 2 8 1140850944 1 640 nil nil nil 5 nil nil nil 640 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 850 393 39 640 802 #text: 34 1 8 '   Preview' 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 196 0 0 0 19 0 0 0] 8 #() 850 193 193 nil 27 nil nil nil 410 #{UI.ImageView} 34 21 nil 544 34 2 8 1140850944 262209 1024 918598 2 #{UI.ValueHolder} nil nil 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 1154 #hash 8 #() nil 917510 #{Graphics.Color} #applicationWorkspace nil 5 nil nil nil 1024 nil nil 722 nil nil nil nil #scaleBestFit 1 1180166 #{Graphics.Rectangle} 850 21 21 850 21 21 nil 754 34 1 802 #createAt:extent: 34 2 850 1 39 850 393 609 1024 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 196 0 0 0 67 1 0 0] 8 #() 1008 nil 27 170 192 34 2 1024 8 'preview' nil 754 34 1 802 #createAt:extent: 34 2 850 785 1 850 397 651 544 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 0 0 0 0 78 2 0 0 69 1 0 0] 34 2 640 1024 1008 nil 27 852486 #{Core.Fraction} 105 155 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140854857 1025 1712 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 1234 #default nil 13 nil nil nil 1712 nil 8 1815049392 1154 #displayString 1824 1154 #iconImageIndex 1824 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 2 1117254 5 #{UI.ListViewColumn} 8 'View Name' 389 #left nil 1154 #<= 8 #() nil nil 1712 1920 3 nil nil 2002 8 'Package' 387 #left 1904 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 2128 7 513 nil 1154 #owningPackage 8 #() nil 1712 nil 3 nil nil #report 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 754 34 2 802 #createAt:extent: 34 2 850 1 1 850 775 651 1712 802 #text: 34 1 8 'View Name' 1712 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 131 1 0 0 69 1 0 0] 8 #() 1008 nil 35 1682 205 155 false 170 192 34 2 1712 8 'resources' nil 754 34 1 802 #createAt:extent: 34 2 850 12287 21 850 1181 651 416 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 77 26 0 0 79 1 0 0] 34 3 1712 410 #{UI.Splitter} 34 12 nil 416 34 2 8 1140850688 1 2672 nil nil nil 517 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 2672 nil 1 #left nil nil nil 850 1 1 850 9 9 nil 2768 nil 754 34 1 802 #createAt:extent: 34 2 850 775 1 850 11 651 2672 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 131 1 0 0 0 0 0 0 136 1 0 0 69 1 0 0] 8 #() 1008 nil 27 544 1008 nil 27)!

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

