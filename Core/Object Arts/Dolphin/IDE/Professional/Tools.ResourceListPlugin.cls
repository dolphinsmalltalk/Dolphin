"Filed out from Dolphin Smalltalk 7"!

Tools.ClassBrowserPlugin subclass: #'Tools.ResourceListPlugin'
	instanceVariableNames: 'resourcesPresenter flags'
	classVariableNames: 'ShowInheritedResourcesMask ShowSubclassResourcesMask'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ResourceListPlugin guid: (Core.GUID fromString: '{9bf86123-58b4-42e2-bdf8-063f7e315276}')!
Tools.ResourceListPlugin comment: 'ResourceListPlugin is a <classBrowserPlugin> that displays a list of the view resources associated with a class, optionally including those inherited from superclasses and/or those owned by subclasses.

Instance Variables:
	resourcesPresenter	<ResourceListPresenter>
	flags				<integer>

Class Variables:
	ShowSubclassResourcesMask		<integer>
	ShowInheritedResourcesMask		<integer>

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
!Tools.ResourceListPlugin categoriesFor: #createComponents!commands!initializing!private! !
!Tools.ResourceListPlugin categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.ResourceListPlugin categoriesFor: #defaultHelpId!constants!public! !
!Tools.ResourceListPlugin categoriesFor: #displayOn:!displaying!public! !
!Tools.ResourceListPlugin categoriesFor: #initialize!initializing!private! !
!Tools.ResourceListPlugin categoriesFor: #isShowingInheritedResources!private!testing! !
!Tools.ResourceListPlugin categoriesFor: #isShowingInheritedResources:!accessing!private! !
!Tools.ResourceListPlugin categoriesFor: #isShowingSubclassResources!private!testing! !
!Tools.ResourceListPlugin categoriesFor: #isShowingSubclassResources:!accessing!private! !
!Tools.ResourceListPlugin categoriesFor: #onBrowserClassSelected!event handling!public! !
!Tools.ResourceListPlugin categoriesFor: #onBrowserMethodSelected!event handling!private! !
!Tools.ResourceListPlugin categoriesFor: #onShownInBrowser!event handling!public! !
!Tools.ResourceListPlugin categoriesFor: #queryCommand:!commands!private! !
!Tools.ResourceListPlugin categoriesFor: #showClassResources!private!updating! !
!Tools.ResourceListPlugin categoriesFor: #toggleShowInheritedResources!commands!public! !
!Tools.ResourceListPlugin categoriesFor: #toggleShowSubclassResources!commands!public! !

!Tools.ResourceListPlugin class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 512 nil nil nil 5 461638 4 ##(UI.Menu) nil true 34 8 1180742 2 ##(UI.CommandMenuItem) 2097153 1377606 4 ##(UI.CommandDescription) #editResource 8 '&Edit' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'ViewComposer.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 626 1 658 #browseReferences 8 'Browse &References' 1 1 nil nil nil 626 1 658 #showResource 8 '&Show' 1 1 706 nil true 752 8 'TestView.ico' 800 nil nil 626 1 658 #newView 8 '&New...' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 626 1 658 #deleteResource 8 '&Delete' 1 1 706 nil true 752 8 'EditClear.ico' 800 nil nil 1010 4097 578 nil true 34 7 626 1 658 #toggleShowInheritedResources 8 'Show I&nherited' 1 1 nil nil nil 626 1 658 #toggleShowSubclassResources 8 'Show &Subclass' 1 1 nil nil nil 1010 4097 626 1 658 #tileIconMode 8 '&Tiles' 1 1 nil nil nil 626 1 658 #largeIconMode 8 '&Icons' 1 1 nil nil nil 626 1025 658 #listMode 8 '&List' 1 1 nil nil nil 626 1025 658 #reportMode 8 '&Details' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 512 1376838 1 ##(UI.ResourceIdentifier) ##(Tools.ResourceListPresenter) #resource_Package_view nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 1 1650 1061 501 512 1602 #contextMenu: 34 1 592 512 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 18 2 0 0 250 0 0 0] 8 #() 1650 193 193 nil 27 170 192 34 2 512 8 'resources' nil 1538 138 144 34 1 1602 #createAt:extent: 34 2 1650 6143 21 1650 1061 501 416 1730 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 17 14 0 0 4 1 0 0] 34 1 512 1792 nil 27 )! !
!Tools.ResourceListPlugin class categoriesFor: #icon!constants!public! !
!Tools.ResourceListPlugin class categoriesFor: #initialize!initializing!public! !
!Tools.ResourceListPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

