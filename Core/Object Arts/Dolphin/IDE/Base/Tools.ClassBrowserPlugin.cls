"Filed out from Dolphin Smalltalk 7"!

UI.Presenter subclass: #'Tools.ClassBrowserPlugin'
	instanceVariableNames: ''
	classVariableNames: 'DefaultPlugins'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ClassBrowserPlugin guid: (Core.GUID fromString: '{4e71c848-3d94-41f6-8ce9-66d437619a5f}')!
Tools.ClassBrowserPlugin isNonInstantiable: true!
Tools.ClassBrowserPlugin comment: '<ClassBrowserPluginAbstract> is the abstract superclass that implements the basic <classBrowserPlugin> protocol to support plug-in views for class browsers. The plug-ins are appended to the standard set of tabbed cards in the lower half of the browser and can be displayed by selecting the appropriate tab. Each browser class maintains an <OrderedCollection> of plug-ins that will be installed when instances of the browser are created. This collection can be modified through the User Preferences for that browser.

When a plug-in is created it is assigned the class browser to which it is attached as its model. From this, the plug-in can observe events in the browser (such as #classSelected, #methodSelected, #packageSelected etc) and use these to initiate the rendition of its own display. In situations where creating this rendition may be a time consuming process, the plug-in may choose to defer this step until its card is actually made visible in the browser. This can be intercepted by overriding #onShownInBrowser.'!
!Tools.ClassBrowserPlugin categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!Tools.ClassBrowserPlugin methodsFor!

applyOptions!

browser
	^self model!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self model ifNotNil: [:m | m cardsPresenter view when: #currentCardChanged send: #onBrowserCardChanged to: self]
!

destroy
	self isOpen ifTrue: [self model removePlugin: self].
	^super destroy!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be used as the label for the tab when the receiver is being displayed as a plugin within the Class Browser."

	^self subclassResponsibility!

isCurrentCard
	"Answer true if the receiver is the current card shown in the browser"

	^self browser cardsPresenter view currentCard == self view!

isModified
	"Most plugins are read-only views."

	^false!

modifiedModel
	"Most plugins are read-only"

	^false asValue!

onBrowserCardChanged
	"Private - Event handler for a card being selected in the receiver's browser"

	self isCurrentCard ifTrue: [self onShownInBrowser]!

onShownInBrowser
	"Private - Event handler indicating that the receiver has been displayed within it's browser. 
	Overridden by subclasses to perform just-in-time rendering of the receiver's contents."

	self model modifiedModel: self modifiedModel.
	self model statusModel value: nil!

onViewOpened
	super onViewOpened.
	self applyOptions!

promptToSaveClassChanges: aSelectionChangingEvent 
	"Sent by the browser when its class selection is about to change. This is an opportunity for
	the plugin to prompt to save changes, etc. If the selection should not be changed, then the
	value of the out parameter, aBooleanValue, should be set to false. Also answers whether the
	selection change can continue."

	^true! !
!Tools.ClassBrowserPlugin categoriesFor: #applyOptions!options!private! !
!Tools.ClassBrowserPlugin categoriesFor: #browser!accessing!public! !
!Tools.ClassBrowserPlugin categoriesFor: #createSchematicWiring!initializing!private! !
!Tools.ClassBrowserPlugin categoriesFor: #destroy!public!realizing/unrealizing! !
!Tools.ClassBrowserPlugin categoriesFor: #displayOn:!displaying!public! !
!Tools.ClassBrowserPlugin categoriesFor: #isCurrentCard!event handling!public! !
!Tools.ClassBrowserPlugin categoriesFor: #isModified!public!testing! !
!Tools.ClassBrowserPlugin categoriesFor: #modifiedModel!accessing!public! !
!Tools.ClassBrowserPlugin categoriesFor: #onBrowserCardChanged!event handling!private! !
!Tools.ClassBrowserPlugin categoriesFor: #onShownInBrowser!event handling!private! !
!Tools.ClassBrowserPlugin categoriesFor: #onViewOpened!event handling!private! !
!Tools.ClassBrowserPlugin categoriesFor: #promptToSaveClassChanges:!helpers!public! !

Tools.ClassBrowserPlugin methodProtocol: #classBrowserPlugin attributes: #(#readOnly) selectors: #(#browser #isCurrentCard #onShownInBrowser)!

!Tools.ClassBrowserPlugin class methodsFor!

uninitialize
	"Private - Un-register the receiver by removing it from any plugins list.
		self uninitialize
	"

	self unregisterFromAllBrowsers!

uninitializeBeforeRemove
	"Perform any pre-removal uninitialisation for the class. This includes any specific #uninitialize
	implementation (but note that #uninitialize is only sent to classes which directly implement
	#uninitialize, otherwise we'd probably end up damaging superclasses which are not being
	removed).
	Implementation Note: This is one of those cases where we want subclasses to inherit the
	uninitialize, so override to always call it."

	self isAbstract ifFalse: [self uninitialize]!

unregisterFromAllBrowsers
	ClassBrowserAbstract allSubclasses do: [:each | each removePlugin: self].
	self primAllInstances do: [:each | each destroy]! !
!Tools.ClassBrowserPlugin class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!Tools.ClassBrowserPlugin class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!private! !
!Tools.ClassBrowserPlugin class categoriesFor: #unregisterFromAllBrowsers!initializing!private! !

