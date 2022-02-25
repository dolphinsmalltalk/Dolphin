"Filed out from Dolphin Smalltalk"!

Tools.ChooseClassDialog subclass: #'Tools.ChooseNamespaceDialog'
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
	^(self on: aValueModel)
		classes: (ClassHierarchyModel withRoots: (Namespace subclasses copyWithout: SharedPool) sort);
		createView: viewString;
		caption: 'Choose Namespace…';
		yourself!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 610 1 1 nil nil 410 #{UI.ReferenceView} 34 14 nil 640 34 2 8 1140850688 131073 720 nil nil nil 7 nil nil nil 720 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 349 11 578 341 71 720 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 5 0 0 0 88 1 0 0 40 0 0 0] 8 #() 578 193 193 nil 27 410 #{UI.ContainerView} 34 15 nil 640 34 2 8 1409286144 131073 1024 nil nil nil 7 nil nil nil 1024 852806 1 #{UI.FlowLayout} 17 17 9 170 192 34 2 410 #{UI.CheckBox} 34 16 nil 1024 34 2 8 1409363203 1 1152 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 1152 nil 8 1793732736 1049094 #{UI.NullConverter} nil nil nil 818 34 2 866 #createAt:extent: 34 2 578 1 17 578 685 43 1152 866 #text: 34 1 8 'Show refactoring changes?' 1152 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 8 0 0 0 86 1 0 0 29 0 0 0] 8 #() 1008 nil 27 8 'showChanges' 1180166 #{Graphics.Rectangle} 578 1 17 578 1 1 818 34 1 866 #createAt:extent: 34 2 578 5 11 578 331 71 1024 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 5 0 0 0 167 0 0 0 40 0 0 0] 34 1 1152 1008 nil 27 nil 170 192 992 1538 578 5 11 578 1 1 818 34 1 866 #createAt:extent: 34 2 578 21 623 578 689 81 640 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 55 1 0 0 98 1 0 0 95 1 0 0] 34 2 1024 720 1008 nil 27 nil nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 132097 1952 nil nil nil 7 nil nil nil 1952 786 #{Tools.ClassHierarchySelector} #resource_Default_view nil 818 34 1 866 #createAt:extent: 34 2 578 21 21 578 689 603 1952 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 55 1 0 0] 992 1008 nil 27 170 192 34 2 1952 8 'classSelector' 1538 578 21 21 578 21 21 nil nil nil nil 15471 nil nil nil 578 661 521 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 1995472976 818 34 2 866 #createAt:extent: 34 2 578 12287 21 578 761 801 416 866 #text: 34 1 8 'Choose Target Namespace…' 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 123 25 0 0 154 1 0 0] 34 2 1952 640 1008 nil 27)! !
!Tools.ChooseNamespaceDialog class categoriesForMethods!
create:on:!instance creation!public! !
resource_Refactoring_view!public!resources-views! !
!

