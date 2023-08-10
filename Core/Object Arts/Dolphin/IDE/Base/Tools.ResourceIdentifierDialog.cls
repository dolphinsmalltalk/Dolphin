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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 21 543 210 509 81 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 15 1 0 0 8 1 0 0 55 1 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 7 nil nil nil 576 242 1 17 nil 18 #{UI.TextEdit} 50 20 nil 576 50 2 8 1140916224 1025 656 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 656 nil 8 1853175488 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 479 210 509 45 656 418 #setMarginWidths: 50 1 8 #(3 3) 656 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 239 0 0 0 254 0 0 0 5 1 0 0] 8 #() 560 nil 45 nil nil 18 #{UI.ReferenceView} 50 14 nil 576 50 2 8 1140916224 132097 992 nil nil nil 7 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 2097153 1350 4 #{UI.CommandDescription} #findClass 8 'Find…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FindClass.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1058 nil true 50 4 1106 1 1138 #browseClassPackage 8 'Package <1d>' 1 1 1186 nil true 1218 8 'Package.ico' 1280 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1106 1 1138 #browseClass 8 '&Class' 1 1 1186 nil true 1218 8 'ClassBrowserShell.ico' 1280 65541 nil nil nil 1106 2097153 1138 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 1442 4097 1058 nil true 50 2 1058 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 nil nil nil nil nil 1058 nil true 8 #() 8 '&Show' #viewsShowMenu 134217729 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 992 338 #{Tools.ClassHierarchySelector} #resource_Default_view nil 370 50 1 418 #createAt:extent: 50 2 210 1 1 210 509 463 992 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 0 0 0 231 0 0 0] 544 560 nil 27 550 #{Core.IdentityDictionary} 2 992 8 'classSelector' 656 8 'resourceName' nil 370 50 1 418 #createAt:extent: 50 2 210 21 21 210 509 523 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 8 1 0 0 15 1 0 0] 50 2 992 656 560 nil 27 1954 0 518 #{Graphics.Rectangle} 210 21 21 210 21 21 nil nil nil nil 13425 nil nil nil 210 421 721 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 581 721 32 418 #text: 50 1 8 'Resource Identification' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 33 13 0 0 114 1 0 0] 50 2 576 272 560 nil 27)! !
!Tools.ResourceIdentifierDialog class categoriesForMethods!
defaultModel!constants!public! !
genNameLike:uniqueWithin:!helpers!private! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

