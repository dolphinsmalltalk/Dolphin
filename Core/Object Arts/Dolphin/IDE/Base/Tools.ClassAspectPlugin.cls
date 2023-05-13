"Filed out from Dolphin Smalltalk"!

Tools.ClassBrowserPlugin
	subclass: #'Tools.ClassAspectPlugin'
	instanceVariableNames: 'textPresenter originalText currentClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ClassAspectPlugin guid: (Core.GUID fromString: '{310dd22a-ce36-4a0a-ba51-44a6014bd35b}')!
Tools.ClassAspectPlugin isNonInstantiable: true!
Tools.ClassAspectPlugin comment: '`ClassAspectPlugin` is an abstract class of `<classBrowserPlugin>`s that allow editing of a textual aspect of a class in a workspace. '!
!Tools.ClassAspectPlugin categoriesForClass!Browser-Plugins! !
!Tools.ClassAspectPlugin methodsFor!

accept
	"Save the text to the class."

	<commandQuerySelector: #hasClassSelected>
	| overwrite |
	overwrite := self promptToOverwrite.
	overwrite ifFalse: [^self].
	textPresenter isModified: false.
	originalText := textPresenter model
				apply;
				value!

applyOptions
	super applyOptions.
	self refreshIcon!

aspect
	"Answer the symbolic name of the aspect of the textual Class aspect that the receiver
	displays/edits."

	^self subclassResponsibility!

backgroundUpdate
	"Private - The selected class has been changed, but this plugin is not the current card. Clear any
	cached content and perform any background update appropriate for the plugin such as changing
	the card title text or icon)."

	currentClass := nil!

caption
	^self subclassResponsibility!

createComponents
	"Private - Create the presenters contained by the receiver"

	textPresenter := self add: self textPresenterClass new name: 'text'.
!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self model)
		when: #classSelected
			send: #onBrowserClassSelected
			to: self;
		when: #methodSelected
			send: #onBrowserMethodSelected
			to: self.
	self model model 
		when: self systemUpdateEvent
		send: #onClassUpdated:
		to: self.
	textPresenter errorModel: self model statusModel!

currentClassUpdated
	| buffer |
	buffer := textPresenter model.
	buffer notifyChanged.
	^buffer isModified ifFalse: [originalText := buffer value]!

defaultHelpId
	^self subclassResponsibility!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be used as the label for the tab when the receiver is being displayed as a plugin within the Class Browser."

	aPuttableStream nextPutAll: self caption!

foregroundUpdate
	| buffer |
	currentClass := self browser selectedClass.
	buffer := self newAspectBufferOn: currentClass.
	textPresenter
		clearStatus;
		model: buffer;
		evaluationContext: currentClass;
		searchEnvironment: self browser searchEnvironment.
	originalText := buffer value.
	self refreshIcon!

hasClassSelected
	^self browser hasClassSelected!

isModified
	^textPresenter isModified!

modifiedModel
	^textPresenter modifiedModel!

newAspectBufferOn: aClass 
	aClass isNil ifTrue: [^ValueHolder new].
	"Use a ValueBuffer as we don't want the value written back until the user specifically accepts the changes"
	^ValueBuffer subject: (ValueAspectAdaptor subject: aClass aspect: self aspect)!

onBrowserClassSelected
	"Event handler for a class being selected within the receiver's associated browser. "

	self isCurrentCard ifTrue: [self foregroundUpdate] ifFalse: [self backgroundUpdate]!

onBrowserMethodSelected
	"Event handler for a method being selected within the receiver's associated browser. "

	(self isCurrentCard and: [self browser hasMethodSelected]) 
		ifTrue: [self browser ensureSourceVisible]!

onClassUpdated: aClass
	"Private - The Class, aClass, has been updated. If it is the currently displayed class, then update 
	the receiver."

	"Implementation Note: Because Classes do not trigger change events off themselves, but
	rather indirection via the system dictionary, we bridge the gap by monitoring class change
	events, and filtering to just those changes on the current class."

	currentClass
		ifNotNil: [:class | class instanceClass == aClass instanceClass ifTrue: [self currentClassUpdated]]!

onShownInBrowser
	"Private - Event handler indicating that the receiver has been displayed within it's browser."

	currentClass ifNil: [self foregroundUpdate].
	super onShownInBrowser.
	"All the plugins are sharing the same error model, so we need to poke our own state into the
	relevant models when activated."
	textPresenter updateErrorStatus!

promptToOverwrite
	"Private - Answer true if the text has not changed since originally displayed in this plugin,
	or the user wants to overwrite it regardless, otherwise false."

	| currentText |
	currentText := self browser selectedClass perform: self aspect.
	^currentText = originalText or: 
			[MessageBox new
				owner: self view topView;
				headline: 'Overwrite modified <1s>?' << self caption asLowercase;
				confirm: 'The <1s> has been changed outside this browser<n><n>Are you sure you want to overwrite it?'
							<< self caption asLowercase]!

promptToSaveClassChanges: aSelectionChangingEvent 
	"Sent by the browser when its class selection is about to change. This is an opportunity for
	the plugin to prompt to save changes, etc. If the selection should not be changed, then the
	value of the out parameter, aBooleanValue, should be set to false. Also answers whether the
	selection change can continue."

	textPresenter prompt: self caption asLowercase toSaveChanges: aSelectionChangingEvent.
	^aSelectionChangingEvent value!

refreshIcon
	self view arrangement: self!

systemUpdateEvent
	"The symbolic name of the system event to monitor for class changes relevant to this plugin."

	^#classUpdated:!

textPresenterClass
	^SmalltalkSystem current workspaceClass! !
!Tools.ClassAspectPlugin categoriesForMethods!
accept!commands-actions!public! !
applyOptions!options!private! !
aspect!constants!private! !
backgroundUpdate!private!updating! !
caption!constants!private! !
createComponents!initializing!private! !
createSchematicWiring!initializing!public! !
currentClassUpdated!event handling!private! !
defaultHelpId!constants!public! !
displayOn:!displaying!public! !
foregroundUpdate!private!updating! !
hasClassSelected!private!testing! !
isModified!public!testing! !
modifiedModel!accessing!public! !
newAspectBufferOn:!helpers!private! !
onBrowserClassSelected!event handling!private! !
onBrowserMethodSelected!event handling!private! !
onClassUpdated:!event handling!private! !
onShownInBrowser!event handling!private! !
promptToOverwrite!helpers!private! !
promptToSaveClassChanges:!helpers!public! !
refreshIcon!private!updating! !
systemUpdateEvent!constants!private! !
textPresenterClass!initializing!private! !
!

