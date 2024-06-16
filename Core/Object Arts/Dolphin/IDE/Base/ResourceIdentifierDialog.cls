"Filed out from Dolphin Smalltalk"!

Dialog subclass: #ResourceIdentifierDialog
	instanceVariableNames: 'classesPresenter resourceNamePresenter classValue'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ResourceIdentifierDialog guid: (GUID fromString: '{87b4c6a4-026e-11d3-9fd7-00a0cc3e4a32}')!

ResourceIdentifierDialog comment: 'ResourceIdentifierDialog is a <dialogPresenter> used to edit the contents of an <ResourceIdentifier> model.

Instance Variables:
	classTreePresenter		<TreePresenter> displaying a hierarchy of presenter classes.
	resourceNamePresenter	<TextPresenter> for the #name aspect.
	classValue		<ValueAspectAdaptor> for the #owningClass aspect.

'!

!ResourceIdentifierDialog categoriesForClass!MVP-Presenters!MVP-Resources-Dialogs! !

!ResourceIdentifierDialog methodsFor!

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

!ResourceIdentifierDialog categoriesForMethods!
canApply!private!testing! !
classesPresenterClass!constants!private! !
createClassesPresenter!initializing!private! !
createComponents!initializing!public! !
model:!accessing!public! !
onClassSelected!event handling!private! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
!

!ResourceIdentifierDialog class methodsFor!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[10 0 0 0 15 1 0 0 8 1 0 0 55 1 0 0] 193 640 8 '' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 578 1 17 nil 410 ##(Smalltalk.TextEdit) 34 16 nil 960 34 2 8 1140916224 1025 1040 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1040 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 1 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 239 0 0 0 254 0 0 0 5 1 0 0] 193 1072 nil 1040 770 #setMarginWidths: 34 1 8 #(3 3) 1040 3 8 #() 930 193 193 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 960 34 2 8 1140916224 132097 1392 nil nil nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1180998 4 ##(Smalltalk.CommandDescription) #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1458 nil true 34 4 1506 1 1538 #browseClassPackage 8 'Package <1d>' 1 1 1586 nil true 1632 8 'Package.ico' 1680 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1506 1 1538 #browseClass 8 '&Class' 1 1 1586 nil true 1632 8 'ClassBrowserShell.ico' 1680 nil nil 1506 2097153 1538 #browseClassReferences 8 'Class &References' 1 1 nil nil nil 8 '&Browse' #browse 134217729 nil nil nil nil nil 1826 4097 1458 nil true 34 2 1458 nil true 8 #() 8 '&Edit' #viewsEditMenu 134217729 nil nil nil nil nil 1458 nil true 8 #() 8 '&Show' #viewsShowMenu 134217729 nil nil nil nil nil 8 '&Views' #viewsMenu 134217729 nil nil nil nil nil 8 '&Class' nil 134217729 nil nil nil nil nil nil nil 1392 674 ##(Smalltalk.ClassHierarchySelector) #resource_Default_view nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 254 0 0 0 231 0 0 0] 193 1424 8 '' 1392 770 #contextMenu: 34 1 1472 1392 3 912 930 193 193 nil 27 170 192 34 4 1040 8 'resourceName' 1392 8 'classSelector' nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 10 0 0 0 8 1 0 0 15 1 0 0] 193 992 8 '' 960 3 34 2 1392 1040 930 193 193 nil 27 170 192 912 590342 ##(Smalltalk.Rectangle) 930 21 21 930 21 21 nil nil nil nil 12705 nil nil nil 930 421 721 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 2642 930 1 1 930 581 721 193 416 770 #setWindowText: 34 1 8 'Resource Identification' 416 1 34 2 960 608 930 193 193 nil 29 )! !

!ResourceIdentifierDialog class categoriesForMethods!
defaultModel!constants!public! !
genNameLike:uniqueWithin:!helpers!private! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

