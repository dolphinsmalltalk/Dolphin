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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 328198 ##(Smalltalk.Point) 781 731 517 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 416 34 2 8 1142952260 262145 608 nil 480 nil 5 nil nil nil 608 nil 8 1915280032 852486 ##(Smalltalk.NullConverter) nil nil 11 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 514 1 1 514 765 429 608 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 126 1 0 0 214 0 0 0] 8 #() 514 193 193 nil 27 141 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 416 34 2 8 1140920580 1025 944 nil 480 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 11 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #evaluateIt 8 'Evaluate it' 1 1 nil nil nil 1058 2097153 1090 #displayIt 8 'Display it' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1058 1 1090 #undo 8 '&Undo' 1 1 nil nil nil 1186 4097 1058 1 1090 #cutSelection 8 'Cu&t' 1 1 nil nil nil 1058 1 1090 #copySelection 8 '&Copy' 1 1 nil nil nil 1058 1 1090 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 1058 1 1090 #clearSelection 8 'De&lete' 1 1 nil nil nil 1186 4097 1058 1 1090 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil nil nil 944 nil 8 1915280032 690 nil nil 9 722 138 144 34 2 786 #createAt:extent: 34 2 514 1 439 514 765 185 944 786 #contextMenu: 34 1 1024 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 219 0 0 0 126 1 0 0 55 1 0 0] 8 #() 928 nil 27 61 true 170 192 34 4 608 8 'output' 944 8 'input' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 2 1010 nil true 34 6 1058 1 1090 #evaluateIt 8 'Evaluate it' 8331 1 nil nil nil 1058 1 1090 #displayIt 8 'Display it' 8329 1 nil nil nil 1186 4097 1058 1 1090 #clearTape 8 'Clear Tape' 1 1 nil nil nil 2016 1058 1 1090 #exit 8 'Exit' 1 1 nil nil nil 8 '&Calculator' nil 1 nil nil 42407 nil nil 1010 nil true 34 8 1058 1 1090 #undo 8 '&Undo' 8373 1 nil nil nil 1186 4097 1058 1 1090 #cutSelection 8 'Cu&t' 8369 1 nil nil nil 1058 1 1090 #copySelection 8 '&Copy' 8327 1 nil nil nil 1058 1 1090 #pasteClipboard 8 '&Paste' 8365 1 nil nil nil 1058 1 1090 #clearSelection 8 'De&lete' 605 1 nil nil nil 1186 4097 1058 1 1090 #selectAll 8 '&Select All' 8323 1 nil nil nil 8 '&Edit' nil 1 nil nil 42421 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 514 53 53 514 781 731 416 786 #text: 34 1 8 'Smalltalk Calculator' 416 786 #updateMenuBar 8 #() 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 26 0 0 0 26 0 0 0 160 1 0 0 135 1 0 0] 34 3 608 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2768 nil 480 nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2768 nil 1 #left nil nil nil 514 1 1 514 9 9 nil 2864 nil 722 138 144 34 1 786 #createAt:extent: 34 2 514 1 429 514 765 11 2768 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 214 0 0 0 126 1 0 0 219 0 0 0] 8 #() 928 nil 27 944 928 nil 27 )!

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

