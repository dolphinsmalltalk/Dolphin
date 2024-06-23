"Filed out from Dolphin Smalltalk"!

Tools.KeyedAspectBatchAccessor
	subclass: #'Tools.Scintilla.CharacterClassificationBatchAccessor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Scintilla.CharacterClassificationBatchAccessor guid: (Core.GUID fromString: '{ba8f42e2-7fa3-41ad-8599-8c3ca04d1198}')!

Tools.Scintilla.CharacterClassificationBatchAccessor comment: ''!

!Tools.Scintilla.CharacterClassificationBatchAccessor methodsFor!

aspectClass
	^CharacterClassificationAspect!

getBatchAccessors
	| accessors subj |
	accessors := Array new: 128.
	subj := self subject.
	##(($\x1 to: $\x7F) copyWithoutAll: #($\n $\r)) do: 
			[:each |
			accessors at: each codeUnit + 1
				put: ((CharacterClassificationAspect character: each) accessorFor: subj)].
	accessors at: 0 + 1
		put: ((CharacterClassificationAspect character: $\0 classification: #whitespace) accessorFor: subj).
	#($\n $\r) do: 
			[:each |
			accessors at: each codeUnit + 1
				put: ((CharacterClassificationAspect character: each classification: #newline) accessorFor: subj)].
	^accessors! !

!Tools.Scintilla.CharacterClassificationBatchAccessor categoriesForMethods!
aspectClass!public! !
getBatchAccessors!public! !
!

