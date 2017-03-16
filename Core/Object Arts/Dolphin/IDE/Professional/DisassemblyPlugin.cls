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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ContainerView) 98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 8 ##(Smalltalk.ScintillaView) 98 50 0 416 98 2 8 1174475012 262145 576 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 721158 ##(Smalltalk.SystemColor) 41 0 1045 0 0 0 576 0 8 4294906441 852486 ##(Smalltalk.NullConverter) 0 0 11 0 234 256 98 10 8 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 832 0 0 0 8 #indentGuide 850 75 0 0 1 0 0 0 0 880 0 0 0 8 #lineNumber 850 67 0 0 1 0 0 0 0 912 0 0 0 8 #callTip 850 77 786694 ##(Smalltalk.IndexedColor) 33554457 978 33554471 1 0 0 0 0 944 0 0 0 8 #whitespace 850 3 0 0 1 0 0 0 0 1024 0 0 0 234 256 98 8 1 864 3 1040 67 928 75 896 1245510 1 ##(Smalltalk.NullScintillaStyler) 832 234 256 98 2 8 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 576 8 #circle 0 0 0 0 0 0 202 208 98 0 0 63 9215 0 0 0 0 978 33554447 0 0 65 0 0 0 8 '' 1 234 256 98 2 8 #container 800 0 0 0 0 1 0 234 256 1232 0 0 234 256 98 6 8 #Notification 850 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 1376 0 0 0 8 #Error 850 1031 1410 335 1410 31317503 1 0 0 0 0 1440 0 0 0 8 #Warning 850 1027 1410 60239 1410 31326207 1 0 0 0 0 1504 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 11 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 1 1 1698 701 501 576 1634 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 576 1634 8 #isTextModified: 98 1 32 576 1634 8 #modificationEventMask: 98 1 9215 576 1634 8 #secondaryCaretForecolor: 98 1 1410 16711423 576 1634 8 #caretPeriod: 98 1 1061 576 1634 8 #wordWrap: 98 1 16 576 1634 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin) 1 576 1 3 32 1 15 2146 3 576 1 1 32 67108863 15 2146 5 576 1 1 32 1 15 576 1634 8 #canHScroll: 98 1 32 576 1634 8 #tabIndents: 98 1 16 576 1634 8 #areAdditionalCaretsVisible: 98 1 16 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 1698 193 193 0 29 234 256 98 2 576 8 'disassembly' 0 1570 202 208 98 1 1634 1664 98 2 1698 3839 21 1698 701 501 416 2354 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 98 1 576 2416 0 27 )! !
!DisassemblyPlugin class categoriesFor: #icon!constants!public! !
!DisassemblyPlugin class categoriesFor: #resource_Default_view!public!resources-views! !

