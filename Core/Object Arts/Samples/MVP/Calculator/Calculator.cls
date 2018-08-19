"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #Calculator
	instanceVariableNames: 'input output'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Calculator guid: (GUID fromString: '{816da2f6-de4a-41df-bea6-0a549e3a715e}')!
Calculator comment: 'Calculator is a <topShell> sample application which illustrates the use of the Dolphin Compiler class in a runtime application. See the package comment for more details.'!
!Calculator categoriesForClass!Samples! !
!Calculator methodsFor!

clearTape
	"Clears the tape output window"

	output clear
!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	input := self add: TextPresenter new name: 'input'.
	output := self add: TextPresenter new name: 'output'.
!

displayIt
	"Evaluates the contents of the input field as a Smalltalk expression and displays
	the result in the output window"

	| answer |
	self print: input value trimBlanks.
	answer := self evaluateIt.
	self print: ' = ' , answer printString.
	self printNewline!

evaluateIt
	"Evaluates the contents of the input field as a Smalltalk expression and answers the result"

	| result |
	
	[[result := Compiler evaluate: input value logged: false] on: Compiler errorClass
		do: [:x | self print: ' (' , x description , ')']] 
			on: Error
			do: [:x | self print: ' (Error: ' , x description , ')'].
	input clear.
	^result!

print: aString 
	"Private - Prints aString to the output tape"

	| stream |
	stream := String new writeStream.
	stream
		nextPutAll: output value;
		nextPutAll: aString.
	output value: stream contents.
	output view lineScroll: output view lineCount!

printNewline
	self print: String lineDelimiter! !
!Calculator categoriesFor: #clearTape!commands!public! !
!Calculator categoriesFor: #createComponents!initializing!private! !
!Calculator categoriesFor: #displayIt!commands!public! !
!Calculator categoriesFor: #evaluateIt!commands!public! !
!Calculator categoriesFor: #print:!helpers!private! !
!Calculator categoriesFor: #printNewline!private! !

!Calculator class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Smalltalk Calculator'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon text: $\x1D6D1 color: (ARGB named: #skyBlue))!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10618!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 328198 ##(Smalltalk.Point)  781 731 551 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.MultilineTextEdit)  98 16 0 416 98 2 8 1142952260 262145 624 0 482 512 0 7 0 0 0 624 0 8 4294904765 852486 ##(Smalltalk.NullConverter)  0 0 11 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 530 1 1 530 765 429 624 834 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 624 834 8 #isTextModified: 98 1 32 624 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 126 1 0 0 214 0 0 0] 98 0 530 193 193 0 27 141 410 640 98 16 0 416 98 2 8 1140920580 1025 1136 0 482 512 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 11 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #evaluateIt 8 'Evaluate it' 1 1 0 0 0 1266 2097153 1298 8 #displayIt 8 'Display it' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 1266 1 1298 8 #undo 8 '&Undo' 1 1 0 0 0 1426 4097 1266 1 1298 8 #cutSelection 8 'Cu&t' 1 1 0 0 0 1266 1 1298 8 #copySelection 8 '&Copy' 1 1 0 0 0 1266 1 1298 8 #pasteClipboard 8 '&Paste' 1 1 0 0 0 1266 1 1298 8 #clearSelection 8 'De&lete' 1 1 0 0 0 1426 4097 1266 1 1298 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 1 0 0 0 0 0 0 0 1136 0 8 4294904765 738 0 0 9 770 202 208 98 4 834 864 98 2 530 1 439 530 765 185 1136 834 8 #contextMenu: 98 1 1232 1136 834 944 98 1 978 3 1 3 1136 834 1024 98 1 32 1136 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 219 0 0 0 126 1 0 0 55 1 0 0] 98 0 1120 0 27 61 16 234 256 98 4 624 8 'output' 1136 8 'input' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 2 1218 0 16 98 6 1266 1 1298 1328 8 'Evaluate it' 8331 1 0 0 0 1266 1 1298 1392 8 'Display it' 8329 1 0 0 0 1426 4097 1266 1 1298 8 #clearTape 8 'Clear Tape' 1 1 0 0 0 2448 1266 1 1298 8 #exit 8 'Exit' 1 1 0 0 0 8 '&Calculator' 0 1 0 0 15295 0 0 1218 0 16 98 8 1266 1 1298 1488 8 '&Undo' 8373 1 0 0 0 1426 4097 1266 1 1298 1568 8 'Cu&t' 8369 1 0 0 0 1266 1 1298 1632 8 '&Copy' 8327 1 0 0 0 1266 1 1298 1696 8 '&Paste' 8365 1 0 0 0 1266 1 1298 1760 8 'De&lete' 605 1 0 0 0 1426 4097 1266 1 1298 1840 8 '&Select All' 8323 1 0 0 0 8 '&Edit' 0 1 0 0 15309 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 770 202 208 98 3 834 864 98 2 530 2799 21 530 781 731 416 834 8 #text: 98 1 8 'Smalltalk Calculator' 416 834 8 #updateMenuBar 98 0 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 253 6 0 0 119 1 0 0] 98 3 624 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 3264 0 482 512 0 519 0 0 0 3264 770 202 208 98 1 834 864 98 2 530 1 429 530 765 11 3264 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 214 0 0 0 126 1 0 0 219 0 0 0] 98 0 1120 0 27 1136 1120 0 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.

	self uninitialize
	"

	Smalltalk developmentSystem removeSystemFolderIconNamed: self displayString! !
!Calculator class categoriesFor: #displayOn:!displaying!public! !
!Calculator class categoriesFor: #icon!constants!public! !
!Calculator class categoriesFor: #initialize!development!initializing!private! !
!Calculator class categoriesFor: #resource_Default_view!public!resources-views! !
!Calculator class categoriesFor: #shutdownOnExit!public!testing! !
!Calculator class categoriesFor: #uninitialize!development!initializing!private! !

Calculator class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

