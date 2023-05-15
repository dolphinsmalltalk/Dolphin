"Filed out from Dolphin Smalltalk"!

Tools.ClassBrowserPlugin
	subclass: #'Tools.ResourceListPlugin'
	instanceVariableNames: 'resourcesPresenter flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'ShowInheritedResourcesMask' -> 16r1. 'ShowSubclassResourcesMask' -> 16r2 }!
Tools.ResourceListPlugin guid: (Core.GUID fromString: '{9bf86123-58b4-42e2-bdf8-063f7e315276}')!
Tools.ResourceListPlugin comment: '`ResourceListPlugin` is a `<classBrowserPlugin>` that displays a list of the view resources associated with a class, optionally including those inherited from superclasses and/or those owned by subclasses.

##Instance Variables:
  resourcesPresenter	`ResourceListPresenter`
  flags				`<integer>`

##Class Variables:
  ShowSubclassResourcesMask		`<integer>`
  ShowInheritedResourcesMask		`<integer>`

'!
!Tools.ResourceListPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !
!Tools.ResourceListPlugin methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	resourcesPresenter := self add: ResourceListPresenter new name: 'resources'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self model)
		when: #methodSelected
			send: #onBrowserMethodSelected
			to: self;
		when: #classSelected
			send: #onBrowserClassSelected
			to: self!

defaultHelpId
	^10749!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Views'!

initialize
	"Private - Initialize the receiver."

	flags := 0.
	super initialize!

isShowingInheritedResources
	"Private - Answer whether the receiver is in 'show inherited methods' mode"

	^flags allMask: ShowInheritedResourcesMask!

isShowingInheritedResources: aBoolean 
	self isShowingInheritedResources == aBoolean ifTrue: [^self].
	flags := flags mask: ShowInheritedResourcesMask set: aBoolean.
	self showClassResources!

isShowingSubclassResources
	"Private - Answer whether the receiver is in 'show subclass' resources' mode"

	^flags allMask: ShowSubclassResourcesMask!

isShowingSubclassResources: aBoolean 
	self isShowingSubclassResources == aBoolean ifTrue: [^self].
	flags := flags mask: ShowSubclassResourcesMask set: aBoolean.
	self showClassResources!

onBrowserClassSelected
	self isCurrentCard ifFalse: [^self].
	self showClassResources!

onBrowserMethodSelected
	"Event handler for a method being selected within the receiver's associated browser. "

	(self isCurrentCard and: [self browser hasMethodSelected]) 
		ifTrue: [self browser ensureSourceVisible]!

onShownInBrowser
	"Event handler indicating that the receiver has been displayed within it's browser."

	super onShownInBrowser.
	self showClassResources!

queryToggleShowInheritedResources: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self isShowingInheritedResources!

queryToggleShowSubclassResources: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self isShowingSubclassResources!

showClassResources
	| classes filter |
	classes := self browser selectedClasses asSet.
	filter := self isShowingInheritedResources
				ifTrue: 
					[
					[:resID |
					| owner |
					owner := resID owningClass.
					classes anySatisfy: 
							[:class |
							(class includesBehavior: owner)
								and: [(ResourceIdentifier class: class name: resID name) resource = resID resource]]]]
				ifFalse: [[:resID | classes includes: resID owningClass]].
	resourcesPresenter filterBlock: (self isShowingSubclassResources
				ifTrue: 
					[
					[:resID |
					| owner |
					owner := resID owningClass.
					(classes anySatisfy: [:class | owner includesBehavior: class]) or: [filter value: resID]]]
				ifFalse: [filter])!

toggleShowInheritedResources
	"Toggle between showing resources owned by subclasses or not"

	<commandQuery: #queryToggleShowInheritedResources:>
	self isShowingInheritedResources: self isShowingInheritedResources not!

toggleShowSubclassResources
	"Toggle between showing resources inherited from superclasses or not"

	<commandQuery: #queryToggleShowSubclassResources:>
	self isShowingSubclassResources: self isShowingSubclassResources not! !
!Tools.ResourceListPlugin categoriesForMethods!
createComponents!initializing!operations!private! !
createSchematicWiring!initializing!public! !
defaultHelpId!constants!public! !
displayOn:!displaying!public! !
initialize!initializing!private! !
isShowingInheritedResources!private!testing! !
isShowingInheritedResources:!accessing!private! !
isShowingSubclassResources!private!testing! !
isShowingSubclassResources:!accessing!private! !
onBrowserClassSelected!event handling!public! !
onBrowserMethodSelected!event handling!private! !
onShownInBrowser!event handling!public! !
queryToggleShowInheritedResources:!commands-queries!private! !
queryToggleShowSubclassResources:!commands-queries!private! !
showClassResources!private!updating! !
toggleShowInheritedResources!commands-actions!public! !
toggleShowSubclassResources!commands-actions!public! !
!

!Tools.ResourceListPlugin class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^View icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 461638 4 #{UI.Menu} nil true 34 8 1180742 2 #{UI.CommandMenuItem} 2097153 1377606 4 #{UI.CommandDescription} #editResource 8 '&Edit' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'ViewComposer.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 626 1 658 #browseReferences 8 'Browse &References' 1 1 nil nil nil 626 1 658 #showResource 8 '&Show' 1 1 706 nil true 738 8 'TestView.ico' 800 65541 nil nil nil 626 1 658 #newView 8 '&New…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 626 1 658 #deleteResource 8 '&Delete' 1 1 706 nil true 738 8 'EditClear.ico' 800 65541 nil nil nil 1026 4097 578 nil true 34 7 626 1 658 #toggleShowInheritedResources 8 'Show I&nherited' 1 1 nil nil nil 626 1 658 #toggleShowSubclassResources 8 'Show &Subclass' 1 1 nil nil nil 1026 4097 626 1 658 #tileIconMode 8 '&Tiles' 1 1 nil nil nil 626 1 658 #largeIconMode 8 '&Icons' 1 1 nil nil nil 626 1025 658 #listMode 8 '&List' 1 1 nil nil nil 626 1025 658 #reportMode 8 '&Details' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 512 1376838 1 #{UI.ResourceIdentifier} #{Tools.ResourceListPresenter} #resource_Package_view nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 1666 1061 501 512 1618 #contextMenu: 34 1 592 512 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 18 2 0 0 250 0 0 0] 8 #() 1666 193 193 nil 27 170 192 34 2 512 8 'resources' nil 1570 34 1 1618 #createAt:extent: 34 2 1666 12287 21 1666 1061 501 416 1746 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 17 26 0 0 4 1 0 0] 34 1 512 1808 nil 27)! !
!Tools.ResourceListPlugin class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

