"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RenameClassRefactoring subclass: #'Tools.RenameNamespacedClassRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Refactory.Browser})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RenameNamespacedClassRefactoring guid: (Core.GUID fromString: '{b0780f17-9017-4316-92eb-789b160450c5}')!
Tools.RenameNamespacedClassRefactoring comment: ''!
!Tools.RenameNamespacedClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Tools.RenameNamespacedClassRefactoring methodsFor!

buildParseTreeRewriter
	| newUnqualified rewriter newEnvironmentName newRef oldRef oldNamespaceName |
	"First the full names as both symbols and variables"
	rewriter := ParseTreeRewriter new.
	newRef := newName asQualifiedReference.
	newUnqualified := newRef unqualifiedName.
	newEnvironmentName := newRef environmentName.
	oldRef := className asQualifiedReference.
	oldNamespaceName := oldRef environmentName.
	#namespaceToDo.	"If the Namespace remains the same we only need to change the final name component, although we might be able to translate fully-qualified references to unqualifed (or partially qualified) ones. If the Namespace is changed, then potentially we may need to rename any of the different ways to refer to the same class (fully qualified, partially qualified, unqualified). We really need to check that the reference is actually a relevant name to this rename, depending on the binding scope, but to do correctly so we woyuld need some model of namespaces to resolve names in context. The current implementation is a hack using the actual namespaces and classes, which is not a correct model of the future state after the refactoring."
	newEnvironmentName = oldNamespaceName
		ifTrue: 
			[| from to |
			from := to := nil.
			oldRef path reverseDo: 
					[:each |
					from := from
								ifNil: 
									[to := newUnqualified.
									each]
								ifNotNil: 
									[to := each , '.' , to.
									each , '.' , from].
					rewriter
						replaceLiteral: from asSymbol with: to asSymbol;
						replace: from with: to]]
		ifFalse: 
			[| from |
			"Namespace has changed: Replace original unqualified and partially qualified references with a unqualified or fully-qualified references, as required."
			from := nil.
			oldRef path reverseDo: 
					[:each |
					from := from ifNil: [each] ifNotNil: [each , '.' , from].
					rewriter
						replaceTree: (RBLiteralNode value: from asSymbol)
							withValueFrom: [:node | RBLiteralNode value: (self nameForReferenceToClass: class fromNode: node) asSymbol];
						replace: from
							withValueFrom: [:node | RBVariableNode named: (self nameForReferenceToClass: class fromNode: node)]]].
	rewriter replaceArgument: newUnqualified
		withValueFrom: [:aNode | self refactoringError: newUnqualified , ' already exists within the reference scope'].
	^rewriter!

className: aName newName: aNewName
	self className: aName.
	"If the new name is unqualified, preserve the original namespace of the class."
	#namespaceToDo.	"Do we need the asSymbol here?"
	newName := ((BindingReference isQualifiedName: aNewName)
				ifTrue: [aNewName]
				ifFalse: 
					[| parts |
					parts := $. split: aName.
					parts at: parts size put: aNewName.
					$. join: parts])
					asSymbol.
	class := self model classNamed: className!

preconditions
	^(RBCondition withBlock: [class notNil and: [class isMeta not]]
		errorString: className , ' is not an existing class') 
			& (RBCondition isValidClassName: newName) 
			& (RBCondition hasNamespace: newName)
			& (RBCondition isGlobal: newName in: self model) not!

renameImports
	"Private - Update any imports of the class - here we really need to match any of the binding references that might refer to the original class"

	| oldBindingRef newBindingRef |
	oldBindingRef := className asQualifiedReference.
	newBindingRef := newName asQualifiedReference.
	self model allClassesDo: 
			[:eachClass |
			eachClass isMeta
				ifFalse: 
					[(eachClass imports includes: oldBindingRef)
						ifTrue: 
							[eachClass
								addImport: newBindingRef;
								removeImport: oldBindingRef]]]!

renameReferences: aCollectionOfRBMethods
	"Private - Note that renaming a class will rename any Symbols that happen to be the name of the class, whether directly held literals or embedded in literal arrays. This is not strictly a refactoring as one cannot be certain that an arbitrary Symbol in a method that happens to be the same as a class name is actually intended for use as the name of that class. This is one good reason to use BindingReferences instead, since these are intended as references to classes so if they bound to the original class, we can be reasonably certain that they should also be renamed."

	| rewriter |
	"The old and new names are full names"
	rewriter := self buildParseTreeRewriter.
	self renameImports.
	aCollectionOfRBMethods do: 
			[:method |
			(method modelClass hierarchyDefinesVariable: newName)
				ifTrue: 
					[self
						refactoringError: newName , ' is already defined in hierarchy of ' , method modelClass printString].
			self convertMethod: method using: rewriter]!

transform
	self model
		renameClass: class
		to: newName
		around: [:methods | self renameReferences: methods]! !
!Tools.RenameNamespacedClassRefactoring categoriesForMethods!
buildParseTreeRewriter!private!transforming! !
className:newName:!initializing!private! !
preconditions!preconditions!public! !
renameImports!private!transforming! !
renameReferences:!private!transforming! !
transform!public!transforming! !
!

