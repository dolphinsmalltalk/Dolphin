"Filed out from Dolphin Smalltalk X6.1"!

HtmlElement subclass: #HtmlNavigationTabs
	instanceVariableNames: 'items selectedIndex selectedTask'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlNavigationTabs guid: (GUID fromString: '{06FBD055-F98F-4A35-9453-B6302FFF6EAF}')!
HtmlNavigationTabs comment: ''!
!HtmlNavigationTabs categoriesForClass!Unclassified! !
!HtmlNavigationTabs methodsFor!

addItem: tabLabel task: task action: action 
	"For compatibility with menus."

	^self 
		addTab: tabLabel
		task: task
		action: action!

addItem: tabLabel task: task action: action tooltip: str 
	"For compatibility with menus."

	^self 
		addTab: tabLabel
		task: task
		action: action!

addMenuTitle: aString 
	"For compatibility with menus. Do nothing."

	!

addTab: tabLabel task: task action: action 
	items isNil 
		ifTrue: 
			[items := OrderedCollection new.
			selectedTask := task].
	items add: (Array 
				with: tabLabel webTranslate
				with: task taskURLPrefix , '?action=' , action webAsActionString
				with: task
				with: action webAsActionString)!

generateOn: stream 
	| marked label |
	Processor activeProcess attributes at: #includeCssForTabs put: true.
	marked := false.
	stream nextPutAll: '<div class="tabs">'.
	items do: 
			[:each | 
			stream
				nextPutAll: '<a href="';
				nextPutAll: (each at: 2).
			((self isSelectedItem: each) and: [marked not]) 
				ifTrue: 
					[marked := true.
					stream nextPutAll: '" class="selected">']
				ifFalse: [stream nextPutAll: '">'].
			label := each at: 1.
			((label includes: $-) or: [label includes: $/]) 
				ifTrue: 
					[stream
						nextPutAll: '<span style="white-space:nowrap;">';
						nextPutAll: (each at: 1) webHtmlEncoded;
						nextPutAll: '</span>']
				ifFalse: [stream nextPutAll: (each at: 1) webHtmlEncoded asHtmlString].
			stream nextPutAll: '</a> '].
	stream nextPutAll: '</div>'!

isSelectedItem: anItem 
	selectedIndex isNil ifFalse: [^selectedIndex = (items indexOf: anItem)].
	selectedTask isNil ifFalse: [^selectedTask == (anItem at: 3)].
	^(items indexOf: anItem) = 1!

items
	^items!

selectedAction: action 
	items doWithIndex: 
			[:eachItem :index | 
			('*action=' , action webAsActionString , '*' match: (eachItem at: 2)) 
				ifTrue: [^self selectedIndex: index]]!

selectedIndex
	^selectedIndex!

selectedIndex: anInteger 
	selectedIndex := anInteger.
	selectedTask := nil!

selectedTask: aWebTask 
	selectedTask := aWebTask.
	selectedIndex := nil!

selectedTask: aWebTask action: action 
	action isNilOrEmpty 
		ifFalse: 
			[items doWithIndex: 
					[:eachItem :index | 
					((eachItem at: 3) == aWebTask 
						and: ['*action=' , action webAsActionString , '*' match: (eachItem at: 2)]) 
							ifTrue: [^self selectedIndex: index]].
			(selectedIndex notNil and: [selectedIndex > 0 and: [selectedIndex <= items size]]) 
				ifTrue: [((items at: selectedIndex) at: 3) == aWebTask ifTrue: [^self]]].
	self selectedTask: aWebTask!

size
	^items isNilOrEmpty ifTrue: [0] ifFalse: [items size]!

taskList
	^items isNil 
		ifTrue: [#()]
		ifFalse: [(items collect: [:each | each at: 3]) select: [:each | each isKindOf: WebTask]]! !
!HtmlNavigationTabs categoriesFor: #addItem:task:action:!menu compatibility!public! !
!HtmlNavigationTabs categoriesFor: #addItem:task:action:tooltip:!menu compatibility!public! !
!HtmlNavigationTabs categoriesFor: #addMenuTitle:!menu compatibility!public! !
!HtmlNavigationTabs categoriesFor: #addTab:task:action:!public! !
!HtmlNavigationTabs categoriesFor: #generateOn:!public! !
!HtmlNavigationTabs categoriesFor: #isSelectedItem:!public! !
!HtmlNavigationTabs categoriesFor: #items!public! !
!HtmlNavigationTabs categoriesFor: #selectedAction:!public! !
!HtmlNavigationTabs categoriesFor: #selectedIndex!public! !
!HtmlNavigationTabs categoriesFor: #selectedIndex:!public! !
!HtmlNavigationTabs categoriesFor: #selectedTask:!public! !
!HtmlNavigationTabs categoriesFor: #selectedTask:action:!public! !
!HtmlNavigationTabs categoriesFor: #size!public! !
!HtmlNavigationTabs categoriesFor: #taskList!public! !

