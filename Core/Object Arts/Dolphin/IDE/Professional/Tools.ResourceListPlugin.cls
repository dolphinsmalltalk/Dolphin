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
		beEnabled;
		isChecked: self isShowingInheritedResources!

queryToggleShowSubclassResources: aCommandQuery
	aCommandQuery
		beEnabled;
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 144 nil nil nil 5 2886 4 #{UI.Menu} nil true 50 8 1094 2 #{UI.CommandMenuItem} 2097153 1350 4 #{UI.CommandDescription} #editResource 8 '&Edit' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'ViewComposer.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 258 1 290 #browseReferences 8 'Browse &References' 1 1 nil nil nil 258 1 290 #showResource 8 '&Show' 1 1 338 nil true 370 8 'TestView.ico' 432 65541 nil nil nil 258 1 290 #newView 8 '&New…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 258 1 290 #deleteResource 8 '&Delete' 1 1 338 nil true 370 8 'EditClear.ico' 432 65541 nil nil nil 658 4097 210 nil true 50 7 258 1 290 #toggleShowInheritedResources 8 'Show I&nherited' 1 1 nil nil nil 258 1 290 #toggleShowSubclassResources 8 'Show &Subclass' 1 1 nil nil nil 658 4097 258 1 290 #tileIconMode 8 '&Tiles' 1 1 nil nil nil 258 1 290 #largeIconMode 8 '&Icons' 1 1 nil nil nil 258 1025 290 #listMode 8 '&List' 1 1 nil nil nil 258 1025 290 #reportMode 8 '&Details' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 144 582 1 #{UI.ResourceIdentifier} #{Tools.ResourceListPresenter} #resource_Package_view nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 1298 1061 501 144 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 18 2 0 0 250 0 0 0] 8 #() 1298 193 193 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 144 8 'resources' nil 1202 50 1 1250 #createAt:extent: 50 2 1298 6143 21 1298 1061 501 32 1346 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 17 14 0 0 4 1 0 0] 50 1 144 1408 nil 27)! !
!Tools.ResourceListPlugin class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

