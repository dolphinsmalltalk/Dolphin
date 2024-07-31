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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 2 518 #{Core.Association} 18 #{UI.ListTreeView} 50 59 nil 32 50 2 8 1140953421 1 224 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 13 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 466 1 498 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 466 1 498 #browseIt 8 '&Browse It' 1 1 546 nil true 578 8 'ClassBrowserShell.ico' 640 65541 nil nil nil 722 4097 466 1 498 #copyAspect 8 '&Copy' 1 1 nil nil nil 466 1 498 #pasteAspect 8 '&Paste <d>' 1 17 nil nil nil 722 4097 466 1 498 #editAspect 8 '&Edit' 1 1 nil nil nil 466 1 498 #resetAspect 8 '&Set to <1?Nil:Default>' 1 17 nil nil nil 722 4097 466 1 498 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 224 nil nil 518 #{Core.Message} #valueText 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 322 3 3142 5 #{UI.ListViewColumn} 8 'Published Aspect' 191 #left 1154 #valueNameOnly 8 #() 1154 #<= 8 #() nil nil 224 1154 #typeImage 8 #() 3 1154 #valueNameInfo 1312 nil 1250 8 'Value' 189 #left 1154 #valueTextOnly 1312 1154 #<= 1344 nil nil 224 1154 #valueImage 8 #() 3 nil nil 1250 8 '' 41 #center 1154 #displayString 8 #() 1154 #<= 1552 nil nil 224 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 1584 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 1600 7 257 nil 1 nil nil #report 8 #() nil 131431 518 #{Graphics.Point} 129 129 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 224 nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 368 322 0 nil nil 1586 0 nil 1318 #{Kernel.CompiledMethod} 2 3 1808 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 1824 1586 0 nil 1874 1 83886083 1808 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 1920 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 13 1 nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 213 0 0 0 170 0 0 0] 193 256 8 'Published Aspect' 224 2082 #contextMenu: 50 1 432 224 3 8 #() 1746 193 193 nil 2029 5 194 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 2304 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2304 nil 1 #left nil nil nil 1746 1 1 1746 9 9 nil 2400 nil 2034 50 1 2082 #createWindow: 50 1 2130 2162 8 #[213 0 0 0 0 0 0 0 218 0 0 0 170 0 0 0] 193 2336 8 '' 2304 3 8 #() 1746 193 193 nil 27 1 false 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 224 8 'aspects' 18 #{UI.CardContainer} 50 16 nil 32 50 2 8 1140850688 131073 2656 nil nil nil 5 nil nil nil 2656 1350 1 #{UI.CardLayout} 322 0 nil nil nil nil 550 #{Core.IdentityDictionary} 0 nil 18 #{UI.TabViewXP} 50 28 nil 2656 50 2 8 1140916866 1 2800 290 322 0 nil 368 nil nil 1 nil nil nil 2800 nil nil 1586 0 nil 1618 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 2896 7 257 nil 1154 #iconImageIndex 8 #() 1216 nil nil nil nil nil #smallIcons nil nil nil nil nil 2034 50 2 2082 #createWindow: 50 1 2130 2162 8 #[0 0 0 0 0 0 0 0 107 0 0 0 170 0 0 0] 193 2832 8 '' 2800 2082 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 2800 3 8 #() 1746 193 193 nil 27 2034 50 1 2082 #createWindow: 50 1 2130 2162 8 #[218 0 0 0 0 0 0 0 69 1 0 0 170 0 0 0] 193 2688 8 '' 2656 3 50 1 2800 1746 193 193 nil 27 8 'display' nil 2034 50 1 2082 #createWindow: 50 1 2130 2162 8 #[255 14 0 0 10 0 0 0 68 16 0 0 180 0 0 0] 193 80 8 '' 32 1 50 3 224 2304 2656 1746 193 193 nil 27)! !

!Tools.PublishedAspectInspector class categoriesForMethods!
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

