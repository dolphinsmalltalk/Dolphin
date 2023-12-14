"Filed out from Dolphin Smalltalk"!

Tools.ChooseClassDialog
	subclass: #'Tools.ChooseNamespaceDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ChooseNamespaceDialog guid: (Core.GUID fromString: '{b8b6cccb-897b-4537-a462-2e8aacbdf65b}')!
Tools.ChooseNamespaceDialog comment: ''!
!Tools.ChooseNamespaceDialog categoriesForClass!MVP-Presenters! !
!Tools.ChooseNamespaceDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	self add: BooleanPresenter new name: 'showChanges'!

showChanges
	^(self presenterNamed: 'showChanges') value! !
!Tools.ChooseNamespaceDialog categoriesForMethods!
createComponents!initializing!public! !
showChanges!initializing!public! !
!

!Tools.ChooseNamespaceDialog class methodsFor!

create: viewString on: aValueModel
	^self
		create: viewString
		on: aValueModel
		choices: (ClassHierarchyModel withRoots: (Namespace subclasses copyWithout: SharedPool) sort)!

create: viewString on: aValueModel choices: aClassHierarchyModel
	^(self on: aValueModel)
		classes: aClassHierarchyModel;
		createView: viewString;
		caption: 'Choose Namespace…';
		yourself! !
!Tools.ChooseNamespaceDialog class categoriesForMethods!
create:on:!instance creation!public! !
create:on:choices:!instance creation!public! !
!

