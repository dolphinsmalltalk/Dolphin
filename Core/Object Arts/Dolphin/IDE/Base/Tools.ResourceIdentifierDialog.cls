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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[10 0 0 0 15 1 0 0 8 1 0 0 55 1 0 0] 193 272 8 '' 240 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 210 1 17 nil 18 #{UI.TextEdit} 50 20 nil 576 50 2 8 1140916224 1025 656 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 656 nil nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 239 0 0 0 254 0 0 0 5 1 0 0] 193 688 nil 656 386 #setMarginWidths: 50 1 8 #(3 3) 656 3 8 #() 546 193 193 nil 45 nil nil 18 #{UI.ReferenceView} 50 14 nil 576 50 2 8 1140916224 132097 976 nil nil nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 2097153 1350 4 #{UI.CommandDescription} #findClass 8 'Find…' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FindClass.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1042 nil true 50 4 1090 1 1122 #browseClassPackage 8 'Package <d>' 1 1 1170 nil true 1202 8 'Package.ico' 1264 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1090 1 1122 #browseClass 8 '&Class' 1 1 1170 nil true 1202 8 'ClassBrowserShell.ico' 1264 65541 nil nil nil 1090 2097153 1122 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 1426 4097 1042 nil true 50 2 1042 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 nil nil nil nil nil 1042 nil true 8 #() 8 '&Show' #viewsShowMenu 134217729 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 976 306 #{Tools.ClassHierarchySelector} #resource_Default_view nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 0 0 0 0 254 0 0 0 231 0 0 0] 193 1008 8 '' 976 386 #contextMenu: 50 1 1056 976 3 528 546 193 193 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 976 8 'classSelector' 656 8 'resourceName' nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 10 0 0 0 8 1 0 0 15 1 0 0] 193 608 8 '' 576 3 50 2 976 656 546 193 193 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 546 21 21 546 21 21 nil nil nil nil 1 nil nil nil 546 421 721 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 338 50 2 386 #createWindow: 50 1 518 #{UI.CreateDialog} 2258 546 7679 21 546 8259 741 193 32 386 #setWindowText: 50 1 8 'Resource Identification' 32 1 50 2 576 240 546 193 193 nil 29)! !

!Tools.ResourceIdentifierDialog class categoriesForMethods!
defaultModel!constants!public! !
genNameLike:uniqueWithin:!helpers!private! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

