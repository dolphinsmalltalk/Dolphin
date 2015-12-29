"Filed out from Dolphin Smalltalk X6"!

ClassBrowserPlugin subclass: #DisassemblyPlugin
	instanceVariableNames: 'disassemblyPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DisassemblyPlugin guid: (GUID fromString: '{D582AE85-FC5C-431B-9BC5-D27DDEFD895C}')!
DisassemblyPlugin comment: 'DisassemblyPlugin is a <classBrowserPlugin> that decompiles a browser''s currently selected compiled method into it''s bytecode assembly instructions. Since this facility is probably not of interest to most developers it is not installed as one of the default plugins. If you wish to add this plugin to all browsers please evaluate:

	ClassBrowserAbstract allSubclasses do: [:each | each plugins add: self]

Instance Variables:
	disassemblyPresenter	<SmalltalkWorkspace> showing bytecode disassembly

'!
!DisassemblyPlugin categoriesForClass!Browser-Plugins!MVP-Presenters! !
!DisassemblyPlugin methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	disassemblyPresenter := self add: Smalltalk developmentSystem workspaceClass new name: 'disassembly'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self model)
		when: #methodSelected
			send: #onBrowserMethodSelected
			to: self;
		when: #classSelected
			send: #onBrowserClassSelected
			to: self!

defaultHelpId
	^10753!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	as a plugin within the Class Browser"

	aStream nextPutAll: 'Disassembly'!

onBrowserClassSelected
	self isCurrentCard ifTrue: [self browser ensureDefinitionVisible]!

onBrowserMethodSelected
	| method |
	method := self browser method.
	disassemblyPresenter text: (method notNil ifTrue: [method disassembly] ifFalse: [''])! !
!DisassemblyPlugin categoriesFor: #createComponents!initializing!public! !
!DisassemblyPlugin categoriesFor: #createSchematicWiring!initializing!public! !
!DisassemblyPlugin categoriesFor: #defaultHelpId!constants!public! !
!DisassemblyPlugin categoriesFor: #displayOn:!displaying!public! !
!DisassemblyPlugin categoriesFor: #onBrowserClassSelected!event handling!public! !
!DisassemblyPlugin categoriesFor: #onBrowserMethodSelected!event handling!public! !

!DisassemblyPlugin class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 416 98 2 8 1174475012 262145 576 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 721158 ##(Smalltalk.SystemColor)  41 0 1045 0 0 0 576 0 8 4294903673 852486 ##(Smalltalk.NullConverter)  0 0 11 0 234 256 98 8 8 #indentGuide 1182726 ##(Smalltalk.ScintillaTextStyle)  75 0 0 1 0 0 0 0 832 0 0 0 8 #normal 850 1 0 0 1 0 0 0 0 880 0 0 0 8 #lineNumber 850 67 0 0 1 0 0 0 0 912 0 0 0 8 #whitespace 850 3 0 0 1 0 0 0 0 944 0 0 0 234 256 98 8 1 896 3 960 67 928 75 864 1245510 1 ##(Smalltalk.NullScintillaStyler)  880 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 786694 ##(Smalltalk.IndexedColor)  33554433 1122 33554471 576 8 #circle 202 208 98 0 0 63 9215 0 0 0 0 1122 33554447 0 0 0 0 0 0 8 '' 1 234 256 98 2 8 #container 800 0 0 0 0 1 0 234 256 1200 983302 ##(Smalltalk.MessageSequence)  202 208 98 9 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1442 701 501 576 1378 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 576 1378 8 #isTextModified: 98 1 32 576 1378 8 #modificationEventMask: 98 1 9215 576 1378 8 #wordWrap: 98 1 16 576 1378 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 576 1 3 32 1 1778 3 576 1 1 32 67108863 1778 5 576 1 1 32 1 576 1378 8 #canHScroll: 98 1 32 576 1378 8 #indentationGuides: 98 1 0 576 1378 8 #tabIndents: 98 1 16 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 1442 193 193 0 27 234 256 98 2 576 8 'disassembly' 0 1314 202 208 98 1 1378 1408 98 2 1442 3359 21 1442 701 501 416 1986 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 237 7 0 0 4 1 0 0] 98 1 576 2048 0 27 )! !
!DisassemblyPlugin class categoriesFor: #icon!constants!public! !
!DisassemblyPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

