"Filed out from Dolphin Smalltalk 7"!

AbstractPublishedAspectInspector subclass: #PropertyInspector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PropertyInspector guid: (GUID fromString: '{35bdcf77-b398-4b3b-bd3a-9675f82870d6}')!
PropertyInspector comment: 'A new version of the Published Aspect Inspector that uses a more traditional hierarchical list pane to edit properties (published aspects) in situ. Doesn''t provide the PAI functionality of rendering separate displays of the aspect being aspected. Should be plug-compatible with retro uses of the PAI.

'!
!PropertyInspector categoriesForClass!Development!MVP-Resources-IDE Tools! !
!PropertyInspector methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	aspectPresenter := self add: ValueWorkspace new name: 'workspace'!

onAspectActioned
	"Event handler for an action being performed on the current aspect, i.e. Enter or double-click"

	self aspectAccessor canImmediateAction 
		ifTrue: [^self aspectAccessor immediateActionUsing: aspectPresenter].
	self popupEditAspect!

onAspectSelected
	"Private - An aspect accessor has been selected within the aspect tree. Transfer the new aspect value
	to our local aspectValueModel buffer and then create the appropriate aspect presenters."

	self aspectAccessor 
		ifNil: 
			["Replacing the entire value model avoids any chance of any old observers seeing future change events"
			aspectValueHolder := nil]
		ifNotNil: [:accessor | accessor selectIn: self]!

popupEditAspect
	"Action the currently selected aspect using the current aspect presenter"

	| aspectDialog |
	aspectDialog := AspectEditorDialog createOn: nil asValue.

	"To avoid visual shock, make sure the dialog font is the same as that of our aspectTreePresenter"
	aspectDialog view font: aspectTreePresenter view font.

	"Ensure the aspect is visible"
	aspectTreePresenter ensureSelectionVisible.
	aspectDialog recommendedRectangle: self selectedAspectValueRect.
	aspectDialog createAspectPresenters: self aspectAccessor for: aspectValueHolder.
	^aspectDialog showModal!

selectAspect: anAspectAccessor 
	"Private - Replacing the entire value model avoids any chance of any old observers seeing future change events"

	self createValueHolderFor: anAspectAccessor.
	aspectPresenter model: aspectValueHolder!

selectedAspectValueRect
	"Private - Answer a screen rectangle bounding the value area of the selected aspect "

	| aspectListView rect |
	aspectListView := aspectTreePresenter view.
	rect := aspectListView subItemRectRow: aspectListView selectionByIndex column: 2.
	^View 
		mapRectangle: rect
		from: aspectListView
		to: View desktop! !
!PropertyInspector categoriesFor: #createComponents!private! !
!PropertyInspector categoriesFor: #onAspectActioned!event handling!private! !
!PropertyInspector categoriesFor: #onAspectSelected!private! !
!PropertyInspector categoriesFor: #popupEditAspect!operations!public! !
!PropertyInspector categoriesFor: #selectAspect:!private! !
!PropertyInspector categoriesFor: #selectedAspectValueRect!private! !

!PropertyInspector class methodsFor!

editButtonImageIndexFor: anAspectAccessor 
	"Answers te image index for an edit button for anAspectAccessor (if any). Used in the
	PropertyInspector aspects view pane to display an edit button where appropriate. Answers -1
	if no such button is required"

	| aspect |
	aspect := anAspectAccessor aspectDescriptor.
	(aspect canEdit and: [aspect canImmediateAction not]) ifFalse: [^-1].
	^self ellipsisButtonIcon imageIndex!

ellipsisButtonIcon
	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 7 48 73 68 65 84 104 67 237 153 123 76 147 103 20 198 167 67 119 113 110 89 150 5 55 201 150 37 243 15 93 182 37 222 69 16 221 80 1 29 211 57 220 69 153 243 50 47 219 220 98 116 19 227 240 54 141 83 163 67 5 229 170 40 114 171 208 10 8 222 80 81 17 16 4 202 165 148 123 91 74 41 55 65 157 215 144 120 118 158 23 170 224 90 63 253 67 248 150 216 228 73 155 190 167 239 249 61 231 188 223 73 251 245 185 231 158 61 158 85 224 89 5 172 86 64 81 92 220 55 241 88 234 226 120 85 242 185 152 184 196 91 177 113 137 212 157 66 206 120 101 242 185 164 148 147 75 82 82 82 94 120 162 54 157 58 117 225 29 69 92 162 58 237 66 22 213 153 27 169 173 173 141 238 221 187 215 173 66 78 228 6 67 180 226 136 58 33 225 196 123 143 101 2 110 1 175 46 44 165 219 119 219 232 214 157 54 186 118 227 46 93 189 126 167 91 133 156 200 13 6 176 68 198 42 11 214 250 251 191 34 105 34 94 149 178 52 245 108 6 181 92 187 45 84 223 124 163 71 101 225 0 211 162 37 75 87 120 121 121 61 255 72 19 138 184 164 204 178 202 26 106 108 185 41 192 205 61 44 48 128 5 76 126 187 246 230 56 56 56 188 244 72 3 81 49 202 155 230 134 86 50 55 253 35 47 49 83 100 140 234 22 195 191 206 234 109 211 68 180 66 69 141 205 87 169 174 241 186 172 4 38 176 49 248 0 23 23 23 59 171 6 136 168 87 84 172 138 26 56 216 212 112 77 86 2 19 216 24 124 224 176 97 195 250 216 52 16 25 163 164 134 166 86 50 213 95 165 90 153 8 44 96 2 27 131 59 72 24 136 167 122 14 174 53 183 146 81 38 2 11 152 34 99 226 165 13 28 138 102 3 141 45 100 172 107 161 26 153 8 44 96 2 27 58 48 100 200 144 190 54 143 80 68 84 28 213 55 48 188 233 10 25 100 34 176 128 9 108 143 97 224 48 153 27 0 223 76 250 90 121 8 44 96 138 136 58 44 109 224 96 36 27 168 7 120 19 233 140 242 16 88 192 4 54 201 14 28 56 164 160 58 14 214 25 27 169 186 70 30 2 11 152 192 38 109 32 34 150 71 104 51 195 55 80 149 65 30 2 11 152 14 48 155 164 129 240 136 24 50 153 155 24 190 158 42 245 242 16 88 192 4 54 73 3 251 15 182 27 168 212 155 169 82 39 19 49 11 152 192 38 105 96 223 129 104 170 173 107 164 10 134 175 208 213 201 68 102 193 4 54 105 3 225 81 237 6 170 235 168 92 38 2 139 48 192 108 146 6 194 194 35 201 104 106 160 242 42 19 149 85 213 202 66 96 1 19 216 36 13 132 238 63 68 53 181 245 252 3 194 72 218 10 121 8 44 96 2 155 164 129 144 125 237 6 74 43 106 72 91 46 15 129 5 76 96 147 54 16 22 65 6 14 6 124 73 185 225 190 138 180 85 148 87 168 165 156 188 34 202 206 45 164 188 2 45 225 189 206 49 150 215 133 37 149 188 94 66 57 28 7 229 243 143 242 226 210 106 235 177 154 10 202 85 107 196 158 216 91 93 84 70 154 82 93 151 88 176 128 41 132 217 36 13 4 135 29 36 131 209 44 54 208 148 233 133 46 171 75 40 32 48 148 22 46 254 145 220 220 220 105 194 132 79 196 235 224 208 112 177 102 137 195 115 102 182 154 118 236 12 160 185 243 127 160 137 19 39 209 164 201 147 105 233 47 203 248 107 64 44 169 139 203 59 197 234 40 45 253 18 109 222 178 157 102 123 127 39 246 156 50 245 51 90 254 155 15 41 226 19 185 56 213 247 99 193 2 38 176 73 26 8 10 61 208 97 160 29 30 213 220 195 240 216 220 201 201 153 70 141 26 69 35 71 142 36 103 231 113 244 165 215 87 98 205 2 118 57 95 67 91 182 238 32 119 143 41 28 235 36 226 16 239 226 50 158 102 205 246 22 38 208 53 236 155 145 157 79 127 248 174 163 201 147 221 104 236 216 177 237 177 163 71 11 35 115 231 45 32 101 66 74 39 3 122 193 4 54 73 3 129 33 225 100 168 225 14 112 146 226 82 61 101 231 21 211 60 174 230 136 17 35 136 127 9 221 215 240 225 195 57 177 147 88 75 207 204 21 201 78 158 62 79 223 124 59 91 192 96 221 18 143 215 227 92 92 232 167 159 127 229 227 162 229 88 3 169 24 112 250 244 25 98 223 135 99 97 98 249 10 31 206 175 19 12 96 1 19 216 164 13 4 195 64 29 39 193 135 117 148 158 145 77 99 198 140 161 161 67 135 118 49 0 56 36 198 218 241 83 103 132 1 69 156 138 70 115 21 59 27 237 108 194 209 209 145 178 114 242 249 120 234 41 40 36 76 116 199 86 44 138 83 204 221 2 3 88 192 20 200 108 146 6 246 6 239 239 98 224 2 27 64 34 91 6 176 118 252 100 187 129 216 195 74 81 125 91 80 48 151 197 71 7 6 2 131 67 109 198 226 243 40 204 195 6 192 38 105 96 79 208 62 210 163 3 236 188 72 171 227 138 169 105 230 204 175 109 86 31 107 184 127 137 86 39 31 75 165 207 167 77 23 157 121 248 88 160 162 179 189 231 240 164 41 22 177 49 10 37 185 185 123 88 141 197 245 53 127 193 66 113 33 131 1 44 96 2 155 180 129 192 118 3 24 123 216 32 143 71 224 186 13 155 196 133 246 48 148 171 235 68 177 150 147 167 17 177 23 179 242 120 138 172 252 79 44 186 226 238 225 65 219 253 252 121 76 150 115 101 171 233 116 90 6 45 92 180 132 43 237 216 101 95 196 122 122 78 227 145 121 80 92 240 216 23 44 194 0 179 73 26 8 8 12 123 96 160 132 77 176 206 164 101 146 207 42 95 242 226 106 227 2 115 114 118 22 93 89 183 126 19 175 101 136 24 168 80 83 201 93 56 205 23 224 74 250 98 134 151 152 62 227 199 243 4 154 229 77 127 241 184 132 65 75 108 65 81 5 29 230 113 137 17 11 96 236 249 169 171 43 205 249 126 30 249 237 220 211 94 148 142 125 45 6 192 38 109 96 111 40 233 13 38 225 188 176 164 170 67 149 60 246 212 124 214 207 146 242 72 18 39 78 16 175 49 243 49 102 31 196 85 81 1 155 72 207 202 165 148 19 167 41 94 149 200 74 162 147 169 231 232 82 110 81 151 56 124 6 227 247 252 197 28 58 122 236 148 216 83 149 144 76 169 103 211 41 135 199 113 231 61 193 2 166 0 102 147 52 224 15 3 220 174 174 6 44 70 122 230 89 24 96 38 176 73 222 216 218 29 16 114 203 96 52 137 209 85 168 97 96 25 72 140 81 102 218 185 59 232 54 12 176 172 223 90 196 205 162 237 126 187 179 74 180 101 84 165 171 21 240 56 18 61 41 48 128 5 76 171 125 55 20 48 226 219 44 235 55 119 97 96 219 54 191 101 170 132 163 212 220 124 133 191 82 27 122 20 30 133 3 3 88 192 228 225 225 185 133 17 223 100 217 254 147 195 211 211 179 255 159 155 183 22 165 95 204 164 43 87 90 168 214 196 63 236 117 70 177 81 119 10 57 145 27 12 96 89 179 110 83 101 159 62 125 62 102 248 254 172 94 40 182 213 199 218 181 107 123 15 26 52 104 240 134 141 91 52 74 158 32 90 110 93 83 115 51 181 182 182 118 171 144 83 91 90 70 96 240 93 191 177 202 222 222 126 10 3 15 96 89 191 47 218 217 13 110 95 247 235 215 207 222 205 109 234 106 159 213 107 114 255 222 181 247 206 78 255 32 234 78 249 237 218 115 247 247 85 190 133 174 147 220 182 219 217 217 141 100 190 129 172 151 31 89 253 206 38 58 254 5 65 187 222 98 189 207 250 128 245 17 11 109 124 218 66 158 15 89 131 89 239 178 222 96 189 200 178 253 215 146 141 19 133 15 160 101 112 14 51 175 118 232 53 126 126 154 178 228 193 223 170 0 199 69 107 251 220 219 128 183 246 54 54 233 78 61 1 218 255 52 244 95 129 95 41 143 160 135 143 1 0 0 0 0 73 69 78 68 174 66 96 130]!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 0 0 34 2 8 1409286144 131073 416 0 0 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 0 416 34 2 8 1140850688 1 576 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 517 0 0 0 576 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 85 802 731 11 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 802 193 193 0 27 1 true 170 192 8 #() 0 690 138 144 34 1 754 #createAt:extent: 34 2 802 3839 21 802 731 341 416 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 236 8 0 0 180 0 0 0] 34 2 576 410 ##(Smalltalk.CardContainer) 34 16 0 416 34 2 8 1409286144 131073 1120 0 0 0 5 0 0 0 1120 655878 ##(Smalltalk.CardLayout) 138 144 34 2 546 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 0 1120 34 2 8 1140953421 1 1264 590662 2 ##(Smalltalk.ListModel) 138 144 944 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 0 0 13 265030 4 ##(Smalltalk.Menu) 0 true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 1458 1 1490 #inspectReferences 8 'Inspect &References' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1458 1 1490 #browseIt 8 '&Browse It' 1 1 1538 0 true 1584 8 'ClassBrowserShell.ico' 1632 0 0 1714 4097 1458 1 1490 #copyAspect 8 '&Copy' 1 1 0 0 0 1458 1 1490 #pasteAspect 8 '&Paste <1d>' 1 1 0 0 0 1714 4097 1458 1 1490 #editAspect 8 '&Edit' 1 1 0 0 0 1458 1 1490 #nilAspect 8 'Set to &Nil' 1 1 0 0 0 1714 4097 1458 1 1490 #refresh 8 'Re&fresh' 1 1 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 1264 0 8 4294905883 459270 ##(Smalltalk.Message) #valueText 8 #() 0 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 0 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Property' 335 #left 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 3 1 2144 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 2320 7 257 0 2146 #<= 8 #() 0 0 1264 0 3 0 0 2258 8 'Value' 333 #left 2306 0 0 2338 2 1 2304 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 2480 7 257 0 2146 #<= 2432 0 0 1264 2306 0 0 2338 2 1 2304 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 2576 7 257 0 3 0 0 2258 8 '' 41 #center 2146 #displayString 8 #() 2146 #<= 2704 0 0 1264 2306 0 0 2338 3 1 2304 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 2736 7 257 0 1 0 0 #report 944 0 359 802 129 129 8 #(nil) false 1050438 3 ##(Smalltalk.VirtualTreeModel) 0 1392 138 144 944 0 0 2306 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 2848 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2864 2306 0 0 2914 1 83886083 2848 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2960 7 257 0 0 138 ##(Smalltalk.PluggableSet) 944 138 ##(Smalltalk.PluggableSet) 944 13 5 0 0 0 0 0 0 0 690 138 144 34 3 754 #createAt:extent: 34 2 802 9 9 802 715 279 1264 754 #contextMenu: 34 1 1424 1264 754 #text: 34 1 8 'Property' 1264 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 143 0 0 0] 8 #() 912 0 2021 546 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 0 1120 34 2 8 1411453252 1 3296 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 642 8 4278190080 0 21 1410 0 true 34 17 1458 1 1490 #accept 8 '&Accept' 1 1 0 0 0 1714 4097 1410 0 true 34 9 1458 1 1490 #undo 8 '&Undo' 1 1 1538 0 true 1584 8 'EditUndo.ico' 1632 0 0 1714 4097 1458 1 1490 #cutSelection 8 'Cu&t' 1 1 1538 0 true 1584 8 'EditCut.ico' 1632 0 0 1458 1 1490 #copySelection 8 '&Copy' 1 1 1538 0 true 1584 8 'EditCopy.ico' 1632 0 0 1458 1 1490 #pasteClipboard 8 '&Paste' 1 1 1538 0 true 1584 8 'EditPaste.ico' 1632 0 0 1458 1 1490 #clearSelection 8 'De&lete' 1 1 1538 0 true 1584 8 'EditClear.ico' 1632 0 0 1458 1 1490 #reformatSource 8 'Re&format' 1 1 0 0 0 1714 4097 1458 1 1490 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 1458 1 1490 #clear 8 'Clea&r' 1 1 0 0 0 1714 4097 1458 1 1490 #browseIt 8 'Bro&wse It' 1 1 1538 0 true 1584 8 'ClassBrowserShell.ico' 1632 0 0 1458 1 1490 #displayIt 8 '&Display It' 1 1 1538 0 true 1584 8 'DisplayIt.ico' 1632 0 0 1458 1 1490 #evaluateIt 8 'E&valuate It' 1 1 1538 0 true 1584 8 'EvaluateIt.ico' 1632 0 0 1458 1 1490 #inspectIt 8 '&Inspect It' 1 1 1538 0 true 1584 8 'InspectIt.ico' 1632 0 0 1458 1 1490 #debugIt 8 'Deb&ug It' 1 1 1538 0 true 1584 8 'Debugger.ico' 1632 0 0 1714 4097 1458 1 1490 #chooseEvaluationPools 8 '&Pools...' 1 1 1538 0 true 1584 8 'SystemDictionary.ico' 1632 0 0 1458 1 1490 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 1714 4097 1410 0 true 34 2 1458 2097153 1490 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 1458 1 1490 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 1714 4097 1410 0 true 34 9 1458 1 1490 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 1458 1 1490 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 1458 1 1490 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 1458 1 1490 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 1458 1 1490 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 1458 1 1490 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 1458 1 1490 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 1714 4097 1410 0 true 34 2 1458 1 1490 2146 #language: 8 #(#container) 8 '&Smalltalk' 1 1 0 0 0 1458 1 1490 2146 #language: 8 #(#xml) 8 '&Xml' 1 1 0 0 0 8 '&Language' 0 134217729 0 0 0 0 0 8 '&Options' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 3296 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 9 0 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 5618 77 786694 ##(Smalltalk.IndexedColor) 33554457 5666 33554471 1 0 0 0 0 #callTip 0 0 0 34 40 5632 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 0 0 false 138 144 944 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 3296 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 944 0 170 176 944 9215 0 0 0 0 5666 33554447 0 0 65 0 0 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 5584 0 0 0 0 3 0 170 192 34 6 #Notification 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 3296 33554437 11 false #Notification 0 0 0 0 0 0 #Warning 6050 19 3296 33554465 3 false #Warning 0 0 0 0 0 0 #Error 6050 21 3296 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 5618 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 5618 1027 6162 60239 6162 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 5618 1031 6162 335 6162 31317503 1 0 0 0 0 #Error 0 0 0 0 690 138 144 34 8 754 #createAt:extent: 34 2 802 9 9 802 715 279 3296 754 #contextMenu: 34 1 3456 3296 754 #modificationEventMask: 8 #(4607) 3296 754 #hoverTime: 8 #(500) 3296 754 #caretPeriod: 8 #(530) 3296 754 #wordWrap: 8 #(true) 3296 754 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 3296 1 3 0 0 5 0 6610 3 3296 1 0 0 67108863 5 0 6610 5 3296 1 0 0 0 5 0 3296 754 #tabWidth: 8 #(4) 3296 850 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 143 0 0 0] 8 #() 912 0 29 1264 170 192 34 4 1264 8 'aspects' 3296 8 'workspace' 0 410 ##(Smalltalk.TabViewXP) 34 28 0 1120 34 2 8 1140916738 1 6816 1330 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) 0 1392 0 0 1 0 0 0 6816 0 8 4294903993 2306 0 0 2338 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 6944 7 257 0 2306 0 0 2914 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7008 7 257 0 2208 0 0 0 0 0 #smallIcons 0 0 0 0 0 690 138 144 34 3 754 #createAt:extent: 34 2 802 1 1 802 731 341 6816 754 #basicSelectionsByIndex: 34 1 8 #(1) 6816 754 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6816 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 8 #() 912 0 27 690 138 144 34 1 754 #createAt:extent: 34 2 802 1 1 802 731 341 1120 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 34 3 1264 3296 6816 912 0 27 912 0 27 )! !
!PropertyInspector class categoriesFor: #editButtonImageIndexFor:!public! !
!PropertyInspector class categoriesFor: #ellipsisButtonIcon!public! !
!PropertyInspector class categoriesFor: #resource_Default_view!public!resources-views! !

