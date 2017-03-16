"Filed out from Dolphin Smalltalk 7"!

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
!ResourceIdentifierDialog categoriesForClass!Development!MVP-Presenters! !
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
!ResourceIdentifierDialog categoriesFor: #canApply!private!testing! !
!ResourceIdentifierDialog categoriesFor: #classesPresenterClass!constants!private! !
!ResourceIdentifierDialog categoriesFor: #createClassesPresenter!initializing!private! !
!ResourceIdentifierDialog categoriesFor: #createComponents!initializing!public! !
!ResourceIdentifierDialog categoriesFor: #model:!accessing!public! !
!ResourceIdentifierDialog categoriesFor: #onClassSelected!event handling!private! !
!ResourceIdentifierDialog categoriesFor: #onViewOpened!event handling!public! !
!ResourceIdentifierDialog categoriesFor: #queryCommand:!commands!private! !

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 560 0 0 0 7 0 0 0 560 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  21 553 834 525 81 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 1 0 0 16 1 0 0 60 1 0 0] 98 0 834 193 193 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 960 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 960 530 1 17 0 410 8 ##(Smalltalk.TextEdit)  98 16 0 960 98 2 8 1140916224 1025 1088 0 482 512 0 7 0 0 0 1088 0 8 4294903807 852486 ##(Smalltalk.NullConverter)  0 0 1 706 202 208 98 3 770 800 98 2 834 1 493 834 525 41 1088 770 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1088 770 8 #isTextModified: 98 1 32 1088 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 246 0 0 0 6 1 0 0 10 1 0 0] 98 0 944 0 27 0 0 410 576 98 14 0 960 98 2 8 1140916224 132097 1520 0 0 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  2097153 1180998 4 ##(Smalltalk.CommandDescription)  8 #findClass 8 'Find...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FindClass.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 1586 0 16 98 4 1634 1 1666 8 #browseClassPackage 8 'Package <1d>' 1 1 1730 0 16 1776 8 'Package.ico' 1824 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 1634 1 1666 8 #browseClass 8 '&Class' 1 1 1730 0 16 1776 8 'ClassBrowserShell.ico' 1824 0 0 1634 2097153 1666 8 #browseClassReferences 8 'Class &References' 1 1 0 0 0 8 '&Browse' 8 #browse 134217729 0 0 0 0 0 1986 4097 1586 0 16 98 2 1586 0 16 98 0 8 '&Edit' 8 #viewsEditMenu 134217729 0 0 0 0 0 1586 0 16 98 0 8 '&Show' 8 #viewsShowMenu 134217729 0 0 0 0 0 8 '&Views' 8 #viewsMenu 134217729 0 0 0 0 0 8 '&Class' 0 134217729 0 0 0 0 0 0 0 1520 642 8 ##(Smalltalk.ClassHierarchySelector)  8 #resource_Default_view 0 706 202 208 98 2 770 800 98 2 834 1 1 834 525 477 1520 770 8 #contextMenu: 98 1 1600 1520 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 6 1 0 0 238 0 0 0] 928 944 0 27 234 256 98 4 1520 8 'classSelector' 1088 8 'resourceName' 0 706 202 208 98 1 770 800 98 2 834 21 21 834 525 533 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 16 1 0 0 20 1 0 0] 98 2 1520 1088 944 0 27 234 256 928 590342 ##(Smalltalk.Rectangle)  834 21 21 834 21 21 0 0 0 0 40209 0 0 0 834 421 721 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 706 202 208 98 3 770 800 98 2 834 2799 21 834 581 721 416 770 8 #text: 98 1 8 'Resource Identification' 416 770 8 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 153 6 0 0 114 1 0 0] 98 2 960 560 944 0 27 )! !
!ResourceIdentifierDialog class categoriesFor: #defaultModel!constants!public! !
!ResourceIdentifierDialog class categoriesFor: #genNameLike:uniqueWithin:!helpers!private! !
!ResourceIdentifierDialog class categoriesFor: #icon!constants!public! !
!ResourceIdentifierDialog class categoriesFor: #resource_Default_view!public!resources-views! !

