"Filed out from Dolphin Smalltalk"!

Tools.AbstractPublishedAspectInspector
	subclass: #'Tools.PublishedAspectInspector'
	instanceVariableNames: 'displayPresenter workspacePresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PublishedAspectInspector guid: (Core.GUID fromString: '{9506570e-d634-421f-a07c-d937f05ad6b6}')!
Tools.PublishedAspectInspector comment: 'PublishedAspectInspector is a <compositePresenter> that displays, and allows the modification of, a hierarchy of the published <Aspect>s for its model. 

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
!Tools.PublishedAspectInspector categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!Tools.PublishedAspectInspector methodsFor!

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
			aspectPresenter view
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
!Tools.PublishedAspectInspector categoriesForMethods!
addToCommandRoute:!private! !
createComponents!private! !
createDisplayPresentersFor:on:!private! !
currentCard!private! !
onAspectActioned!event handling!private! !
onAspectSelected!private! !
removeDisplayPresenters!private! !
selectAspect:!private! !
!

!Tools.PublishedAspectInspector class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	SmalltalkSystem current registerTool: self.
	treeUpdateMode := #lazy.
	treeHasGridLines := false!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 #{UI.ProportionalLayout} 138 #{Core.Dictionary} 34 2 1049094 #{Core.Association} 410 #{UI.ListTreeView} 34 59 nil 416 34 2 8 1140953421 1 576 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 13 461638 4 #{UI.Menu} nil true 34 12 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 818 1 850 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 818 1 850 #browseIt 8 '&Browse It' 1 1 898 nil true 930 8 'ClassBrowserShell.ico' 992 65541 nil nil nil 1074 4097 818 1 850 #copyAspect 8 '&Copy' 1 1 nil nil nil 818 1 850 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1074 4097 818 1 850 #editAspect 8 '&Edit' 1 1 nil nil nil 818 1 850 #resetAspect 8 '&Set to <1?Nil:Default>' 1 1 nil nil nil 1074 4097 818 1 850 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 576 nil 8 1815049392 786950 #{Core.Message} #valueText 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 3 1117254 5 #{UI.ListViewColumn} 8 'Published Aspect' 191 #left 1522 #valueNameOnly 8 #() 1522 #<= 8 #() nil nil 576 1522 #typeImage 8 #() 3 1522 #valueNameInfo 1696 nil 1634 8 'Value' 189 #left 1522 #valueTextOnly 1696 1522 #<= 1728 nil nil 576 1522 #valueImage 8 #() 3 nil nil 1634 8 '' 41 #center 1522 #displayString 8 #() 1522 #<= 1936 nil nil 576 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 3 1 1968 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1442886 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 1984 7 257 nil 1 nil nil #report 8 #() nil 131431 918022 #{Graphics.Point} 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 #{UI.VirtualTreeModel} nil 720 138 144 688 nil nil 1970 0 nil 1377574 #{Kernel.CompiledMethod} 2 3 2160 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2176 1970 0 nil 2226 1 83886083 2160 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2272 7 257 nil nil 138 #{Core.PluggableSet} 688 138 #{Core.IdentitySet} 688 13 1 nil nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 2130 1 1 2130 427 341 576 2402 #contextMenu: 34 1 784 576 2402 #text: 34 1 8 'Published Aspect' 576 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 213 0 0 0 170 0 0 0] 8 #() 2130 193 193 nil 2029 5 546 410 #{UI.Splitter} 34 12 nil 416 34 2 8 1140850688 1 2656 nil nil nil 517 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 2656 nil 1 #left nil nil nil 2130 1 1 2130 9 9 nil 2752 nil 2354 34 1 2402 #createAt:extent: 34 2 2130 427 1 2130 11 341 2656 2562 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 213 0 0 0 0 0 0 0 218 0 0 0 170 0 0 0] 8 #() 2624 nil 27 1 false 170 192 34 4 576 8 'aspects' 410 #{UI.CardContainer} 34 16 nil 416 34 2 8 1140850688 131073 2976 nil nil nil 5 nil nil nil 2976 853318 1 #{UI.CardLayout} 138 144 688 nil nil nil nil 170 192 688 nil 410 #{UI.TabViewXP} 34 28 nil 2976 34 2 8 1140916866 1 3104 642 138 144 688 nil 720 nil nil 1 nil nil nil 3104 nil 8 1814862704 1970 0 nil 2002 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 3216 7 257 nil 1522 #iconImageIndex 8 #() 1584 nil nil nil nil nil #smallIcons nil nil nil nil nil 2354 34 2 2402 #createAt:extent: 34 2 2130 1 1 2130 215 341 3104 2402 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3104 2562 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 107 0 0 0 170 0 0 0] 8 #() 2624 nil 27 2354 34 1 2402 #createAt:extent: 34 2 2130 437 1 2130 215 341 2976 2562 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 218 0 0 0 0 0 0 0 69 1 0 0 170 0 0 0] 34 1 3104 2624 nil 27 8 'display' nil 2354 34 1 2402 #createAt:extent: 34 2 2130 12287 21 2130 651 341 416 2562 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 68 25 0 0 180 0 0 0] 34 3 576 2656 2976 2624 nil 27)! !
!Tools.PublishedAspectInspector class categoriesForMethods!
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

