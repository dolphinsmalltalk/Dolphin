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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 2 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 576 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 576 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 674 9 9 nil 688 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 427 1 674 11 341 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 213 0 0 0 0 0 0 0 218 0 0 0 170 0 0 0] 8 #() 674 193 193 nil 27 1 546 410 ##(Smalltalk.ListTreeView) 34 44 nil 416 34 2 8 1140953421 1 960 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 13 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1218 1 1250 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1218 1 1250 #browseIt 8 '&Browse It' 1 1 1298 nil true 1344 8 'ClassBrowserShell.ico' 1392 nil nil 1474 4097 1218 1 1250 #copyAspect 8 '&Copy' 1 1 nil nil nil 1218 1 1250 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1474 4097 1218 1 1250 #editAspect 8 '&Edit' 1 1 nil nil nil 1218 1 1250 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1474 4097 1218 1 1250 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 960 nil 8 1912800272 459270 ##(Smalltalk.Message) #valueText 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Published Aspect' 191 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 2064 8 'doIt' 8 '[:x | x  valueNameOnly]' 8 #[30 105 226 0 106] #valueNameOnly 2080 7 257 nil 1906 #<= 8 #() nil nil 960 nil 3 2066 0 nil 2098 2 1 2064 8 'doIt' 8 '[:x | x valueNameInfo]' 8 #[30 105 226 0 106] #valueNameInfo 2208 7 257 nil nil 2018 8 'Value' 189 #left 2066 0 nil 2098 2 1 2064 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 2320 7 257 nil 1906 #<= 2192 nil nil 960 2066 0 nil 2098 2 1 2064 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 2416 7 257 nil 3 nil nil 2018 8 '' 41 #center 1906 #displayString 8 #() 1906 #<= 2544 nil nil 960 2066 0 nil 2098 3 1 2064 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 2576 7 257 nil 1 nil nil #report 1072 nil 133479 674 129 129 34 4 nil nil 674 1 1 nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1104 138 144 1072 nil nil 2066 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2704 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2720 2066 0 nil 2770 1 83886083 2704 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2816 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 1072 138 ##(Smalltalk.PluggableSet) 1072 13 5 nil nil nil nil nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 674 1 1 674 427 341 960 786 #contextMenu: 34 1 1184 960 786 #text: 34 1 8 'Published Aspect' 960 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 213 0 0 0 170 0 0 0] 8 #() 928 nil 2021 5 false 170 192 34 4 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1140850688 131073 3168 nil nil nil 5 nil nil nil 3168 655878 ##(Smalltalk.CardLayout) 138 144 1072 nil 170 192 1072 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3168 34 2 8 1140916866 1 3296 1026 138 144 1072 nil 1104 nil nil 1 nil nil nil 3296 nil 8 1912616880 2066 0 nil 2098 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 3408 7 257 nil ##(Smalltalk.IconicListAbstract) 1968 nil nil nil nil nil #smallIcons nil nil nil nil nil 722 138 144 34 2 786 #createAt:extent: 34 2 674 1 1 674 215 341 3296 786 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3296 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 107 0 0 0 170 0 0 0] 8 #() 928 nil 27 722 138 144 34 1 786 #createAt:extent: 34 2 674 437 1 674 215 341 3168 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 218 0 0 0 0 0 0 0 69 1 0 0 170 0 0 0] 34 1 3296 928 nil 27 8 'display' 960 8 'aspects' nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 3839 21 674 651 341 416 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 196 8 0 0 180 0 0 0] 34 3 960 576 3168 928 nil 27 )! !
!PublishedAspectInspector class categoriesFor: #initialize!initializing!private! !
!PublishedAspectInspector class categoriesFor: #resource_Default_view!public!resources-views! !

