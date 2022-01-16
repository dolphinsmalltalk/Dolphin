"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassRefactoring subclass: #'Tools.RenameClassRefactoring'
	instanceVariableNames: 'newName class newClassReference oldUnqualified classBinding'
	classVariableNames: ''
	imports: #(#{Refactory.Browser})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RenameClassRefactoring guid: (Core.GUID fromString: '{b0780f17-9017-4316-92eb-789b160450c5}')!
Tools.RenameClassRefactoring comment: '`RenameClassRefactoring` is based on the original Refactory implementation, but is is Namespace aware.

Renaming classes with namespaces and qualified names is considerably more complicated than renames in traditional Smalltalk with a single global namespace, because binding resolution is much more than just a single dictionary lookup. There are multiple ways to refer to the same class using unqualified, partially-qualified and fully-qualified names. The same unqualified and partially-qualified names may bind to different variables in different contexts. Ambiguous references are possible for partially-qualified and unqualified names, so whether a particular identifier needs to be renamed depends on its binding context, i.e. whether it actually would have bound to the class being renamed prior to the rename. Given the need to consider binding context, setting up specific static searches in advance is not terribly useful, as we''ll still need to check the actual binding resolution for each candidate match to see if it really is a match. This means we need to perform a much broader match against variable references in methods that are referencing the renamed class, and then decide individually whether to rename them. We also need to consider the binding context when deciding how to rename them. Although we could always rename to a fully qualified name, this will make the code more verbose than it may need to be (a bit like using someone''s full name every time one refers to them). Therefore the refactoring attempts to use the least qualified variant of the new name that will still bind to the same (renamed) class. _Maybe minimising previously fully-qualified names should be an option, TBD_.

The original `RenameClassRefactoring` renamed references in code that were direct references to the class in question, but also symbolic references using the (unqualified) class name. The renaming of symbolic references has always been a bit questionable from a _refactorings must preserve behaviour_ perspective since it is possible that another `Symbol` used for another purpose just happens to be the name of a class being renamed. This was fairly unlikely, but the assumption that all `Symbol`s that look like class names and match a class name, must be class names, is not guaranteed to be true. We now have `BindingReference`s, so the former use of plain `Symbol`s for the purpose of late bound lookups has been superseded. We know that the name components of a `BindingReference`  must be the names of program objects (actually static variables) since this is the explicit purpose of `BindingReference`s. In Dolphin `Namespace`s are just classes, so all but the final component of a `BindingReference` path must be class names. The final component of the name is usually a class name, but may also refer to other static variables in the namespace referred to by the path up to that terminal component. As the non-terminal components of a qualified `BindingReference` must be classes, then these are candidates to rename if they would have bound to the class being renamed at some point along the path. 

The renaming of `Symbol`s is no longer performed. In order to assist migrating code into namespaces, which will typically involve renaming classes out of Smalltalk and into some other namespace, any symbolic lookups of the renamed class in the `Smalltalk` "dictionary" are first refactored into literal `BindingReferences`. Not all such lookups can be readily identified, so some symbolic references may remain. Where this is the case a refactoring option is used to warn the user and allow them to choose how to proceed.

Renaming a class in Dolphin can change any of the components (and any number of them) of the fully qualified name of a class. Unless it is only the leaf identifier (aka the short name, or unqualified name) that is changed, then the class is effectively moved to a different `Namespace`. When moving a class to a new `Namespace` it is entirely possible that unqualified and partially qualified names in the methods of the class itself will either no longer bind at all, or will bind to different static variables (where there is ambiguity and some part of the name is not globally unique). This means we must also rewrite the renamed class'' own methods, updating any variable references as required to maintain the previous binding. As with the references to the class being renamed, the references in the class being renamed should also have a minimal form after renaming.

Renaming a class in such a way as to change its `Namespace` can result in ambiguous references that cannot be resolved. This is regarded as a refactoring error that will fail the refactoring abandoning any changes.
'!
!Tools.RenameClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Tools.RenameClassRefactoring methodsFor!

buildReferenceRewriter
	| newUnqualified rewriter |
	rewriter := ParseTreeRewriter new.
	"Any real references to the variable will need to be rewritten using a form that still binds to the same (renamed) variable."
	rewriter
		replace: '`identifier'
		withValueFrom: [:variableNode | self rewriteVariable: variableNode]
		when: [:variableNode | variableNode isBindingChanged].
	"We rewrite any BindingReferences that bind to class before it is renamed, even if embedded in literal arrays. Symbols are not renamed."
	rewriter
		replace: '`#literal'
		withValueFrom: [:literalNode | self rewriteLiteral: literalNode]
		when: [:literalNode | self isImpactedLiteral: literalNode].
	newUnqualified := newClassReference unqualifiedName.
	rewriter replaceArgument: newUnqualified
		withValueFrom: 
			[:aNode |
			self refactoringError: '<1s> already exists within the reference scope' << newUnqualified].
	^rewriter!

checkForSymbolicReferences
	| symbolicRefs |
	symbolicRefs := model allReferencesTo: oldUnqualified.
	symbolicRefs isEmpty ifFalse: [
		self shouldIgnoreRemainingSymbolicReferences: symbolicRefs]!

className: oldString newName: newString
	"If the new name is unqualified, preserve the original namespace of the class."

	newClassReference := (BindingReference isQualifiedName: newString)
				ifTrue: [BindingReference pathString: newString]
				ifFalse: 
					[| parts |
					parts := oldString asQualifiedReference path.
					parts at: parts size put: newString.
					BindingReference path: parts].
	self className: oldString.
	newName := newClassReference pathString.
	class := self model classNamed: className.
	oldUnqualified := class unqualifiedName.
	classBinding := class globalScope fullBindingFor: oldString environment: class environment!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: 'Rename class ';
		nextPutAll: className;
		nextPutAll: ' to ';
		nextPutAll: newName!

getOptionIgnoreSymbolicClassReferences: aCollection
	| details response |
	details := String writeStream.
	details
		nextPutAll: 'The following methods still reference the original unqualified class name symbol ';
		print: oldUnqualified;
		nextPut: $:;
		cr.
	self
		printNameList: (aCollection asArray collect: [:each | each printString]) sort
		on: details
		limit: self maxDetails // 2
		type: 'methods'.
	response := UI.MessageBox new
				caption: self displayString;
				headline: 'Class may have symbolic references.';
				text: 'The original class name ''<1s>'' may still be referenced symbolically in <2d> methods. If you proceed with the class rename these Symbols will not be renamed as it cannot be guaranteed that these are intended as references to the class being renamed.<n><n>It is recommended that you first browse all references to understand the use, and replace any real references to the class with literal BindingReferences.'
							<< {oldUnqualified. aCollection size};
				customButtons: #(#(#yes '&Rename Class') #(#no '&Browse Methods'));
				defaultButton: 2;
				detailsText: details contents;
				iconStyle: #warning;
				confirmOrCancel.
	response == #yes ifTrue: [^true].
	response == #no
		ifTrue: 
			[self openBrowserOn: ((self model environment forMethods: aCollection)
						label: 'Remaining references to class being renamed from <1p>' << oldUnqualified;
						yourself)].
	^false!

isImpactedLiteral: aStLiteralNode
	aStLiteralNode isLiteralArray
		ifTrue: 
			[^aStLiteralNode contents
				anySatisfy: [:each | each isLiteralNode and: [self isImpactedLiteral: each]]].
	aStLiteralNode isQualifiedReference
		ifTrue: 
			[| binding |
			binding := aStLiteralNode binding.
			^binding == classBinding or: 
					["Any qualified reference that now binds differently is impacted and needs rewriting"
					aStLiteralNode isRelative and: [aStLiteralNode resolveBinding ~~ binding]]].
	^false!

preconditions
	^(RBCondition withBlock: [class notNil and: [class isMeta not]]
		errorString: className , ' is not an existing class') & (RBCondition isValidClassName: newName)
		& (RBCondition hasNamespace: newName) & (RBCondition isStatic: newName in: self model) not!

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

renameInboundReferences: aCollectionOfRBMethods
	"Private - Note that renaming a class will no longer rename any Symbols that happen to be the name of the class, whether directly held literals or embedded in literal arrays. This was never strictly a refactoring as Symbols are not necessarily the names of program objects, so one cannot be certain that an arbitrary Symbol in a method that happens to be the same as a class name in scope in the method is actually intended for use as the name of that class. This is one good reason to use qualified references (aka BindingReferences) instead, since these are intended as references to classes so if they are bound to the original class, we can be certain that they should also be renamed. "

	| rewriter |
	rewriter := self buildReferenceRewriter.
	self renameImports.
	aCollectionOfRBMethods do: [:method | self convertMethod: method using: rewriter]!

rewriteLiteral: aStLiteralNode
	aStLiteralNode isLiteralArray ifTrue: [^self rewriteLiteralArray: aStLiteralNode].
	aStLiteralNode isQualifiedReference ifTrue: [^self rewriteQualifiedReference: aStLiteralNode].
	^aStLiteralNode copy!

rewriteLiteralArray: aStLiteralArrayNode
	^StLiteralArrayNode
		contents: (aStLiteralArrayNode contents collect: [:each | self rewriteLiteral: each])!

rewriteQualifiedReference: aStQualifiedReferenceNode
	| targetBinding pathString path i methodNode |
	targetBinding := aStQualifiedReferenceNode binding.
	targetBinding == classBinding
		ifFalse: 
			[^aStQualifiedReferenceNode isBindingChanged
				ifTrue: 
					[StQualifiedReferenceNode
						pathString: targetBinding fullName
						start: nil
						flags: aStQualifiedReferenceNode flags]
				ifFalse: [aStQualifiedReferenceNode copy]].
	aStQualifiedReferenceNode isRelative
		ifFalse: 
			["Previous fully qualified reference, just answer the new fully-qualifed reference"
			^StQualifiedReferenceNode
				pathString: class fullName
				start: nil
				flags: aStQualifiedReferenceNode flags].
	"Relative bindings are more complex - for now do the brute force implementation that should always work, and just keep adding qualification to the path until it binds, or we reach the fully-qualified path anyway."
	methodNode := aStQualifiedReferenceNode methodNode.
	path := newClassReference path.
	i := path size.
	pathString := ''.
	
	[pathString := (path at: i) , pathString.
	(methodNode fullBindingFor: pathString) == targetBinding
		ifTrue: 
			[^StQualifiedReferenceNode
				pathString: (i == path size ifTrue: [pathString] ifFalse: ['_.' , pathString])
				start: nil
				flags: aStQualifiedReferenceNode flags].
	i > 2]
			whileTrue: 
				[i := i - 1.
				pathString := BindingReference.PathSeparatorString , pathString].
	^StQualifiedReferenceNode
		pathString: newClassReference pathString
		start: nil
		flags: aStQualifiedReferenceNode flags!

rewriteSymbolicReferencesToClass
	"Private - If renaming a class that is currently in Smalltalk into another Namespace, we first rewrite any definite symbolic references to the class into literal binding references."

	| rewriteClassNames symbolicRefs |
	(classBinding environment == self model smalltalkNamespace
		and: [newClassReference environment ~~ classBinding environment])
			ifTrue: 
				[rewriteClassNames := ClassNameToBindingReferenceRefactoring model: model
							replaceSymbolicReferencesTo: class.
				self performComponentRefactoring: rewriteClassNames].
	"self halt."
	symbolicRefs := model allReferencesTo: oldUnqualified.
	symbolicRefs isEmpty
		ifFalse: 
			[(self shouldIgnoreRemainingSymbolicReferences: symbolicRefs) ifFalse: [self refactoringAborted]]!

rewriteVariable: aStVariableNode
	^aStVariableNode binding == classBinding
		ifTrue: 
			[| unqualifiedName |
			"The static variable is the renamed class' binding - try and shorten to an unqualified name if we can (iff it binds to the class from the method)"
			unqualifiedName := class unqualifiedName.
			"Even if the method's environment is the same, it may be shadowed by a same named class variable in the referencing class, so we have to check."
			StVariableNode named: ((aStVariableNode methodNode fullBindingFor: unqualifiedName) == classBinding
						ifTrue: [unqualifiedName]
						ifFalse: 
							["We don't bother to try and find a partially qualified name that will bind correctly, but just use the fully-qualified name"
							newName])]
		ifFalse: 
			["The static variable is not the renamed class' binding, but we may need to rewrite it if it can no longer be resolved using an unqualified or partially qualified name"
			aStVariableNode isBindingChanged
				ifTrue: [StVariableNode named: aStVariableNode binding fullName]
				ifFalse: [aStVariableNode copy]]!

shouldIgnoreRemainingSymbolicReferences: aCollection
	^(self lookupOption: #ignoreSymbolicClassReferences) cull: self cull: aCollection!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' rename: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' to: ';
		print: newName;
		nextPut: $)!

transform
	self rewriteSymbolicReferencesToClass.
	self model
		renameClass: class
		to: newName
		around: [:inbound | self renameInboundReferences: inbound]! !
!Tools.RenameClassRefactoring categoriesForMethods!
buildReferenceRewriter!private!transforming! !
checkForSymbolicReferences!private!transforming! !
className:newName:!initializing!private! !
displayOn:!displaying!public! !
getOptionIgnoreSymbolicClassReferences:!options!public! !
isImpactedLiteral:!helpers!private! !
preconditions!accessing!public! !
renameImports!private!transforming! !
renameInboundReferences:!private!transforming! !
rewriteLiteral:!private!transforming! !
rewriteLiteralArray:!private!transforming! !
rewriteQualifiedReference:!private!transforming! !
rewriteSymbolicReferencesToClass!private!transforming! !
rewriteVariable:!private!transforming! !
shouldIgnoreRemainingSymbolicReferences:!options!private! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Tools.RenameClassRefactoring class methodsFor!

model: aRBModel rename: aClass to: aNewName
	^self new
		model: aRBModel;
		className: aClass fullName newName: aNewName;
		yourself!

rename: aClass to: aNewName
	^self new className: aClass fullName newName: aNewName! !
!Tools.RenameClassRefactoring class categoriesForMethods!
model:rename:to:!instance creation!public! !
rename:to:!instance creation!public! !
!

