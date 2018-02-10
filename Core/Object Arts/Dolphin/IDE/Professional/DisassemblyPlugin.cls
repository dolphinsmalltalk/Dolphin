"Filed out from Dolphin Smalltalk 7"!

ClassBrowserPlugin subclass: #DisassemblyPlugin
	instanceVariableNames: 'disassemblyPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DisassemblyPlugin guid: (GUID fromString: '{d582ae85-fc5c-431b-9bc5-d27ddefd895c}')!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 0 0 34 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 416 34 2 8 1174475012 262145 560 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 721158 ##(Smalltalk.SystemColor) 41 0 1045 0 0 0 560 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 11 0 170 192 34 10 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 834 33554471 1 0 0 0 0 #callTip 0 0 0 #normal 802 1 0 0 1 0 0 0 0 #normal 0 0 0 #lineNumber 802 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #whitespace 802 3 0 0 1 0 0 0 0 #whitespace 0 0 0 #indentGuide 802 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 170 192 34 8 1 880 3 912 75 928 67 896 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 560 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 8 #() 0 170 176 1088 9215 0 0 0 0 834 33554447 0 0 65 0 0 0 8 '' 1 170 192 34 2 #container 768 0 0 0 0 1 0 170 192 1088 0 0 170 192 34 6 #Notification 802 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 802 1027 1250 60239 1250 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 802 1031 1250 335 1250 31317503 1 0 0 0 0 #Error 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 6 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1490 701 501 560 1442 #modificationEventMask: 8 #(4607) 560 1442 #caretPeriod: 8 #(530) 560 1442 #wordWrap: 8 #(true) 560 1442 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 560 1 3 0 0 0 0 1682 3 560 1 0 0 67108863 0 0 1682 5 560 1 0 0 0 0 0 560 1442 #canHScroll: 8 #(false) 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 1490 193 193 0 29 170 192 34 2 560 8 'disassembly' 0 1378 138 144 34 1 1442 #createAt:extent: 34 2 1490 3839 21 1490 701 501 416 1778 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 34 1 560 1840 0 27 )! !
!DisassemblyPlugin class categoriesFor: #icon!constants!public! !
!DisassemblyPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

