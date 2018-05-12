"Filed out from Dolphin Smalltalk 7"!

AbstractPublishedAspectInspector subclass: #PublishedAspectInspector
	instanceVariableNames: 'displayPresenter workspacePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PublishedAspectInspector guid: (GUID fromString: '{9506570e-d634-421f-a07c-d937f05ad6b6}')!
PublishedAspectInspector comment: 'PublishedAspectInspector is a <compositePresenter> that displays, and allows the modification of, a hierarchy of the published <Aspect>s for its model. 

In order that the PublishedAspectInspector can display the aspects of a particular object, they must first be published by the object''s class. This is generally done by implementing the class side method, #publishedAspectsOfInstances, to add each of the <Aspect>s that need to be published to a <Set>. In certain specialised cases it may also be necessary to override the instance side method, #publishedAspects, in order to adjust this set by adding or removing aspects that are not discernible on the class side alone. If no aspects are explicitly published by the above means then any
public instance variable accessor methods are published by default (see Object>>publicAccessorAspect).

Typically, a PublishedAspectInspector is used as one of the renditions in the FlipperInspector and the main attribute editor in the View Composer. However, you''ll find it used in other places in the development image, such as for editing "Pool Dictionaries" and "Dolphin Options" within the main system folder.

Example (to browse the system options):
PublishedAspectInspector showOn: SmalltalkSystem registeredTools asOrderedCollection.

Instance Variables:
	aspectTreePresenter	<TreePresenter> holding the aspect hierarchy.
	aspectValueModel    <valueModel> holding the current value for the selected aspect.
	displayPresenter	<compositePresenter> where the selected aspect value will be presented.
	aspectPresenter	<presenter> used to display the selected aspect in its recommended format.
	workspacePresenter	<presenter> used to display the selected aspect in a <ValueWorkspace>
'!
!PublishedAspectInspector categoriesForClass!Development!MVP-Presenters!MVP-Resources-IDE Tools! !
!PublishedAspectInspector methodsFor!

addToCommandRoute: route 
	"Private - Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer self to have the command policy decide where
	to go next."

	super addToCommandRoute: route.
	aspectPresenter notNil ifTrue: [self currentCard ifNotNil: [:card | route appendPresenter: card]]!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	displayPresenter := self add: Presenter new name: 'display'!

createDisplayPresentersFor: anAspectAccessor on: valueHolder 
	"Private - Create the Workspace and Value presenters for the currently selected aspect"

	aspectPresenter := anAspectAccessor aspectDescriptor presenterFor: valueHolder in: displayPresenter.
	(aspectPresenter isKindOf: ValueWorkspace) 
		ifTrue: 
			["This is a workspace anyway so no need to create another"
			aspectPresenter view arrangement: aspectPresenter]
		ifFalse: 
			["Add a separate workspace onto the same model"
			aspectPresenter isReadOnly: anAspectAccessor canSet not.
			workspacePresenter := ValueWorkspace createIn: displayPresenter on: valueHolder.
			workspacePresenter view arrangement: workspacePresenter.
			(aspectPresenter view)
				arrangement: aspectPresenter;
				zOrderTop].
	aspectPresenter ensureVisible!

currentCard
	"Private - Answers the aspect presenter card that is current visible"

	^displayPresenter view currentCard ifNotNil: [:card | card presenter]!

onAspectActioned
	"Event handler for an action being performed on the current aspect, i.e. Enter or double-click"

	self editAspect!

onAspectSelected
	"Private - An aspect accessor has been selected within the aspect tree. Transfer the new aspect value
	to our local aspectValueHolder buffer and then create the appropriate aspect presenters."

	self aspectAccessor 
		ifNil: 
			[self removeDisplayPresenters.
			"Replacing the entire value model avoids any chance of any old observers seeing future change events"
			aspectValueHolder := nil.
			displayPresenter view invalidate]
		ifNotNil: [:accessor | accessor selectIn: self]!

removeDisplayPresenters
	"Private - Remove any existing display presenters. Note that the act of removing an
	aspectPresenter may cause modified data to be flushed back to the aspect. This in turn may
	cause the aspect to be reselected in the aspectTreePresenter (depending on the nature of the
	aspect being flushed. To avoid receiving a recursive change notification we protect the
	removal code within a #noEventsDo: block"

	displayPresenter view noRedrawDo: 
			[aspectTreePresenter noEventsDo: 
					[displayPresenter subPresenters shallowCopy do: [:each | displayPresenter remove: each].
					aspectPresenter := workspacePresenter := nil]]!

selectAspect: anAspectAccessor 
	"Select anAspectAccessor ingto the receiver. This involves creating new aspect presenters inside our displayPresenter"

	self removeDisplayPresenters.

	"Replacing the entire value model avoids any chance of any old observers seeing future change events"
	(self createValueHolderFor: anAspectAccessor) 
		ifTrue: 
			[displayPresenter view noRedrawDo: 
					[[self createDisplayPresentersFor: anAspectAccessor on: aspectValueHolder] on: Error
						do: 
							[:ex | 
							Notification 
								signal: ('Error inspecting <1s>: <2p>' expandMacrosWith: aspectValueHolder value basicPrintString
										with: ex description)]]].
	displayPresenter view invalidate! !
!PublishedAspectInspector categoriesFor: #addToCommandRoute:!private! !
!PublishedAspectInspector categoriesFor: #createComponents!private! !
!PublishedAspectInspector categoriesFor: #createDisplayPresentersFor:on:!private! !
!PublishedAspectInspector categoriesFor: #currentCard!private! !
!PublishedAspectInspector categoriesFor: #onAspectActioned!event handling!private! !
!PublishedAspectInspector categoriesFor: #onAspectSelected!private! !
!PublishedAspectInspector categoriesFor: #removeDisplayPresenters!private! !
!PublishedAspectInspector categoriesFor: #selectAspect:!private! !

!PublishedAspectInspector class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	Smalltalk developmentSystem registerTool: self.
	treeUpdateMode := #lazy.
	treeHasGridLines := false!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 0 0 34 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 2 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.ListTreeView) 34 44 0 416 34 2 8 1140953421 1 624 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 482 8 4278190080 0 13 265030 4 ##(Smalltalk.Menu) 0 true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 866 1 898 #inspectReferences 8 'Inspect &References' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 866 1 898 #browseIt 8 '&Browse It' 1 1 946 0 true 992 8 'ClassBrowserShell.ico' 1040 0 0 1122 4097 866 1 898 #copyAspect 8 '&Copy' 1 1 0 0 0 866 1 898 #pasteAspect 8 '&Paste <1d>' 1 1 0 0 0 1122 4097 866 1 898 #editAspect 8 '&Edit' 1 1 0 0 0 866 1 898 #nilAspect 8 'Set to &Nil' 1 1 0 0 0 1122 4097 866 1 898 #refresh 8 'Re&fresh' 1 1 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 624 0 8 4294904511 459270 ##(Smalltalk.Message) #valueText 8 #() 0 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 0 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Published Aspect' 191 #left 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 1712 8 'doIt' 8 '[:x | x  valueNameOnly]' 8 #[30 105 226 0 106] #valueNameOnly 1728 7 257 0 1554 #<= 8 #() 0 0 624 0 3 1714 0 0 1746 2 1 1712 8 'doIt' 8 '[:x | x valueNameInfo]' 8 #[30 105 226 0 106] #valueNameInfo 1856 7 257 0 0 1666 8 'Value' 189 #left 1714 0 0 1746 2 1 1712 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 1968 7 257 0 1554 #<= 1840 0 0 624 1714 0 0 1746 2 1 1712 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 2064 7 257 0 3 0 0 1666 8 '' 41 #center 1554 #displayString 8 #() 1554 #<= 2192 0 0 624 1714 0 0 1746 3 1 1712 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 2224 7 257 0 1 0 0 #report 736 0 133479 328198 ##(Smalltalk.Point) 129 129 34 4 0 0 2306 1 1 0 false 1050438 3 ##(Smalltalk.VirtualTreeModel) 0 768 138 144 736 0 0 1714 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 2368 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2384 1714 0 0 2434 1 83886083 2368 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2480 7 257 0 0 138 ##(Smalltalk.PluggableSet) 736 138 ##(Smalltalk.PluggableSet) 736 13 5 0 0 0 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 2306 1 1 2306 427 341 624 2626 #contextMenu: 34 1 832 624 2626 #text: 34 1 8 'Published Aspect' 624 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 213 0 0 0 170 0 0 0] 8 #() 2306 193 193 0 2021 5 594 410 ##(Smalltalk.Splitter) 34 12 0 416 34 2 8 1140850688 1 2880 0 482 512 0 517 0 0 0 2880 2562 138 144 34 1 2626 #createAt:extent: 34 2 2306 427 1 2306 11 341 2880 2786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 213 0 0 0 0 0 0 0 218 0 0 0 170 0 0 0] 8 #() 2848 0 27 1 false 170 192 34 4 624 8 'aspects' 410 ##(Smalltalk.CardContainer) 34 16 0 416 34 2 8 1140850688 131073 3168 0 721158 ##(Smalltalk.SystemColor) 31 0 5 0 0 0 3168 655878 ##(Smalltalk.CardLayout) 138 144 736 0 170 192 736 0 410 ##(Smalltalk.TabViewXP) 34 28 0 3168 34 2 8 1140916866 1 3328 690 138 144 736 0 768 0 0 1 0 0 0 3328 0 8 4294902673 1714 0 0 1746 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 3440 7 257 0 ##(Smalltalk.IconicListAbstract) 1616 0 0 0 0 0 #smallIcons 0 0 0 0 0 2562 138 144 34 2 2626 #createAt:extent: 34 2 2306 1 1 2306 215 341 3328 2626 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3328 2786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 107 0 0 0 170 0 0 0] 8 #() 2848 0 27 2562 138 144 34 1 2626 #createAt:extent: 34 2 2306 437 1 2306 215 341 3168 2786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 218 0 0 0 0 0 0 0 69 1 0 0 170 0 0 0] 34 1 3328 2848 0 27 8 'display' 0 2562 138 144 34 1 2626 #createAt:extent: 34 2 2306 2731 21 2306 651 341 416 2786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 5 0 0 10 0 0 0 92 6 0 0 180 0 0 0] 34 3 624 2880 3168 2848 0 27 )! !
!PublishedAspectInspector class categoriesFor: #initialize!initializing!private! !
!PublishedAspectInspector class categoriesFor: #resource_Default_view!public!resources-views! !

