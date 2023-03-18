"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest
	subclass: #'Refactory.Browser.Tests.RemoveClassChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveClassChangeTest guid: (Core.GUID fromString: '{3f03db7b-ccd3-427a-b17a-0355b2075f9e}')!
Refactory.Browser.Tests.RemoveClassChangeTest comment: ''!
!Refactory.Browser.Tests.RemoveClassChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveClassChangeTest methodsFor!

subjectClass
	^RemoveClassChange!

testAsUndo
	| subject undo filer afterText |
	subject := self subjectClass remove: String.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: self undoClass.
	"Until the change is applied, the undo's beforeText will be empty because the class does not exist"
	self assert: undo beforeText equals: ''.
	afterText := String writeStream.
	filer := String sourceFilerClass on: afterText.
	String withAllSubclasses do: 
			[:each |
			filer
				fileOutDefinitionOfClass: each;
				cr.
			(each selectors asSortedArray collect: [:selector | each compiledMethodAt: selector])
				, (each class selectors asSortedArray collect: [:selector | each class compiledMethodAt: selector])
					do: 
						[:method |
						filer
							emitHeaderForMethodsOf: method methodClass;
							cr;
							cr;
							nextChunkPut: method getSource;
							emitFooterForMethodsOf: method methodClass;
							emitCategoriesOfMethod: method]
					separatedBy: [filer cr]]
		separatedBy: [filer cr].
	afterText := afterText contents.
	self assert: undo afterText equals: afterText!

testPrinting
	| subject |
	subject := self subjectClass remove: ClassToRename.
	self assert: subject beforeText equals: ClassToRename definition.
	self assert: subject afterText equals: ''.
	self assert: subject changeString equals: 'Remove class ' , ClassToRename fullName.
	self assert: subject printString equals: ClassToRename fullName , ' removeFromSystem!!'!

undoClass
	^CompositeRefactoryChange! !
!Refactory.Browser.Tests.RemoveClassChangeTest categoriesForMethods!
subjectClass!constants!private! !
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
undoClass!constants!private! !
!

