"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #LightsOutGame
	instanceVariableNames: 'cellPresenters'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LightsOutGame guid: (GUID fromString: '{BEB54F56-314C-4E39-A83B-9DD791F017E1}')!
LightsOutGame comment: ''!
!LightsOutGame categoriesForClass!Unclassified! !
!LightsOutGame methodsFor!

clearExistingCellPresenters
	cellPresenters do: [:each | each destroy].!

createCellPresenters
	self clearExistingCellPresenters.
	self view layoutManager rows: self model size.
	self model cells do: 
			[:eachCell | 
			| cp |
			cp := LightsOutCell createIn: self on: eachCell.
			cellPresenters add: cp.
			cp when: #cellAction perform: [self toggleNeighborsOf: cp]]!

initialize
	super initialize.
	cellPresenters := OrderedCollection new!

model: aLightsOutBoard 
	super model: aLightsOutBoard.
	self hasView ifTrue: [self createCellPresenters]!

neighborsOf: aLightsOutCellPresenter 
	| cpRect |
	cpRect := aLightsOutCellPresenter view rectangle.
	^cellPresenters select: 
			[:each | 
			| eachRect |
			eachRect := each view rectangle.
			eachRect rightCenter = cpRect leftCenter | (eachRect leftCenter = cpRect rightCenter) 
				| (eachRect topCenter = cpRect bottomCenter) | (eachRect bottomCenter = cpRect topCenter)]!

onViewOpened
	super onViewOpened.
	self createCellPresenters!

toggleNeighborsOf: aLightsOutCellPresenter 
	(self neighborsOf: aLightsOutCellPresenter) do: [:eachCell | eachCell toggle]! !
!LightsOutGame categoriesFor: #clearExistingCellPresenters!private! !
!LightsOutGame categoriesFor: #createCellPresenters!private! !
!LightsOutGame categoriesFor: #initialize!private! !
!LightsOutGame categoriesFor: #model:!public! !
!LightsOutGame categoriesFor: #neighborsOf:!private! !
!LightsOutGame categoriesFor: #onViewOpened!private! !
!LightsOutGame categoriesFor: #toggleNeighborsOf:!private! !

!LightsOutGame class methodsFor!

defaultModel
	^LightsOutBoard new!

icon

	"Generated from:
	self createIconMethod: #icon ofSize: 48@48 fromFile: 'C:\Users\Administrator\Desktop\LightsOutGame.png'.
	"
	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 1 227 73 68 65 84 104 67 237 90 61 75 3 65 16 61 109 197 127 16 144 52 98 97 161 22 41 45 237 5 75 27 59 11 209 78 139 32 228 138 216 157 4 68 12 34 8 54 42 8 118 138 24 196 34 162 133 177 136 118 193 20 138 22 130 141 216 234 200 11 65 150 147 155 123 200 133 187 98 138 169 246 237 206 206 206 206 199 190 59 207 43 137 48 178 116 18 200 106 173 20 41 51 7 135 146 91 127 82 49 152 15 12 163 175 207 255 142 93 107 106 239 84 60 102 49 96 30 94 135 229 253 99 48 82 118 27 179 82 216 190 81 49 152 15 12 163 179 223 255 138 93 171 124 185 98 6 252 158 146 121 32 20 139 118 133 194 129 102 65 220 205 96 169 101 161 90 107 82 238 95 70 34 37 168 47 202 216 214 157 138 193 124 96 216 52 170 233 195 216 242 217 26 159 70 25 165 169 96 138 231 190 180 222 134 84 65 70 96 54 55 81 189 141 93 11 152 141 235 121 21 87 111 23 40 125 157 61 161 154 105 21 22 99 172 1 108 37 70 205 208 116 34 97 48 7 102 6 132 79 201 60 208 77 181 118 133 194 1 102 65 236 188 35 16 39 137 102 161 233 253 35 169 92 45 168 130 215 17 147 214 242 149 118 236 90 192 204 29 239 168 56 255 162 72 233 235 236 137 217 24 48 163 155 77 25 175 54 34 37 95 121 148 129 242 167 138 193 124 96 88 157 154 62 140 229 130 103 222 0 235 70 211 238 70 205 3 230 129 191 148 142 209 42 110 197 54 90 165 215 180 74 102 11 25 219 74 160 188 107 45 7 218 3 182 194 38 218 74 176 79 74 166 14 176 6 36 218 204 153 1 221 2 133 83 53 15 244 242 73 105 49 224 228 121 11 98 183 232 177 212 34 232 62 141 130 4 93 200 6 113 162 212 34 171 52 179 56 80 212 113 52 54 104 149 204 210 235 73 22 50 150 90 100 188 73 127 35 51 3 156 74 108 30 112 210 163 93 33 247 185 136 211 96 90 9 187 66 255 185 66 248 101 69 251 141 6 99 32 119 179 250 187 205 15 252 151 91 161 20 103 86 240 0 0 0 0 73 69 78 68 174 66 96 130]!

initialize
	"Private - 
	self initialize
	"
	Smalltalk developmentSystem addSamplesFolderIconFor: self description: 'Lights Out'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 26607617 131073 416 0 196934 1 ##(Smalltalk.RGB)  33488897 0 39 0 0 0 416 656390 ##(Smalltalk.GridLayout)  3 3 1 1 234 256 98 0 0 0 0 0 0 1 0 0 0 0 1 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  3839 21 706 891 871 416 642 8 #text: 98 1 8 'Lights Out' 416 642 8 #updateMenuBar 560 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 60 9 0 0 189 1 0 0] 98 0 706 193 193 0 27 )!

uninitialize
	Smalltalk developmentSystem removeSystemFolderIconNamed: 'Lights Out'! !
!LightsOutGame class categoriesFor: #defaultModel!public! !
!LightsOutGame class categoriesFor: #icon!constants!public! !
!LightsOutGame class categoriesFor: #initialize!private! !
!LightsOutGame class categoriesFor: #resource_Default_view!public!resources-views! !
!LightsOutGame class categoriesFor: #uninitialize!private! !

