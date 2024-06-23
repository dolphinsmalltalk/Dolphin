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

classesPresenterClass
	^ClassHierarchySelector!

createClassesPresenter
	classesPresenter := self add: self classesPresenterClass new name: 'classSelector'!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	self createClassesPresenter.
	resourceNamePresenter := self add: TextPresenter new name: 'resourceName'!

createSchematicWiring
	super createSchematicWiring.
	resourceNamePresenter
		when: #valueChanged
		send: #onNameChanged
		to: self!

model: aResourceIdentifier 
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aResourceIdentifier.
	aspectBuffer := self model.
	resourceNamePresenter model: (aspectBuffer aspectValue: #name).
	classValue := aspectBuffer aspectValue: #owningClass!

onClassSelected
	"Private - The class selected within the receiver has changed."

	classValue value: classesPresenter selectionOrNil.
	self validate!

onNameChanged
	"Private - The name has been edited. Initiate delayed validation."

	self deferredValidate!

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

validateModel
	| proposedName |
	classesPresenter hasSelection
		ifFalse: 
			[^(ValidationResult errorMessage: 'Please select a class')
				presenter: classesPresenter;
				yourself].
	proposedName := resourceNamePresenter value.
	(ResourceIdentifier isValidResourceName: proposedName)
		ifFalse: 
			[^(ValidationResult errorMessage: '<p> is not a valid resource name' << proposedName)
				presenter: resourceNamePresenter;
				yourself].
	^ValidationResult new!

validationResultPresenterClass
	^ValidationHintPresenter! !

!Tools.ResourceIdentifierDialog categoriesForMethods!
classesPresenterClass!constants!private! !
createClassesPresenter!initializing!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
model:!accessing!public! !
onClassSelected!event handling!private! !
onNameChanged!event handling!private! !
onViewOpened!event handling!public! !
validateModel!private!testing! !
validationResultPresenterClass!constants!public! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 21 543 210 509 81 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 15 1 0 0 8 1 0 0 55 1 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 242 1 17 nil 18 #{UI.TextEdit} 50 20 nil 576 50 2 8 1140916224 1025 656 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 656 nil nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 479 210 509 45 656 418 #setMarginWidths: 50 1 8 #(3 3) 656 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 239 0 0 0 254 0 0 0 5 1 0 0] 8 #() 560 nil 45 nil nil 18 #{UI.ReferenceView} 50 14 nil 576 50 2 8 1140916224 132097 976 nil nil nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 2097153 1350 4 #{UI.CommandDescription} #findClass 8 'Find…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FindClass.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1042 nil true 50 4 1090 1 1122 #browseClassPackage 8 'Package <d>' 1 1 1170 nil true 1202 8 'Package.ico' 1264 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1090 1 1122 #browseClass 8 '&Class' 1 1 1170 nil true 1202 8 'ClassBrowserShell.ico' 1264 65541 nil nil nil 1090 2097153 1122 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 1426 4097 1042 nil true 50 2 1042 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 nil nil nil nil nil 1042 nil true 8 #() 8 '&Show' #viewsShowMenu 134217729 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 976 338 #{Tools.ClassHierarchySelector} #resource_Default_view nil 370 50 1 418 #createAt:extent: 50 2 210 1 1 210 509 463 976 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 0 0 0 231 0 0 0] 544 560 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 976 8 'classSelector' 656 8 'resourceName' nil 370 50 1 418 #createAt:extent: 50 2 210 21 21 210 509 523 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 8 1 0 0 15 1 0 0] 50 2 976 656 560 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 210 21 21 210 21 21 nil nil nil nil 1 nil nil nil 210 421 721 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 581 721 32 418 #text: 50 1 8 'Resource Identification' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 33 13 0 0 114 1 0 0] 50 2 576 272 560 nil 27)! !

!Tools.ResourceIdentifierDialog class categoriesForMethods!
defaultModel!constants!public! !
genNameLike:uniqueWithin:!helpers!private! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

