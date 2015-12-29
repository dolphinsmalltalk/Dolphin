"Filed out from Dolphin Smalltalk X6.2"!

AbstractPublishedAspectInspector subclass: #PublishedAspectInspector
	instanceVariableNames: 'displayPresenter workspacePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PublishedAspectInspector guid: (GUID fromString: '{9506570E-D634-421F-A07C-D937F05AD6B6}')!
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

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  202 8 ##(Smalltalk.Dictionary)  98 2 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.ListTreeView)  98 44 0 416 98 2 8 1140953421 1 656 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 8 4278190080 0 13 265030 4 ##(Smalltalk.Menu)  0 16 98 12 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 914 1 946 8 #inspectReferences 8 'Inspect &References' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 914 1 946 8 #browseIt 8 '&Browse It' 1 1 1010 0 16 1056 8 'ClassBrowserShell.ico' 1104 0 0 1202 4097 914 1 946 8 #copyAspect 8 '&Copy' 1 1 0 0 0 914 1 946 8 #pasteAspect 8 '&Paste <1d>' 1 1 0 0 0 1202 4097 914 1 946 8 #editAspect 8 '&Edit' 1 1 0 0 0 914 1 946 8 #nilAspect 8 'Set to &Nil' 1 1 0 0 0 1202 4097 914 1 946 8 #refresh 8 'Re&fresh' 1 1 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 656 0 8 4294907285 459270 ##(Smalltalk.Message)  8 #valueText 98 0 0 1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 3 920646 5 ##(Smalltalk.ListViewColumn)  8 'Published Aspect' 191 8 #left 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 1920 8 'doIt' 8 '[:x | x  valueNameOnly]' 8 #[30 105 226 0 106] 8 #valueNameOnly 1936 7 257 0 1730 8 #<= 98 0 0 0 656 0 3 1922 0 0 1954 2 1 1920 8 'doIt' 8 '[:x | x valueNameInfo]' 8 #[30 105 226 0 106] 8 #valueNameInfo 2096 7 257 0 0 1858 8 'Value' 189 1904 1922 0 0 1954 2 1 1920 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] 8 #valueTextOnly 2224 7 257 0 1730 2064 2080 0 0 656 1922 0 0 1954 2 1 1920 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] 8 #valueImage 2336 7 257 0 3 0 0 1858 8 '' 41 8 #center 1730 8 #displayString 98 0 1730 2064 2512 0 0 656 1922 0 0 1954 3 1 1920 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] 8 ##(Smalltalk.PropertyInspector)  8 #editButtonImageIndexFor: 2544 7 257 0 1 0 0 8 #report 784 0 2407 328198 ##(Smalltalk.Point)  129 129 0 32 1050438 3 ##(Smalltalk.VirtualTreeModel)  0 816 202 208 784 0 0 1922 0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 2704 8 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] 8 #childrenOf: 8 #notEmpty 17 257 2720 1922 0 0 2770 1 83886083 2704 8 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2864 7 257 0 0 202 8 ##(Smalltalk.PluggableSet)  784 202 2944 784 13 5 0 0 0 0 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 2674 1 1 2674 427 341 656 3042 8 #contextMenu: 98 1 880 656 3042 8 #text: 98 1 8 'Published Aspect' 656 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 213 0 0 0 170 0 0 0] 98 0 2674 193 193 0 2021 5 626 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 3344 0 498 528 0 517 0 0 0 3344 2978 202 208 98 1 3042 3072 98 2 2674 427 1 2674 11 341 3344 3250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 213 0 0 0 0 0 0 0 218 0 0 0 170 0 0 0] 98 0 3312 0 27 1 32 234 256 98 4 656 8 'aspects' 410 8 ##(Smalltalk.CardContainer)  98 16 0 416 98 2 8 1140850688 131073 3648 0 721158 ##(Smalltalk.SystemColor)  31 0 5 0 0 0 3648 655878 ##(Smalltalk.CardLayout)  202 208 784 0 234 256 784 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 3648 98 2 8 1140916866 1 3824 738 202 208 784 0 816 0 0 1 0 0 0 3824 0 8 4294903839 1922 0 0 1954 1 83886081 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 3952 7 257 0 8 ##(Smalltalk.IconicListAbstract)  1808 0 0 0 0 0 8 #smallIcons 0 0 0 0 0 2978 202 208 98 2 3042 3072 98 2 2674 1 1 2674 215 341 3824 3042 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 3824 3250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 107 0 0 0 170 0 0 0] 98 0 3312 0 27 2978 202 208 98 1 3042 3072 98 2 2674 437 1 2674 215 341 3648 3250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 218 0 0 0 0 0 0 0 69 1 0 0 170 0 0 0] 98 1 3824 3312 0 27 8 'display' 0 2978 202 208 98 1 3042 3072 98 2 2674 3359 21 2674 651 341 416 3250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 212 7 0 0 180 0 0 0] 98 3 656 3344 3648 3312 0 27 )! !
!PublishedAspectInspector class categoriesFor: #resource_Default_view!public!resources-views! !

