"Filed out from Dolphin Smalltalk 2000 release 4.01"!

BrowserApplicationModel subclass: #CodeModel
	instanceVariableNames: 'navigator tool lockPolicy state selectionPolicies selectionPolicy timeStamp'
	classVariableNames: 'DefaultSelectionPolicies'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CodeModel comment: ''!

CodeModel guid: (GUID fromString: '{A8B6C1BA-0E73-11D5-B80B-000102677BBF}')!

!CodeModel categoriesForClass!Unclassified! !
!CodeModel methodsFor!

application
	^self state application!

applications
	^self state applications!

buildInterfaceIn: aWidget 
	| widget strings values |
	values := self selectionPolicies.
	strings := values collect: [:each | each name].
	self
		addWidget: (aWidget createLabel: 'Default:'
				argBlock: 
					[:w | 
					w labelString: 'Default: ' , Application default name;
						borderWidth: 1;
						alignment: XmALIGNMENTBEGINNING;
						leftAttachment: XmATTACHFORM;
						leftOffset: 2;
						topAttachment: XmATTACHFORM;
						topOffset: 2;
						rightAttachment: XmATTACHPOSITION;
						rightPosition: 25])
					manageChild
		named: #defaultApplication.
	self addWidget: (aWidget createComboBox: 'type'
				argBlock: 
					[:w | 
					w comboBoxType: XmDROPDOWN;
						items: strings;
						leftAttachment: XmATTACHPOSITION;
						leftPosition: 75;
						rightAttachment: XmATTACHFORM;
						rightOffset: 2;
						topAttachment: XmATTACHFORM;
						topOffset: 2])
		named: #type.
	(self widgetAt: #type) addCallback: XmNsingleSelectionCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: 
				[self changeRequest
					ifTrue: 
						[self selectionPolicy: (values at: (strings indexOf: (self selectionFor: #type))).
						self changedSelectionPolicy]
					ifFalse: 
						[(self widgetAt: #type)
							setString: (self selectionPolicy name)]];
		setString: (self selectionPolicy name);
		manageChild.
	self
		addWidget: (aWidget createLabel: ' '
				argBlock: 
					[:w | 
					w borderWidth: 1;
						alignment: XmALIGNMENTBEGINNING;
						leftAttachment: XmATTACHWIDGET;
						leftWidget: (self widgetAt: #defaultApplication);
						leftOffset: 2;
						rightAttachment: XmATTACHWIDGET;
						rightWidget: (self widgetAt: #type);
						topAttachment: XmATTACHFORM;
						topOffset: 2])
					manageChild
		named: #description.
	(widget := self widgetAt: #codeModel) notNil
		ifTrue: [widget isDestroyed ifFalse: [widget destroyWidget]].
	self addWidget: (aWidget createForm: 'CodeModel'
				argBlock: 
					[:w | 
					w leftAttachment: XmATTACHFORM;
						leftOffset: 2;
						rightAttachment: XmATTACHFORM;
						rightOffset: 2;
						topAttachment: XmATTACHWIDGET;
						topWidget: (self widgetAt: #defaultApplication);
						topOffset: 2;
						bottomAttachment: XmATTACHFORM;
						bottomOffset: 2])
		named: #codeModel.
	(self widgetAt: #codeModel) manageChild.
	self buildTool!

buildTool
	tool buildCompletedInterfaceIn: (self widgetAt: #codeModel)!

changedSelectionPolicy
	self updateCodeTool!

changeRequest
	^super changeRequest and: [self updateRequest]!

className
	^self state className!

classNames
	^self state classNames!

codeToolClass
	^self selectionPolicy toolClass!

initialize
	super initialize.
	self selectionPolicy: self selectionPolicies first!

installNewTool: oldTool
	(oldTool isText and: [tool isText])
		ifTrue: 
			[tool widgets: oldTool widgets.
			oldTool releaseCallbacks.
			tool postBuild]
		ifFalse: 
			[| widget |
			widget := self widgetAt: #codeModel.
			widget isNil ifTrue: [^self].
			widget children copy do: [:each | each destroyWidget].
			self buildTool]!

isEditing
	^tool notNil and: [tool isEditing]!

isLocked
	^lockPolicy isLocked!

isMetaclass
	^self state isMetaclass!

lock

	self isLocked ifTrue: [^self].
	lockPolicy lock.
"rbDmm - we save state in the queryCommand method
	self saveState"!

lockPolicyClass: aClass
	lockPolicy := aClass on: self!

menu
	^tool menu!

menuBar
	^(MenuHolder for: self) add: '&Window' -> self windowMenu;
		add: '&Tool' -> (MenuHolder forBlock: [self menu]);
		yourself!

methods
	^state methods!

navigate
	navigator setState: self state!

navigator
	^navigator!

navigator: aNavigator 
	navigator notNil ifTrue: [navigator removeDependent: self].
	navigator := aNavigator.
	navigator addDependent: self.
	lockPolicy := StateLockPolicy on: self.
	tool := self codeToolClass on: self.!

nonMetaClass
	^self state nonMetaClass!

nonMetaClasses
	^self state nonMetaClasses!

noticeOfWindowClose: aWindow
	navigator removeDependent: self.
	^super noticeOfWindowClose: aWindow!

printOn: aStream 
	self state printOn: aStream.
	(tool notNil and: [tool isEditing])
		ifTrue: [aStream nextPut: $*]!

protocol
	^self state protocol!

protocols
	^self state protocols!

release
	navigator removeDependent: self.
	tool release.
	super release!

saveState
	tool notNil ifTrue: [tool saveState]!

selectedClass
	^self state selectedClass!

selectedClasses
	^self state selectedClasses!

selectionPolicies
	^selectionPolicies isNil 
		ifTrue: 
			[selectionPolicies := self class defaultSelectionPolicies collect: 
							[:each | 
							(each copy)
								for: self;
								yourself]]
		ifFalse: [selectionPolicies]!

selectionPolicy
	^selectionPolicy!

selectionPolicy: aCodeToolSelectionPolicy
	selectionPolicy := aCodeToolSelectionPolicy!

selector
	^self state selector!

selectors
	^self state selectors!

setClass: aClass 
	self state selectedClass: aClass.
	self updateNavigator!

setSelector: aSelector 
	self state selector: aSelector.
	self updateNavigator!

sourceToolClass
	^self protocol notNil
		ifTrue: [BrowserCodeTool]
		ifFalse: [BrowserClassTool]!

state
	state isNil ifTrue: [state := navigator getState].
	^state!

state: anObject

	^state := anObject!

subcanvases
	| superSubcanvases |
	superSubcanvases := super subcanvases.
	^self tool isNil
		ifTrue: [superSubcanvases]
		ifFalse: 
			[(superSubcanvases asOrderedCollection) add: self tool;
				yourself]!

timeStamp
	"Private - Answer the value of the receiver's ''timeStamp'' instance variable."

	^timeStamp!

timeStamp: anObject
	"Private - Set the value of the receiver's ''timeStamp'' instance variable to the argument, anObject."

	timeStamp := anObject!

tool
	^tool!

unlock

	self isLocked ifFalse: [^self].
"	navigator setState: self state. rbDmm
	don't need to do this ^^^^"
	lockPolicy unlock!

update: anAspectSymbol 
	anAspectSymbol = #closed ifTrue: [^self closeRequest].
	lockPolicy isLocked ifTrue: [^self].
	self state: navigator getState.
	self updateLabels.
	anAspectSymbol == #defaultApplication ifTrue: [^self].
	self updateCodeTool!

updateCodeTool
	"rbDmm - not needed"

"
	| oldTool codeToolClass |
	oldTool := tool.
	codeToolClass := self codeToolClass.
	tool class == codeToolClass ifFalse: [tool := codeToolClass on: self].
	tool == oldTool 
		ifFalse: 
			[self installNewTool: oldTool.
			oldTool release].
	tool notNil ifTrue: [tool updateContents]"!

updateDisplay

	self updateLabels.
"rbDmm 
	tool updateDisplay
not needed"

!

updateLabels
"rbDmm - get state and create label"
	| class selector application label method |
	
	class := state selectedClass.
	self state mode = #'C&lass' ifTrue: [class := class class].
	label := class isNil
		ifFalse: [selector := state method.
				selector isNil
					ifTrue: [class name]
					ifFalse: [method := class compiledMethodAt: selector selector ifAbsent: [nil].
							method isNil 
								ifTrue: [class name] 
								ifFalse: [class name, '>>', method selector]]].
	^label!

updateNavigator
	CodeModelLockPolicy flushCache. 
	self isLocked ifFalse: [navigator setState: self state].
	self update: nil!

updateRequest
	^self isLocked or: [super updateRequest]!

updateTool: aBrowser
	"rbDmmFix - added"

	lockPolicy isLocked ifTrue: [^self updateLabels].
	self state: (navigator setState: aBrowser).
	^self updateLabels.
	!

windowMenu
	^(MenuHolder for: self) add: '&Navigate to' -> #navigate;
		yourself! !
!CodeModel categoriesFor: #application!*-unclassified!public! !
!CodeModel categoriesFor: #applications!*-unclassified!public! !
!CodeModel categoriesFor: #buildInterfaceIn:!*-compilation failures!*-unclassified!public! !
!CodeModel categoriesFor: #buildTool!*-unclassified!public! !
!CodeModel categoriesFor: #changedSelectionPolicy!*-unclassified!public! !
!CodeModel categoriesFor: #changeRequest!*-unclassified!public! !
!CodeModel categoriesFor: #className!*-unclassified!public! !
!CodeModel categoriesFor: #classNames!*-unclassified!public! !
!CodeModel categoriesFor: #codeToolClass!accessing!public! !
!CodeModel categoriesFor: #initialize!*-unclassified!public! !
!CodeModel categoriesFor: #installNewTool:!*-unclassified!public! !
!CodeModel categoriesFor: #isEditing!*-unclassified!public! !
!CodeModel categoriesFor: #isLocked!*-unclassified!public! !
!CodeModel categoriesFor: #isMetaclass!*-unclassified!public! !
!CodeModel categoriesFor: #lock!accessing!public! !
!CodeModel categoriesFor: #lockPolicyClass:!*-unclassified!public! !
!CodeModel categoriesFor: #menu!*-unclassified!public! !
!CodeModel categoriesFor: #menuBar!*-compilation failures!*-unclassified!public! !
!CodeModel categoriesFor: #methods!*-unclassified!public! !
!CodeModel categoriesFor: #navigate!*-unclassified!public! !
!CodeModel categoriesFor: #navigator!accessing!public! !
!CodeModel categoriesFor: #navigator:!*-unclassified!public! !
!CodeModel categoriesFor: #nonMetaClass!*-unclassified!public! !
!CodeModel categoriesFor: #nonMetaClasses!*-unclassified!public! !
!CodeModel categoriesFor: #noticeOfWindowClose:!*-unclassified!public! !
!CodeModel categoriesFor: #printOn:!*-unclassified!public! !
!CodeModel categoriesFor: #protocol!*-unclassified!public! !
!CodeModel categoriesFor: #protocols!*-unclassified!public! !
!CodeModel categoriesFor: #release!*-unclassified!public! !
!CodeModel categoriesFor: #saveState!*-unclassified!public! !
!CodeModel categoriesFor: #selectedClass!*-unclassified!public! !
!CodeModel categoriesFor: #selectedClasses!*-unclassified!public! !
!CodeModel categoriesFor: #selectionPolicies!accessing!public! !
!CodeModel categoriesFor: #selectionPolicy!accessing!public! !
!CodeModel categoriesFor: #selectionPolicy:!*-unclassified!public! !
!CodeModel categoriesFor: #selector!*-unclassified!public! !
!CodeModel categoriesFor: #selectors!*-unclassified!public! !
!CodeModel categoriesFor: #setClass:!*-unclassified!public! !
!CodeModel categoriesFor: #setSelector:!*-unclassified!public! !
!CodeModel categoriesFor: #sourceToolClass!*-compilation failures!accessing!public! !
!CodeModel categoriesFor: #state!*-unclassified!public! !
!CodeModel categoriesFor: #state:!*-unclassified!public! !
!CodeModel categoriesFor: #subcanvases!*-unclassified!public! !
!CodeModel categoriesFor: #timeStamp!accessing!private! !
!CodeModel categoriesFor: #timeStamp:!accessing!private! !
!CodeModel categoriesFor: #tool!*-unclassified!public! !
!CodeModel categoriesFor: #unlock!*-unclassified!public! !
!CodeModel categoriesFor: #update:!*-unclassified!public! !
!CodeModel categoriesFor: #updateCodeTool!*-unclassified!public! !
!CodeModel categoriesFor: #updateDisplay!*-unclassified!public! !
!CodeModel categoriesFor: #updateLabels!accessing!public! !
!CodeModel categoriesFor: #updateNavigator!*-unclassified!public! !
!CodeModel categoriesFor: #updateRequest!*-unclassified!public! !
!CodeModel categoriesFor: #updateTool:!*-unclassified!public! !
!CodeModel categoriesFor: #windowMenu!*-compilation failures!*-unclassified!public! !

!CodeModel class methodsFor!

defaultSelectionPolicies
	^DefaultSelectionPolicies isNil 
		ifTrue: 
			[DefaultSelectionPolicies := Array 
						with: (SourceSelectionPolicy named: 'Source')
						with: (CommentSelectionPolicy named: 'Comment')
						with: (NotesSelectionPolicy named: 'Notes')]
		ifFalse: [DefaultSelectionPolicies]!

defaultSelectionPolicies: aCollection 
	DefaultSelectionPolicies := aCollection!

navigator: aNavigator 
"rbDmm - added timestamp to differentiate the codeModels in the tools" 
	^(self new)
		navigator: aNavigator;
 		timeStamp: TimeStamp current printString
		yourself! !
!CodeModel class categoriesFor: #defaultSelectionPolicies!accessing!public! !
!CodeModel class categoriesFor: #defaultSelectionPolicies:!accessing!public! !
!CodeModel class categoriesFor: #navigator:!instance creation!public! !

