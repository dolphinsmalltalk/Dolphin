"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RenameClassRefactoring subclass: #'Tools.RenameNamespacedClassRefactoring'
	instanceVariableNames: 'oldClassReference newClassReference oldUnqualified hasSymbolRenames'
	classVariableNames: ''
	imports: #(#{Refactory.Browser})
	classInstanceVariableNames: ''
	classConstants: {
		'RewriteTracing' -> true
	}!
Tools.RenameNamespacedClassRefactoring guid: (Core.GUID fromString: '{b0780f17-9017-4316-92eb-789b160450c5}')!
Tools.RenameNamespacedClassRefactoring comment: '`RenameNamespaceClassRefactoring` is an enhanced version of the `RenameClassRefactoring` that is Namespace aware.

Renaming classes with namespaces and qualified names is considerably more complicated than renames in traditional Smalltalk with a single global namespace, because the identifiers used to reference the class in code for a full or partial path to be used for binding resolution, and the binding resolution for any particular path can be different depending on the binding context. The names can be fully-qualified, partially-qualified, or unqualified. Ambiguous references are possible for partially-qualified and unqualified names, so whether a particular identifier needs to be renamed depends on its binding context, i.e. whether it actually would have bound to the class being renamed prior to the rename. Given the need to consider binding context, setting up specific static searches in advance is not terribly useful, as we''ll still need to check the actual binding resolution for each candidate match to see if it really is a match. This means we need to perform a much broader match against variable references in methods that are referencing the renamed class, and then decide individually whether to rename them. We also need to consider the binding context when deciding how to rename them. Although we could always rename to a fully qualified name, this will make the code more verbose than it may need to be (a bit like using someone''s full name every time one refers to them). Therefore the refactoring attempts to use the least qualified variant of the new name that will still bind to the same (renamed) class. _Maybe minimising previously fully-qualified names should be an option, TBD_.

`RenameClassRefactoring` renames references in code that were direct references to the class in question, and also symbolic references using the class name. The renaming of symbolic references has always been a bit questionable from a _refactorings must preserve behaviour_ perspective since it is possible that another `Symbol` used for another purpose just happens to be the name of a class being renamed. This was fairly unlikely, but the assumption that all `Symbol`s that look like class names and match a class name, must be class names, is not guaranteed to be true. We now have `BindingReference`s, so the former use of plain `Symbol`s for the purpose of late bound lookups has been superseded, and we know that the name components of a `BindingReference`  must be the names of program objects since this is the explicit purpose of `BindingReference`s. In Dolphin all but the final component of a `BindingReference` path must be class names, since Dolphin''s `Namespace`s are actually classes. The final component of the name is usually a class name, but may also refer to other static variables in the namespace referred to by the path up to the terminal component. As the non-terminal components of a qualified `BindingReference` must be classes, then these are candidates to rename if they would have bound to the class being renamed at some point along the path. The renaming of `Symbol`s is still performed, but deliberately limited to renaming classes in the legacy Smalltalk namespace. The intent is that such renames will also invoke a refactoring option that will normally prompt for confirmation for each `Symbol` that is a candidate for renaming. Details TBD.

Renaming a class can change any of the components (and any number of them) of the fully qualified name of a class. Unless it is only the leaf identifier (aka the short name, or unqualified name) that is changed, then the class is effectively moved to a different `Namespace`. When moving a class to a new `Namespace` it is entirely possible that unqualified and partially qualified names in the methods of the class itself will either no longer bind at all, or will bind to different static variables (where there is ambiguity and some part of the name is not globally unique). This means we must also rewrite the renamed class'' own methods, updating any variable references as required to maintain the previous binding. As with the references to the class being renamed, the references in the class being renamed should also have a minimal form after renaming.

Renaming a class in such a way as to change its `Namespace` can result in ambiguous references that cannot be resolved. This is regarded as a refactoring error that will fail the refactoring abandoning any changes.
'!
!Tools.RenameNamespacedClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Tools.RenameNamespacedClassRefactoring methodsFor!

bindingReference: aBindingReference refersToClassFrom: aStLiteralNode
	| methodNode binding methodClassName methodClass |
	(aBindingReference isAbsolute and: 
			["It's a definite match if the absolute path is the same as as our class name. We want to rename meta binding references, and private ones too."
			aBindingReference pathString = oldClassReference pathString])
		ifTrue: [^true].
	"Could never have bound to the renamed class if the terminal identifier is not the unqualified name"
	aBindingReference path last = oldUnqualified ifFalse: [^false].
	"It might be a rereference to the renamed class, but we'll we need to try binding it to be sure"
	methodNode := aStLiteralNode methodNode.
	methodClassName := methodNode methodClass fullName.
	methodClass := methodClassName = newName
				ifTrue: [class]
				ifFalse: [model classNamed: methodClassName].
	binding := methodClass fullBindingFor: aBindingReference pathString
				environment: (model classNamed: methodNode environment fullName).
	^binding notNil and: [binding value == class]!

buildParseTreeRewriter
	| newUnqualified rewriter oldUnqualified |
	rewriter := ParseTreeRewriter new.
	"Any real references to the variable will need to be rewritten using the minimally-qualified form that still binds to the same (renamed) variable."
	oldUnqualified := oldClassReference path last.
	rewriter
		replace: '`variable'
		withValueFrom: 
			[:variableNode |
			| node |
			RewriteTracing ifTrue: [self traceRewriteEnter: variableNode].
			node := self rewriteVariableReference: variableNode.
			RewriteTracing ifTrue: [self traceRewriteExit: variableNode].
			node]
		when: 
			[:variableNode |
			| string |
			string := variableNode name.
			(string first isUppercase or: [string first == $_]) and: 
					[| varRef index |
					varRef := variableNode name asQualifiedReference.
					"We need to consider potential matches anywhere in the binding path, e.g. when renaming a namespace."
					index := varRef path indexOf: oldUnqualified.
					index ~~ 0 and: 
							[RewriteTracing
								ifTrue: 
									[Transcript
										nextPutAll: 'Candidate variable reference: ';
										print: variableNode;
										nextPutAll: ' in ';
										display: variableNode methodNode;
										cr].
							self bindingReference: varRef refersToClassFrom: variableNode]]].
	"We replace any symbols naming the class if they are fully qualified (new namespaced class name), or if the class was in Smalltalk originally (i.e. legacy global namespace)'"
	rewriter
		replace: '`#literal'
		withValueFrom: 
			[:literalNode |
			| node |
			RewriteTracing ifTrue: [self traceRewriteEnter: literalNode].
			node := self rewriteLiteral: literalNode.
			RewriteTracing ifTrue: [self traceRewriteExit: node].
			node]
		when: [:literalNode | self isOldLiteralReference: literalNode].
	newUnqualified := newClassReference unqualifiedName.
	rewriter replaceArgument: newUnqualified
		withValueFrom: 
			[:aNode |
			self refactoringError: '<1s> already exists within the reference scope' << newUnqualified].
	^rewriter!

className: aName newName: aNewName
	"If the new name is unqualified, preserve the original namespace of the class."

	oldClassReference := aName asQualifiedReference.
	newClassReference := (BindingReference isQualifiedName: aNewName)
				ifTrue: [BindingReference pathString: aNewName]
				ifFalse: 
					[| parts |
					parts := oldClassReference path copy.
					parts at: parts size put: aNewName.
					BindingReference path: parts].
	super className: aName newName: newClassReference pathString.
	oldUnqualified := class unqualifiedName.
	hasSymbolRenames := false!

isOldLiteralReference: aStLiteralNode
	| literal |
	aStLiteralNode isLiteralArray
		ifTrue: 
			[^aStLiteralNode isForByteArray not and: 
					[aStLiteralNode contents
						anySatisfy: [:each | each isLiteralNode and: [self isOldLiteralReference: each]]]].
	aStLiteralNode isQualifiedReference
		ifTrue: [^self bindingReference: aStLiteralNode value refersToClassFrom: aStLiteralNode].
	literal := aStLiteralNode token value.
	"Symbolic references to the (unqualified) class name have historically been renamed, even though it isn't guaranteed that these are really intended for use as the class name. With namespaces, this is somewhat more dubious as now we have the potential for ambiguity; more than one class may have the same unqualified name. There are various choices we could make to decide whether to rename such unqualified symbolic references. Aside from the original 'rename all' stragegy, we could  rename only those that would bind in context. This would avoid some false positives, but might also result in some false negatives as it is based on the assumption that any attempt to bind the name will be performed in one particular binding context, whereas it might be of the form `InvisibleClasses at: #FoundMe`. Another alternative might be to add a refactoring option to prompt on each occurrence, but this could get annoying. Overall the best solution would seem to be to note that symbol renames are present in the changes, and then show the user a single warning with the option to view the changes in the changes browser."
	^literal isSymbol and: 
			["We only consider direct matches to the unqualified name or fully-qualified name for renaming. Partially qualified names cannot be present in legacy code, and are not a supported use in namespace aware code (partially qualified BindingReferences can be used). We don't really expect to encounter fully-qualified names as Symbols either, but since these are extremely likely to be class names, it would be perverse not to rename them."
			literal == oldUnqualified or: [literal == className and: [hasSymbolRenames := true]]]!

isOldVariableReference: variableNode
	| varRef |
	varRef := variableNode name asQualifiedReference.
	"It appears too lax to check just that the terminal name component (i.e. the unqualified name) is a match, rather than insisting that all parts of the path match the same number of final parts of the referenced class' name, but because there are multiple potential binding paths we would end up excluding references we should rename. For example, we can bind Core.Object from most other namespaces, as they generally have Core as a non-private import. This means that OS.Object is a legitimate reference to Core.Object. We check that the variable reference does actually bind to the target anyway."
	^varRef path last = oldClassReference path last
		and: [self bindingReference: varRef refersToClassFrom: variableNode]!

preconditions
	^(RBCondition withBlock: [class notNil and: [class isMeta not]]
		errorString: className , ' is not an existing class') 
			& (RBCondition isValidClassName: newName) 
			& (RBCondition hasNamespace: newName)
			& (RBCondition isGlobal: newName in: self model) not!

renameImports
	"Private - Update any imports of the class. Imports should always be fully-qualified, non-meta references, but they can be private."

	| newPrivate |
	newPrivate := newClassReference private.
	self model allClassesDo: 
			[:eachClass |
			eachClass isMeta
				ifFalse: 
					[(eachClass imports detect: [:each | each pathString = className] ifNone: nil)
						ifNotNil: 
							[:oldImport |
							eachClass
								addImport: (oldImport isPrivate ifTrue: [newPrivate] ifFalse: [newClassReference]);
								removeImport: oldImport]]]!

renameReferences: aCollectionOfRBMethods
	"Private - Note that renaming a class will rename any Symbols that happen to be the name of the class, whether directly held literals or embedded in literal arrays. To minimize the chance of renaming some arbitrary symbol or qualified reference that is not intended to refer to the renamed class, we only rename those that would actually bind to the class from the scope of each method. Even so, this is not strictly a refactoring as one cannot be certain that an arbitrary Symbol in a method that happens to be the same as a class name in scope in the method is actually intended for use as the name of that class. This is one good reason to use qualified references (aka BindingReferences) instead, since these are intended as references to classes so if they are bound to the original class, we can be almost certain that they should also be renamed. "

	| rewriter |
	"The old and new names are full names"
	rewriter := self buildParseTreeRewriter.
	self renameImports.
	aCollectionOfRBMethods do: 
			[:method |
			(method modelClass hierarchyDefinesVariable: newName)
				ifTrue: 
					[self refactoringError: '<1s> is already defined in hierarchy of <2p>'
								<< {newName. method modelClass printString}].
			self convertMethod: method using: rewriter]!

rewriteLiteral: aStLiteralNode
	| value |
	aStLiteralNode isLiteralArray ifTrue: [^self rewriteLiteralArray: aStLiteralNode].
	aStLiteralNode isQualifiedReference ifTrue: [^self rewriteQualifiedReferenced: aStLiteralNode].
	value := aStLiteralNode value.
	^value isSymbol
		ifTrue: [StLiteralValueNode value: (self rewriteSymbol: value)]
		ifFalse: [aStLiteralNode copy]!

rewriteLiteralArray: aStLiteralArrayNode
	aStLiteralArrayNode isForByteArray ifTrue: [^aStLiteralArrayNode copy].
	^StLiteralArrayNode
		contents: (aStLiteralArrayNode contents collect: [:each | self rewriteLiteral: each])!

rewriteQualifiedReferenced: aStLiteralNode
	| ref |
	ref := aStLiteralNode value.
	^(self bindingReference: ref refersToClassFrom: aStLiteralNode)
		ifTrue: [StLiteralValueNode value: (self rewriteReferenceName: ref)]
		ifFalse: [aStLiteralNode copy]!

rewriteReferenceName: aBindingReference
	| pathLength |
	pathLength := aBindingReference path size.
	^pathLength >= newClassReference path size
		ifTrue: [newClassReference]
		ifFalse: [BindingReference path: (newClassReference path last: pathLength)]!

rewriteSymbol: aSymbol
	"We match only the unqualified old name, and fully qualified old name."

	aSymbol == oldUnqualified ifTrue: [^class unqualifiedName].
	aSymbol == className ifTrue: [^newName].
	^aSymbol!

rewriteVariableReference: aStVariableNode
	^RBVariableNode named: (self nameForReferenceToClass: class fromNode: aStVariableNode)!

traceRewriteEnter: variableNode
	Transcript
		nextPutAll: 'Rewriting ';
		print: variableNode;
		nextPutAll: ' in ';
		display: variableNode methodNode;
		nextPutAll: ' ==> '!

traceRewriteExit: node
	Transcript
		print: node;
		cr!

transform
	self model
		renameClass: class
		to: newName
		around: [:methods | self renameReferences: methods]! !
!Tools.RenameNamespacedClassRefactoring categoriesForMethods!
bindingReference:refersToClassFrom:!helpers!private! !
buildParseTreeRewriter!private!transforming! !
className:newName:!initializing!private! !
isOldLiteralReference:!public! !
isOldVariableReference:!public! !
preconditions!accessing!public! !
renameImports!private!transforming! !
renameReferences:!private!transforming! !
rewriteLiteral:!private!transforming! !
rewriteLiteralArray:!private!transforming! !
rewriteQualifiedReferenced:!accessing!private! !
rewriteReferenceName:!private!transforming! !
rewriteSymbol:!private!transforming! !
rewriteVariableReference:!private!transforming! !
traceRewriteEnter:!private!transforming! !
traceRewriteExit:!private!transforming! !
transform!public!transforming! !
!

