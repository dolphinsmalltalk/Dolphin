"Filed out from Dolphin Smalltalk"!

ClassBrowserPlugin subclass: #ResourceListPlugin
	instanceVariableNames: 'resourcesPresenter flags'
	classVariableNames: 'ShowInheritedResourcesMask ShowSubclassResourcesMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResourceListPlugin guid: (GUID fromString: '{9bf86123-58b4-42e2-bdf8-063f7e315276}')!
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
!ResourceListPlugin categoriesForMethods!
createComponents!commands!initializing!private! !
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
queryCommand:!commands!private! !
showClassResources!private!updating! !
toggleShowInheritedResources!commands!public! !
toggleShowSubclassResources!commands!public! !
!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1180998 4 ##(Smalltalk.CommandDescription) #editResource 8 '&Edit' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ViewComposer.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 626 1 658 #browseReferences 8 'Browse &References' 1 1 nil nil nil 626 1 658 #showResource 8 '&Show' 1 1 706 nil true 752 8 'TestView.ico' 800 nil nil 626 1 658 #newView 8 '&New...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 626 1 658 #deleteResource 8 '&Delete' 1 1 706 nil true 752 8 'EditClear.ico' 800 nil nil 1010 4097 578 nil true 34 7 626 1 658 #toggleShowInheritedResources 8 'Show I&nherited' 1 1 nil nil nil 626 1 658 #toggleShowSubclassResources 8 'Show &Subclass' 1 1 nil nil nil 1010 4097 626 1 658 #tileIconMode 8 '&Tiles' 1 1 nil nil nil 626 1 658 #largeIconMode 8 '&Icons' 1 1 nil nil nil 626 1025 658 #listMode 8 '&List' 1 1 nil nil nil 626 1025 658 #reportMode 8 '&Details' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 512 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.ResourceListPresenter) #resource_Package_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1650 1061 501 512 1602 #contextMenu: 34 1 592 512 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 18 2 0 0 250 0 0 0] 8 #() 1650 193 193 nil 27 170 192 34 2 512 8 'resources' nil 1538 138 144 34 1 1602 #createAt:extent: 34 2 1650 3839 21 1650 1061 501 416 1730 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 145 9 0 0 4 1 0 0] 34 1 512 1792 nil 27 )! !
!ResourceListPlugin class categoriesForMethods!
icon!constants!public! !
initialize!initializing!public! !
resource_Default_view!public!resources-views! !
!

