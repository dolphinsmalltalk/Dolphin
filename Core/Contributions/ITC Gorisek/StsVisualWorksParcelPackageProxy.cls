"Filed out from Dolphin Smalltalk X6.2"!

StsPackageProxy subclass: #StsVisualWorksParcelPackageProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsVisualWorksParcelPackageProxy guid: (GUID fromString: '{8DB019A3-AAAA-4E2C-A5B5-60FFD062BA5A}')!
StsVisualWorksParcelPackageProxy comment: ''!
!StsVisualWorksParcelPackageProxy categoriesForClass!Unclassified! !
!StsVisualWorksParcelPackageProxy methodsFor!

classNameFromVW: fullClassName 
	| className index lastIndex |
	index := 1.
	lastIndex := fullClassName size.
	1 to: fullClassName size
		do: 
			[:i | 
			(fullClassName at: i) = $. ifTrue: [index := i + 1].
			(fullClassName at: i) = $  ifTrue: [lastIndex := i - 1]].
	^(fullClassName copyFrom: index to: lastIndex) asSymbol!

findOrCreateVWClassNamed: fullClassName 
	^self findOrCreateClassNamed: (self classNameFromVW: fullClassName)!

importClassComment: xmlNode 
	| classProxy classComment |
	comment := ''.
	xmlNode childNodes do: 
			[:eachNode | 
			eachNode nodeName = 'class-id' 
				ifTrue: [classProxy := self findOrCreateVWClassNamed: eachNode text]
				ifFalse: 
					[eachNode nodeName = 'body' ifTrue: [classComment := eachNode text withNormalizedLineDelimiters]]].
	classProxy isNil ifFalse: [classProxy comment: classComment]!

importClassDefinition: xmlNode 
	| className superClass classProxy instVars classInstVars |
	instVars := ''.
	classInstVars := ''.
	xmlNode childNodes do: 
			[:eachNode | 
			eachNode nodeName = 'name' 
				ifTrue: [className := eachNode text]
				ifFalse: 
					[eachNode nodeName = 'super' 
						ifTrue: [superClass := self classNameFromVW: eachNode text]
						ifFalse: 
							[eachNode nodeName = 'inst-vars' 
								ifTrue: [instVars := eachNode text]
								ifFalse: 
									[eachNode nodeName = 'class-inst-vars' 
										ifTrue: [classInstVars := eachNode text]
										ifFalse: [eachNode nodeName = 'indexed-type' ifTrue: [] ifFalse: []]]]]].
	(superClass isNil or: [superClass isEmpty]) ifTrue: [superClass := 'nil'].
	classProxy := self findOrCreateClassNamed: className asSymbol.
	classProxy
		definition: superClass , ' subclass: #' , className , '
	instanceVariableNames: ''' , instVars 
					, '''
	classVariableNames: ''''
	poolDictionaries: ''''
	classInstanceVariableNames: ''' 
						, classInstVars , '''';
		comment: ''!

importMethods: xmlNode 
	| classProxy method category isLoose className |
	xmlNode childNodes do: 
			[:eachNode | 
			eachNode nodeName = 'class-id' 
				ifTrue: 
					[className := self classNameFromVW: eachNode text.
					classProxy := self classNamed: className.
					(isLoose := classProxy isNil) ifTrue: [classProxy := StsClassProxy new name: className].
					eachNode text subStrings size = 2 ifTrue: [classProxy := classProxy metaClass]	"Class class"]
				ifFalse: 
					[eachNode nodeName = 'category' 
						ifTrue: [category := eachNode text]
						ifFalse: 
							[eachNode nodeName = 'body' 
								ifTrue: 
									[method := (StsCompiledMethodProxy new)
												methodSource: eachNode text withNormalizedLineDelimiters;
												methodClass: classProxy;
												isPrivate: false.
									category isNil ifFalse: [method categoriesString: category , '!!'].
									classProxy methodDictionary at: method selector put: method.
									isLoose ifTrue: [looseMethods add: method]]]]]!

loadFrom: pathname 
	| doc root ignoreClassTag |
	classes := OrderedCollection new.
	looseMethods := OrderedCollection new.
	prerequisiteNames := OrderedCollection new.
	version := ''.
	comment := ''.
	resources := OrderedCollection new.
	doc := IXMLDOMDocument new.
	name := File removeExtension: (File splitFilenameFrom: pathname).
	doc load: pathname.
	root := doc documentElement.
	ignoreClassTag := false.
	root childNodes do: 
			[:eachNode | 
			(eachNode nodeName = 'class' and: [ignoreClassTag not]) 
				ifTrue: [self importClassDefinition: eachNode]
				ifFalse: 
					[eachNode nodeName = 'comment' 
						ifTrue: [self importClassComment: eachNode]
						ifFalse: 
							[eachNode nodeName = 'methods' 
								ifTrue: 
									[ignoreClassTag := true.
									self importMethods: eachNode]
								ifFalse: 
									[eachNode nodeName = '#comment' 
										ifTrue: [comment := eachNode text withNormalizedLineDelimiters]
										ifFalse: [eachNode nodeName = 'time-stamp' ifTrue: [version := eachNode text]]]]]]!

manualPrerequisites
	^#()! !
!StsVisualWorksParcelPackageProxy categoriesFor: #classNameFromVW:!public! !
!StsVisualWorksParcelPackageProxy categoriesFor: #findOrCreateVWClassNamed:!public! !
!StsVisualWorksParcelPackageProxy categoriesFor: #importClassComment:!public! !
!StsVisualWorksParcelPackageProxy categoriesFor: #importClassDefinition:!public! !
!StsVisualWorksParcelPackageProxy categoriesFor: #importMethods:!public! !
!StsVisualWorksParcelPackageProxy categoriesFor: #loadFrom:!public! !
!StsVisualWorksParcelPackageProxy categoriesFor: #manualPrerequisites!public! !

