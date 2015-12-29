"Filed out from Dolphin Smalltalk 2000 release 4.01"!

Model subclass: #BrowserApplicationModel
	instanceVariableNames: 'widgets'
	classVariableNames: 'ActiveDialogs'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BrowserApplicationModel comment: ''!

BrowserApplicationModel guid: (GUID fromString: '{A8B6C1B9-0E73-11D5-B80B-000102677BBF}')!

!BrowserApplicationModel categoriesForClass!Unclassified! !
!BrowserApplicationModel methodsFor!

handleError: aBlock 
	^self showWaitCursorWhile: 
			[aBlock when: Refactoring preconditionSignal
				do: 
					[:signal | 
					signal exception resumable
						ifTrue: 
							[(self confirm: (signal argument last == $?
										ifTrue: [signal argument]
										ifFalse: ['<1s><n>Do you want to proceed?' expandMacrosWith: signal argument]))
								ifTrue: [signal resumeWith: nil]]
						ifFalse: 
							[| args |
							args := signal arguments.
							args size = 2
								ifTrue: [(self confirm: args first) ifTrue: [args last value]]
								ifFalse: [self warn: signal argument]].
					signal exitWith: nil]]!

initialize
	widgets := IdentityDictionary new!

performChange: aRefactoringChange 
	RefactoryChangeManager instance performChange: aRefactoringChange!

performChange: aRefactoringChange withMessage: aString 
	RefactoryChangeManager instance performChange: aRefactoringChange
		withMessage: aString!

selectionFor: aSymbol 
	| items |
	items := self selectionsFor: aSymbol.
	(items isNil or: [items isEmpty]) ifTrue: [^nil].
	^items first!

selectionsFor: aSymbol 
	| aListWidget |
	aListWidget := self widgetAt: aSymbol.
	aListWidget isNil ifTrue: [^#()].
	^aListWidget selectedItems!

setLabel: aSymbol to: aString 
	| widget |
	widget := self widgetAt: aSymbol.
	widget isNil ifTrue: [^self].
	widget labelString: aString!

showWaitCursorWhile: aBlock 
	^Cursor wait showWhile: aBlock!

widgetAt: aSymbol 
	^self widgets at: aSymbol ifAbsent: [nil]!

widgets
	"Private - Answer the value of the receiver's ''widgets'' instance variable."

	^widgets!

widgets: anObject
	"Private - Set the value of the receiver's ''widgets'' instance variable to the argument, anObject."

	widgets := anObject! !
!BrowserApplicationModel categoriesFor: #handleError:!error handling!public! !
!BrowserApplicationModel categoriesFor: #initialize!accessing!public! !
!BrowserApplicationModel categoriesFor: #performChange:!accessing!public! !
!BrowserApplicationModel categoriesFor: #performChange:withMessage:!accessing!public! !
!BrowserApplicationModel categoriesFor: #selectionFor:!accessing!private! !
!BrowserApplicationModel categoriesFor: #selectionsFor:!accessing!private! !
!BrowserApplicationModel categoriesFor: #setLabel:to:!accessing!public! !
!BrowserApplicationModel categoriesFor: #showWaitCursorWhile:!*-unclassified!private! !
!BrowserApplicationModel categoriesFor: #widgetAt:!accessing!public! !
!BrowserApplicationModel categoriesFor: #widgets!accessing!private! !
!BrowserApplicationModel categoriesFor: #widgets:!accessing!private! !

!BrowserApplicationModel class methodsFor!

activeDialogs
	^ActiveDialogs isNil
		ifTrue: [ActiveDialogs := IdentityDictionary new]
		ifFalse: [ActiveDialogs]!

new
	^super new initialize! !
!BrowserApplicationModel class categoriesFor: #activeDialogs!accessing!public! !
!BrowserApplicationModel class categoriesFor: #new!accessing!public! !

