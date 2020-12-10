"Filed out from Dolphin Smalltalk 7"!

UI.Dialog subclass: #'Tools.ResourceIdentifierDialog'
	instanceVariableNames: 'classesPresenter resourceNamePresenter classValue'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ResourceIdentifierDialog guid: (Core.GUID fromString: '{87b4c6a4-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.ResourceIdentifierDialog comment: 'ResourceIdentifierDialog is a <dialogPresenter> used to edit the contents of an <ResourceIdentifier> model.

Instance Variables:
	classTreePresenter		<TreePresenter> displaying a hierarchy of presenter classes.
	resourceNamePresenter	<TextPresenter> for the #name aspect.
	classValue		<ValueAspectAdaptor> for the #owningClass aspect.

'!
!Tools.ResourceIdentifierDialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !
!Tools.ResourceIdentifierDialog methodsFor!

canApply
	^classesPresenter hasSelection and: [resourceNamePresenter value notEmpty]!

classesPresenterClass
	^ClassHierarchySelector!

createClassesPresenter
	classesPresenter := self add: self classesPresenterClass new name: 'classSelector'!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	self createClassesPresenter.
	resourceNamePresenter := self add: TextPresenter new name: 'resourceName'!

model: aResourceIdentifier 
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aResourceIdentifier.
	aspectBuffer := self model.
	resourceNamePresenter model: (aspectBuffer aspectValue: #name).
	classValue := aspectBuffer aspectValue: #owningClass!

onClassSelected
	"Private - The class selected within the receiver has changed."

	classValue value: classesPresenter selectionOrNil!

onViewOpened
	"Received when the receiver's view has been connected. "

	super onViewOpened.
	classesPresenter selectionOrNil: classValue value.
	"We can't wire up to the tree's selection change in #createSchematicWiring because
	 the tree view's behaviour of auto-selecting its first root (i.e. Object) will cause the
	 initial model value to be overwritten"
	classesPresenter 
		when: #selectionChanged
		send: #onClassSelected
		to: self!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok 
		ifTrue: 
			[aCommandQuery isEnabled: self canApply.
			^true].
	^super queryCommand: aCommandQuery! !
!Tools.ResourceIdentifierDialog categoriesFor: #canApply!private!testing! !
!Tools.ResourceIdentifierDialog categoriesFor: #classesPresenterClass!constants!private! !
!Tools.ResourceIdentifierDialog categoriesFor: #createClassesPresenter!initializing!private! !
!Tools.ResourceIdentifierDialog categoriesFor: #createComponents!initializing!public! !
!Tools.ResourceIdentifierDialog categoriesFor: #model:!accessing!public! !
!Tools.ResourceIdentifierDialog categoriesFor: #onClassSelected!event handling!private! !
!Tools.ResourceIdentifierDialog categoriesFor: #onViewOpened!event handling!public! !
!Tools.ResourceIdentifierDialog categoriesFor: #queryCommand:!commands!private! !

!Tools.ResourceIdentifierDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ResourceIdentifier new!

genNameLike: aString uniqueWithin: aCollection
	"Private - Answer a String unique within aCollection based on aString."

	| tryName suffixNo |
	tryName := aString.
	suffixNo := 1.
	[aCollection includes: tryName]
		whileTrue: [
			tryName := aString, suffixNo asString.
			suffixNo := suffixNo + 1].
	^tryName!

icon
	"Answers an Icon that can be used to represent this class."

	^Smalltalk developmentSystem icon
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 133 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 21 543 578 509 81 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 15 1 0 0 8 1 0 0 55 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 610 1 17 nil 410 ##(UI.TextEdit) 34 16 nil 960 34 2 8 1140916224 1025 1040 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1040 nil 8 1801338832 1049094 ##(UI.NullConverter) nil nil 1 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 479 578 509 45 1040 802 #setMarginWidths: 34 1 8 #(3 3) 1040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 239 0 0 0 254 0 0 0 5 1 0 0] 8 #() 944 nil 27 nil nil 410 ##(UI.ReferenceView) 34 14 nil 960 34 2 8 1140916224 132097 1392 nil nil nil 7 461638 4 ##(UI.Menu) nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 2097153 1377606 4 ##(UI.CommandDescription) #findClass 8 'Find...' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FindClass.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1458 nil true 34 4 1506 1 1538 #browseClassPackage 8 'Package <1d>' 1 1 1586 nil true 1632 8 'Package.ico' 1680 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 1506 1 1538 #browseClass 8 '&Class' 1 1 1586 nil true 1632 8 'ClassBrowserShell.ico' 1680 nil nil 1506 2097153 1538 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 1826 4097 1458 nil true 34 2 1458 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 nil nil nil nil nil 1458 nil true 8 #() 8 '&Show' #viewsShowMenu 134217729 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 1392 706 ##(Tools.ClassHierarchySelector) #resource_Default_view nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 1 578 509 463 1392 802 #contextMenu: 34 1 1472 1392 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 0 0 0 231 0 0 0] 928 944 nil 27 170 192 34 4 1040 8 'resourceName' 1392 8 'classSelector' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 21 21 578 509 523 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 8 1 0 0 15 1 0 0] 34 2 1392 1040 944 nil 27 170 192 928 1180166 ##(Graphics.Rectangle) 578 21 21 578 21 21 nil nil nil nil 25833 nil nil nil 578 421 721 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 1996777232 738 138 144 34 2 802 #createAt:extent: 34 2 578 6143 21 578 581 721 416 802 #text: 34 1 8 'Resource Identification' 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 33 13 0 0 114 1 0 0] 34 2 960 640 944 nil 27 )! !
!Tools.ResourceIdentifierDialog class categoriesFor: #defaultModel!constants!public! !
!Tools.ResourceIdentifierDialog class categoriesFor: #genNameLike:uniqueWithin:!helpers!private! !
!Tools.ResourceIdentifierDialog class categoriesFor: #icon!constants!public! !
!Tools.ResourceIdentifierDialog class categoriesFor: #resource_Default_view!public!resources-views! !

