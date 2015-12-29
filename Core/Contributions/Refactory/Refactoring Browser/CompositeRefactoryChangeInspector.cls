"Filed out from Dolphin Smalltalk 2000 release 4.01"!

BrowserApplicationModel subclass: #CompositeRefactoryChangeInspector
	instanceVariableNames: 'refactoryBuilder menu'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompositeRefactoryChangeInspector comment: ''!

CompositeRefactoryChangeInspector guid: (GUID fromString: '{A8B6C1C0-0E73-11D5-B80B-000102677BBF}')!

!CompositeRefactoryChangeInspector categoriesForClass!Unclassified! !
!CompositeRefactoryChangeInspector methodsFor!

buildInterfaceIn: aWidget 
	| listWidget textWidget |
	self addWidget: (listWidget := CwObjectList 
						createScrolledManagedWidget: 'changes'
						parent: aWidget
						argBlock: 
							[:w | 
							w
								selectionPolicy: XmSINGLESELECT;
								printBlock: [:item | item displayString]])
		named: #changes.
	listWidget parent setValuesBlock: 
			[:w | 
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: 2;
				topAttachment: XmATTACHFORM;
				topOffset: 2;
				rightAttachment: XmATTACHFORM;
				rightOffset: 2;
				bottomAttachment: XmATTACHPOSITION;
				bottomPosition: 33].
	listWidget
		addCallback: XmNsingleSelectionCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #changedChange.
	self addWidget: (textWidget := aWidget createScrolledText: 'description'
						argBlock: 
							[:w | 
							w
								editMode: XmMULTILINEEDIT;
								scrollHorizontal: false;
								wordWrap: true;
								tabSpacing: EmTextCompatibilityFilter tabSize])
		named: #changeDescription.
	textWidget manageChild.
	(CwSmalltalkTextSelectionManager for: textWidget) connect.
	textWidget parent setValuesBlock: 
			[:w | 
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: 2;
				topAttachment: XmATTACHWIDGET;
				topWidget: listWidget;
				topOffset: 2;
				rightAttachment: XmATTACHFORM;
				rightOffset: 2;
				bottomAttachment: XmATTACHFORM;
				bottomOffset: 2].
	self schedulePopUpMenu: self changesMenu for: (self widgetAt: self changes)
!

changedChange
	| change |
	change := self selectionFor: self changes.
	self setString: (change isNil ifTrue: [''] ifFalse: [change printString])
		for: self changeDescription.
	change isNil
		ifTrue: [self changesMenu disableAllExcept: #('Execute All')]
		ifFalse: [self changesMenu enableAll]!

changeDescription
	^#changeDescription!

changes
	^#changes!

changesMenu
	^menu isNil
		ifTrue: [menu := self initializeMenu: self class changesMenu]
		ifFalse: [menu]!

executeAll
	self performChange: refactoryBuilder withMessage: 'Compiling changes'!

executeChange
	self performChange: (self selectionFor: self changes)!

inspect: aRefactoryBuilder 
	refactoryBuilder := aRefactoryBuilder.
	self open.
	self setList: refactoryBuilder changes in: self changes!

postBuild
	super postBuild.
	self changedChange!

removeChange
	| item |
	item := self selectionFor: self changes.
	refactoryBuilder removeChange: item.
	self remove: item fromList: self changes.
	self select: nil in: self changes.
	self changedChange!

removeClass
	| class |
	class := (self selectionFor: self changes) changeClass.
	(self listFrom: self changes) copy do: 
			[:each | 
			each changeClass == class ifTrue: 
					[refactoryBuilder removeChange: each.
					self remove: each fromList: self changes]].
	self select: nil in: self changes.
	self changedChange! !
!CompositeRefactoryChangeInspector categoriesFor: #buildInterfaceIn:!*-compilation failures!*-unclassified!public! !
!CompositeRefactoryChangeInspector categoriesFor: #changedChange!*-unclassified!public! !
!CompositeRefactoryChangeInspector categoriesFor: #changeDescription!*-unclassified!public! !
!CompositeRefactoryChangeInspector categoriesFor: #changes!*-unclassified!public! !
!CompositeRefactoryChangeInspector categoriesFor: #changesMenu!*-unclassified!public! !
!CompositeRefactoryChangeInspector categoriesFor: #executeAll!*-unclassified!public! !
!CompositeRefactoryChangeInspector categoriesFor: #executeChange!*-unclassified!public! !
!CompositeRefactoryChangeInspector categoriesFor: #inspect:!*-unclassified!public! !
!CompositeRefactoryChangeInspector categoriesFor: #postBuild!*-unclassified!public! !
!CompositeRefactoryChangeInspector categoriesFor: #removeChange!*-unclassified!public! !
!CompositeRefactoryChangeInspector categoriesFor: #removeClass!*-unclassified!public! !

!CompositeRefactoryChangeInspector class methodsFor!

changesMenu
	^MenuHolder fromSpec: #(#('Execute' 'Execute All' nil 'Remove' 'Remove Class') #(#executeChange #executeAll nil #removeChange #removeClass))!

openOn: aRefactoryBuilder 
	self new inspect: aRefactoryBuilder! !
!CompositeRefactoryChangeInspector class categoriesFor: #changesMenu!*-compilation failures!*-unclassified!public! !
!CompositeRefactoryChangeInspector class categoriesFor: #openOn:!*-unclassified!public! !

