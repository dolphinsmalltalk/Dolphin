"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RenameMethodRefactoring subclass: #'Tools.RenameMethodReferencesRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Refactory.Browser})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RenameMethodReferencesRefactoring guid: (Core.GUID fromString: '{721e4622-9483-4d18-a01f-8c2ae241b26b}')!
Tools.RenameMethodReferencesRefactoring comment: 'RenameMethodReferencesRefactoring is a specialisation of the <RenameMethodRefactoring> that does not rename any implementors. This can be useful when one wishes to adapt code using one selector to another, and occurrence one frequently encounters when porting code from one Smalltalk to another. Note that this may not be behaviour preserving.'!
!Tools.RenameMethodReferencesRefactoring categoriesForClass!Refactory-Refactorings! !
!Tools.RenameMethodReferencesRefactoring methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: 'Replace References to ';
		print: oldSelector;
		nextPutAll: ' with ';
		print: newSelector!

getOptionReplaceReferencesTo: oldSymbol with: newSymbol
	| references details |
	references := self model allReferencesTo: oldSymbol.
	details := String writeStream.
	details
		print: oldSymbol;
		nextPutAll: ' is currently referenced from ';
		print: references size;
		nextPutAll: ' methods:';
		cr.
	self
		printNameList: (references asArray collect: [:each | each printString]) sort
		on: details
		limit: self maxDetails
		type: 'methods'.
	^MessageBox new
		caption: self displayString;
		headline: 'Replace references to <1p> with <2p>?' << {oldSymbol. newSymbol};
		text: 'Renaming method references is not a true refactoring, and may not preserve behavior.';
		customButtons: #(#(#yes '&Rename') #(#no '&Don''t Rename'));
		defaultButton: 2;
		iconStyle: #warning;
		confirm!

initialize
	implementors := #()!

preconditions
	^super preconditions & (RBCondition hierarchyOf: class canUnderstand: newSelector)
		& (RBCondition withBlock: 
					[(self shouldReplaceReferencesTo: oldSelector with: newSelector) or: [self refactoringAborted]])!

shouldReplaceReferencesTo: oldSymbol with: newSymbol
	^(self options at: #replaceReferences)
		cull: self
		cull: oldSymbol
		cull: newSymbol! !
!Tools.RenameMethodReferencesRefactoring categoriesForMethods!
displayOn:!displaying!public! !
getOptionReplaceReferencesTo:with:!options!public! !
initialize!initializing!public! !
preconditions!preconditions!public! !
shouldReplaceReferencesTo:with:!private!requests! !
!

