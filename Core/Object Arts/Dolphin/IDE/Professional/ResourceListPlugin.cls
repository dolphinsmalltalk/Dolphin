"Filed out from Dolphin Smalltalk 7"!

ClassBrowserPlugin subclass: #ResourceListPlugin
	instanceVariableNames: 'resourcesPresenter flags'
	classVariableNames: 'ShowInheritedResourcesMask ShowSubclassResourcesMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResourceListPlugin guid: (GUID fromString: '{9BF86123-58B4-42E2-BDF8-063F7E315276}')!
ResourceListPlugin comment: 'ResourceListPlugin is a <classBrowserPlugin> that displays a list of the view resources associated with a class, optionally including those inherited from superclasses and/or those owned by subclasses.

Instance Variables:
	resourcesPresenter	<ResourceListPresenter>
	flags				<integer>

Class Variables:
	ShowSubclassResourcesMask		<integer>
	ShowInheritedResourcesMask		<integer>

'!
!ResourceListPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !
!ResourceListPlugin methodsFor!

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

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	as a plugin within the Class Browser"

	aStream nextPutAll: 'Views'!

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

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	#toggleShowInheritedResources == selector 
		ifTrue: 
			[aCommandQuery isEnabled: true; isChecked: self isShowingInheritedResources.
			^true].
	#toggleShowSubclassResources == selector 
		ifTrue: 
			[aCommandQuery isEnabled: true; isChecked: self isShowingSubclassResources.
			^true].
	^super queryCommand: aCommandQuery!

showClassResources
	| class filter |
	class := self browser selectedClass.
	filter := self isShowingInheritedResources 
				ifTrue: 
					[
					[:resID | 
					(class includesBehavior: resID owningClass) 
						and: [(ResourceIdentifier class: class name: resID name) resource = resID resource]]]
				ifFalse: [[:resID | resID owningClass == class]].
	resourcesPresenter filterBlock: (self isShowingSubclassResources 
				ifTrue: [[:resID | (resID owningClass includesBehavior: class) or: [filter value: resID]]]
				ifFalse: [filter])!

toggleShowInheritedResources
	"Toggle between showing resources owned by subclasses or not"

	self isShowingInheritedResources: self isShowingInheritedResources not!

toggleShowSubclassResources
	"Toggle between showing resources inherited from superclasses or not"

	self isShowingSubclassResources: self isShowingSubclassResources not! !
!ResourceListPlugin categoriesFor: #createComponents!commands!initializing!private! !
!ResourceListPlugin categoriesFor: #createSchematicWiring!initializing!public! !
!ResourceListPlugin categoriesFor: #defaultHelpId!constants!public! !
!ResourceListPlugin categoriesFor: #displayOn:!displaying!public! !
!ResourceListPlugin categoriesFor: #initialize!initializing!private! !
!ResourceListPlugin categoriesFor: #isShowingInheritedResources!private!testing! !
!ResourceListPlugin categoriesFor: #isShowingInheritedResources:!accessing!private! !
!ResourceListPlugin categoriesFor: #isShowingSubclassResources!private!testing! !
!ResourceListPlugin categoriesFor: #isShowingSubclassResources:!accessing!private! !
!ResourceListPlugin categoriesFor: #onBrowserClassSelected!event handling!public! !
!ResourceListPlugin categoriesFor: #onBrowserMethodSelected!event handling!private! !
!ResourceListPlugin categoriesFor: #onShownInBrowser!event handling!public! !
!ResourceListPlugin categoriesFor: #queryCommand:!commands!private! !
!ResourceListPlugin categoriesFor: #showClassResources!private!updating! !
!ResourceListPlugin categoriesFor: #toggleShowInheritedResources!commands!public! !
!ResourceListPlugin categoriesFor: #toggleShowSubclassResources!commands!public! !

!ResourceListPlugin class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^View icon!

initialize
	ShowInheritedResourcesMask := 1.
	ShowSubclassResourcesMask := 2!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 576 0 498 8 4278190080 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 7 984134 2 ##(Smalltalk.CommandMenuItem)  2097153 1180998 4 ##(Smalltalk.CommandDescription)  8 #editResource 8 '&Edit' 1 1 0 0 0 738 1 770 8 #showResource 8 '&Show' 1 1 0 0 0 738 1 770 8 #newView 8 '&New...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 738 1 770 8 #deleteResource 8 '&Delete' 1 1 0 0 0 962 4097 690 0 16 98 7 738 1 770 8 #toggleShowInheritedResources 8 'Show I&nherited' 1 1 0 0 0 738 1 770 8 #toggleShowSubclassResources 8 'Show &Subclass' 1 1 0 0 0 962 4097 738 1 770 8 #tileIconMode 8 '&Tiles' 1 1 0 0 0 738 1 770 8 #largeIconMode 8 '&Icons' 1 1 0 0 0 738 1025 770 8 #listMode 8 '&List' 1 1 0 0 0 738 1025 770 8 #reportMode 8 '&Details' 1 1 0 0 0 8 '&View' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 576 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.ResourceListPresenter)  8 #resource_Package_view 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1730 1061 501 576 1666 8 #contextMenu: 98 1 704 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 18 2 0 0 250 0 0 0] 98 0 1730 193 193 0 27 234 256 98 2 576 8 'resources' 0 1602 202 208 98 1 1666 1696 98 2 1730 2799 21 1730 1061 501 416 1826 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 137 7 0 0 4 1 0 0] 98 1 576 1888 0 27 )! !
!ResourceListPlugin class categoriesFor: #icon!constants!public! !
!ResourceListPlugin class categoriesFor: #initialize!initializing!public! !
!ResourceListPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

