"Filed out from Dolphin Smalltalk"!

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
	
	[[result := Compiler evaluate: input value] on: Compiler errorClass
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

!Calculator categoriesForMethods!
clearTape!commands!public! !
createComponents!initializing!private! !
displayIt!commands!public! !
evaluateIt!commands!public! !
print:!helpers!private! !
printNewline!private! !
!

!Calculator class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Smalltalk Calculator'!

icon
	"Answers an Icon that can be used to represent this class"

	^##((TextTileIcon
		text: $\xE8EF
		fontName: 'Segoe Fluent Icons'
		color: Color skyBlue)
		margin: 1;
		yourself)!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 781 731 517 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 416 34 2 8 1142952260 262145 592 nil 480 nil 5 nil nil nil 592 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 11 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 118 1 0 0 210 0 0 0] 193 624 nil 592 3 8 #() 498 193 193 nil 27 141 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 416 34 2 8 1140920580 1025 928 nil 480 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 11 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #evaluateIt 8 'Evaluate it' 1 1 nil nil nil 1042 2097153 1074 #displayIt 8 'Display it' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1042 1 1074 #undo 8 '&Undo' 1 1 nil nil nil 1170 4097 1042 1 1074 #cutSelection 8 'Cu&t' 1 1 nil nil nil 1042 1 1074 #copySelection 8 '&Copy' 1 1 nil nil nil 1042 1 1074 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 1042 1 1074 #clearSelection 8 'De&lete' 1 1 nil nil nil 1170 4097 1042 1 1074 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil nil nil 928 nil 8 1759000288 674 nil nil 9 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 215 0 0 0 118 1 0 0 50 1 0 0] 193 960 nil 928 770 #contextMenu: 34 1 1008 928 3 8 #() 498 193 193 nil 27 61 true 170 192 34 4 592 8 'output' 928 8 'input' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 2 994 nil true 34 6 1042 1 1074 #evaluateIt 8 'Evaluate it' 8331 1 nil nil nil 1042 1 1074 #displayIt 8 'Display it' 8329 1 nil nil nil 1170 4097 1042 1 1074 #clearTape 8 'Clear Tape' 1 1 nil nil nil 2000 1042 1 1074 #exit 8 'Exit' 1 1 nil nil nil 8 '&Calculator' nil 1 nil nil 11287 nil nil 994 nil true 34 8 1042 1 1074 #undo 8 '&Undo' 8373 1 nil nil nil 1170 4097 1042 1 1074 #cutSelection 8 'Cu&t' 8369 1 nil nil nil 1042 1 1074 #copySelection 8 '&Copy' 8327 1 nil nil nil 1042 1 1074 #pasteClipboard 8 '&Paste' 8365 1 nil nil nil 1042 1 1074 #clearSelection 8 'De&lete' 605 1 nil nil nil 1170 4097 1042 1 1074 #selectAll 8 '&Select All' 8323 1 nil nil nil 8 '&Edit' nil 1 nil nil 11301 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 706 138 144 34 1 770 #createWindow: 34 1 818 590342 ##(Smalltalk.Rectangle) 498 1 1 498 781 731 193 448 8 'Smalltalk Calculator' 416 1 34 3 592 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2704 nil 480 nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2704 nil 1 #left nil nil nil 498 1 1 498 9 9 nil 2800 nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 210 0 0 0 118 1 0 0 215 0 0 0] 193 2736 8 '' 2704 3 8 #() 498 193 193 nil 27 928 498 193 193 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !

!Calculator class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
!

Calculator class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

