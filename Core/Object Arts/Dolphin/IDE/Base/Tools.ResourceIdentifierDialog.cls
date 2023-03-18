"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'Tools.ResourceIdentifierDialog'
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
!Tools.ResourceIdentifierDialog categoriesForMethods!
canApply!private!testing! !
classesPresenterClass!constants!private! !
createClassesPresenter!initializing!private! !
createComponents!initializing!public! !
model:!accessing!public! !
onClassSelected!event handling!private! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
!

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

	^SmalltalkSystem current icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 21 543 578 509 81 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 15 1 0 0 8 1 0 0 55 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 610 1 17 nil 410 #{UI.TextEdit} 34 16 nil 944 34 2 8 1140916224 1025 1024 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1024 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 738 34 2 786 #createAt:extent: 34 2 578 1 479 578 509 45 1024 786 #setMarginWidths: 34 1 8 #(3 3) 1024 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 239 0 0 0 254 0 0 0 5 1 0 0] 8 #() 928 nil 27 nil nil 410 #{UI.ReferenceView} 34 14 nil 944 34 2 8 1140916224 132097 1360 nil nil nil 7 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 2097153 1377606 4 #{UI.CommandDescription} #findClass 8 'Find…' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'FindClass.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 1426 nil true 34 4 1474 1 1506 #browseClassPackage 8 'Package <1d>' 1 1 1554 nil true 1586 8 'Package.ico' 1648 65541 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 1474 1 1506 #browseClass 8 '&Class' 1 1 1554 nil true 1586 8 'ClassBrowserShell.ico' 1648 65541 nil nil nil 1474 2097153 1506 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 1810 4097 1426 nil true 34 2 1426 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 nil nil nil nil nil 1426 nil true 8 #() 8 '&Show' #viewsShowMenu 134217729 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 1360 706 #{Tools.ClassHierarchySelector} #resource_Default_view nil 738 34 2 786 #createAt:extent: 34 2 578 1 1 578 509 463 1360 786 #contextMenu: 34 1 1440 1360 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 0 0 0 231 0 0 0] 912 928 nil 27 170 192 34 4 1360 8 'classSelector' 1024 8 'resourceName' nil 738 34 1 786 #createAt:extent: 34 2 578 21 21 578 509 523 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 8 1 0 0 15 1 0 0] 34 2 1360 1024 928 nil 27 170 192 912 1180166 #{Graphics.Rectangle} 578 21 21 578 21 21 nil nil nil nil 59245 nil nil nil 578 421 721 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 581 721 416 786 #text: 34 1 8 'Resource Identification' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 33 25 0 0 114 1 0 0] 34 2 944 640 928 nil 27)! !
!Tools.ResourceIdentifierDialog class categoriesForMethods!
defaultModel!constants!public! !
genNameLike:uniqueWithin:!helpers!private! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

